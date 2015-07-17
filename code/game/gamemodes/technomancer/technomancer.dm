/*

TECHNOMANCER: A gamemode based on previously-run events

Aliens called technomancers are on the station.
These technomancers can 'huskify' crew members and enslave them.
They also burn in the light but heal rapidly whilst in the dark.
The game will end under two conditions:
	1. The technomancers die
	2. The emergency shuttle docks at CentCom

Technomancer strengths:
	- The dark
	- Hard vacuum (They are not affected by it)
	- Their husks who are not harmed by the light
	- Stealth

Technomancer weaknesses:
	- The light
	- Fire
	- Enemy numbers
	- Lasers (Lasers are concentrated light and do more damage)
	- Flashbangs (High stun and high burn damage; if the light stuns humans, you bet your ass it'll hurt the technomancer very much!)

Technomancers start off disguised as normal crew members, and they only have two abilities: Hatch and Huskify.
They can still huskify and perhaps complete their objectives in this form.
Hatch will, after a short time, cast off the human disguise and assume the technomancer's true identity.
They will then assume the normal technomancer form and gain their abilities.

The technomancer will seem OP, and that's because it kinda is. Being restricted to the dark while being alone most of the time is extremely difficult and as such the technomancer needs powerful abilities.
Made by Xhuis

*/



/*
	GAMEMODE
*/


/datum/game_mode
	var/list/datum/mind/technos = list()
	var/list/datum/mind/technomancer_husks = list()
	var/list/techno_objectives = list()
	var/required_husks = 15 //How many husks are needed (hardcoded for now)
	var/technomancer_ascended = 0 //If at least one technomancer has ascended
	var/technomancer_dead = 0 //is technomancer kill?


/proc/is_husk(var/mob/living/M)
	return istype(M) && M.mind && ticker && ticker.mode && (M.mind in ticker.mode.technomancer_husks)
/* Legend
techno - shadow
technos - shadows
technomancer - shadowling

*/

/proc/is_techno_or_husk(var/mob/living/M)
	return istype(M) && M.mind && ticker && ticker.mode && ((M.mind in ticker.mode.technomancer_husks) || (M.mind in ticker.mode.technos))


/proc/is_techno(var/mob/living/M)
	return istype(M) && M.mind && ticker && ticker.mode && (M.mind in ticker.mode.technos)


/datum/game_mode/technomancer
	name = "technomancer"
	config_tag = "technomancer"
	required_players = 30
	required_enemies = 2
	recommended_enemies = 2
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Blueshield", "Nanotrasen Representative", "Security Pod Pilot", "Magistrate", "Brig Physician", "Internal Affairs Agent")

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/technomancer/announce()
	world << "<b>The current game mode is - Technomancer!</b>"
	world << "<b>There is a <span class='deadsay'>technomancer</span> on the station. Crew: Kill the technomancer before they can zombify the crew. Technomancers: Zombify the crew!</b>"

/datum/game_mode/technomancer/pre_setup()	//Pre-setup
	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/list/datum/mind/possible_technomancers = get_players_for_role(BE_TECHNOMANCER)

	if(!possible_technomancers.len)
		return 0

	var/technomancers = 1 //How many technomancers there are

	while(technomancers)
		var/datum/mind/techno = pick(possible_technomancers)
		technos += techno
		possible_technomancers -= techno
		modePlayer += techno
		techno.special_role = "Technomancer"
		techno.restricted_roles = restricted_jobs
		technomancers--
	return 1


/datum/game_mode/technomancer/post_setup()	//Post-setup
	for(var/datum/mind/techno in technos)
		log_game("[techno.key] (ckey) has been selected as the Technomancer.")
		sleep(10)
		techno.current << "<br>"
		techno.current << "<span class='deadsay'><b><font size=3>You are the technomancer!</font></b></span>"
		greet_techno(techno)
		finalize_technomancer(techno)
		process_techno_objectives(techno)

	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	..()
	return

/datum/game_mode/proc/greet_techno(var/datum/mind/techno)	//Roundstart welcome message for technomancers
	techno.current << "<b>Currently, you are disguised as an employee aboard [world.name].</b>"
	techno.current << "<b>You have one telecrystal in your backpack. Use it to summon your equipment. Do this in private!</b>"
	techno.current << "<b>If you are new to technomancer, or want to read about abilities, check the wiki page at http://nanotrasen.se/wiki/index.php/Technomancer</b><br>"


/datum/game_mode/proc/process_techno_objectives(var/datum/mind/techno_mind)		//Technomancer objectives
	var/objective = "huskify"	//Only the one objective

	if(objective == "huskify")
		var/objective_explanation = "Ascend to your full potantial by enslaving the station. This may only be used with [required_husks] collective husks."
		techno_objectives += "huskify"
		techno_mind.memory += "<b>Objective #1</b>: [objective_explanation]"
		techno_mind.current << "<b>Objective #1</b>: [objective_explanation]<br>"


/datum/game_mode/proc/finalize_technomancer(var/datum/mind/techno_mind)
	var/mob/living/carbon/human/T = techno_mind.current
	//techno_mind.current.verbs += /mob/living/carbon/human/proc/technomancer_hatch
	//T.mind.AddSpell(new /obj/effect/proc_holder/spell/wizard/targeted/huskify)
	spawn(0)
		//techno_mind.current.add_language("Technomancer Hivemind")
		update_techno_icons_added(techno_mind)
		if(techno_mind.assigned_role == "Clown")
			T << "<span class='notice'>Your masterful mind has allowed you to overcome your clownishness.</span>"
			T.mutations.Remove(CLUMSY)
		techno_mind.current.hud_updateflag |= (1 << SPECIALROLE_HUD)

