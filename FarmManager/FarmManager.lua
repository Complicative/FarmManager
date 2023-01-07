FarmManager = {
	version = "1.2.0",
	name = "FarmManager",
	displayName = "Farm Manager",
	variableVersion = 4,
	classes = {},
	worldName = GetWorldName(),
	accountName = GetDisplayName(),
	charName = GetUnitName("player")
}

function FarmManager.OnAddOnLoaded(_, addonName)
	if addonName ~= FarmManager.name then return end
	EVENT_MANAGER:UnregisterForEvent(FarmManager.name, EVENT_ADD_ON_LOADED)
	FarmManager.Init()
end

function FarmManager.ShouldInclude(itemLink)
	--Filters out items using the list in FMSettings
	local itemType = GetItemLinkItemType(itemLink)
	local localItemType = FmSettings.itemFilter[itemType]
	return localItemType == nil or localItemType == true
end

function FarmManager.SetupSVs()
	if not FarmManagerData then FarmManagerData = {} end
	if not FarmManagerData[FarmManager.worldName] then FarmManagerData[FarmManager.worldName] = {} end
end

function FarmManager.SaveLoot(itemLink, amount, type, itemId)
	local zone = GetZoneNameById(GetZoneId(GetUnitZoneIndex("player")))
	local timeStamp = GetTimeStamp()

	local item = {
		["itemId"] = itemId,
		["itemLink"] = itemLink,
		["amount"] = amount,
		["itemType"] = type,
		["accountName"] = FarmManager.accountName,
		["charName"] = FarmManager.charName,
		["zone"] = zone,
		["timeStamp"] = timeStamp
	}
	table.insert(FarmManagerData[FarmManager.worldName], item)

end

function FarmManager.Init()
	--Init
	FmSettings.Init()
	FmUI.Init()
	FarmManager.SetupSVs()
	--FmFarmer.Init()
end

function FarmManager.StartStop()
	if not FmFarmer.running then
		EVENT_MANAGER:RegisterForEvent(FarmManager.name, EVENT_LOOT_RECEIVED, FarmManager.OnLootReceived)
		FmUI.Start()
		FmFarmer.Start()
		d("Farm Manager running")


	else
		EVENT_MANAGER:UnregisterForEvent(FarmManager.name, EVENT_LOOT_RECEIVED)
		FmUI.Stop()
		FmFarmer.Stop()
		d("Farm Manager stopped")
	end
end

function FarmManager.test()
	FmFarmer.Farm("|H1:item:64504:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", 1)
	FmFarmer.Farm("|H1:item:71668:6:1:0:0:0:0:0:0:0:0:0:0:0:1:36:0:1:0:0:0|h|h", 5)
	FmFarmer.Farm("|H1:item:26802:28:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", 3)
	FmFarmer.Farm("|H1:item:33771:25:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", 6)
	FmFarmer.Farm("|H1:item:33257:30:1:0:0:0:0:0:0:0:0:0:0:0:0:3:0:0:0:0:0|h|h", 8)
	FmFarmer.Farm("|H1:item:54180:33:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", 1)
	FmFarmer.Farm("|H1:item:139419:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", 2)
	FmFarmer.Farm("|H1:item:139419:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", 5)
	FmFarmer.Farm("|H1:item:77584:31:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", 3)
	FmFarmer.Farm("|H1:item:64504:30:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", 2)
end

function FarmManager.OnLootReceived(_, _, itemLink, amount, _, lootType, isSelf, _, _, itemId)
	if not isSelf then return end
	if not FarmManager.ShouldInclude(itemLink) then return end
	--Lets FmFarmer add the item
	FmFarmer.Farm(itemLink, amount)
	FarmManager.SaveLoot(itemLink, amount, lootType, itemId)
end

function FarmManager.Reset()
	--Triggers reset dialog
	ZO_Dialogs_ShowDialog("FarmManager_Dialogs_ResetConfirm")
end

--Keybindings
ZO_CreateStringId("SI_BINDING_NAME_FARM_MANAGER_WINDOW_TOGGLE", "Open/Close Farm Manager Window")
ZO_CreateStringId("SI_BINDING_NAME_FARM_MANAGER_START_STOP_TOGGLE", "Start/Stop Farming")
ZO_CreateStringId("SI_BINDING_NAME_FARM_MANAGER_RESET", "Resets Farming")

SLASH_COMMANDS["/farm"] = function(args)
	if args == "start" then FarmManager.StartStop() return end
	if args == "stop" then FarmManager.StartStop() return end
	if args == "reset" then FarmManager.Reset() return end
	FmUI.WindowToggle()
end

ESO_Dialogs["FarmManager_Dialogs_ResetConfirm"] = {
	--Reset Confirm Dialog
	title = {
		text = "Reset?",
	},
	mainText = {
		text = "Are you sure you want to reset all Farm data? This action cannot be undone.",
	},
	buttons = {
		[1] = {
			text = SI_DIALOG_CONFIRM,
			callback = function(...)
				FmFarmer.Reset()
				FmUI.Reset()
			end,
		},
		[2] = {
			text = SI_DIALOG_CANCEL,
		}
	}
}

EVENT_MANAGER:RegisterForEvent(FarmManager.name, EVENT_ADD_ON_LOADED, FarmManager.OnAddOnLoaded)
