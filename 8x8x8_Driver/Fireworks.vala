/*
 * Fireworks - Copyright (C) 2014 Nick Schrader
 * 
 * Based on the effects made by Christian Moen and Ståle Kristoffersen.
 * Distributed under the same terms.
 */

public class Fireworks: VoxelSource {
	private struct Vektor {
		public double x;
		public double y;
		public double z;
		public double dx;
		public double dy;
		public double dz;
	}

	private enum Task {
		INIT,
		SHOOT,
		EXPLODE
	}
	private uint n;
	private uint ox;
	private uint oy;
	private uint oz;
	private Vektor[] particles;
	private Task task;

	public Fireworks(uint p) requires (p > 0) {
		base();
		n = p;
		particles = new Vektor[n];
	}

	public override void draw(R_3 r3) {
		switch (task) {
			case Task.INIT:
				task = Task.SHOOT;
				init();
				i = 0;
				break;
			case Task.SHOOT:
				if (i < oz) {
					r3.setvoxel(ox, i, oz, true);
					delay = 10 + i*i*20;
				} else {
					task = Task.EXPLODE;
					i = 0;
					delay = 100;
				}
				break;
			case Task.EXPLODE:
				if (i < 25)
					explode(r3);
				else {
					task = Task.INIT;
					i = 0;
				}
				break;
		}
		i++;
	}

	public override void reset(LEDCube cube) {
		(void) cube;
		task = Task.INIT;
		_delay = 50;
		i = 0;
	}

	private void init() {
		int j;
		ox = Random.next_int()%4 + 2;
		oy = Random.next_int()%2 + 5;
		oz = Random.next_int()%4 + 2;
		for (j = 0; j < n; j++)	{
			particles[j].x = ox;
			particles[j].y = oy;
			particles[j].z = oz;
			particles[j].dx = 1 - (double) (Random.next_int()%200) / 100;
			particles[j].dy = 1 - (double) (Random.next_int()%200) / 100;
			particles[j].dz = 1 - (double) (Random.next_int()%200) / 100;
		}
	}

	private void explode(R_3 r3) {
		int j;
		double slowrate, gravity;
		slowrate = 1 + Math.tan((i+0.1) / 10) * 10;
		gravity = Math.tan((i+0.1) / 20) / 2;
		for (j = 0; j < n; j++)	{
			particles[j].x += particles[j].dx/slowrate;
			particles[j].y += particles[j].dy/slowrate - gravity;
			particles[j].z += particles[j].dz/slowrate;
			if (0 <= particles[j].x < 8 && 0 <= particles[j].y < 8 && 0 <= particles[j].z < 8)
				r3.setvoxel((uint) particles[j].x, (uint) particles[j].y, (uint) particles[j].z, true);
		}
	}
}

