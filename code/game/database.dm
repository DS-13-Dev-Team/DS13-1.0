#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0
var/failed_old_db_connections = 0

/hook/startup/proc/connectDB()
	var/success = FALSE
	while (failed_db_connections < FAILED_DB_CONNECTION_CUTOFF && !success)
		var/result = setup_database_connection()
		if(!result)
			sleep(10)
		else
			success = TRUE

	if (success)
		world.log << "Feedback database connection established ? [dbcon.IsConnected()]"

	else
		world.log << "Your server failed to establish a connection with the feedback database."
	return success

proc/setup_database_connection()

	log_world("Setting up DB connection 1")
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		log_world("Setting up DB connection 2, too many failures")
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = CONFIG_GET(string/login)
	var/pass = CONFIG_GET(string/password)
	var/db = CONFIG_GET(string/database)
	var/address = CONFIG_GET(string/address)
	var/port = CONFIG_GET(number/port)

	log_world("Setting up DB connection 3: attempting connect:\n\
	[user]\n\
	[pass]\n\
	[db]\n\
	[address]\n\
	[port]")
	var/result = dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	log_world("Setting up DB connection 3.5 R:[result]")
	. = dbcon.IsConnected()
	log_world("Setting up DB connection 4, Connected status [.]!")
	if ( . )

		log_world("Setting up DB connection 5a, Success!")
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.

		return TRUE
	else
		log_world("Setting up DB connection 5b, fail [failed_db_connections]")
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()
		return FALSE


//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1



#undef FAILED_DB_CONNECTION_CUTOFF
