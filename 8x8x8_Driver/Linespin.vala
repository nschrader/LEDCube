/*
 * Linespin - Copyright (C) 2014 Nick Schrader
 * 
 * Based on the effects made by Christian Moen and Ståle Kristoffersen.
 * Distributed under the same terms.
 */

public class Linespin: VoxelSource {
	private const double cx = 4;
	private const double cz = 4;

	public override void draw(R_3 r3) {
		double tx, ty, tz, bx, by, bz, s;
		int y;
		for (y = 0; y < 8; y++) {
			s = (double) i/5 + (double) y/(10 + (7 * Math.sin((double) i/20)));
			tx = cx + Math.sin(s) * 5;
			tz = cx + Math.cos(s) * 5;
			ty = y;
			bx = cx + Math.sin(s + Math.PI) * 10;
			bz = cx + Math.cos(s + Math.PI) * 10;		
			by = y;
			r3.line((uint) tx, (uint) ty, (uint) tz, (uint) bx, (uint) by, (uint) bz);
		}
		i++;
	}
}
