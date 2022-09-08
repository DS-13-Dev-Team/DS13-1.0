#define HAS_TRANSFORMATION_MOVEMENT_HANDLER(X) X.HasMovementHandler(/datum/movement_handler/mob/transformation)
#define ADD_TRANSFORMATION_MOVEMENT_HANDLER(X) X.AddMovementHandler(/datum/movement_handler/mob/transformation)
#define DEL_TRANSFORMATION_MOVEMENT_HANDLER(X) X.RemoveMovementHandler(/datum/movement_handler/mob/transformation)

// Quick and deliberate movements are not necessarily mutually exclusive
#define MOVE_INTENT_DELIBERATE (1<<0)
#define MOVE_INTENT_EXERTIVE   (1<<1)
#define MOVE_INTENT_QUICK      (1<<2)
#define MOVE_INTENT_SILENT	   (1<<3)

#define MOVING_DELIBERATELY(X) (X.move_intent.flags & MOVE_INTENT_DELIBERATE)
#define MOVING_QUICKLY(X) (X.move_intent.flags & MOVE_INTENT_QUICK)
#define MOVING_SILENT(X) (X.move_intent.flags & MOVE_INTENT_SILENT)

//Takes a speed in metres per second, and outputs delay in deciseconds between each step to achieve that
#define SPEED_TO_DELAY(speed) (10/speed)

//Takes a speed in metres per second, and outputs the number of ticks to wait between each step to achieve that
#define SPEED_TO_TICKS(speed) (SPEED_TO_DELAY(speed) / world.tick_lag)

/// The minimum for glide_size to be clamped to.
#define MIN_GLIDE_SIZE 1
/// The maximum for glide_size to be clamped to.
/// This shouldn't be higher than the icon size, and generally you shouldn't be changing this, but it's here just in case.
#define MAX_GLIDE_SIZE 32

/// Compensating for time dialation
GLOBAL_VAR_INIT(glide_size_multiplier, 1.0)

///Broken down, here's what this does:
/// divides the world icon_size (32) by delay divided by ticklag to get the number of pixels something should be moving each tick.
/// The division result is given a min value of 1 to prevent obscenely slow glide sizes from being set
/// Then that's multiplied by the global glide size multiplier. 1.25 by default feels pretty close to spot on. This is just to try to get byond to behave.
/// The whole result is then clamped to within the range above.
/// Not very readable but it works
#define DELAY2GLIDESIZE(delay) (clamp(((world.icon_size / max((delay) / world.tick_lag, 1)) * GLOB.glide_size_multiplier), MIN_GLIDE_SIZE, MAX_GLIDE_SIZE))

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