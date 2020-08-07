// The below should be used to define an item's w_class variable.
// Example: w_class = ITENSIZE_LARGE
// This allows the addition of future w_classes without needing to change every file.
#define ITEM_SIZE_TINY           1
#define ITEM_SIZE_SMALL          2
#define ITEM_SIZE_NORMAL         3
#define ITEM_SIZE_LARGE          4
/// Items that can be wielded or equipped, (e.g. defibrillator, backpack, space suits)
#define ITEM_SIZE_BULKY          4
#define ITEM_SIZE_HUGE           5
#define ITEM_SIZE_GARGANTUAN     6
#define ITEM_SIZE_NO_CONTAINER INFINITY // Use this to forbid item from being placed in a container.


/*
	The values below are not yet in use.
*/


#define BASE_STORAGE_COST(w_class) (2**(w_class-1)) //1,2,4,8,16,...

//linear increase. Using many small storage containers is more space-efficient than using large ones,
//in exchange for being limited in the w_class of items that will fit
#define BASE_STORAGE_CAPACITY(w_class) (10*(w_class-1))

#define DEFAULT_BACKPACK_STORAGE BASE_STORAGE_CAPACITY(5)
#define DEFAULT_LARGEBOX_STORAGE BASE_STORAGE_CAPACITY(4)
#define DEFAULT_BOX_STORAGE      BASE_STORAGE_CAPACITY(3)

#define DEFAULT_GARGANTUAN_STORAGE 40
#define DEFAULT_HUGE_STORAGE       32
#define DEFAULT_BULKY_STORAGE      25
#define DEFAULT_NORMAL_STORAGE     20
#define DEFAULT_SMALL_STORAGE      16