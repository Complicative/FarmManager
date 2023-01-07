FmUI = {
	mainWindow = FarmManagerWindow,
	itemList = FarmManagerWindowDetailPanelFmItemList, --scrollList
	lastSort = nil,
	mini = false
}

local mainFragment = ZO_SimpleSceneFragment:New(FarmManagerWindow)
local statsFragment = ZO_SimpleSceneFragment:New(StatsControl)
local exportFragment = ZO_SimpleSceneFragment:New(ExportControl)

function FmUI.ToGold(amount)
	return ZO_CurrencyControl_FormatCurrencyAndAppendIcon(amount, false, CURT_MONEY, false)
end

function FmUI.SetHidden(fragment, hidden)
	if hidden then
		HUD_SCENE:RemoveFragment(fragment)
		HUD_UI_SCENE:RemoveFragment(fragment)
	else
		HUD_SCENE:AddFragment(fragment)
		HUD_UI_SCENE:AddFragment(fragment)
	end

end

function FmUI.Init()
	ZO_ScrollList_AddDataType(FmUI.itemList, 1, "FarmManagerGUIItemListItemTemplate", 30,
		function(control, data) FmUI.UpdateDataRow(control, data) end) --Init of the scroll list

	--Some default values
	FmUI.UpdateStats()

	--Tooltips
	FmUI.mainWindow:GetNamedChild("ButtonChangeSize"):SetHandler("OnMouseEnter", function(control)
		ZO_Tooltips_ShowTextTooltip(control, RIGHT, "Toggle Small/Big Window")
	end)
	FmUI.mainWindow:GetNamedChild("ButtonChangeSize"):SetHandler("OnMouseExit", function()
		ZO_Tooltips_HideTextTooltip()
	end)
end

function FmUI.Start()
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("ButtonStartStop"):GetNamedChild("ButtonStartStopLabel"):
		SetText("Stop Farming") --Button changes text
end

function FmUI.Stop()
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("ButtonStartStop"):GetNamedChild("ButtonStartStopLabel"):
		SetText("Start Farming")
	FmUI.UpdateStats()
end

function FmUI.WindowToggle()
	FmUI.SetHidden(mainFragment, not FmUI.mainWindow:IsHidden())
end

function FmUI.UpdateDataRow(control, data)
	--Format the data to appear in the scroll list
	control:GetNamedChild("Icon"):SetTexture(data.texture)
	control:GetNamedChild("NameLabel"):SetText(zo_strformat('<<t:1>>', data.itemLink))
	control:GetNamedChild("AmountLabel"):SetText(data.amount)
	control:GetNamedChild("ValueLabel"):SetText(FmUI.ToGold(math.floor(data.value)))
	control:GetNamedChild("TotalValueLabel"):SetText(FmUI.ToGold(math.floor(data.totalValue)))
end

function FmUI.UpdateStats()
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("GoldLabel"):SetText(FmUI.ToGold(math.floor(FmFarmer.totalValue
		or 0)))
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("GoldPerMinuteLabel"):SetText(FmUI.ToGold(math.floor(FmFarmer
		.GetGoldPerSecond() * 60)))
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("NodesLabel"):SetText(FmFarmer.nodesFarmed or 0)
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("NodesPerMinuteLabel"):SetText(math.floor((
		FmFarmer.GetNodesPerSecond()
			* 60) * 100) / 100)
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("TimeFarmedLabel"):SetText(FmFarmer.GetTimeFarmedFormated())
end

function FmUI.OnItemFarmed(item)
	--gets called by FmFarmer when an item has been added (the item elem is the finished elem from the internal list, not just 1 amount of it but the total amount with all info)
	local scrollData = ZO_ScrollList_GetDataList(FmUI.itemList)
	local found = false
	for _, itemData in pairs(scrollData) do
		--goes through the scroll list data and checks if such item already exists
		if itemData.data.itemId == item.itemId then
			--if it exists, updates the values of amount and total value in the scroll list data
			itemData.data.amount = item.amount
			itemData.data.totalValue = item.totalValue
			found = true
			break
		end
	end

	if not found then
		--if it doesnt exist, create the data
		local data = { ["texture"] = item.texture, ["itemLink"] = item.itemLink, ["itemId"] = item.itemId,
			["value"] = item.value, ["amount"] = item.amount, ["totalValue"] = item.totalValue }
		scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(1, data)
	end

	FmUI.SortBy(FmSettings.settings.sortBy)

	ZO_ScrollList_Commit(FmUI.itemList) --Updates the scroll list
	FmUI.UpdateStats() --Updates Stats
end

