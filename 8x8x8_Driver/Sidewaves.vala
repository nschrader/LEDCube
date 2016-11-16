/*
 * Sidewaves - Copyright (C) 2014 Nick Schrader
 * 
 * Based on the effects made by Christian Moen and Ståle Kristoffersen.
 * Distributed under the same terms.
 */

public class Sidewaves: VoxelSource {
	public override void draw(R_3 r3) {
		double ox, oz, d, y;
		ox = 3.5 + Math.sin((float) i/250) * 4;
		oz = 3.5 + Math.cos((float) i/250) * 4;
		for (x = 0; x < 8; x++) {
			for (z = 0; z < 8; z++) {
				d = R_3.distance(ox, 0, oz, x, 0, z) / 1.25;
				y = 4 + Math.sin(d/2 + (float) i/4) * 3.6;
				r3.setvoxel(x, (uint) y, z, true);				
			}
		}
		i++;
	}
}

