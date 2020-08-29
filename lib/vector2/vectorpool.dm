/*
	Vector pooling solution
	Keeps vectors in a global list and recycles them

	Creates new ones when needed
*/

GLOBAL_LIST_EMPTY(vector_pool)
GLOBAL_VAR_INIT(vector_pool_filling, FALSE)

//GLOBAL_VAR_INIT(vectors_created, 0)
//GLOBAL_VAR_INIT(vectors_recycled, 0)

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
	if (length(GLOB.vector_pool))
		var/vector2/newvec
		macropop(GLOB.vector_pool, newvec)
		newvec.x = new_x
		newvec.y = new_y
		return newvec

	else
		//If we failed to get one from the list, make a new one for almost-immediate return
		.=new /vector2(new_x,new_y)
		//GLOB.vectors_created++
		//And start the pool filling if needed
		if (!GLOB.vector_pool_filling)
			spawn()
				fill_vector_pool()


//Releasing vectors is handled via a define in _macros.dm



/client/proc/debug_vectorpool()
	set category = "Debug"
	set name = "Vector Pool Debug"
	to_chat(src, "Vecpool: [length(GLOB.vector_pool)]")
	//to_chat(src, "Created: [GLOB.vectors_created]")
	//to_chat(src, "Recycled: [GLOB.vectors_recycled]")