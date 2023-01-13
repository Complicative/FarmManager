FmUI = {
	mainWindow = FarmManagerWindow,
	itemList = FarmManagerWindowDetailPanelFmItemList, --scrollList
	lastSort = nil,
	mini = false
}

local mainFragment = ZO_SimpleSceneFragment:New(FarmManagerWindow)
local statsFragment = ZO_SimpleSceneFragment:New(FarmManagerStatsControl)
local exportFragment = ZO_SimpleSceneFragment:New(FarmManagerExportControl)

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

	FarmManagerExportControl:GetNamedChild("EditBox"):SetText(s)
	FarmManagerExportControl:GetNamedChild("EditBox"):SelectAll()
	FarmManagerExportControl:GetNamedChild("EditBox"):TakeFocus()
end

function FmUI.ToggleExportWindow()
	if FarmManagerExportControl:IsHidden() then
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
	local blackSmithingItemLink = "|H1:item:71198:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
	local woodworkingNodesFarmed, woodworkingOreFarmed = FmStats.GetWoodworking()
	local avgWoodworking = math.floor((woodworkingOreFarmed / woodworkingNodesFarmed) * 100) / 100
	local woodworkingItemLink = "|H1:item:71199:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
	local clothingNodesFarmed, clothingOreFarmed = FmStats.GetClothing()
	local avgClothing = math.floor((clothingOreFarmed / clothingNodesFarmed) * 100) / 100
	local clothingItemLink = "|H1:item:71200:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"

	local jewelryNodesFarmed, jewelryOreFarmed = FmStats.GetJewelry()
	local avgJewelry = math.floor((jewelryOreFarmed / jewelryNodesFarmed) * 100) / 100
	local jewelryItemLink = "|H1:item:135145:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"

	local cyrodiilNodesFarmed, mourningDewFarmed = FmStats.GetCyrodiil()
	local avgMourningDew = math.floor((cyrodiilNodesFarmed / mourningDewFarmed) * 100) / 100
	local mourningDewItemLink = "|H1:item:171433:0:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"

	local craglornNodesFarmed, potentNirncruxFarmed, fortifiedNirncruxFarmed = FmStats.GetCraglorn()
	local avgPotentNirncrux = math.floor((craglornNodesFarmed / potentNirncruxFarmed) * 100) / 100
	local potentNirncruxItemLink = "|H1:item:56863:0:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
	local avgFortifiedNirncrux = math.floor((craglornNodesFarmed / fortifiedNirncruxFarmed) * 100) / 100
	local fortifiedNirncruxItemLink = "|H1:item:56862:0:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"

	local giantClamNodesFarmed, clamGallFarmed, motherOfPearlFarmed = FmStats.GetGiantClam()
	local avgClamGall = math.floor((giantClamNodesFarmed / clamGallFarmed) * 100) / 100
	local clamGallItemLink = "|H1:item:139020:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
	local avgMotherOfPearl = math.floor((giantClamNodesFarmed / motherOfPearlFarmed) * 100) / 100
	local motherOfPearlItemLink = "|H1:item:139019:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"

	local crimsonNirnrootNodesFarmed, crimsonNirnrootFarmed = FmStats.GetCrimsonNirnroot()
	local avgCrimsonNirnroot = math.floor((crimsonNirnrootFarmed / crimsonNirnrootNodesFarmed) * 100) / 100
	local crimsonNirnrootItemLink = "|H1:item:150672:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"

	local baseGameNodesFarmed, aetherialDustFarmed = FmStats.GetBaseGameZones()
	local avgAetherialDust = math.floor((baseGameNodesFarmed / aetherialDustFarmed) * 100) / 100
	local aetherialDustItemLink = "|H1:item:115026:29:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"

	local s = "Common Drops:\n\n"
	--[[ Blacksmithing ]]
	s = s .. FmUI.GetStatsStringCommon("Blacksmithing Nodes", blacksmithingNodesFarmed, blackSmithingItemLink,
		blacksmithingOreFarmed, avgBlacksmithing)
	s = s .. "..................................\n"
	--[[ Woodworking ]]
	s = s ..
		FmUI.GetStatsStringCommon("Woodworking Nodes", woodworkingNodesFarmed, woodworkingItemLink, woodworkingOreFarmed,
			avgWoodworking)
	s = s .. "..................................\n"
	--[[ Clothing ]]
	s = s ..
		FmUI.GetStatsStringCommon("Clothing Nodes", clothingNodesFarmed, clothingItemLink, clothingOreFarmed, avgClothing)
	s = s .. "..................................\n"
	--[[ Jewelry ]]
	s = s .. FmUI.GetStatsStringCommon("Jewelry Nodes", jewelryNodesFarmed, jewelryItemLink, jewelryOreFarmed, avgJewelry)
	s = s .. "..................................\n"
	--[[ Crimson Nirnroot ]]
	s = s .. FmUI.GetStatsStringCommon("Crimson Nirnroot Nodes", crimsonNirnrootNodesFarmed, crimsonNirnrootItemLink,
		crimsonNirnrootFarmed, avgCrimsonNirnroot)
	s = s .. "..................................\n"

	FarmManagerStatsControlLabel1:SetText(s)
	s = "Rare Drops:\n\n"


	--[[ Craglorn ]]
	s = s .. FmUI.GetStatsStringRare("Craglorn Nodes", craglornNodesFarmed, potentNirncruxItemLink, potentNirncruxFarmed,
		avgPotentNirncrux,
		fortifiedNirncruxItemLink, fortifiedNirncruxFarmed, avgFortifiedNirncrux)
	s = s .. "..................................\n"
	--[[ Giant Clam ]]
	s = s .. FmUI.GetStatsStringRare("Giant Clam", giantClamNodesFarmed, clamGallItemLink, clamGallFarmed, avgClamGall,
		motherOfPearlItemLink, motherOfPearlFarmed, avgMotherOfPearl)
	s = s .. "..................................\n"
	--[[ Cyrodiil ]]
	s = s .. FmUI.GetStatsStringRare("Cyrodiil Nodes", cyrodiilNodesFarmed, mourningDewItemLink, mourningDewFarmed,
		avgMourningDew)
	s = s .. "..................................\n"
	--[[ Base Game ]]
	s = s .. FmUI.GetStatsStringRare("Base Game Nodes", baseGameNodesFarmed, aetherialDustItemLink, aetherialDustFarmed,
		avgAetherialDust)
	s = s .. "..................................\n"

	FarmManagerStatsControlLabel2:SetText(s)
