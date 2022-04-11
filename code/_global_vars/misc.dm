GLOBAL_LIST_EMPTY(all_observable_events)

GLOBAL_LIST_INIT(font_resources, list('fonts/Shage/Shage.ttf'))

//Holds cached icons for items used in recipes
GLOBAL_LIST_EMPTY(initialTypeIcon)

GLOBAL_VAR_INIT(timezoneOffset, 0)   // The difference betwen midnight (of the host computer) and 0 world.ticks.

GLOBAL_LIST_EMPTY(craftitems)

GLOBAL_VAR_INIT(current_date_string, "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], [GAME_YEAR]")

GLOBAL_VAR_INIT(triai, FALSE)

GLOBAL_VAR(cinematic)
