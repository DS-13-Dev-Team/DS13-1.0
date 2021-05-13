/// Used to trigger observations and call procs registered for that observation
/// The datum hosting the observation is automaticaly added as the first argument
/// Returns a bitfield gathered from all registered procs
/// Arguments given here are packaged in a list and given to _RaiseEvenet
#define RAISE_EVENT(event_source, observation_datum, arguments...) ( !event_source.observations || !event_source.observations[observation_datum] ? NONE : observation_datum.RaiseEvent(event_source, list(event_source, ##arguments)) )
