#define dump_args	for (var/thing in args)	{ to_chat(world, "[thing]") }

#define dump_vars(x)	for (var/thing in x:vars) { to_chat(world, "[thing]:	[x:vars[thing]]") }