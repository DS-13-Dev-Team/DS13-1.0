#define DEFAULT_HUNGER_FACTOR 0.03 // Factor of how fast mob nutrition decreases

#define REM 0.15 // Means 'Reagent Effect Multiplier'. This is how many units of reagent are consumed per tick
//Reduced by nanako, in combination with a new volume_metabolism_mult feature

#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_BLOOD 3

#define MINIMUM_CHEMICAL_VOLUME 0.0001

#define SOLID 1
#define LIQUID 2

#define REAGENTS_OVERDOSE 30

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

// Atom reagent_flags
#define INJECTABLE		(1<<0)	// Makes it possible to add reagents through droppers and syringes.
#define DRAWABLE		(1<<1)	// Makes it possible to remove reagents through syringes.

#define REFILLABLE		(1<<2)	// Makes it possible to add reagents through any reagent container.
#define DRAINABLE		(1<<3)	// Makes it possible to remove reagents through any reagent container.

#define TRANSPARENT		(1<<4)	// For containers with fully visible reagents.
#define AMOUNT_VISIBLE	(1<<5)	// For non-transparent containers that still have the general amount of reagents in them visible.

#define NO_REACT        (1<<6)  // Applied to a reagent holder, the contents will not react with each other.

// Some on_mob_life() procs check for alien races.
#define IS_DIONA   1
#define IS_VOX     2
#define IS_SKRELL  3
#define IS_UNATHI  4
#define IS_TAJARA  5
#define IS_XENOS   6
#define IS_SLIME   8
#define IS_NABBER  9
#define IS_NECROMORPH	10

#define CE_STABLE        "stable"       // Inaprovaline
#define CE_ANTIBIOTIC    "antibiotic"   // Spaceacilin // Fights wound-based infections.
#define CE_BLOODRESTORE  "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER    "painkiller"
#define CE_ALCOHOL       "alcohol"      // Liver filtering
#define CE_ALCOHOL_TOXIC "alcotoxic"    // Liver damage
//#define CE_SPEEDBOOST    "gofast"       // Hyperzine
#define CE_UNENCUMBRANCE	"unencumbrance"
#define CE_SLOWDOWN      "goslow"       // Slowdown
#define CE_PULSE         "xcardic"      // increases or decreases heart rate
#define CE_NOPULSE       "heartstop"    // stops heartbeat
#define CE_ANTITOX       "antitox"      // Dylovene
#define CE_OXYGENATED    "oxygen"       // Dexalin.
#define CE_BRAIN_REGEN   "brainfix"     // Alkysine.
#define CE_ANTIVIRAL     "antiviral"    // Anti-virus effect.
#define CE_TOXIN         "toxins"       // Generic toxins, stops autoheal.
#define CE_BREATHLOSS    "breathloss"   // Breathing depression, makes you need more air
#define CE_MIND    		 "mindbending"  // Stabilizes or wrecks mind. Used for hallucinations
#define CE_CRYO 	     "cryogenic"    // Prevents damage from being frozen
#define CE_BLOCKAGE	     "blockage"     // Gets in the way of blood circulation, higher the worse
#define CE_SQUEAKY		 "squeaky"      // Helium voice. Squeak squeak.
#define CE_SEDATE        "sedate"       // Applies sedation effects, i.e. paralysis, inability to use items, etc.
#define CE_ENERGETIC     "energetic"    // Speeds up stamina recovery.
#define	CE_VOICELOSS     "whispers"     // Lowers the subject's voice to a whisper

//reagent flags
#define IGNORE_MOB_SIZE 0x1
#define AFFECTS_DEAD    0x2

#define HANDLE_REACTIONS(_reagents)  SSchemistry.active_holders[_reagents] = TRUE
#define UNQUEUE_REACTIONS(_reagents) SSchemistry.active_holders -= _reagents