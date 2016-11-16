/*
 * LEDCube - Copyright (C) 2014 Nick Schrader
 *
 * Based on moserial's SerialConnection Class and distributed under the same terms.
 */

using Posix;

public class LEDCube: Object {	
	private int fd;
	private string tty;
	private File dev;
	private FileMonitor dev_mon;
	private IOChannel dev_io;
	private uint dev_src;
	private ulong dev_lck;
	private Posix.termios dev_tio;
	private const string ERR_MSG = "%s: %s\n";

	private enum COMMAND {
		DATA = 0x00,
		SEEK = 0x01,
		TELL = 0x02,
		RESET = 0x03,
		INTERVAL = 0x04,
		IDENTIFY = 0x2A,
		UNLOCK = 0x33,
		LOCK = 0xF3
	}
	private enum ANSWER {
		MAGIC_NUMBER = 0xD5,
		UNKNOWN = 0x3F
	}

	public bool connected {
		get;
		private set;
		default = false;
	}

	public signal void recieve(uint8[] bytes);

	public LEDCube(string path) {
		tty = path;
		dev = File.new_for_path(tty);
		try {
			dev_mon = dev.monitor_file(FileMonitorFlags.NONE);
		} catch (Error e) {
			critical(ERR_MSG, tty, (e.message));
		}
		dev_mon.changed.connect(handle_connection);
		if (dev.query_exists())
			dev_mon.emit_event(dev, dev, FileMonitorEvent.CREATED);
	}

	public void sendData(uint8[] bytes) {
		if(connected) {
			writeBytes({COMMAND.DATA});
			writeBytes(bytes);
		}
	}

	public void setInterval(uint8 i) {
		if(connected)
			writeBytes({COMMAND.INTERVAL, i});
	}

	public void reset() {
		if(connected)
			writeBytes({COMMAND.RESET});
	}

	private void handle_connection(File file, File? crap, FileMonitorEvent event) {
		if (event == FileMonitorEvent.DELETED) {
			Posix.close(fd);
			Source.remove(dev_src);
			connected = false;
			return;
		} else if (event != FileMonitorEvent.CREATED)
			return;	
		fd = Posix.open(tty, Posix.O_RDWR | Posix.O_NONBLOCK);
    	if (fd < 0) {
			warning(ERR_MSG, tty, Posix.strerror(Posix.errno));
			return;
		}
        Posix.tcflush(fd, Posix.TCIOFLUSH);
		Posix.cfsetospeed(ref dev_tio, Posix.B9600);
		Posix.cfsetispeed(ref dev_tio, Posix.B9600);
		dev_tio.c_cflag = (dev_tio.c_cflag & ~Posix.CSIZE);
		dev_tio.c_cflag |= Posix.CS8;
        dev_tio.c_cflag |= Posix.CLOCAL;
		dev_tio.c_cflag |= Posix.CREAD;
		dev_tio.c_cflag &= ~(Posix.PARENB | Posix.PARODD);
		dev_tio.c_cflag &= ~Posix.CSTOPB;
		dev_tio.c_iflag = Posix.IGNBRK;
		dev_tio.c_iflag &= ~(Posix.IXON | Posix.IXOFF | Posix.IXANY);
		dev_tio.c_lflag = 0;
		dev_tio.c_oflag = 0;
		dev_tio.c_cc[Posix.VTIME] = 1;
		dev_tio.c_cc[Posix.VMIN] = 1;
		Posix.tcsetattr(fd, Posix.TCSANOW, dev_tio);
		dev_io = new IOChannel.unix_new(fd);
		dev_src = dev_io.add_watch(IOCondition.IN, readBytes);
		dev_lck = recieve.connect((bytes) => {
			if (bytes[0] == ANSWER.MAGIC_NUMBER) {
				connected = true;
				disconnect(dev_lck);
			} else
				warning(ERR_MSG, tty, "Seems not to be a LED-Cube");
		});
		writeBytes({COMMAND.UNLOCK, COMMAND.IDENTIFY, COMMAND.RESET});
	}

	private bool readBytes(IOChannel source, IOCondition condition) {
		uint8[] buf = new uint8[128];
		uint8[] sized_buf;
		ssize_t rx;
		int i;
		rx = Posix.read(fd, buf, 128);
		if (rx < 0) {
			warning(ERR_MSG, tty, Posix.strerror(Posix.errno));
            return false;
		}
		sized_buf = new uint8[rx];
		for (i = 0; i < rx; i++) {
			sized_buf[i] = buf[i];
		}
		if (rx > 0)
			recieve(sized_buf);
		else
			// rx = 0 only happens if the device was disconnected
			dev_mon.emit_event(dev, dev, FileMonitorEvent.DELETED);
		return connected;
	}

	private void writeBytes(uint8[] bytes) {
		ssize_t tx = Posix.write(fd, bytes, bytes.length);
		if (tx < 0)
			warning(ERR_MSG, tty, Posix.strerror(Posix.errno));
		Posix.tcdrain(fd);
	}
}
