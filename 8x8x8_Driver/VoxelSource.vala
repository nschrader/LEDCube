/*
 * VoxelSource - Copyright (C) 2014 Nick Schrader
 */

public abstract class VoxelSource: Object {
	protected uint x;
	protected uint z;
	protected uint i = 0;
	protected uint _delay = 50;

	public uint delay {
		get {
			return _delay;
		}
		protected set {
			_delay = value;
		}
	}
 
	public abstract void draw(R_3 r3);

	public virtual void reset(LEDCube cube) {
		(void) cube;
		i = 0;
	}
}
