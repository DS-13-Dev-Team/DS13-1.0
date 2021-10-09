
//Absolute pixel coordinate to relative. If MODULUS is zero, then we want to return 32, as pixel coordinates range from 1 to 32 within a tile.
#define ABS_PIXEL_TO_REL(apc) (MODULUS(apc, 32) || 32)
