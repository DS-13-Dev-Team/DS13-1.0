/// Used to trigger observations and call procs registered for that observation
/// The datum hosting the observation is automaticaly added as the first argument
/// Returns a bitfield gathered from all registered procs
/// Arguments given here are packaged in a list and given to _RaiseEvenet
#define RAISE_EVENT(listener, obstype, arguments...) ( !listener.observations || !listener.observations[obstype.name] ? NONE : listener._RaiseEvent(obstype, list(listener, ##arguments)) )

#define RAISE_GLOBAL_EVENT(obstype, arguments...) ( RAISE_EVENT(SSobservation, obstype, ##arguments) )
