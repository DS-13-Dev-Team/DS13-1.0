/*
Written by dog in the baystation discord

Byond implements a set of undocumented functions that map to libmysql
or libmariadb. They are used in SSmysql to provide a minimal interface
for querying either a mysql or mariadb server. As is tradition, refer
to https://secure.byond.com/developer/Dantom/DB for a DBI that uses them
in a more flexible way. Their behavior is explained here to avoid needing
to dig next time.
--------

_dm_db_new_con()
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-init.html
		https://dev.mysql.com/doc/c-api/8.0/en/c-api-data-structures.html
	return:
		A new connection handle as a /list instance.
	description:
		Creates a Connection Handle, CH. A CH is an object used to refer to
		and hold the state of a database connection. A CH holds a MYSQL data
		structure on the inside. A CH is a /list instance in DM land, but
		should not be used like one.

_dm_db_new_query()
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/c-api-data-structures.html
	return:
		A new query handle as a /list instance.
	description:
		Creates a Query Handle, QH. A QH is an object used to refer to and
		persist the state of a mysql query, and is an interfacce to a MYSQL_RES
		data structure. A QH is a /list instance in DM land, but should not be
		used like one.

_dm_db_connect(CH, DSN, username, password, cursor_type, null)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-connect.html
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-real-connect.html
		https://en.wikipedia.org/wiki/Data_source_name
	return:
		A TRUE/FALSE success of connecting
	parameters:
		CH:
			An UNUSED Connection handle created with _dm_db_new_con
		DSN:
			A data source name string with the database name, address, and port
			of the form "dbi:mysql:[name]:[address]:[port]".
		username:
			The account to use for database permissions.
		password:
			The password of the account.
		cursor_type:
			The type of cursor the connection will use, from:
				null - Same as Default
				0 - Default
				1 - Client
				2 - Server
		trailing null:
			Unknown, but null.
	description:
		Attempts to connect CH to the database specified by DSN with user and
		pass. The last two parameters should almost always be null, null.

_dm_db_is_connected(CH)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-ping.html
	return:
		A TRUE/FALSE of whether CH is open.
	parameters:
		CH:
			A connection handle.
	description:
		Whether the connection handle is open. Unlike ping, does not attempt
		to reconnect if not. If you previously had an open CH and this returns
		FALSE, create a new one instead of reusing it.

_dm_db_close(CH or QH)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-close.html
	return:
		A TRUE/FALSE of the success of closing the CH or QH.
	parameters:
		CH:
			A connection handle.
		or QH:
			A query handle.
	description:
		Given a CH, closes it if it is open. Do not reuse a closed CH;
		create a new one instead. Given a QH, clears it if it is used.
		While a cleared QH can be reused, it is better practice to
		create a new one instead.

_dm_db_error_msg(CH or QH)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-error.html
	return:
		Null if CH or QH are not valid, or the last error message associated
		with either, or an empty string if there was no error.
	parameters:
		CH:
			A connection handle.
		or QH:
			A query handle.
	description:
		Fetches the last error text associated with CH or QH. If there was
		no error, will fetch an empty string instead.

_dm_db_execute(QH, query_text, CH, cursor_type, null)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-query.html
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-real-query.html
	return:
		A TRUE/FALSE on whether query_text executed successfully. Note that
		if a query contains multiple statements, this will be FALSE even if
		only one fails.
	parameters:
		QH:
			A clean query handle.
		query_text:
			SQL text to execute.
		CH:
			An open connection handle.
		cursor_type:
			The type of cursor the connection will use, from:
				null - Same as Default
				0 - Default
				1 - Client
				2 - Server
		trailing null:
			Unknown, but null.
	description:
		Executes the SQL in query_text against CH, holding the result state
		in QH. As with _dm_db_connect, the last two parameters should almost
		always be null, null.

_dm_db_quote(CH, text)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-real-escape-string.html
	return:
		Null if CH is not valid or not open, otherwise the value of text with
		the characters \, ', ", NUL (ASCII 0), \n, \r, and Control+Z escaped
		according to the CH database's charset.
	parameters:
		CH:
			An open connection handle.
		text:
			A value that will be interpolated into a SQL statement.
	description:
		Provides some protection against SQL injection attacks and should be
		used to sanitize any input that will be sent as part of a query. NOT
		a magic bullet, but okayish.

_dm_db_row_count(QH)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-num-rows.html
	return:
		The count of rows in the query's result set, if there is one.
	parameters:
		QH: A used query handle.
	description:
		Information-returning queries like SELECT cause this value to
		be set according to how many rows the query has selected. Most
		of the time it is better to use _dm_db_rows_affected.

_dm_db_rows_affected(QH)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-affected-rows.html
	return:
		The number of rows in the query's result set, if there is one,
		or the number of rows the query changed, if it did that.
	parameters:
		QH:
			A used query handle.
	description:
		Acts like _dm_db_row_count for SELECT queries. For queries that
		change data like INSERT or UPDATE, instead shows the number of
		rows they changed. Usually preferable to _dm_db_rows_affected.

_dm_db_next_row(QH, value_list, conversions_list)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-fetch-row.html
	return:
		A TRUE/FALSE of whether this function has populated value_list
		by being called. If FALSE, you have finished the result set and
		there is no more data to handle.
	parameters:
		QH:
			A used query handle.
		value_list:
			An *instantiated* /list instance that will be cleared and then
			populated with the values in the next row, if there is one.
		conversions_list:
			Null, or a /list of mysql type to byond type? hints that skip duck
			typing and allow you to specify. Mostly you should pass null because
			this behavior is rarely helpful. If a list, the type codes are:
				TINYINT 1
				SMALLINT 2
				MEDIUMINT 3
				INTEGER 4
				BIGINT 5
				DECIMAL 6
				FLOAT 7
				DOUBLE 8
				DATE 9
				DATETIME 10
				TIMESTAMP 11
				TIME 12
				STRING 13
				BLOB 14
	description:
		Advances the result row of the query made against CH and held in QH,
		populating value_list with the row if there is one after advancing, then
		telling you if you have anything new in value_list to deal with.

_dm_db_columns(QH, metadata_type)
	references:
		https://dev.mysql.com/doc/c-api/8.0/en/mysql-fetch-fields.html
	return:
		An associative list of column_name = column_metadata in the same order as
		data in value_list on _dm_db_next_row for the last query on QH, where
		column_metadata is an instance of metadata_type or null.
	parameters:
		QH:
			A used query handle.
		metadata_type:
			Null, or a type that will be created once for each column in the
			result set on QH. The type is created by calling its New in with
			ordered parameters:
				column_name,
				table_name,
				index_in_value_list,
				text_sql_type,
				column_flags,
				length_of_current_value,
				column_max_length
	description:
		Gets the column names of the result of a query and gives you their
		metadata if you want it. Typically, passing null instead of a type
		is preferable, because you very rarely want any of the extra info.
		Iterating over the result list's keys to flatten it is useful, but
		replacing its values with lists so that they can be populated by row
		data is also an option.
--------
*/
