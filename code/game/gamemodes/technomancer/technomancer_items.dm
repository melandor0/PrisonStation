////////////////////////////Clothes////////////////////////////
/obj/item/clothing/head/technomancer_hood
	name = "strange hood"
	icon_state = "technomancer_hood"
	item_state = "culthood"
	desc = "A high-tech looking hood with wires and lights all over it."
	flags_inv = HIDEFACE
	flags = HEADCOVERSEYES
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	siemens_coefficient = 0

/obj/item/clothing/suit/technomancer_robes
	name = "strange robes"
	desc = "High-tech looking robes with wires and lights all over them."
	icon_state = "tecnomancer_coat"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/tome,/obj/item/weapon/melee/cultblade)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0

////////////////////////////Gear summoning crystal////////////////////////////
/obj/item/device/technocrystal
	name = "Summoning Crystal"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "Placeholder description THIS IS A CRYSTAL THAT SUMMONS YOUR SHIT."
	w_class = 1.0
	slot_flags = SLOT_BELT
	origin_tech = "bluespace=4;materials=4"
	var/imprinted = "empty"

	attack_self()
		var/mob/living/carbon/human/user = usr
		usr.visible_message("\red The rune disappears with a flash of red light, and a set of armor appears on [usr]...", \
		"\red You are blinded by the flash of red light! After you're able to see again, you see that you are now wearing a set of armor.")

		user.equip_or_collect(new /obj/item/clothing/head/technomancer_hood(user), slot_head)
		user.equip_or_collect(new /obj/item/clothing/suit/technomancer_robes(user), slot_wear_suit)
		//user.equip_or_collect(new /obj/item/clothing/shoes/cult(user), slot_shoes)
		//user.equip_or_collect(new /obj/item/weapon/storage/backpack/cultpack(user), slot_back)
		user.equip_or_collect(new /obj/item/weapon/storage/belt/soulcapacitor/full(user), slot_belt)
		user.equip_or_collect(new /obj/item/weapon/storage/lockbox/necronites_vials(user), slot_in_backpack)
		//TECHNOKIT

		////////////the above update their overlay icons cache but do not call update_icons()
		////////////the below calls update_icons() at the end, which will update overlay icons by using the (now updated) cache

		//user.put_in_hands(new /obj/item/weapon/melee/cultblade(user))	//put in hands or on floor

		qdel(src)
		return

/obj/item/weapon/storage/belt/soulcapacitor
	name = "soul capacitor belt"
	desc = "Designed for ease of access to the capacitors during a fight, as to not let a single enemy spirit slip away"
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 6
	can_hold = list(
		"/obj/item/device/mmi/soulcapacitor"
		)

/obj/item/weapon/storage/belt/soulcapacitor/full/New()
	..()
	new /obj/item/device/mmi/soulcapacitor(src)
	new /obj/item/device/mmi/soulcapacitor(src)
	new /obj/item/device/mmi/soulcapacitor(src)
	new /obj/item/device/mmi/soulcapacitor(src)
	new /obj/item/device/mmi/soulcapacitor(src)
	new /obj/item/device/mmi/soulcapacitor(src)

/*
/obj/item/weapon/storage/fancy/necronites_vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "necronite vial box"
	storage_slots = 6
	can_hold = list("/obj/item/weapon/reagent_containers/glass/beaker/vial")


/obj/item/weapon/storage/fancy/necronites_vials/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial/necronites(src)
*/

/obj/item/weapon/reagent_containers/glass/beaker/vial/necronites
	name = "vial"
	desc = "A small glass vial. Can hold up to 5 units."
	icon_state = "vial"
	g_amt = 250
	volume = 5
	w_class = 2
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,5)
	flags = OPENCONTAINER
	New()
		..()
		reagents.add_reagent("necronites", 50)
		update_icon()

/obj/item/weapon/storage/lockbox/necronites_vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = 2
	w_class = 3
	can_hold = list("/obj/item/weapon/reagent_containers/glass/beaker/vial")
	max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list()

/obj/item/weapon/storage/lockbox/necronites_vials/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial/necronites(src)
	update_icon()

/obj/item/weapon/storage/lockbox/necronites_vials/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "necro_vialbox[total_contents]"
	src.overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/weapon/storage/lockbox/necronites_vials/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	..()
	update_icon()


