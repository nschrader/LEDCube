/*
 * Ripples - Copyright (C) 2014 Nick Schrader
 * 
 * Based on the effects made by Christian Moen and Ståle Kristoffersen.
 * Distributed under the same terms.
 */

public class Ripples: VoxelSource {
	public override void draw(R_3 r3) {
		double d, y;
		for (x = 0; x < 8; x++) {
			for (z = 0; z < 8; z++) {
				d = R_3.distance(3.5, 0, 3.5, x, 0, z) / 1.25;
				y = 4 + Math.sin(d/1.3 + (double) i/4) * 4;
				r3.setvoxel(x, (uint) y, z, true);
			}
		}
		i++;
	}
}

