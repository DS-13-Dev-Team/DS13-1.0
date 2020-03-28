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