/datum/game_mode/proc/add_husk(datum/mind/new_husk_mind)	//LET'S MAKE SOMEONE A HUSK AND GIVE THEM COOL STUFF N SHIT
	if (!istype(new_husk_mind))
		return 0
	if(!(new_husk_mind in technomancer_husks))
		technomancer_husks += new_husk_mind
		update_techno_icons_added(new_husk_mind)
		new_husk_mind.current.attack_log += "\[[time_stamp()]\] <span class='danger'>Became a husk</span>"
		new_husk_mind.memory += "<b>The Technomancers' Objectives:</b> PLACEHOLDER. \
		This may only be used with [required_husks] collective husks, PLACEHOLDER."
		new_husk_mind.current << "<b>The objectives of your technomancers:</b>: Ascend to your true form by use of the Ascendance ability. \
		This may only be used with [required_husks] collective husks, while hatched, and is unlocked with the Collective Mind ability."
		new_husk_mind.current.add_language("Husk Hivemind")
		new_husk_mind.current.hud_updateflag |= (1 << SPECIALROLE_HUD)
		return 1



/*
	GAME FINISH CHECKS
*/


/datum/game_mode/technomancer/check_finished()
	var/technos_alive = 0 //and then technomancer was kill
	for(var/datum/mind/techno in technos) //but what if technomancer was not kill?
		//if(!istype(techno.current,/mob/living/carbon/human) && !istype(techno.current,/mob/living/simple_animal/ascendant_technomancer))
		//	continue
		if(techno.current.stat == DEAD)
			continue
		technos_alive++
	if(technos_alive)
		return ..()
	else
		technomancer_dead = 1 //but technomancer was kill :(
		return 1


/datum/game_mode/technomancer/proc/check_techno_victory()
	var/success = 0 //Did they win?
	if(techno_objectives.Find("huskify"))
		success = technomancer_ascended
	return success


/datum/game_mode/technomancer/declare_completion()
	if(check_techno_victory() && emergency_shuttle.returned()) //Doesn't end instantly - this is hacky and I don't know of a better way ~X
		world << "<span class='greentext'><b>The technomancers have ascended and taken over the station!</b></span>"
	else if(technomancer_dead && !check_techno_victory()) //If the technomancers have ascended, they can not lose the round
		world << "<span class='redtext'><b>The technomancers have been killed by the crew!</b></span>"
	else if(!check_techno_victory() && emergency_shuttle.returned())
		world << "<span class='redtext'><b>The crew has escaped the station before the technomancers could ascend!</b></span>"
	..()
	return 1


/datum/game_mode/proc/auto_declare_completion_technomancer()
	var/text = ""
	if(technos.len)
		text += "<br><span class='big'><b>The technomancers were:</b></span>"
		for(var/datum/mind/techno in technos)
			text += "<br>[techno.key] was [techno.name] ("
			if(techno.current)
				if(techno.current.stat == DEAD)
					text += "died"
				else
					text += "survived"
				if(techno.current.real_name != techno.name)
					text += " as <b>[techno.current.real_name]</b>"
			else
				text += "body destroyed"
			text += ")"
		text += "<br>"
		if(technomancer_husks.len)
			text += "<br><span class='big'><b>The husks were:</b></span>"
			for(var/datum/mind/husk in technomancer_husks)
				text += "<br>[husk.key] was [husk.name] ("
				if(husk.current)
					if(husk.current.stat == DEAD)
						text += "died"
					else
						text += "survived"
					if(husk.current.real_name != husk.name)
						text += " as <b>[husk.current.real_name]</b>"
				else
					text += "body destroyed"
				text += ")"
	text += "<br>"
	world << text


/*
	MISCELLANEOUS
*/

/datum/game_mode/proc/update_techno_icons_added(datum/mind/techno_mind)
	spawn(0)
		for(var/datum/mind/technomancer in technos)
			if(technomancer.current && technomancer != techno_mind)
				if(technomancer.current.client)
					var/I = image('icons/mob/mob.dmi', loc = techno_mind.current, icon_state = "husk")
					technomancer.current.client.images += I
			if(techno_mind.current)
				if(techno_mind.current.client)
					var/image/J = image('icons/mob/mob.dmi', loc = technomancer.current, icon_state = "technomancer")
					techno_mind.current.client.images += J
		for(var/datum/mind/husk in technomancer_husks)
			if(husk.current)
				if(husk.current.client)
					var/I = image('icons/mob/mob.dmi', loc = techno_mind.current, icon_state = "husk")
					husk.current.client.images += I
			if(techno_mind.current)
				if(techno_mind.current.client)
					var/image/J = image('icons/mob/mob.dmi', loc = husk.current, icon_state = "husk")
					techno_mind.current.client.images += J

/datum/game_mode/proc/update_techno_icons_removed(datum/mind/techno_mind)
	spawn(0)
		for(var/datum/mind/technomancer in technos)
			if(technomancer.current)
				if(technomancer.current.client)
					for(var/image/I in technomancer.current.client.images)
						if((I.icon_state == "husk" || I.icon_state == "technomancer") && I.loc == techno_mind.current)
							qdel(I)

		for(var/datum/mind/husk in technomancer_husks)
			if(husk.current)
				if(husk.current.client)
					for(var/image/I in husk.current.client.images)
						if((I.icon_state == "husk" || I.icon_state == "technomancer") && I.loc == techno_mind.current)
							qdel(I)

		if(techno_mind.current)
			if(techno_mind.current.client)
				for(var/image/I in techno_mind.current.client.images)
					if(I.icon_state == "husk" || I.icon_state == "technomancer")
						qdel(I)
