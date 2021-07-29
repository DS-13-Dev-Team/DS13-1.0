/decl/emote/audible
	key = "burp"
	emote_message_3p = "USER burps."
	message_type = AUDIBLE_MESSAGE
	var/emote_sound
	var/emote_soundf

/decl/emote/audible/do_extra(var/atom/user)
	if(emote_sound)
		playsound(user.loc, emote_sound, 50, 0)
	if(user.gender == FEMALE)
		playsound(user.loc, emote_soundf, 50, 0)


/decl/emote/audible/deathgasp_alien
	key = "deathgasp"
	emote_message_3p = "USER lets out a waning guttural screech, green blood bubbling from its maw."

/decl/emote/audible/whimper
	key ="whimper"
	emote_message_3p = "USER whimpers."

/decl/emote/audible/gasp
	key ="gasp"
	emote_message_3p = "USER gasps."
	conscious = 0
	emote_sound = pick('sound/voice/human/male_gasp_1.ogg',
	'sound/voice/human/male_gasp_2.ogg',
	'sound/voice/human/male_gasp_3.ogg',
	'sound/voice/human/male_gasp_4.ogg')
	emote_soundf = pick('sound/voice/human/female_gasp_1.ogg',
	'sound/voice/human/female_gasp_2.ogg',
	'sound/voice/human/female_gasp_3.ogg',
	'sound/voice/human/female_gasp_4.ogg')

/decl/emote/audible/scretch
	key ="scretch"
	emote_message_3p = "USER scretches."

/decl/emote/audible/choke
	key ="choke"
	emote_message_3p = "USER chokes."
	conscious = 0

/decl/emote/audible/gnarl
	key ="gnarl"
	emote_message_3p = "USER gnarls and shows its teeth.."

/decl/emote/audible/chirp
	key ="chirp"
	emote_message_3p = "USER chirps!"
	emote_sound = 'sound/misc/nymphchirp.ogg'

/decl/emote/audible/alarm
	key = "alarm"
	emote_message_1p = "You sound an alarm."
	emote_message_3p = "USER sounds an alarm."

/decl/emote/audible/alert
	key = "alert"
	emote_message_1p = "You let out a distressed noise."
	emote_message_3p = "USER lets out a distressed noise."

/decl/emote/audible/notice
	key = "notice"
	emote_message_1p = "You play a loud tone."
	emote_message_3p = "USER plays a loud tone."

/decl/emote/audible/whistle
	key = "whistle"
	emote_message_1p = "You whistle."
	emote_message_3p = "USER whistles."

/decl/emote/audible/boop
	key = "boop"
	emote_message_1p = "You boop."
	emote_message_3p = "USER boops."

/decl/emote/audible/sneeze
	key = "sneeze"
	emote_message_3p = "USER sneezes."

/decl/emote/audible/sniff
	key = "sniff"
	emote_message_3p = "USER sniffs."

/decl/emote/audible/snore
	key = "snore"
	emote_message_3p = "USER snores."
	conscious = 0

/decl/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "USER whimpers."

/decl/emote/audible/yawn
	key = "yawn"
	emote_message_3p = "USER yawns."

/decl/emote/audible/clap
	key = "clap"
	emote_message_3p = "USER claps."

/decl/emote/audible/chuckle
	key = "chuckle"
	emote_message_3p = "USER chuckles."

/decl/emote/audible/cough
	key = "cough"
	emote_message_3p = "USER coughs!"
	conscious = 0
	emote_sound = pick('sound/voice/human/male_cough_1.ogg',
	'sound/voice/human/male_cough_2.ogg')
	emote_soundf = pick('sound/voice/human/female_cough_1.ogg',
	'sound/voice/human/female_cough_2.ogg')

/decl/emote/audible/cry
	key = "cry"
	emote_message_3p = "USER cries."

/decl/emote/audible/sigh
	key = "sigh"
	emote_message_3p = "USER sighs."

/decl/emote/audible/laugh
	key = "laugh"
	emote_message_3p = "USER laughs."
	emote_sound = pick('sound/voice/human/male_laugh_1.ogg',
	'sound/voice/human/male_laugh_2.ogg',
	'sound/voice/human/male_laugh_3.ogg')
	emote_soundf = pick('sound/voice/human/female_laugh_1.ogg',
	'sound/voice/human/female_laugh_2.ogg',
	'sound/voice/human/female_laugh_3.ogg')

/decl/emote/audible/mumble
	key = "mumble"
	emote_message_3p = "USER mumbles!"

/decl/emote/audible/grumble
	key = "grumble"
	emote_message_3p = "USER grumbles!"

/decl/emote/audible/groan
	key = "groan"
	emote_message_3p = "USER groans!"
	conscious = 0

/decl/emote/audible/moan
	key = "moan"
	emote_message_3p = "USER moans!"
	conscious = 0

/decl/emote/audible/giggle
	key = "giggle"
	emote_message_3p = "USER giggles."

/decl/emote/audible/scream
	key = "scream"
	emote_message_3p = "USER screams!"
	emote_sound = pick('sound/voice/human/male_scream_1.ogg',
	'sound/voice/human/male_scream_2.ogg',
	'sound/voice/human/male_scream_3.ogg',
	'sound/voice/human/male_scream_4.ogg',
	'sound/voice/human/male_scream_5.ogg',
	'sound/voice/human/male_scream_6.ogg',
	'sound/voice/human/male_scream_7.ogg')
	emote_soundf = pick('sound/voice/human/female_scream_1.ogg',
	'sound/voice/human/female_scream_2.ogg',
	'sound/voice/human/female_scream_3.ogg',
	'sound/voice/human/female_scream_4.ogg',
	'sound/voice/human/female_scream_5.ogg',
	'sound/voice/human/female_scream_6.ogg',
	'sound/voice/human/female_scream_7.ogg')

decl/emote/audible/pain
	key = "pain"
	emote_message_3p = "USER cries out in pain!"
	emote_sound = pick('sound/voice/human/male_pain_1.ogg',
	'sound/voice/human/male_pain_2.ogg',
	'sound/voice/human/male_pain_3.ogg',
	'sound/voice/human/male_pain_4.ogg',
	'sound/voice/human/male_pain_5.ogg',
	'sound/voice/human/male_pain_6.ogg',
	'sound/voice/human/male_pain_7.ogg',
	'sound/voice/human/male_pain_8.ogg')
	emote_soundf = pick('sound/voice/human/female_pain_1.ogg',
	'sound/voice/human/female_pain_2.ogg',
	'sound/voice/human/female_pain_3.ogg',
	'sound/voice/human/female_pain_4.ogg',
	'sound/voice/human/female_pain_5.ogg',
	'sound/voice/human/female_pain_6.ogg',
	'sound/voice/human/female_pain_7.ogg',
	'sound/voice/human/female_pain_8.ogg')

/decl/emote/audible/grunt
	key = "grunt"
	emote_message_3p = "USER grunts."

/decl/emote/audible/bug_hiss
	key ="hiss"
	emote_message_3p = "USER hisses."
	emote_sound = 'sound/voice/BugHiss.ogg'

/decl/emote/audible/bug_buzz
	key ="buzz"
	emote_message_3p = "USER buzzes its wings."
	emote_sound = 'sound/voice/BugBuzz.ogg'

/decl/emote/audible/bug_chitter
	key ="chitter"
	emote_message_3p = "USER chitters."
	emote_sound = 'sound/voice/Bug.ogg'
