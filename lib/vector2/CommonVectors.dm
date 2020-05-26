/* Common vectors.
	Make sure you don't modify these vectors.
	You should treat all vectors as immutable in general.
*/
var Vector2/Vector2 = new

Vector2
	var
		vector2
			Zero = new(0, 0)
			One = new(1, 1)
			North = new(0, 1)
			South = new(0, -1)
			East = new(1, 0)
			West = new(-1, 0)
			Northeast = new(sqrt(1/2), sqrt(1/2))
			Northwest = new(-sqrt(1/2), sqrt(1/2))
			Southeast = new(sqrt(1/2), -sqrt(1/2))
			Southwest = new(-sqrt(1/2), -sqrt(1/2))

	proc
		FromDir(dir)
			switch(dir)
				if(NORTH) return North
				if(SOUTH) return South
				if(EAST) return East
				if(WEST) return West
				if(NORTHEAST) return Northeast
				if(SOUTHEAST) return Southeast
				if(NORTHWEST) return Northwest
				if(SOUTHWEST) return Southwest
				else CRASH("Invalid direction.")

	proc
		//Gets a directional vector between two atoms
		DirectionBetween(var/atom/A, var/atom/B)
			var/vector2/delta = new /vector2(B.x - A.x, B.y - A.y)
			delta = delta.ToMagnitude(1)
			return delta

	proc
		VecDirectionBetween(var/vector2/A, var/vector2/B)
			var/vector2/delta = new /vector2(B.x - A.x, B.y - A.y)
			delta = delta.ToMagnitude(1)
			return delta

	proc
		//Returns a directional vector and a magnitude between
		DirMagBetween(var/atom/A, var/atom/B)
			if (get_turf(A) == get_turf(B))
				return list("direction" = Vector2.Zero, "magnitude" = 0)
			var/vector2/delta = new /vector2(B.x - A.x, B.y - A.y)
			return list("direction" = delta.ToMagnitude(1), "magnitude" = delta.Magnitude())
	proc
		MagnitudeBetween(var/atom/A, var/atom/B, var/magnitude)
			var/vector2/delta = new /vector2(B.x - A.x, B.y - A.y)
			delta = delta.ToMagnitude(magnitude)
			return delta

	proc
		TurfAtMagnitudeBetween(var/atom/A, var/atom/B, var/magnitude)
			var/vector2/delta = MagnitudeBetween(A, B, magnitude)
			return locate(A.x + delta.x, A.y + delta.y, A.z)

	proc
		RandomDirection()
			var/vector2/delta = new /vector2(rand(), rand())
			return delta.ToMagnitude(1)

	proc
		VectorAverage(var/vector2/A)
			if (A)
				return (A.x + A.y) / 2