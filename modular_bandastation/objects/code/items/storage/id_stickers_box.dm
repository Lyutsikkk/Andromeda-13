/obj/item/storage/box/id_stickers
	name = "ID stickers box"
	desc = "Коробка с кучкой наклеек на ID карту."
	icon = 'modular_bandastation/objects/icons/obj/storage/box.dmi'
	icon_state = "id_stickers_box"
	illustration = "id_stickers_box_label"

/obj/item/storage/box/id_stickers/PopulateContents()
	var/list/insert = list()
	for(var/i in 1 to 3)
		insert += pick(subtypesof(/obj/item/id_sticker))
	return insert
