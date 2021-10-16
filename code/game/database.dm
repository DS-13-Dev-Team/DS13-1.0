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
		log_world("Database connection established ? [dbcon.IsConnected()]")
		callHook("database_connected")

	else
		log_world("Your server failed to establish a connection with the database.")
	return success

proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = CONFIG_GET(string/login)
	var/pass = CONFIG_GET(string/password)
	var/db = CONFIG_GET(string/database)
	var/address = CONFIG_GET(string/address)
	var/port = CONFIG_GET(number/port)


	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )

		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.

		return TRUE
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		log_world(dbcon.ErrorMsg())
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
