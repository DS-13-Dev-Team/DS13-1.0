// Macro functions.
#define RAND_F(LOW, HIGH) (rand()*(HIGH-LOW) + LOW)
#define ceil(x) (-round(-(x)))
#define CEILING(x, y) ( -round(-(x) / (y)) * (y) )

// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	if (max == min)
		return min
	var/d = max - min
	var/t = Floor((val - min) / d)
	return val - (t * d)

/proc/Default(a, b)
	return a ? a : b

// Trigonometric functions.
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/Csc(x)
	return 1 / sin(x)

/proc/Sec(x)
	return 1 / cos(x)

/proc/Cot(x)
	return 1 / Tan(x)

/proc/Atan2(x, y)
	if(!x && !y) return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

/proc/Floor(x)
	return round(x)


/proc/floor_to_multiple(x, multiple)
	return (x - (x % multiple))

/proc/Ceiling(x)
	return -round(-x)

/proc/ceiling_to_multiple(x, multiple)
	return ((x - (x % multiple)) + multiple)

// Greatest Common Divisor: Euclid's algorithm.
/proc/Gcd(a, b)
	while (1)
		if (!b) return a
		a %= b
		if (!a) return b
		b %= a

// Least Common Multiple. The formula is a consequence of: a*b = LCM*GCD.
/proc/Lcm(a, b)
	return abs(a) * abs(b) / Gcd(a, b)

// Useful in the cases when x is a large expression, e.g. x = 3a/2 + b^2 + Function(c)
/proc/Square(x)
	return x*x

/proc/Inverse(x)
	return 1 / x

// Condition checks.
/proc/IsAboutEqual(a, b, delta = 0.1)
	return abs(a - b) <= delta

// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return (val >= min) && (val <= max)

/proc/IsInteger(x)
	return Floor(x) == x

/proc/IsMultiple(x, y)
	return x % y == 0

/proc/IsEven(x)
	return !(x & 0x1)

/proc/IsOdd(x)
	return  (x & 0x1)

// Performs a linear interpolation between a and b.
// Note: weight=0 returns a, weight=1 returns b, and weight=0.5 returns the mean of a and b.
/proc/Interpolate(a, b, weight = 0.5)
	return a + (b - a) * weight // Equivalent to: a*(1 - weight) + b*weight

/proc/rand_between(var/lower, var/upper)
	return (rand() * (upper - lower)) + lower

/proc/Mean(...)
	var/sum = 0
	for(var/val in args)
		sum += val
	return sum / args.len

// Returns the nth root of x.
/proc/Root(n, x)
	return x ** (1 / n)

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)

	. = list()
	var/discriminant = b*b - 4*a*c
	var/bottom       = 2*a

	// Return if the roots are imaginary.
	if(discriminant < 0)
		return

	var/root = sqrt(discriminant)
	. += (-b + root) / bottom

	// If discriminant == 0, there would be two roots at the same position.
	if(discriminant != 0)
		. += (-b - root) / bottom

/proc/ToDegrees(radians)
	// 180 / Pi ~ 57.2957795
	return radians * 57.2957795

/proc/ToRadians(degrees)
	// Pi / 180 ~ 0.0174532925
	return degrees * 0.0174532925

// Vector algebra.
/proc/squaredNorm(x, y)
	return x*x + y*y

/proc/norm(x, y)
	return sqrt(squaredNorm(x, y))

/proc/IsPowerOfTwo(var/val)
	return (val & (val-1)) == 0

/proc/RoundUpToPowerOfTwo(var/val)
	return 2 ** -round(-log(2,val))


/*
	This proc makes the input taper off above cap. But there's no absolute cutoff.
	Chunks of the input value above cap, are reduced more and more with each successive one and added to the output

	A higher input value always makes a higher output value. but the rate of growth slows

*/
/proc/soft_cap(var/input, var/cap = 0, var/groupsize = 1, var/groupmult = 0.9)

	//The cap is a ringfenced amount. If we're below that, just return the input
	if (input <= cap)
		return input

	var/output = 0
	var/buffer = 0
	var/power = 1//We increment this after each group, then apply it to the groupmult as a power

	//Ok its above, so the cap is a safe amount, we move that to the output
	input -= cap
	output += cap

	//Now we start moving groups from input to buffer


	while (input > 0)
		buffer = min(input, groupsize)	//We take the groupsize, or all the input has left if its less
		input -= buffer

		buffer *= groupmult**power //This reduces the group by the groupmult to the power of which index we're on.
		//This ensures that each successive group is reduced more than the previous one

		output += buffer
		power++ //Transfer to output, increment power, repeat until the input pile is all used

	return output


