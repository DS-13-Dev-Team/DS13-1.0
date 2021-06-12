#define HAS_TRANSFORMATION_MOVEMENT_HANDLER(X) X.HasMovementHandler(/datum/movement_handler/mob/transformation)
#define ADD_TRANSFORMATION_MOVEMENT_HANDLER(X) X.AddMovementHandler(/datum/movement_handler/mob/transformation)
#define DEL_TRANSFORMATION_MOVEMENT_HANDLER(X) X.RemoveMovementHandler(/datum/movement_handler/mob/transformation)

#define MOVING_DELIBERATELY(X) (X.move_intent.flags & MOVE_INTENT_DELIBERATE)
#define MOVING_QUICKLY(X) (X.move_intent.flags & MOVE_INTENT_QUICK)

//Takes a speed in metres per second, and outputs delay in deciseconds between each step to achieve that
#define SPEED_TO_DELAY(speed) (10/speed)

//Takes a speed in metres per second, and outputs the number of ticks to wait between each step to achieve that
#define SPEED_TO_TICKS(speed) (SPEED_TO_DELAY(speed) / world.tick_lag)

//Returned by structures which have no opinion on whether to allow/block ztransition, when asked
#define ZTRANSITION_MAYBE	-1

//Used for kinesis releasing
#define RELEASE_DROP	"drop"	//Drop on the floor right below us
#define RELEASE_THROW	"throw"	//Inherit velocity and continue flying
#define RELEASE_LAUNCH	"launch"	//Explicitly launched with a powerful burst of force. Like throw but faster, and rougher start


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

#define RUN_DELAY 2
#define WALK_DELAY 3.5
#define STALK_DELAY 6
#define MINIMUM_SPRINT_COST 0.8
#define SKILL_SPRINT_COST_RANGE 0.8
#define MINIMUM_STAMINA_RECOVERY 4
#define MAXIMUM_STAMINA_RECOVERY 6