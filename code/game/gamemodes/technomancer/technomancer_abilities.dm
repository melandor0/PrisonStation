/*
/obj/effect/proc_holder/spell/wizard/targeted/glare
	name = "Glare"
	desc = "Stuns and mutes a target for a decent duration."
	panel = "Technomancer Abilities"
	charge_max = 300
	clothes_req = 0

/obj/effect/proc_holder/spell/wizard/targeted/glare/cast(list/targets)
	for(var/mob/living/carbon/human/target in targets)
		if(!ishuman(target))
			charge_counter = charge_max
			return
		if(target.stat)
			charge_counter = charge_max
			return
		if(is_shadow_or_husk(target))
			usr << "<span class='danger'>You don't see why you would want to paralyze an ally.</span>"
			charge_counter = charge_max
			return

		usr.visible_message("<span class='warning'><b>[usr]'s eyes flash a blinding red!</b></span>")
		target.visible_message("<span class='danger'>[target] freezes in place, their eyes glazing over...</span>")
		if(in_range(target, usr))
			target << "<span class='userdanger'>Your gaze is forcibly drawn into [usr]'s eyes, and you are mesmerized by the heavenly lights...</span>"
		else //Only alludes to the technomancer if the target is close by
			target << "<span class='userdanger'>Red lights suddenly dance in your vision, and you are mesmerized by the heavenly lights...</span>"
		target.Stun(10)
		if(target.reagents)
			target.reagents.add_reagent("capulettium_plus", 4) //This is really bad but it's the only way it works.

/obj/effect/proc_holder/spell/wizard/targeted/shadow_walk
	name = "Shadow Walk"
	desc = "Phases you into the space between worlds for a short time, allowing movement through walls and invisbility."
	panel = "Technomancer Abilities"
	charge_max = 600
	clothes_req = 0
	range = -1
	include_user = 1

/obj/effect/proc_holder/spell/wizard/targeted/shadow_walk/cast(list/targets)
	for(var/mob/living/user in targets)
		playsound(user.loc, 'sound/effects/bamf.ogg', 50, 1)
		user.visible_message("<span class='danger'>[user] vanishes into thin air!</span>", "<span class='deadsay'>You enter the space between worlds as a passageway.</span>")
		user.SetStunned(0)
		user.SetWeakened(0)
		user.incorporeal_move = 1
		user.alpha = 0
		if(user.buckled)
			user.buckled.unbuckle()
		sleep(40) //4 seconds
		user.visible_message("<span class='danger'>[user] appears out of nowhere!</span>", "<span class='deadsay'>The pressure becomes too much and you vacate the interdimensional darkness.</span>")
		user.incorporeal_move = 0
		user.alpha = 255

//Huskify is the single most important spell
/obj/effect/proc_holder/spell/wizard/targeted/huskify
	name = "Huskify"
	desc = "Allows you to enslave a conscious, non-braindead, non-catatonic human to your will. This takes some time to cast."
	panel = "Technomancer Abilities"
	charge_max = 450
	clothes_req = 0
	range = 1 //Adjacent to user
	var/huskifying = 0

/obj/effect/proc_holder/spell/wizard/targeted/huskify/cast(list/targets)
	for(var/mob/living/carbon/human/target in targets)
		if(!in_range(usr, target))
			usr << "<span class='warning'>You need to be closer to huskify [target].</span>"
			charge_counter = charge_max
			return
		if(!target.ckey)
			usr << "<span class='warning'>The target has no mind.</span>"
			charge_counter = charge_max
			return
		if(target.stat)
			usr << "<span class='warning'>The target must be conscious.</span>"
			charge_counter = charge_max
			return
		if(is_shadow_or_husk(target))
			usr << "<span class='warning'>You can not huskify allies.</span>"
			charge_counter = charge_max
			return
		if(!ishuman(target))
			usr << "<span class='warning'>You can only huskify humans.</span>"
			charge_counter = charge_max
			return
		if(huskifying)
			usr << "<span class='danger'>You are already huskifying!</span>"
			charge_counter = charge_max
			return
		huskifying = 1
		usr << "<span class='danger'>This target is valid. You begin the huskifying.</span>"
		target << "<span class='userdanger'>[usr] focuses in concentration. Your head begins to ache.</span>"

		for(var/progress = 0, progress <= 3, progress++)
			switch(progress)
				if(1)
					usr << "<span class='notice'>You begin allocating energy for the huskifying.</span>"
					usr.visible_message("<span class='danger'>[usr]'s eyes begin to throb a piercing red.</span>")
				if(2)
					usr << "<span class='notice'>You begin the huskifying of [target].</span>"
					usr.visible_message("<span class='danger'>[usr] leans over [target], their eyes glowing a deep crimson, and stares into their face.</span>")
					target << "<span class='danger'>Your gaze is forcibly drawn into a blinding red light. You fall to the floor as conscious thought is wiped away.</span>"
					target.Weaken(12)
					sleep(20)
					if(isloyal(target))
						usr << "<span class='notice'>They are enslaved by Nanotrasen. You begin to shut down the nanobot implant - this will take some time.</span>"
						usr.visible_message("<span class='danger'>[usr] halts for a moment, then begins passing its hand over [target]'s body.</span>")
						target << "<span class='danger'>You feel your loyalties begin to weaken!</span>"
						sleep(150) //15 seconds - not spawn() so the huskifying takes longer
						usr << "<span class='notice'>The nanobots composing the loyalty implant have been rendered inert. Now to continue.</span>"
						usr.visible_message("<span class='danger'>[usr] halts thier hand and resumes staring into [target]'s face.</span>")
						for(var/obj/item/weapon/implant/loyalty/L in target)
							if(L && L.implanted)
								qdel(L)
								target << "<span class='danger'>Your unwavering loyalty to Nanotrasen falters, dims, dies.</span>"
				if(3)
					usr << "<span class='notice'>You begin rearranging [target]'s memories.</span>"
					usr.visible_message("<span class='danger'>[usr]'s eyes flare brightly, and a horrible grin begins to spread across [target]'s face...</span>")
					target << "<span class='danger'>Your head cries out. The veil of reality begins to crumple and something evil bleeds through.</span>" //Ow the edge
			if(!do_mob(usr, target, 100)) //around 30 seconds total for huskifying, 45 for someone with a loyalty implant
				usr << "<span class='danger'>The huskifying has been interrupted - your target's mind returns to its previous state.</span>"
				target << "<span class='warning'>Your thoughts become coherent once more. Already you can barely remember what's happened to you.</span>"
				huskifying = 0
				return

		huskifying = 0
		usr << "<span class='notice'>You have huskifyed <b>[target]</b>!</span>"
		target << "<span class='deadsay'><b>You see the Truth. Reality has been torn away and you realize what a fool you've been.</b></span>"
		target << "<span class='deadsay'><b>The technomancers are your masters.</b> Serve them above all else and ensure they complete their goals.</span>"
		target << "<span class='deadsay'>You may not harm other husks or the technomancers. However, you do not need to obey other husks.</span>"
		target << "<span class='deadsay'>You can communicate with the other enlightened ones by using the Technomancer Hivemind (:8) ability.</span>"
		target.adjustOxyLoss(-200) //In case the technomancer was choking them out
		ticker.mode.add_husk(target.mind)
		target.mind.special_role = "Technomancer Husk"

/obj/effect/proc_holder/spell/wizard/targeted/blindness_smoke
	name = "Blindness Smoke"
	desc = "Spews a cloud of smoke which will blind enemies."
	panel = "Technomancer Abilities"
	charge_max = 600
	clothes_req = 0
	range = -1
	include_user = 1

/obj/effect/proc_holder/spell/wizard/targeted/blindness_smoke/cast(list/targets) //Extremely hacky
	for(var/mob/living/user in targets)
		user.visible_message("<span class='warning'>[user] suddenly bends over and coughs out a cloud of black smoke, which begins to spread rapidly!</span>")
		user << "<span class='deadsay'>You regurgitate a vast cloud of blinding smoke.</span>"
		playsound(user, 'sound/effects/bamf.ogg', 50, 1)
		var/obj/item/weapon/reagent_containers/glass/beaker/large/B = new /obj/item/weapon/reagent_containers/glass/beaker/large(user.loc)
		B.reagents.clear_reagents() //Just in case!
		B.icon_state = null //Invisible
		B.reagents.add_reagent("blindness_smoke", 10)
		var/datum/effect/effect/system/chem_smoke_spread/S = new /datum/effect/effect/system/chem_smoke_spread
		S.attach(B)
		if(S)
			S.set_up(B.reagents, 10, 0, B.loc)
			S.start(4)
			sleep(10)
		qdel(B)

datum/reagent/technomancer_blindness_smoke //Blinds non-technomancers, heals technomancers/husks
	name = "!(%@ ERROR )!@$"
	id = "blindness_smoke"
	description = "<::ERROR::> CANNOT ANALYZE REAGENT <::ERROR::>"
	color = "#000000" //Complete black (RGB: 0, 0, 0)
	metabolization_rate = 100 //lel

datum/reagent/technomancer_blindness_smoke/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!is_shadow_or_husk(M))
		M << "<span class='warning'><b>You breathe in the black smoke, and your eyes burn horribly!</b></span>"
		M.eye_blind = 5
		if(prob(25))
			M.visible_message("<b>[M]</b> screams and claws at their eyes!")
			M.Stun(2)
	else
		M << "<span class='notice'><b>You breathe in the black smoke, and you feel revitalized!</b></span>"
		M.heal_organ_damage(2,2)
		M.adjustOxyLoss(-2)
		M.adjustToxLoss(-2)
	..()
	return

/obj/effect/proc_holder/spell/wizard/aoe_turf/unearthly_screech
	name = "Sonic Screech"
	desc = "Deafens, stuns, and confuses nearby people. Also shatters windows."
	panel = "Technomancer Abilities"
	range = 7
	charge_max = 300
	clothes_req = 0

/obj/effect/proc_holder/spell/wizard/aoe_turf/unearthly_screech/cast(list/targets)
	usr.audible_message("<span class='warning'><b>[usr] lets out a horrible scream!</b></span>")
	playsound(usr.loc, 'sound/effects/screech.ogg', 100, 1)

	for(var/turf/T in targets)
		for(var/mob/target in T.contents)
			if(is_shadow_or_husk(target))
				if(target == usr) //No message for the user, of course
					continue
				else
					continue
			if(iscarbon(target))
				var/mob/living/carbon/M = target
				M << "<span class='danger'><b>A spike of pain drives into your head and scrambles your thoughts!</b></span>"
				M.Weaken(2)
				M.confused += 10
				M.ear_damage += 3
			else if(issilicon(target))
				var/mob/living/silicon/S = target
				S << "<span class='warning'><b>ERROR $!(@ ERROR )#^! SENSOR INTERFERENCE DETECTED</b></span>"
				S << 'sound/misc/interference.ogg'
				playsound(S, 'sound/machines/warning-buzzer.ogg', 50, 1)
				var/datum/effect/effect/system/spark_spread/sp = new /datum/effect/effect/system/spark_spread
				sp.set_up(5, 1, S)
				sp.start()
				S.Weaken(6)
		for(var/obj/structure/window/W in T.contents)
			W.hit(rand(50,100))

/obj/effect/proc_holder/spell/wizard/aoe_turf/drain_husks
	name = "Drain Husks"
	desc = "Damages nearby husks, draining their life and healing yourself."
	panel = "Technomancer Abilities"
	range = 3
	charge_max = 100
	clothes_req = 0
	var/husks_drained = 0
	var/list/nearby_husks = list()

/obj/effect/proc_holder/spell/wizard/aoe_turf/drain_husks/cast(list/targets)
	husks_drained = 0
	nearby_husks = list()
	for(var/turf/T in targets)
		for(var/mob/living/carbon/M in T.contents)
			if(is_husk(M))
				husks_drained++
				nearby_husks.Add(M)
				M << "<span class='warning'>You feel a curious draining sensation and a wave of exhaustion washes over you.</span>"
		for(var/mob/living/carbon/M in nearby_husks)
			nearby_husks.Remove(M) //To prevent someone dying like a zillion times
			M.take_organ_damage(25/husks_drained,25/husks_drained) //For every nearby husk, the damage to each is reduced - 1 husk = 50 for him, 2 husks = 25 for each, etc.
			usr << "<span class='deadsay'>You draw the life from [M] to heal your wounds.</span>"
	if(husks_drained)
		var/mob/living/carbon/U = usr
		U.heal_organ_damage(25, 25)
	else
		charge_counter = charge_max
		usr << "<span class='warning'>There were no nearby husks for you to drain.</span>"
*/