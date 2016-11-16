/*
 * ControlWin - Copyright (C) 2014 Nick Schrader
 */

using Gtk;
using Cairo;
using Posix;

public class ControlWin: Window {
	private Fixed fix;
	private DrawingArea lines;
	private ToggleButton LED[8];
	private LEDCube cube;
	private R_3 r3;
	private bool _connected;

	public bool connected { 
		get {
			return _connected; 
		}
		set {
			_connected = value;
			lines.queue_draw();
			foreach(Widget w in LED)
				w.sensitive = value;
			recalc_R3();
		}
		default = false;
	}

	public ControlWin() {
		int i;
		Image img;
		cube = new LEDCube("/dev/ttyACM0");
		cube.bind_property("connected", this, "connected");
		r3 = new R_3(2);
		fix = new Fixed();
		fix.border_width = 10;
		lines = new DrawingArea();
		lines.draw.connect(_draw);
		fix.put(lines, 0, 0);
		// Foreach doesn't allow references
		for (i = 0; i < LED.length; i++) {
			img = new Image();
			img.icon_name = "weather-clear";
			LED[i] = new ToggleButton();
			LED[i].set_image(img);
			LED[i].toggled.connect(recalc_R3);
			LED[i].sensitive = false;
		}
		fix.put(LED[0], 000, 300);
		fix.put(LED[1], 100, 200);
		fix.put(LED[2], 200, 300);
		fix.put(LED[3], 300, 200);
		fix.put(LED[4], 000, 100);
		fix.put(LED[5], 100, 000);
		fix.put(LED[6], 200, 100);
		fix.put(LED[7], 300, 000);
		this.title = "2x2x2 LED-Cube";
		this.resizable = false;
		this.destroy.connect(main_quit);
		this.add(fix);
		this.show_all();
	}

	private bool _draw(Context cr) {
		TextExtents extents;
		string err_msg = "NOT CONNECTED!";
		int tb_width = LED[0].get_allocated_width();
		int tb_height = LED[0].get_allocated_height();
		int tb_mid_width = tb_width/2;
		int tb_mid_height = tb_height/2;
		if (!connected)
			cr.set_source_rgba(0, 0, 0, 0.5);
		else
			cr.set_source_rgb(0, 0, 0);
		lines.set_size_request(300+tb_width, 300+tb_height);
		//Layer 0
		cr.move_to(000+tb_width	, 300				);
		cr.line_to(100			, 200+tb_height		); //LED0 - LED1
		cr.move_to(100+tb_width	, 200+tb_mid_height	);
		cr.line_to(300			, 200+tb_mid_height	); //LED1 - LED2
		cr.move_to(200+tb_width	, 300				);
		cr.line_to(300			, 200+tb_height		); //LED2 - LED3
		cr.move_to(200			, 300+tb_mid_height	);
		cr.line_to(000+tb_width	, 300+tb_mid_height	); //LED3 - LED0
		//Layer 1
		cr.move_to(000+tb_width	, 100				);
		cr.line_to(100			, 000+tb_height		); //LED4 - LED5
		cr.move_to(100+tb_width	, 000+tb_mid_height	);
		cr.line_to(300			, 000+tb_mid_height	); //LED5 - LED6
		cr.move_to(200+tb_width	, 100				);
		cr.line_to(300			, 000+tb_height		); //LED6 - LED7
		cr.move_to(200			, 100+tb_mid_height	);
		cr.line_to(000+tb_width	, 100+tb_mid_height	); //LED7 - LED4
		//Colums
		cr.move_to(000+tb_mid_width, 300			);
		cr.line_to(000+tb_mid_width, 100+tb_height	); //LED0 - LED4
		cr.move_to(100+tb_mid_width, 200			);
		cr.line_to(100+tb_mid_width, 000+tb_height	); //LED1 - LED5
		cr.move_to(200+tb_mid_width, 300			);
		cr.line_to(200+tb_mid_width, 100+tb_height	); //LED2 - LED6
		cr.move_to(300+tb_mid_width, 200			);
		cr.line_to(300+tb_mid_width, 000+tb_height	); //LED3 - LED7
		cr.stroke();
		//Not Connected
		if (!connected) {
			cr.set_font_size(30);
			cr.set_source_rgb(1, 0, 0);
			cr.text_extents(err_msg, out extents);
			cr.move_to(lines.width_request/2 - extents.width/2 - extents.x_bearing, 
				lines.height_request/2 - extents.height/2 - extents.y_bearing);
			cr.show_text(err_msg);
		}
		return true;
	}

	private void recalc_R3() {
		int i, ii, iii;
		uint8[] data;
		for (i = 0; i < 2; i++) { //y
			for (ii = 0; ii < 2; ii++) { //x
				for (iii = 0; iii < 2; iii++) //z
					r3.setvoxel(ii, i, iii, LED[4*i+2*ii+iii].active);
			}
		}
		data = Bytes.unref_to_data(r3.translate());
		cube.sendData(data[0:1]);
		cube.sendData(data[1:2]);
	}

	public static int main(string[] args) {
		init(ref args);
		new ControlWin();
		Gtk.main();
		return EXIT_SUCCESS;
	}
}

