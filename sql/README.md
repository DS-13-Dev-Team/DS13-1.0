### Prerequisites

The server connects to a mysql-compatible server (mysql, mariadb, percona), so you'll need one of those with a database and user/password pair ready.

We use [flyway](https://flywaydb.org/) to manage database migrations. To set up the database, you'll need to [download flyway](https://flywaydb.org/getstarted/download.html).

You'll also need some proficiency with the command line.

---

### Initial setup

Using a command line, first CD to the root project directory. For example:
	cd C:\Projects\DeadSpace13\baystation12


In the root project directory, run:

    path/to/flyway.cmd migrate -user=USER -password=PASSWORD -url=jdbc:mysql://HOST:PORT/DATABASE
	
	For example:
	C:\Projects\Flyway\flyway-commandline-7.11.0-windows-x64\flyway-7.11.0\flyway.cmd migrate -user=root -password=****** -url=jdbc:mysql://localhost:3306/database

Where USER is your mysql username, PASSWORD is your mysql password, HOST is the hostname of the mysql server and DATABASE is the database to use.

---

### Migrating

Use the same command as above. Handy, isn't it?

---

### Using a pre-flyway database

If you're using a database since before we moved to flyway, it's a bit more involved to get migrations working.

In the root project directory, run:

    path/to/flyway baseline -user=USER -password=PASSWORD -url=jdbc:mysql://HOST/DATABASE -baselineVersion=001 -baselineDescription="Initial schema"

From there, you can run migrations as normal.

---

### Configuration file

Instead of putting -user, -password and -url in the command line every time you execute flyway, you can use a config file. Create it somewhere in the root of your project (we're calling it 'db.conf'):

    flyway.url=jdbc:mysql://HOST/DATABASE
    flyway.user=USER
    flyway.password=PASSWORD

Now you can just run `flyway migrate -configFile=db.conf`, and the settings will be loaded from config.


---

Troubleshooting:
Added by Nanako
Solutions to some problems I personally ran into

Connection Error: Can't initialize character set unknown (path: compiled_in)
-----------------------------------------------------------------------------
This is caused by not having a character set setup for the server. To fix this, you need to find and edit my.ini
On windows 10, it is located in C:\ProgramData\MySQL\MySQL Server X.X

Note: This section should not just be copypasted as is, copy the three individual sections and paste them in under the appropriate heading in the ini
Set these values in that ini:
[client]
default-character-set = utf8mb4

[mysql]
default-character-set = utf8mb4

[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci




Plugin caching_sha2_password could not be loaded: The specified module could not be found. 
-------------------------------------------------------------------------------------------
This will happen if you use the default settings while installing mysql. You need to run the installer again and pick the legacy authentication option to change it over
But then you also need to update the auth method for existing users (presumably just root)

Connect to your MySQL under root in a command line client and execute:

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xxx';



If you want to wipe all the tables and start over, use this:
DROP TABLE IF EXISTS `characters`;
DROP TABLE IF EXISTS `credit_lastround`;
DROP TABLE IF EXISTS `credit_records`;
DROP TABLE IF EXISTS `death`;
DROP TABLE IF EXISTS `erro_admin`;
DROP TABLE IF EXISTS `erro_admin_log`;
DROP TABLE IF EXISTS `erro_ban`;
DROP TABLE IF EXISTS `erro_feedback`;
DROP TABLE IF EXISTS `erro_player`;
DROP TABLE IF EXISTS `erro_poll_option`;
DROP TABLE IF EXISTS `erro_poll_question`;
DROP TABLE IF EXISTS `erro_poll_textreply`;
DROP TABLE IF EXISTS `erro_poll_vote`;
DROP TABLE IF EXISTS `erro_privacy`;
DROP TABLE IF EXISTS `flyway_schema_history`;
DROP TABLE IF EXISTS `library`;
DROP TABLE IF EXISTS `population`;
DROP TABLE IF EXISTS `ranks`;
DROP TABLE IF EXISTS `whitelist`;
DROP TABLE IF EXISTS `store_schematics`;