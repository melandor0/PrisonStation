/datum/job/prisoner
	title = "Prisoner"
	flag = PRISONER
	department_flag = SUPPORT
	total_positions = -1
	spawn_positions = -1
	supervisors = "the warden"
	selection_color = "#dddddd"
	access = list()
	minimal_access = list()

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/clothing/under/color/orange(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/orange(H), slot_shoes)
		//var/randomprisoneritem = pick(/obj/item/device/t_scanner(H), /obj/item/clothing/gloves/color/yellow(H))
		//H.equip_or_collect(new randomprisoneritem), slot_r_store)
		return 1