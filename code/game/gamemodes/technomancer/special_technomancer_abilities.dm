//In here: Hatch and Ascendance
/*
/mob/living/carbon/human/proc/technomancer_ascendance()
	set category = "Technomancer Evolution"
	set name = "Ascendance"

	if(usr.stat)
		return
	usr.verbs -= /mob/living/carbon/human/proc/technomancer_ascendance
	switch(alert("It is time to ascend. Are you completely sure about this? You cannot undo this!",,"Yes","No"))
		if("No")
			usr << "<span class='warning'>You decide against ascending for now."
			usr.verbs += /mob/living/carbon/human/proc/technomancer_ascendance
			return
		if("Yes")
			usr.notransform = 1
			usr.visible_message("<span class='warning'>[usr] rapidly bends and contorts, their eyes flaring a deep crimson!</span>", \
								"<span class='technomancer'>You begin unlocking the genetic vault within you and prepare yourself for the power to come.</span>")

			sleep(30)
			usr.visible_message("<span class='danger'>[usr] suddenly shoots up a few inches in the air and begins hovering there, still twisting.</span>", \
								"<span class='technomancer'>You hover into the air to make room for your new form.</span>")

			sleep(60)
			usr.visible_message("<span class='danger'>[usr]'s skin begins to pulse red in sync with their eyes. Their form slowly expands outward.</span>", \
								"<span class='technomancer'>You feel yourself beginning to mutate.</span>")

			sleep(20)
			if(!ticker.mode.technomancer_ascended)
				usr << "<span class='technomancer'>It isn't enough. Time to draw upon your husks.</span>"
			else
				usr << "<span class='technomancer'>After some telepathic searching, you find the reservoir of life energy from the husks and tap into it.</span>"

			sleep(50)
			for(var/mob/M in mob_list)
				if(is_husk(M) && !ticker.mode.technomancer_ascended)
					M.visible_message("<span class='userdanger'>[M] trembles minutely as their form turns to ash, black smoke pouring from their disintegrating face.</span>", \
									  "<span class='userdanger'><font size=3>It's time! Your masters are ascending! Your last thoughts are happy as your body is drained of life.</span>")

					ticker.mode.husks -= M.mind //To prevent message spam
					M.death(0)
					M.dust()

			usr << "<span class='userdanger'>Drawing upon your husks, you find the strength needed to finish and rend apart the final barriers to godhood.</b></span>"

			sleep(40)
			for(var/mob/living/M in orange(7, src))
				M.Weaken(10)
				M << "<span class='userdanger'>An immense pressure slams you onto the ground!</span>"
			usr << "<font size=3.5><span class='technomancer'>YOU LIVE!!!</font></span>"
			world << "<br><br><font size=4><span class='technomancer'><b>A horrible wail echoes in your mind as the world plunges into blackness.</font></span><br><br>"
			world << 'sound/hallucinations/veryfar_noise.ogg'
			for(var/obj/machinery/power/apc/A in world)
				A.overload_lighting()
			var/mob/A = new /mob/living/simple_animal/ascendant_technomancer(usr.loc)
			usr.spell_list = list()
			usr.mind.AddSpell(new /obj/effect/proc_holder/spell/wizard/targeted/annihilate)
			usr.mind.AddSpell(new /obj/effect/proc_holder/spell/wizard/targeted/hypnosis)
			usr.mind.AddSpell(new /obj/effect/proc_holder/spell/wizard/targeted/technomancer_phase_shift)
			usr.mind.AddSpell(new /obj/effect/proc_holder/spell/wizard/aoe_turf/glacial_blast)
			usr.mind.AddSpell(new /obj/effect/proc_holder/spell/wizard/targeted/vortex)
			usr.mind.transfer_to(A)
			A.spell_list = usr.spell_list
			A.name = usr.real_name
			A.languages = usr.languages
			if(A.real_name)
				A.real_name = usr.real_name
			usr.alpha = 0 //This is pretty bad, but is also necessary for the shuttle call to function properly
			usr.flags |= GODMODE
			usr.notransform = 1
			sleep(50)
			if(!ticker.mode.technomancer_ascended)
				if(emergency_shuttle && emergency_shuttle.can_call())
					emergency_shuttle.call_evac()
					emergency_shuttle.launch_time = 0	// Cannot recall
			ticker.mode.technomancer_ascended = 1
			qdel(usr)
*/