function FmUI.Reset()
	--Clears the scroll list
	ZO_ScrollList_Clear(FmUI.itemList)
	ZO_ScrollList_Commit(FmUI.itemList)

	--resets values
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("GoldLabel"):SetText(FmUI.ToGold(0))
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("GoldPerMinuteLabel"):SetText(FmUI.ToGold(0))
	FmUI.mainWindow:GetNamedChild("StatsControl"):GetNamedChild("TimeFarmedLabel"):SetText("00:00:00")
end

function FmUI.ChangeSortDirection()

end

function FmUI.SortBy(category)
	FmSettings.settings.sortBy = category --changes default sort

	local scrollData = ZO_ScrollList_GetDataList(FmUI.itemList)
	if category == "name" then
		table.sort(scrollData, function(a, b)
			return GetItemLinkName(a.data.itemLink) < GetItemLinkName(b.data.itemLink)
		end)

	elseif category == "value" then
		table.sort(scrollData, function(a, b)
			if a.data.value ~= b.data.value then --if value is not equal
				return a.data.value > b.data.value
			else
				return GetItemLinkName(a.data.itemLink) < GetItemLinkName(b.data.itemLink) --sort by name if equal
			end
		end)
	elseif category == "amount" then
		table.sort(scrollData, function(a, b)
			if a.data.amount ~= b.data.amount then
				return a.data.amount > b.data.amount
			else
				return GetItemLinkName(a.data.itemLink) < GetItemLinkName(b.data.itemLink)
			end
		end)
	elseif category == "totalValue" then
		table.sort(scrollData, function(a, b)
			if a.data.totalValue ~= b.data.totalValue then
				return a.data.totalValue > b.data.totalValue
			else
				return GetItemLinkName(a.data.itemLink) < GetItemLinkName(b.data.itemLink)
			end
		end)
	end
	ZO_ScrollList_Commit(FmUI.itemList) --Updates the scroll list
end

function FmUI.PopulateExportWindow()
	local accountName = GetDisplayName()
	local charName = GetUnitName("player")
	local s = "Account,Character,Name,Amount,Value,Total Value,Time Farmed(s)\n"
	for _, v in pairs(FmFarmer.items) do
		s = s ..
			string.format("%s,%s,%s,%d,%d,%d,%d\n", accountName, charName,
				zo_strformat('<<t:1>>', GetItemLinkName(v.itemLink)),
				v.amount, v.value, v.totalValue, FmFarmer.GetTimeFarmed())
	end
	ExportControl:GetNamedChild("EditBox"):SetText(s)
	ExportControl:GetNamedChild("EditBox"):SelectAll()
	ExportControl:GetNamedChild("EditBox"):TakeFocus()
end

function FmUI.ToggleExportWindow()
	if ExportControl:IsHidden() then
		FmUI.SetHidden(exportFragment, false)
		FmUI.PopulateExportWindow()
	else
		FmUI.SetHidden(exportFragment, true)
	end
end

function FmUI.ToggleSizeChange()
	FmUI.mini = not FmUI.mini
	FarmManagerWindow:GetNamedChild("DetailPanel"):SetHidden(FmUI.mini)

	FarmManagerWindow:GetNamedChild("ButtonSortByName"):SetHidden(FmUI.mini)
	FarmManagerWindow:GetNamedChild("ButtonSortByAmount"):SetHidden(FmUI.mini)
	FarmManagerWindow:GetNamedChild("ButtonSortByValue"):SetHidden(FmUI.mini)
	FarmManagerWindow:GetNamedChild("ButtonSortByTotalValue"):SetHidden(FmUI.mini)

	FarmManagerWindow:GetNamedChild("StatsControl"):GetNamedChild("ButtonReset"):SetHidden(FmUI.mini)
	FarmManagerWindow:GetNamedChild("StatsControl"):GetNamedChild("ButtonExport"):SetHidden(FmUI.mini)
	FarmManagerWindow:GetNamedChild("StatsControl"):GetNamedChild("ButtonStats"):SetHidden(FmUI.mini)

	FarmManagerWindow:GetNamedChild("TitleLabel"):SetHidden(FmUI.mini)

	if FmUI.mini then
		FarmManagerWindow:GetNamedChild("StatsControl"):SetAnchor(TOPLEFT, FarmManagerWindow, TOPLEFT, 0, 0)
		FarmManagerWindow:SetDimensionConstraints(250, 190)
		FarmManagerWindow:SetWidth(250)
		FarmManagerWindow:SetHeight(190)
	else
		FarmManagerWindow:GetNamedChild("StatsControl"):SetAnchor(TOPLEFT, FarmManagerWindow:GetNamedChild("DetailPanel"),
			BOTTOMLEFT, 0, 20)
		FarmManagerWindow:SetDimensionConstraints(550, 400)
		FarmManagerWindow:SetWidth(600)
		FarmManagerWindow:SetHeight(700)
	end
