#define QDELING(X) (X.gc_destroyed)
#define QDELETED(X) (!X || QDELING(X))
#define QDESTROYING(X) (!X || X.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)

#define QDEL_IN(item, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, item), time, TIMER_STOPPABLE)
#define QDEL_IN_CLIENT_TIME(item, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, item), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)
#define QDEL_NULL(item) qdel(item); item = null
#define QDEL_NULL_LIST(L) for(var/y in L) qdel(y); L = null;
#define QDEL_LIST(L) for(var/I in L) qdel(I); L?.Cut();
#define QDEL_LIST_IN(L, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/______qdel_list_wrapper, L), time, TIMER_STOPPABLE)
#define QDEL_ASSOC_LIST(L) for(var/I in L) { qdel(L[I]); qdel(I); } L?.Cut();
#define QDEL_LIST_ASSOC_VAL(L) for(var/I in L) qdel(L[I]); L?.Cut();
#define QDEL_NULL_IN(obj, var, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/______qdel_null_wrapper, obj, var), time, TIMER_STOPPABLE)

/proc/______qdel_list_wrapper(list/L) //the underscores are to encourage people not to use this directly.
	QDEL_LIST(L)

/proc/______qdel_null_wrapper(datum/D, var_name)
	qdel(D.vars[var_name])
	D.vars[var_name] = null