/*
 * GameOfLife - Copyright (C) 2014 Nick Schrader
 * 
 * Based on the effects made by Christian Moen and Ståle Kristoffersen.
 * Distributed under the same terms.
 */

public class GameOfLife: VoxelSource {
	private R_3 last;
	private uint y;

	private const uint TERMINATE_LONELY = 3;
	private const uint TERMINATE_CROWDED = 5;
	private const uint CREATE_MIN = 4;
	private const uint CREATE_MAX = 4;

	public GameOfLife() {
		last = new R_3(8);
		delay = 200;
		random_fill();
	}

	public override void draw(R_3 r3) {
		nextgen(r3);
		if (count_changes(r3) == 0)
			random_fill();
		else
			last.apply(r3);
	}

	public override void reset(LEDCube cube) {
		(void) cube;
		random_fill();
	}

	private void nextgen(R_3 r3) {
		uint n;
		for (x = 0; x < 8; x++)	{
			for (y = 0; y < 8; y++)	{
				for (z = 0; z < 8; z++)	{
					n = count_neighbors(x, y, z);
					if (last.getvoxel(x, y, z) && TERMINATE_LONELY < n < TERMINATE_CROWDED)
							r3.setvoxel(x, y, z, true);
					else if (CREATE_MIN <= n <= CREATE_MAX)
							r3.setvoxel(x, y, z, true);
				}
			}
		}
	}

	private uint count_neighbors(uint x, uint y, uint z) {
		int ix, iy, iz, nx, ny, nz;
		uint n = 0;
		for (ix = -1; ix < 2; ix++)	{
			for (iy = -1; iy < 2; iy++) {
				for (iz = -1; iz < 2; iz++) {
					if (ix == 0 && iy == 0 && iz == 0)
						continue;
					nx = (int) x + ix;
					ny = (int) y + iy;
					nz = (int) z + iz;
					if (0 <= nx < 8 && 0 <= ny < 8 && 0 <= nz < 8) {
						last.getvoxel(nx, ny, nz) ? n++ : n;
					}
				}
			}
		}
		return n;
	}

	private uint count_changes(R_3 r3) {
		int j = 0;
		for (x = 0; x < 8; x++)	{
			for (y = 0; y < 8; y++)	{
				for (z = 0; z < 8; z++)	{
					if (last.getvoxel(x, y, z) != r3.getvoxel(x, y, z))
						j++;
				}
			}
		}
		return j;
	}

	private void random_fill() {
		last.clear();
		for (i = 0; i < 20; i++)
			last.setvoxel(Random.next_int()%4, Random.next_int()%4, Random.next_int()%4, true);
	}
}

