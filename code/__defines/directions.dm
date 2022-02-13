//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define N_NORTH     2
#define N_SOUTH     4
#define N_EAST      16
#define N_WEST      256
#define N_NORTHEAST 32
#define N_NORTHWEST 512
#define N_SOUTHEAST 64
#define N_SOUTHWEST 1024


//String versions of direction defines
#define S_NORTH	"1"
#define S_SOUTH	"2"
#define S_EAST	"4"
#define S_WEST	"8"
#define S_NORTHEAST	"5"
#define S_NORTHWEST	"9"
#define S_SOUTHEAST	"6"
#define S_SOUTHWEST	"10"
#define S_UP	"16"
#define S_DOWN "32"

//Axes
#define LATERAL	list(EAST, WEST)	//East or west
#define LONGITUDINAL list(NORTH, SOUTH)	//North or South

/proc/direction_to_axis(var/direction)
	switch (direction)
		if (NORTH, SOUTH)
			return LONGITUDINAL
		if (EAST, WEST)
			return LATERAL


//Connection indexes
#define CONNECTION_NORTH	1
#define CONNECTION_SOUTH	2
#define CONNECTION_EAST	3
#define CONNECTION_WEST	4

#define LIST_CORNERS list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)