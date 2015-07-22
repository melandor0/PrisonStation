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

		//user.equip_to_slot_or_collect(new /obj/item/clothing/head/culthood/alt(user), slot_head)
		//user.equip_to_slot_or_collect(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
		//user.equip_to_slot_or_collect(new /obj/item/clothing/shoes/cult(user), slot_shoes)
		//user.equip_to_slot_or_collect(new /obj/item/weapon/storage/backpack/cultpack(user), slot_back)
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
		"/obj/item/device/soulcapacitor"
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
	src.icon_state = "vialbox[total_contents]"
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

