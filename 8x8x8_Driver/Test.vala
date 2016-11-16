/*
 * Test - Copyright (C) 2014 Nick Schrader
 */

public class Test: VoxelSource {
	private uint y;

	public Test() {
		base();
		x = 7;
		y = 7;
		z = 7;
		delay = 150;
	}

	public override void draw(R_3 r3) {
		if (z == 7) {
			z = 0;
			if (x == 7) {
				x = 0;
				if (y == 7)
					y = 0;
				else
					y++;
			} else {
				x++;
			}
		} else {
			z++;
		}
		r3.setvoxel(x, y, z, true);
	}

	public override void reset(LEDCube cube) {
		(void) cube;
		x = 7;
		y = 7;
		z = 7;
	}
}

