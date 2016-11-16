/*
 * IntervalDemo - Copyright (C) 2014 Nick Schrader
 */

public class IntervalDemo: VoxelSource {
	private uint y;
	private bool dec;
	private LEDCube cube;

	public IntervalDemo(LEDCube c) {
		base();
		cube = c;
		delay = 500;
		i = 2;
		dec = false;
	}

	public override void draw(R_3 r3) {
		for (x = 0; x < 8; x++) {
			for (y = 0; y < 8; y++) {
				for (z = 0; z < 8; z++)
					r3.setvoxel(x, y, z, true);
			}
		}
		cube.setInterval((uint8) (i*i));
		if (1 <= i < 10 && !dec)
			i++;
		else if (2 <= i < 11 && dec)
			i--;
		else 
			dec = !dec;
	}

	public override void reset(LEDCube cube) {
		(void) cube;
		cube.reset();
		delay = 500;
		i = 2;
		dec = false;
	}
}

