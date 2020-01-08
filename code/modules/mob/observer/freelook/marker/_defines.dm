//Errorcodes returned from a biomass source
#define MASS_READY	"ready"	//Nothing is wrong, ready to absorb
#define MASS_PAUSE	"pause"	//Not ready to deliver, but keep this source in the list and check again next tick
#define MASS_EXHAUST	"exhaust"	//All mass is gone, delete this source
#define MASS_FAIL	"fail"	//The source can't deliver anymore, maybe its not in range of where it needs to be