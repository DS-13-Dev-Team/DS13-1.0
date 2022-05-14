#define HAS_TRANSFORMATION_MOVEMENT_HANDLER(X) X.HasMovementHandler(/datum/movement_handler/mob/transformation)
#define ADD_TRANSFORMATION_MOVEMENT_HANDLER(X) X.AddMovementHandler(/datum/movement_handler/mob/transformation)
#define DEL_TRANSFORMATION_MOVEMENT_HANDLER(X) X.RemoveMovementHandler(/datum/movement_handler/mob/transformation)

#define MOVING_DELIBERATELY(X) (X.move_intent.flags & MOVE_INTENT_DELIBERATE)
#define MOVING_QUICKLY(X) (X.move_intent.flags & MOVE_INTENT_QUICK)
#define MOVING_SILENT(X) (X.move_intent.flags & MOVE_INTENT_SILENT)

//Takes a speed in metres per second, and outputs delay in deciseconds between each step to achieve that
#define SPEED_TO_DELAY(speed) (10/speed)

//Takes a speed in metres per second, and outputs the number of ticks to wait between each step to achieve that
#define SPEED_TO_TICKS(speed) (SPEED_TO_DELAY(speed) / world.tick_lag)

#define DELAY2GLIDESIZE(delay) (world.icon_size / max(Ceiling(delay / world.tick_lag), 1))

//Returned by structures which have no opinion on whether to allow/block ztransition, when asked
#define ZTRANSITION_MAYBE	-1

//Used for kinesis releasing
#define RELEASE_DROP	"drop"	//Drop on the floor right below us
#define RELEASE_THROW	"throw"	//Inherit velocity and continue flying
#define RELEASE_LAUNCH	"launch"	//Explicitly launched with a powerful burst of force. Like throw but faster, and rougher start




#define RUN_DELAY 1.6
#define WALK_DELAY 2.95
#define STALK_DELAY 6
#define MINIMUM_SPRINT_COST 0.85	//The part of sprint cost that everyone gets
#define SKILL_SPRINT_COST_RANGE 0.775	//The part of sprint cost that is affected by athletics
#define MINIMUM_STAMINA_RECOVERY 1.75
#define MAXIMUM_STAMINA_RECOVERY 5