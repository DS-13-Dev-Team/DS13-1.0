/*
	Vector pooling solution
	Keeps vectors in a global list and recycles them

	Creates new ones when needed
*/

GLOBAL_LIST_EMPTY(vector_pool)
GLOBAL_VAR_INIT(vector_pool_filling, FALSE)

//Fills the pool with fresh vectors for later use. Sleeps while doing so to reduce lag.
//This can take as long as it needs to, and other procs may extend the time by taking from the pool while it fills
//If the pool runs empty during the process then vectors will be created on demand
/proc/fill_vector_pool()
	set waitfor = FALSE

	if (GLOB.vector_pool_filling)
		return

	GLOB.vector_pool_filling = TRUE
	while (length(GLOB.vector_pool) < VECTOR_POOL_FULL)
		sleep()
		GLOB.vector_pool += new /vector2(0,0)

	GLOB.vector_pool_filling = FALSE

/proc/get_new_vector(var/new_x, var/new_y)

	var/vector2/newvec = pop(GLOB.vector_pool)
	if (newvec)
		newvec.x = new_x
		newvec.y = new_y
		return newvec

	else
		//If we failed to get one from the list, make a new one for almost-immediate return
		.=new /vector2(new_x,new_y)

		//And start the pool filling if needed
		if (!GLOB.vector_pool_filling)
			spawn()
				fill_vector_pool()


//Releasing vectors is handled via a define in _macros.dm