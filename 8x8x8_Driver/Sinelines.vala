/*
 * Sinelines - Copyright (C) 2014 Nick Schrader
 * 
 * Based on the effects made by Christian Moen and Ståle Kristoffersen.
 * Distributed under the same terms.
 */

public class Sinelines: VoxelSource {
	public override void draw(R_3 r3) {
		uint z;
		double l, r, s, d, h;
		for (z = 0; z < 8; z++)	{
			d = 2 + Math.sin((double) i/1000) + 1;
			h = 3 + (Math.sin((double) i/2000) + 1) * 6;
			s = (double) i/5 + (double) z/d;
			l = 4 + Math.sin(s) * h;
			r = 7 - l;
			r3.line(0, (uint) l, z, 7, (uint) r, z);
		}
		i++;
	}
}
