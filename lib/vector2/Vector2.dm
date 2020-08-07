/* A 2D vector datum with overloaded operators and other common functions.
*/
//Converts a vector to a string
/proc/vstr(var/vector2/input)
	if (istype(input))
		return "([input.x], [input.y])"
	else if (isnull(input))
		return "(null)"
	else
		return "(wrongtype)"

vector2
	var x
	var y

	/* Takes 2 numbers or a vector2 to copy.
	*/
	New(x = 0, y = 0)
		..()
		if(isnum(x)) if(!isnum(y)) y = x

		else if(istype(x, /vector2))
			var vector2/v = x
			x = v.x
			y = v.y

		else CRASH("Invalid args.")

		src.x = x
		src.y = y

	proc
		/* Equivalence checking. Compares components exactly.
		*/
		operator~=(vector2/v) return v ? x == v.x && y == v.y : FALSE

		/* Vector addition.
		*/
		operator+(vector2/v) return v ? new/vector2(x + v.x, y + v.y) : src

		/* Vector subtraction and negation.
		*/
		operator-(vector2/v) return v ? new/vector2(x - v.x, y - v.y) : new/vector2(-x, -y)

		/* Vector scaling.
		*/
		operator*(s)
			// Scalar
			if(isnum(s)) return new/vector2(x * s, y * s)

			// Transform
			else if(istype(s, /matrix))
				var matrix/m = s
				return new/vector2(x * m.a + y * m.b + m.c, x * m.d + y * m.e + m.f)

			// Component-wise
			else if(istype(s, /vector2))
				var vector2/v = s
				return new/vector2(x * v.x, y * v.y)

			else CRASH("Invalid args.")

		/* Vector inverse scaling.
		*/
		operator/(d)
			// Scalar
			if(isnum(d)) return new/vector2(x / d, y / d)

			// Inverse transform
			else if(istype(d, /matrix)) return src * ~d

			// Component-wise
			else if(istype(d, /vector2))
				var vector2/v = d
				return new/vector2(x / v.x, y / v.y)

			else CRASH("Invalid args.")

		/* Vector dot product.
			Returns the cosine of the angle between the vectors.
		*/
		Dot(vector2/v) return x * v.x + y * v.y

		/* Z-component of the 3D cross product.
			Returns the sine of the angle between the vectors.
		*/
		Cross(vector2/v) return x * v.y - y * v.x

		/* Square of the magnitude of the vector.
			Commonly used for comparing magnitudes more efficiently than with Magnitude.
		*/
		SquareMagnitude() return Dot(src)

		/* Magnitude of the vector.
		*/
		Magnitude() return hypot(x, y)

		/* Get a vector in the same direction but with magnitude m.
			Be careful about dividing by zero. This won't work with the zero vector.
		*/
		ToMagnitude(m)
			if(isnum(m)) return src * (m / Magnitude())
			else CRASH("Invalid args.")

		/*
			Get a vector in the same direction, with its magnitude clamped between minimum and maximum
		*/
		ClampMag(var/minimum, var/maximum)

			var/current_magnitude = Magnitude()
			if (current_magnitude < minimum)
				return ToMagnitude(minimum)

			if (current_magnitude > maximum)
				return ToMagnitude(maximum)

			//If we're within range, do this anyway to return a copy of ourselves
			.=src.ToMagnitude(current_magnitude)

		/* Get a vector in the same direction but with magnitude 1.
		*/
		Normalized() return ToMagnitude(1)

		/*
			Safe version of the above that sacrifices performance for robustness
		*/
		SafeNormalized()
			if (NonZero())
				return ToMagnitude(1)
			else
				return new /vector2(0,0)

		/* Convert the vector to text with a specified number of significant figures.
		*/
		ToText(SigFig) return "vector2([num2text(x, SigFig)], [num2text(y, SigFig)])"

		/* Get the components via index (1, 2) or name ("x", "y").
		*/
		operator[](index)
			switch(index)
				if(1, "x") return x
				if(2, "y") return y
				else CRASH("Invalid args.")

		/* Get the matrix that rotates north to point in this direction.
			This can be used as the transform of an atom whose icon is drawn pointing north.
		*/
		Rotation() return RotationFrom(Vector2.North)

		/* Get the matrix that rotates from_vector to point in this direction.
			This can be used as the transform of an atom whose icon is drawn pointing in the direction of from_vector.
			Also accepts a dir.
		*/
		RotationFrom(vector2/from_vector = Vector2.North)
			var vector2/to_vector = Normalized()

			if(isnum(from_vector)) from_vector = Vector2.FromDir(from_vector)

			if(istype(from_vector, /vector2))
				from_vector = from_vector.Normalized()
				var
					cos_angle = to_vector.Dot(from_vector)
					sin_angle = to_vector.Cross(from_vector)
				return matrix(cos_angle, sin_angle, 0, -sin_angle, cos_angle, 0)

			else CRASH("Invalid 'from' vector.")



		/* Get the angle that rotates north to point in this direction.
			this can be fed into the Turn proc to apply to matrices and vectors
		*/
		Angle()	return AngleFrom(Vector2.North)


		//Projects this vector onto another
		Projection(var/vector2/onto)
			var/vector2/result = (onto*(src.Dot(onto) / onto.Dot(onto)))
			return result


		Rejection(var/vector2/onto)
			var/vector2/result = src - Projection(onto)
			return result


		SafeProjection(var/vector2/onto)
			if (NonZero() && onto && onto.NonZero())
				var/vector2/result = (onto*(src.Dot(onto) / onto.Dot(onto)))
				return result
			return new /vector2(0,0)


		SafeRejection(var/vector2/onto)
			if (NonZero() && onto && onto.NonZero())
				var/vector2/result = src - Projection(onto)
				return result
			return new /vector2(0,0)

		/* Get the matrix that rotates from_vector to point in this direction.
			Also accepts a dir.
		*/
		AngleFrom(vector2/from_vector = Vector2.North, var/shorten = FALSE)
			var vector2/to_vector = Normalized()

			if(isnum(from_vector)) from_vector = Vector2.FromDir(from_vector)

			var/angle = (Atan2(to_vector.y, to_vector.x) - Atan2(from_vector.y, from_vector.x))

			if (shorten)
				angle = shortest_angle(angle)

			return angle

		/* Get a vector with the same magnitude rotated by a clockwise angle in degrees.
		*/
		Turn(angle) return src * matrix().Turn(angle)

		FloorVec()
			return new/vector2(Floor(x), Floor(y))

		CeilingVec()
			return new/vector2(Ceiling(x), Ceiling(y))


		NonZero()
			if (x != 0 || y != 0)
				return TRUE
			else
				return FALSE