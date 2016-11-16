/*
 * R_3 - Copyright (C) 2014 Nick Schrader
 */

public class R_3: Object {
	private uint size_sq;
	private uint bits_per_byte;
	private uint bytes_r3;

	public bool[] space {
		get;
		private set;
	}

	public uint size {
		get;
		private set;
	}

	public R_3(uint _size) requires (_size > 0) {
		size = _size;
		size_sq = size*size;
		bits_per_byte = size_sq < 8 ? size_sq : 8;
		bytes_r3 = (uint) Math.ceil(size_sq/8)*size;
		space = new bool[(int) Math.pow(size, 3)];
	}

	public void setvoxel(uint x, uint y, uint z, bool state) 
	requires (x < size) requires (y < size) requires (z < size) {
		space[z+(x*size)+(y*size_sq)] = state;
	}

	public bool getvoxel(uint x, uint y, uint z) 
	requires (x < size) requires (y < size) requires (z < size) {
		return space[z+(x*size)+(y*size_sq)];
	}

	public void line (uint x1, uint y1, uint z1, uint x2, uint y2, uint z2) {
		int i, dx, dy, dz, l, m, n, x_inc, y_inc, z_inc, err_1, err_2, dx2, dy2, dz2;
		int[] pixel = new int[3];
		pixel[0] = (int) x1;
		pixel[1] = (int) y1;
		pixel[2] = (int) z1;
		dx = (int) (x2 - x1);
		dy = (int) (y2 - y1);
		dz = (int) (z2 - z1);
		x_inc = (dx < 0) ? -1 : 1;
		l = dx.abs();
		y_inc = (dy < 0) ? -1 : 1;
		m = dy.abs();
		z_inc = (dz < 0) ? -1 : 1;
		n = dz.abs();
		dx2 = l << 1;
		dy2 = m << 1;
		dz2 = n << 1;
		if ((l >= m) && (l >= n)) {
			err_1 = dy2 - l;
			err_2 = dz2 - l;
			for (i = 0; i < l; i++) {
				if (0 <= pixel[0] < size && 0 <= pixel[1] < size && 0 <= pixel[2]< size)
					setvoxel(pixel[0], pixel[1], pixel[2], true);
				if (err_1 > 0) {
					pixel[1] += y_inc;
					err_1 -= dx2;
				}
				if (err_2 > 0) {
					pixel[2] += z_inc;
					err_2 -= dx2;
				}
				err_1 += dy2;
				err_2 += dz2;
				pixel[0] += x_inc;
			}
		} else if ((m >= l) && (m >= n)) {
			err_1 = dx2 - m;
			err_2 = dz2 - m;
			for (i = 0; i < m; i++) {
				if (0 <= pixel[0] < size && 0 <= pixel[1] < size && 0 <= pixel[2]< size)
					setvoxel(pixel[0], pixel[1], pixel[2], true);
				if (err_1 > 0) {
					pixel[0] += x_inc;
					err_1 -= dy2;
				}
				if (err_2 > 0) {
					pixel[2] += z_inc;
					err_2 -= dy2;
				}
				err_1 += dx2;
				err_2 += dz2;
				pixel[1] += y_inc;
			}
		} else {
			err_1 = dy2 - n;
			err_2 = dx2 - n;
			for (i = 0; i < n; i++) {
				if (0 <= pixel[0] < size && 0 <= pixel[1] < size && 0 <= pixel[2]< size)
					setvoxel(pixel[0], pixel[1], pixel[2], true);
				if (err_1 > 0) {
					pixel[1] += y_inc;
					err_1 -= dz2;
				}
				if (err_2 > 0) {
					pixel[0] += x_inc;
					err_2 -= dz2;
				}
				err_1 += dy2;
				err_2 += dx2;
				pixel[2] += z_inc;
			}
		}
		if (0 <= pixel[0] < size && 0 <= pixel[1] < size && 0 <= pixel[2]< size)
			setvoxel(pixel[0], pixel[1], pixel[2], true);
	}

	public void apply(R_3 r3) requires (size == r3.size) {
		space = r3.space;
	}

	public void clear() {
		int i;
		for (i = 0; i < space.length; i++)
			space[i] = false;
	}

	public Bytes translate() {
		uint8 b;
		int i;
		ByteArray ba = new ByteArray.sized(bytes_r3);
		b = 0;
		for (i = 0; i < space.length; i++) {
			b |= (uint8) ((int) space[i] << (i%bits_per_byte));
			if (i%bits_per_byte == bits_per_byte-1) {
				ba.append({b});
				b = 0;
			}
		}
		return ByteArray.free_to_bytes((owned) ba);
	}

	public static double distance (double x1, double y1, double z1, double x2, double y2, double z2) {	
		return Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2));
	}
}

