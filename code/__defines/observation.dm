/// Used to trigger observations and call procs registered for that observation
/// The datum hosting the observation is automaticaly added as the first argument
/// Returns a bitfield gathered from all registered procs
/// Arguments given here are packaged in a list and given to _RaiseEvenet
#define RAISE_EVENT(source_event, obstype, arguments...) ( !source_event.observations || !source_event.observations[obstype.name] ? NONE : source_event.RaiseEvent(obstype, list(source_event, ##arguments)) )

#define RAISE_GLOBAL_EVENT(obstype, arguments...) ( RAISE_EVENT(SSobservation, obstype, ##arguments) )