end

function FmUI.GetStatsStringCommon(nodeName, nodeAmount, itemLink1, itemAmount1, itemAvg1, itemLink2, itemAmount2,
                                   itemAvg2)
	local s = ""
	s = s .. nodeName .. " Farmed: " .. ZO_CommaDelimitNumber(nodeAmount) .. "\n"

	s = s .. "|t32:32:" .. GetItemLinkInfo(itemLink1) .. "|t"
	s = s .. itemLink1 .. " Farmed: " .. ZO_CommaDelimitNumber(itemAmount1) .. "\n"
	s = s .. "|t32:32:" .. GetItemLinkInfo(itemLink1) .. "|t"
	s = s .. itemLink1 .. " per Node: " .. ZO_CommaDelimitNumber(itemAvg1) .. "\n"

	if itemLink2 then
		s = s .. "|t32:32:" .. GetItemLinkInfo(itemLink2) .. "|t"
		s = s .. itemLink2 .. " Farmed: " .. ZO_CommaDelimitNumber(itemAmount2) .. "\n"
		s = s .. "|t32:32:" .. GetItemLinkInfo(itemLink2) .. "|t"
		s = s .. itemLink2 .. " per Node: " .. ZO_CommaDelimitNumber(itemAvg2) .. "\n"
	end

	return s
end

function FmUI.GetStatsStringRare(nodeName, nodeAmount, itemLink1, itemAmount1, itemAvg1, itemLink2, itemAmount2,
                                 itemAvg2)
	local s = ""
	s = s .. nodeName .. " Farmed: " .. ZO_CommaDelimitNumber(nodeAmount) .. "\n"

	s = s .. "|t32:32:" .. GetItemLinkInfo(itemLink1) .. "|t"
	s = s .. itemLink1 .. " Farmed: " .. ZO_CommaDelimitNumber(itemAmount1) .. "\n"
	s = s .. "|t32:32:" .. GetItemLinkInfo(itemLink1) .. "|t"
	s = s .. "Nodes per " .. itemLink1 .. ": " .. ZO_CommaDelimitNumber(itemAvg1) .. "\n"

	if itemLink2 then
		s = s .. "|t32:32:" .. GetItemLinkInfo(itemLink2) .. "|t"
		s = s .. itemLink2 .. " Farmed: " .. ZO_CommaDelimitNumber(itemAmount2) .. "\n"
		s = s .. "|t32:32:" .. GetItemLinkInfo(itemLink2) .. "|t"
		s = s .. "Nodes per " .. itemLink2 .. ": " .. ZO_CommaDelimitNumber(itemAvg2) .. "\n"
	end

	return s
end

function FmUI.ToggleStatsWindow()
	if FarmManagerStatsControl:IsHidden() then
		FmUI.SetHidden(statsFragment, false)
		FmUI.PopulateStatsWindow()
	else
		FmUI.SetHidden(statsFragment, true)
	end
end
