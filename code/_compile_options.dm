#define BACKGROUND_ENABLED 0    // The default value for all uses of set background. Set background can cause gradual lag and is recommended you only turn this on if necessary.
								// 1 will enable set background. 0 will disable set background.

//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_VERSION 513
#define MIN_COMPILER_BUILD 1523
#ifndef SPACEMAN_DMM
#if DM_VERSION < MIN_COMPILER_VERSION || DM_BUILD < MIN_COMPILER_BUILD
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error You need version 513.1523 or higher
#endif
#endif

//Update this whenever the byond version is stable so people stop updating to hilariously broken versions
#define MAX_COMPILER_VERSION 514
#define MAX_COMPILER_BUILD 1554
#if DM_VERSION > MAX_COMPILER_VERSION || DM_BUILD > MAX_COMPILER_BUILD
#warn WARNING! your byond version is over the recommended version(MAX_COMPILER_VERSION:MAX_COMPILER_BUILD)! There may be unexpected byond bugs!
#endif

//Don't load extools on 514
#if DM_VERSION < 514
#define USE_EXTOOLS
#endif

#ifdef USE_EXTOOLS
//#define REFERENCE_TRACKING		//Enables extools-powered reference tracking system, letting you see what is
									//referencing objects that refuse to hard delete
#endif

//Additional code for the above flags.
#ifdef TESTING
#warn compiling in TESTING mode. testing() debug messages will be visible.
#endif

#ifdef CIBUILDING
#define UNIT_TESTS
#endif

#ifdef CITESTING
#define TESTING
#endif