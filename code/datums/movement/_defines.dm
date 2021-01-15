// These are designed to be used within /datum/movement_handler procs
// Do not attempt to use in /atom/movable/proc/DoMove, /atom/movable/proc/MayMove, etc.
#define IS_SELF(w) !IS_NOT_SELF(w)
#define IS_NOT_SELF(w) (w && w != host)


// If is_external is explicitly set then use that, otherwise if the mover isn't the host assume it's external
#define SET_MOVER(X) X = X || src
#define SET_IS_EXTERNAL(X) is_external = isnull(is_external) ? (mover != src) : is_external


#define INIT_MOVEMENT_HANDLERS \
if(LAZYLEN(movement_handlers) && ispath(movement_handlers[1])) { \
	var/new_handlers = list(); \
	for(var/path in movement_handlers){ \
		var/arguments = movement_handlers[path];   \
		arguments = arguments ? (list(src) | (arguments)) : list(src); \
		new_handlers += new path(arglist(arguments)); \
	} \
	movement_handlers= new_handlers; \
}

#define REMOVE_AND_QDEL(X) LAZYREMOVE(movement_handlers, X); qdel(X);