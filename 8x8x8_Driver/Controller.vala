/*
 * Controller - Copyright (C) 2014 Nick Schrader
 */

public class Controller: Object {
	private uint timeout;
	private ulong notify_id;
	private LEDCube cube;
	private R_3 r3;
	private VoxelSource _vs;

	public VoxelSource vs {
		get {
			return _vs;
		}
		set {
			//Uninstall the old VoxelSource
			if (timeout != 0)
				Source.remove(timeout);
			if (_vs != null) {
				_vs.reset(cube);
				_vs.disconnect(notify_id);
			}
			//Install the new one
			if (value != null)
				timeout = Timeout.add(value.delay, refresh);
			notify_id = value.notify.connect((p) => {
				if (p.name != "delay")
					return;
				Source.remove(timeout);
				timeout = Timeout.add(_vs.delay, refresh);
			});
			_vs = value;
		}
		default = null;
	}
			

	public Controller(LEDCube c) {
		timeout = 0;
		cube = c;
		r3 = new R_3(8);
		c.notify.connect((p) => {
			if (p.name != "connected")
				return;
			if (!c.connected && timeout != 0)
				Source.remove(timeout);
			if (c.connected)
				this.notify_property("vs");
		});
	}

	~Controller() {
		if (timeout != 0)
			Source.remove(timeout);
	}

	private bool refresh() {
		uint8[] data;
		r3.clear();
		vs.draw(r3);
		data = Bytes.unref_to_data(r3.translate());
		cube.sendData(data[0:8]);
		cube.sendData(data[8:16]);
		cube.sendData(data[16:24]);
		cube.sendData(data[24:32]);
		cube.sendData(data[32:40]);
		cube.sendData(data[40:48]);
		cube.sendData(data[48:56]);
		cube.sendData(data[56:64]);
		return true;
	}
}
