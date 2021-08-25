#define dump_args	for (var/thing in args)	{ world << "[thing]"}

#define dump_vars(x)	for (var/thing in x:vars) { world << "[thing]:	[x:vars[thing]]"}