end

function FmUI.PopulateStatsWindow()

	FmStats.Init()

	local nodesFarmed = FmStats.GetNodesFarmed()
	local blacksmithingNodesFarmed, blacksmithingOreFarmed = FmStats.GetBlacksmithing()
	local avgBlacksmithing = math.floor((blacksmithingOreFarmed / blacksmithingNodesFarmed) * 100) / 100
	local clothingNodesFarmed, clothingOreFarmed = FmStats.GetClothing()
	local avgClothing = math.floor((clothingOreFarmed / clothingNodesFarmed) * 100) / 100
	local woodworkingNodesFarmed, woodworkingOreFarmed = FmStats.GetWoodworking()
	local avgWoodworking = math.floor((woodworkingOreFarmed / woodworkingNodesFarmed) * 100) / 100
	local cyrodiilNodesFarmed, dewFarmed = FmStats.GetCyrodiil()
	local avgCyrodiil = math.floor((cyrodiilNodesFarmed / dewFarmed) * 100) / 100
	local craglornNodesFarmed, potentNirncruxFarmed, fortifiedNirncruxFarmed = FmStats.GetCraglorn()
	local avgCraglornPotent = math.floor((craglornNodesFarmed / potentNirncruxFarmed) * 100) / 100
	local avgCraglornFortified = math.floor((craglornNodesFarmed / fortifiedNirncruxFarmed) * 100) / 100

	local s = ""
	s = s .. "Nodes Farmed: " .. ZO_CommaDelimitNumber(nodesFarmed) .. "\n"
	s = s .. "..................................\n"
	s = s .. "Blacksmithing Nodes Farmed: " .. ZO_CommaDelimitNumber(blacksmithingNodesFarmed) .. "\n"
	s = s .. "Blacksmithing Ore Farmed: " .. ZO_CommaDelimitNumber(blacksmithingOreFarmed) .. "\n"
	s = s ..
		"   Average Ore per Node: " ..
		ZO_CommaDelimitNumber(avgBlacksmithing) ..
		"\n"
	s = s .. "..................................\n"
	s = s .. "Clothing Nodes Farmed: " .. ZO_CommaDelimitNumber(clothingNodesFarmed) .. "\n"
	s = s .. "Clothing Ore Farmed: " .. ZO_CommaDelimitNumber(clothingOreFarmed) .. "\n"
	s = s ..
		"   Average Ore per Node: " ..
		ZO_CommaDelimitNumber(avgClothing) .. "\n"
	s = s .. "..................................\n"
	s = s .. "Woodworking Nodes Farmed: " .. ZO_CommaDelimitNumber(woodworkingNodesFarmed) .. "\n"
	s = s .. "Woodworking Ore Farmed: " .. ZO_CommaDelimitNumber(woodworkingOreFarmed) .. "\n"
	s = s ..
		"   Average Ore per Node: " ..
		ZO_CommaDelimitNumber(avgWoodworking) .. "\n"
	s = s .. "..................................\n"
	s = s .. "Cyrodiil Nodes Farmed: " .. ZO_CommaDelimitNumber(cyrodiilNodesFarmed) .. "\n"
	s = s ..
		"|H0:item:171433:0:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h Farmed: " .. ZO_CommaDelimitNumber(dewFarmed) .. "\n"
	s = s ..
		"   Average Node per Dew: " .. ZO_CommaDelimitNumber(avgCyrodiil) .. "\n"
	s = s .. "..................................\n"
	s = s .. "Craglorn Nodes Farmed: " .. ZO_CommaDelimitNumber(craglornNodesFarmed) .. "\n"
	s = s ..
		"|H0:item:56863:0:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h Farmed: " ..
		ZO_CommaDelimitNumber(potentNirncruxFarmed) .. "\n"
	s = s ..
		"   Average Node per Crux: " ..
		ZO_CommaDelimitNumber(avgCraglornPotent) .. "\n"
	s = s ..
		"|H0:item:56862:0:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h Farmed: " ..
		ZO_CommaDelimitNumber(fortifiedNirncruxFarmed) .. "\n"
	s = s ..
		"   Average Node per Crux: " ..
		ZO_CommaDelimitNumber(avgCraglornFortified) .. "\n"
	s = s .. "..................................\n"
	StatsControlLabel:SetText(s)
end

function FmUI.ToggleStatsWindow()
	if StatsControl:IsHidden() then
		FmUI.SetHidden(statsFragment, false)
		FmUI.PopulateStatsWindow()
	else
		FmUI.SetHidden(statsFragment, true)
	end
end
