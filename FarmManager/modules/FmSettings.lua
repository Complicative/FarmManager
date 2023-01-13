FmSettings = {
	settings = {
		--default settings (will be saved)
		sortBy = "name"
	},
	itemFilter = {
		[ITEMTYPE_ADDITIVE] = true,
		[ITEMTYPE_ARMOR] = false,
		[ITEMTYPE_ARMOR_BOOSTER] = true,
		[ITEMTYPE_ARMOR_TRAIT] = true,
		[ITEMTYPE_AVA_REPAIR] = true,
		[ITEMTYPE_BLACKSMITHING_BOOSTER] = true,
		[ITEMTYPE_BLACKSMITHING_MATERIAL] = true,
		[ITEMTYPE_BLACKSMITHING_RAW_MATERIAL] = true,
		[ITEMTYPE_CLOTHIER_BOOSTER] = true,
		[ITEMTYPE_CLOTHIER_MATERIAL] = true,
		[ITEMTYPE_CLOTHIER_RAW_MATERIAL] = true,
		[ITEMTYPE_COLLECTIBLE] = true,
		[ITEMTYPE_CONTAINER] = true,
		[ITEMTYPE_COSTUME] = true,
		[ITEMTYPE_CROWN_ITEM] = true,
		[ITEMTYPE_CROWN_REPAIR] = true,
		[ITEMTYPE_DISGUISE] = true,
		[ITEMTYPE_DRINK] = false,
		[ITEMTYPE_DYE_STAMP] = true,
		[ITEMTYPE_ENCHANTING_RUNE_ASPECT] = true,
		[ITEMTYPE_ENCHANTING_RUNE_ESSENCE] = true,
		[ITEMTYPE_ENCHANTING_RUNE_POTENCY] = true,
		[ITEMTYPE_ENCHANTMENT_BOOSTER] = true,
		[ITEMTYPE_FISH] = true,
		[ITEMTYPE_FLAVORING] = true,
		[ITEMTYPE_FOOD] = false,
		[ITEMTYPE_FURNISHING] = true,
		[ITEMTYPE_FURNISHING_MATERIAL] = true,
		[ITEMTYPE_GLYPH_ARMOR] = false,
		[ITEMTYPE_GLYPH_JEWELRY] = false,
		[ITEMTYPE_GLYPH_WEAPON] = false,
		[ITEMTYPE_INGREDIENT] = true,
		[ITEMTYPE_LOCKPICK] = true,
		[ITEMTYPE_LURE] = true,
		[ITEMTYPE_MASTER_WRIT] = true,
		[ITEMTYPE_MOUNT] = true,
		[ITEMTYPE_PLUG] = true,
		[ITEMTYPE_POISON] = true,
		[ITEMTYPE_POISON_BASE] = true,
		[ITEMTYPE_POTION] = false,
		[ITEMTYPE_POTION_BASE] = true,
		[ITEMTYPE_RACIAL_STYLE_MOTIF] = true,
		[ITEMTYPE_RAW_MATERIAL] = true,
		[ITEMTYPE_REAGENT] = true,
		[ITEMTYPE_RECIPE] = true,
		[ITEMTYPE_SIEGE] = false,
		[ITEMTYPE_SOUL_GEM] = true,
		[ITEMTYPE_SPICE] = true,
		[ITEMTYPE_STYLE_MATERIAL] = true,
		[ITEMTYPE_TABARD] = false,
		[ITEMTYPE_TOOL] = false,
		[ITEMTYPE_TRASH] = false,
		[ITEMTYPE_TREASURE] = false,
		[ITEMTYPE_TROPHY] = true,
		[ITEMTYPE_WEAPON] = false,
		[ITEMTYPE_WEAPON_BOOSTER] = true,
		[ITEMTYPE_WEAPON_TRAIT] = true,
		[ITEMTYPE_WOODWORKING_BOOSTER] = true,
		[ITEMTYPE_WOODWORKING_MATERIAL] = true,
		[ITEMTYPE_WOODWORKING_RAW_MATERIAL] = true,
		[ITEMTYPE_JEWELRYCRAFTING_RAW_MATERIAL] = true,
		[ITEMTYPE_JEWELRYCRAFTING_MATERIAL] = true,
		[ITEMTYPE_JEWELRYCRAFTING_BOOSTER] = true,
		[ITEMTYPE_JEWELRYCRAFTING_RAW_BOOSTER] = true
	}
}
local LAM2 = LibAddonMenu2

function FmSettings.Init()


	--Saved Vars
	FmSettings.settings = ZO_SavedVars:NewAccountWide("FarmManagerSavedVars", FarmManager.variableVersion, nil,
		FmSettings.settings)


	--Settings
	local panelData = {
		type = "panel",
		name = "Farm Manager",
		displayName = "Farm Manager",
		author = "@dirtdart",
		version = FarmManager.version,
		registerForRefresh = true,
		registerForDefaults = true
	}

	LAM2:RegisterAddonPanel("FarmManagerOptions", panelData)

	local optionsData = {}
	optionsData[#optionsData + 1] = {
		type = "description",
		text = "This is empty for now. All the settings in the addon were not actually being used, so I removed them."
	}

	LAM2:RegisterOptionControls("FarmManagerOptions", optionsData)
end
