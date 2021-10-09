
#define RAISE_EVENT(event_source, observation, arguments...) ( !event_source.observations?[GLOB.##observation] ? NONE : GLOB.##observation.RaiseEvent(event_source, list(event_source, ##arguments)) )
