/*
 * Spheremove - Copyright (C) 2014 Nick Schrader
 * 
 * Based on the effects made by Christian Moen and Ståle Kristoffersen.
 * Distributed under the same terms.
 */

public class Spheremove: VoxelSource {
	public override void draw(R_3 r3) {
		uint y;
		double ox, oy, oz, dm, d;
		ox = 3.5 + Math.sin((double) i/5) * 2.5;
		oy = 3.5 + Math.cos((double) i/5) * 2.5;
		oz = 3.5 + Math.cos((double) i/3) * 2;
		dm = 2 + Math.sin((double) i/50);
		for (x = 0; x < 8; x++)	{
			for (y = 0; y < 8; y++)	{
				for (z = 0; z < 8; z++)	{
					d = R_3.distance(x, y, z, ox, oy, oz);
					if (d > dm && d < dm+1)
						r3.setvoxel(x, y, z, true);
				}
			}
		}
		i++;
	}
}