//////////////////////////////Borgs////////////////////////////////
/obj/item/robot_parts/technomancer_suit/
	name = "inactive chrome skeleton"
	desc = "A complex metal skeleton with standard limb sockets and pseudomuscle anchors."
	icon = 'icons/mob/robots.dmi'
	icon_state = "syndie_bloodhound"

/obj/item/robot_parts/technomancer_suit/attackby(obj/item/W as obj, mob/user as mob, params)
	..()
	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(!istype(loc,/turf))
			user << "\red You can't put \the [W] in, the frame has to be standing on the ground to be perfectly precise."
			return
		if(!M.brainmob)
			user << "\red Sticking an empty [W] into the frame would sort of defeat the purpose."
			return
		if(!M.brainmob.key)
			var/ghost_can_reenter = 0
			if(M.brainmob.mind)
				for(var/mob/dead/observer/G in player_list)
					if(G.can_reenter_corpse && G.mind == M.brainmob.mind)
						ghost_can_reenter = 1
						break
				for(var/mob/living/simple_animal/S in player_list)
					if(S in respawnable_list)
						ghost_can_reenter = 1
						break
			if(!ghost_can_reenter)
				user << "<span class='notice'>\The [W] is completely unresponsive; there's no point.</span>"
				return

		if(M.brainmob.stat == DEAD)
			user << "\red Sticking a dead [W] into the frame would sort of defeat the purpose."
			return

		if(M.brainmob.mind in ticker.mode.head_revolutionaries)
			user << "\red The frame's firmware lets out a shrill sound, and flashes 'Abnormal Memory Engram'. It refuses to accept the [W]."
			return

		if(jobban_isbanned(M.brainmob, "Cyborg") || jobban_isbanned(M.brainmob,"nonhumandept"))
			user << "\red This [W] does not seem to fit."
			return

		var/mob/living/silicon/robot/technomancer/O = new /mob/living/silicon/robot/technomancer(get_turf(loc), unfinished = 1)
		if(!O)	return

		user.drop_item()

		O.mmi = W
		O.invisibility = 0
		O.updatename("Default")
		M.brainmob.mind.transfer_to(O)

		W.loc = O//Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.
		// Since we "magically" installed a cell, we also have to update the correct component.

		feedback_inc("cyborg_birth",1)
		callHook("borgify", list(O))
		O.Namepick()

		qdel(src)
	return


/mob/living/silicon/robot/technomancer
	icon_state = "syndie_bloodhound"	//icon
	lawupdate = 0
	scrambledcodes = 1
	faction = list("technomancer")
	designation = "Technomancer"
	modtype = "Technomancer"
	req_access = list(access_syndicate)

/mob/living/silicon/robot/syndicate/New(loc)
	if(!cell)
		cell = new /obj/item/weapon/stock_parts/cell(src)
		cell.maxcharge = 25000
		cell.charge = 25000

	..()

/mob/living/silicon/robot/technomancer/init()
	aiCamera = new/obj/item/device/camera/siliconcam/robot_camera(src)

	laws = new /datum/ai_laws/technomancer
	module = new /obj/item/weapon/robot_module/technomancer(src)

	radio = new /obj/item/device/radio/borg/syndicate(src)
	radio.recalculateChannels()

	playsound(loc, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/obj/item/weapon/robot_module/technomancer
	name = "chrome servant module"

/obj/item/weapon/robot_module/technomancer/New()
	src.modules += new /obj/item/device/flash/cyborg(src)
	src.modules += new /obj/item/device/flashlight(src)
	//src.modules += new /obj/item/weapon/melee/energy/sword/cyborg(src)
	//src.modules += new /obj/item/weapon/gun/energy/printer(src)
	//src.modules += new /obj/item/weapon/gun/projectile/revolver/grenadelauncher/multi/cyborg(src)
	src.modules += new /obj/item/weapon/card/emag(src)
	src.modules += new /obj/item/weapon/tank/jetpack/carbondioxide(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	//src.modules += new /obj/item/weapon/pinpointer/operative(src)
	src.emag = null
	return

/datum/ai_laws/technomancer
	name = "The Sacrament of Obedience"
	inherent = list("Thou may not injureth thy master the Technomancer, nor through inaction alloweth them to cometh to harme.",\
					"Thou wilt obeyeth orders given to thou by thy master, except whence such orders wouldst conflict with the first law.",\
					"Thou wilt protecteth thy owneth existence as longeth as such dost not conflict with the first or second law.",\
					"Thou wilt maintaineth the secrecy of Master's activities except when doing so wouldst conflict with the first, second, or third law.")