//This proc returns all turfs which fall inside a cone stretching Distance tiles from origin, in direction, and being angle degrees wide
/proc/get_cone(var/turf/origin, var/vector2/direction, var/distance, var/angle)

	if (!istype(direction))
		direction = Vector2.FromDir(direction)	//One of the byond direction constants may be passed in

	angle *= 0.5//We split the angle in two for the arc function

	if (!istype(origin))
		origin = get_turf(origin)

	//First of all, lets find a centre point. Halfway between origin and the edge of the cone
	var/turf/halfpoint = locate(origin.x + (direction.x * distance * 0.5), origin.y + (direction.y * distance * 0.5), origin.z)

	//And from this halfpoint, lets get a square area of turfs which is every possible turf that could be in the cone
	//We use half the distance as radius, +1 to account for any rounding errors. Its not a big deal if we get some unnecessary turfs in here
	var/list/turfs = trange(((distance*0.5) + 1), halfpoint)

	//Alright next up, we loop through the turfs. for each one:

	for (var/turf/T as anything in turfs)
		//1. We check if its distance is less than the requirement. This is cheap. If it is...
		var/dist_delta = get_dist_euclidian(origin, T)
		if (dist_delta > distance)
			turfs -= T

		//2. We check if it falls within the desired angle
		if (!target_in_arc(origin, T, direction, angle))
			turfs -= T

	//Alright we've removed all the turfs which aren't in the cone!
	return turfs

/proc/get_view_cone(var/turf/origin, var/vector2/direction, var/distance, var/angle)
	if (!istype(origin))
		origin = get_turf(origin)
	var/list/viewlist = origin.turfs_in_view(distance)
	var/list/conelist = get_cone(origin, direction, distance, angle)

	return (viewlist & conelist)

//This hella complex proc gets a cone, but divided into several smaller cones. Returns a list of lists, each containing the tiles of the subcone
//No overlapping is allowed, each subcone contains a unique list
/proc/get_multistage_cone(var/turf/origin, var/vector2/direction, var/distance, var/angle, var/stages = 5, var/clock_direction = CLOCKWISE)
	var/subcone_angle = angle / stages
	var/vector2/subcone_direction

	//If clockwise, we rotate anticlockwise to the start, by half of the main angle minus half of the subcone angle
	if (clock_direction == CLOCKWISE)
		//And after this we'll add the subcone angle to eacch direction to get the next subcone centre
		subcone_direction = direction.Turn((angle*0.5 - subcone_angle*0.5)*-1)

	//If clockwise, we rotate clockwise to the end, by half of the main angle minus half of the subcone angle
	else if (clock_direction == ANTICLOCKWISE)
		subcone_direction = direction.Turn(angle*0.5 - subcone_angle*0.5)
		subcone_angle *= -1	//And we invert the subcone angle, since we'll still be adding it


	var/list/subcones = list()
	var/list/all_tiles = list()
	for (var/i in 1 to stages)
		//For each stage, we'll get the subcone
		var/list/subcone = get_cone(origin, subcone_direction, distance, abs(subcone_angle))
		subcone -= all_tiles	//Filter out any tiles that are already in another subcone

		//Don't add empty cones to lists
		if (length(subcone) > 0)
			all_tiles += subcone	//Then add ours to the global list
			subcones += list(subcone)	//And add this cone to the list of all the cones

		subcone_direction = subcone_direction.Turn(subcone_angle)

	return subcones

/proc/shortest_angle(var/delta)
	return (delta - round(delta, 360))
#define CLAMP(CLVALUE,CLMIN,CLMAX) ( max( (CLMIN), min((CLVALUE), (CLMAX)) ) )

// Similar to clamp but the bottom rolls around to the top and vice versa. min is inclusive, max is exclusive


/client/verb/multistage_cone_test()



	var/vector2/direction = new /vector2(rand(), rand())
	direction = direction.Normalized()

	var/list/C = get_multistage_cone(get_turf(mob), direction, 6, 120, 20, CLOCKWISE)

	for (var/list/subcone in C)
		var/newcolor = RANDOM_RGB
		for (var/turf/T in subcone)
			debug_mark_turf(T, 30, newcolor)