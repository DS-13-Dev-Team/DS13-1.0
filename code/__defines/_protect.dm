///Protects a datum from being VV'd
#define GENERAL_PROTECT_DATUM(Path)\
##Path/get_variable_value(var_name){\
	return;\
}\
##Path/may_edit_var(var_user, var_name){\
	return FALSE;\
}\
##Path/CanProcCall(procname){\
	return FALSE;\
}