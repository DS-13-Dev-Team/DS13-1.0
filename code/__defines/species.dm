// Species flags.
#define SPECIES_FLAG_NO_MINOR_CUT        (1<<0)  // Can step on broken glass with no ill-effects. Either thick skin (diona/vox), cut resistant (slimes) or incorporeal (shadows)
#define SPECIES_FLAG_IS_PLANT            (1<<1)  // Is a treeperson.
#define SPECIES_FLAG_NO_SCAN             (1<<2)  // Cannot be scanned in a DNA machine/genome-stolen.
#define SPECIES_FLAG_NO_PAIN             (1<<3)  // Cannot suffer halloss/recieves deceptive health indicator.
#define SPECIES_FLAG_NO_SLIP             (1<<4)  // Cannot fall over.
#define SPECIES_FLAG_NO_POISON           (1<<5)  // Cannot not suffer toxloss.
#define SPECIES_FLAG_NO_EMBED            (1<<6)  // Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define SPECIES_FLAG_NO_TANGLE           (1<<7)  // This species wont get tangled up in weeds
#define SPECIES_FLAG_NO_BLOCK            (1<<8)  // Unable to block or defend itself from attackers.
#define SPECIES_FLAG_NEED_DIRECT_ABSORB  (1<<9)  // This species can only have their DNA taken by direct absorption.
#define SPECIES_FLAG_LOW_GRAV_ADAPTED    (1<<10)  // This species is used to lower than standard gravity, affecting stamina in high-grav

// unused: 0x8000 - higher than this will overflow

// Species spawn flags
#define SPECIES_IS_WHITELISTED      0x1    // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED       0x2    // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN            0x4    // Species is selectable in chargen.
#define SPECIES_NO_FBP_CONSTRUCTION 0x8    // FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CHARGEN      0x10   // FBP of this species can't be selected at chargen.
#define SPECIES_NO_LACE             0x20   // This species can't have a neural lace.

// Species appearance flags
#define HAS_SKIN_TONE_NORMAL                                                      0x1    // Skin tone selectable in chargen for baseline humans (0-220)
#define HAS_SKIN_COLOR                                                            0x2    // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS                                                                  0x4    // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR                                                             0x8    // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR                                                             0x10   // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR                                                            0x20   // Hair colour selectable in chargen. (RGB)
#define RADIATION_GLOWS                                                           0x40   // Radiation causes this character to glow.
#define HAS_SKIN_TONE_GRAV                                                        0x80   // Skin tone selectable in chargen for grav-adapted humans (0-100)
#define HAS_SKIN_TONE_SPCR                                                        0x100  // Skin tone selectable in chargen for spacer humans (0-165)
#define HAS_BASE_SKIN_COLOURS                                                     0x200  // Has multiple base skin sprites to go off of
#define HAS_A_SKIN_TONE (HAS_SKIN_TONE_NORMAL | HAS_SKIN_TONE_GRAV | HAS_SKIN_TONE_SPCR) // Species has a numeric skintone

// Skin Defines
#define SKIN_NORMAL 0
#define SKIN_THREAT 1


#define SPECIES_HUMAN       "Human"
#define SPECIES_TAJARA      "Tajara"
#define SPECIES_DIONA       "Diona"
#define SPECIES_VOX         "Vox"
#define SPECIES_IPC         "Machine"
#define SPECIES_UNATHI      "Unathi"
#define SPECIES_SKRELL      "Skrell"
#define SPECIES_NABBER      "giant armoured serpentid"
#define SPECIES_PROMETHEAN  "Promethean"
#define SPECIES_XENO        "Xenophage"
#define SPECIES_ALIEN       "Humanoid"
#define SPECIES_ADHERENT    "Adherent"

//Necromorph species
#define SPECIES_NECROMORPH 	"Necromorph"
#define SPECIES_NECROMORPH_DIVIDER 	"Divider"
#define SPECIES_NECROMORPH_DIVIDER_COMPONENT 	"Divider Component"
#define SPECIES_NECROMORPH_SLASHER 	"Slasher"

#define SPECIES_NECROMORPH_SLASHER_ENHANCED 	"Enhanced Slasher"
#define SPECIES_NECROMORPH_SPITTER	"Spitter"
#define SPECIES_NECROMORPH_PUKER	"Puker"
#define SPECIES_NECROMORPH_BRUTE	"Brute"
#define SPECIES_NECROMORPH_EXPLODER	"Exploder"
#define SPECIES_NECROMORPH_EXPLODER_ENHANCED	"Enhanced Exploder"
#define SPECIES_NECROMORPH_TRIPOD	"Tripod"
#define SPECIES_NECROMORPH_HUNTER	"Hunter"
#define SPECIES_NECROMORPH_INFECTOR	"Infector"
#define SPECIES_NECROMORPH_TWITCHER	"Twitcher"
#define SPECIES_NECROMORPH_TWITCHER_ORACLE	"Oracle Twitcher"
#define SPECIES_NECROMORPH_LEAPER 	"Leaper"
#define SPECIES_NECROMORPH_LEAPER_ENHANCED 	"Enhanced Leaper"
#define SPECIES_NECROMORPH_LEAPER_HOPPER	"Hopper"
#define	SPECIES_NECROMORPH_LURKER	"Lurker"
#define SPECIES_NECROMORPH_UBERMORPH	"Ubermorph"


//Graphical variants
#define SPECIES_NECROMORPH_BRUTE_FLESH	"BruteF"
#define SPECIES_NECROMORPH_SLASHER_DESICCATED "Ancient Slasher"
#define SPECIES_NECROMORPH_SLASHER_CARRION	"Carrion Gestalt"
#define	SPECIES_NECROMORPH_LURKER_MALO	"Malo"

#define SPECIES_NECROMORPH_PUKER_FLAYED	"Flayed One"
#define SPECIES_NECROMORPH_PUKER_CLASSIC	"Classic Puker"

#define SPECIES_NECROMORPH_EXPLODER_RIGHT	"Right Wing Exploder"
#define SPECIES_NECROMORPH_EXPLODER_ENHANCED_RIGHT	"Enhanced Right Wing Exploder"
#define SPECIES_NECROMORPH_EXPLODER_CLASSIC	"Classic Exploder"

#define SPECIES_ALL_NECROMORPHS SPECIES_NECROMORPH,\
SPECIES_NECROMORPH_SLASHER,\
SPECIES_NECROMORPH_SLASHER_ENHANCED,\
SPECIES_NECROMORPH_SPITTER,\
SPECIES_NECROMORPH_PUKER,\
SPECIES_NECROMORPH_BRUTE,\
SPECIES_NECROMORPH_EXPLODER,\
SPECIES_NECROMORPH_BRUTE_FLESH,\
SPECIES_NECROMORPH_TWITCHER,\
SPECIES_NECROMORPH_LEAPER,\
SPECIES_NECROMORPH_LEAPER_ENHANCED,\
SPECIES_NECROMORPH_LEAPER_HOPPER,\
SPECIES_NECROMORPH_LURKER,\
SPECIES_NECROMORPH_UBERMORPH,\
SPECIES_NECROMORPH_INFECTOR

//Put this into any necromorph definition which is just a graphical change from its parent species.
//These flags make sure that variant doesn't appear in places it shouldn't
#define NECROMORPH_VISUAL_VARIANT	marker_spawnable = FALSE;\
spawner_spawnable = FALSE;\
preference_settable = FALSE;\
variants = list();

#define STANDARD_CLOTHING_EXCLUDE_SPECIES	list("exclude", SPECIES_NABBER,SPECIES_ALL_NECROMORPHS)
#define SIGNAL	"signal"
