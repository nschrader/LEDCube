/*
 * ControlWin - Copyright (C) 2014 Nick Schrader
 */

using Gtk;
using Cairo;
using Posix;

public class ControlWin: Window {
	private Box box;
	private LEDCube cube;
	private Controller controller;
	private bool _connected;
	private Button[] buttons;
	private VoxelSource[] items;

	public bool connected { 
		get {
			return _connected; 
		}
		set {
			_connected = value;
			box.sensitive = value;
		}
		default = false;
	}

	public ControlWin() {
		int i;
		cube = new LEDCube("/dev/ttyACM0");
		cube.bind_property("connected", this, "connected");
		controller = new Controller(cube);
		items = {
			new Clear(),
			new Test(),
			new IntervalDemo(cube),
			new Ripples(),
			new Sidewaves(),
			new Linespin(),
			new Spheremove(),
			new Sinelines(),
			new Fireworks(50),
			new GameOfLife()
		};
		box = new Box(Orientation.VERTICAL, 8);
		box.width_request = 250;
		box.border_width = 8;
		box.sensitive = false;
		buttons.resize(items.length);
		for (i = 0; i < items.length; i++) {
			buttons[i] = new Button();
			buttons[i].label = items[i].get_type().name();
			buttons[i].clicked.connect((t) => {
				int j;
				for (j = 0; j < items.length; j++) {
        			if  (t == buttons[j])
						break;
				}
				controller.vs = items[j];
			});
			box.pack_start(buttons[i]);
		}
		this.title = "8x8x8 LED-Cube";
		this.resizable = false;
		this.destroy.connect(main_quit);
		this.add(box);
		this.show_all();
		buttons[0].clicked();
	}

	public static int main(string[] args) {
		init(ref args);
		new ControlWin();
		Gtk.main();
		return EXIT_SUCCESS;
	}
}

