FmFarmer = {
    timeStarted = nil,
    timeToAdd = 0, --if run is paused, the already elapsed time is saved in this var
    totalValue = 0,
    nodesFarmed = 0,
    items = {},
    running = false
}

function FmFarmer.Start()
    FmFarmer.timeStarted = GetTimeStamp()
    FmFarmer.running = true
end

function FmFarmer.Stop()
    FmFarmer.timeToAdd = GetTimeStamp() - FmFarmer.timeStarted + FmFarmer.timeToAdd
    FmFarmer.running = false
end

function FmFarmer.Add(itemLink, amount)
    --Adds item to the internal list
    local itemId = GetItemLinkItemId(itemLink)
    --if the item does not exist, creates a new item
    if FmFarmer.items[itemId] == nil then
        local item = {
            ["texture"] = GetItemLinkInfo(itemLink),
            ["itemId"] = itemId,
            ["itemLink"] = itemLink,
            ["amount"] = 0,
            ["totalValue"] = 0,
            ["value"] = LibPrice.ItemLinkToPriceGold(itemLink) or 0,
        }
        FmFarmer.items[itemId] = item
    end

    local item = FmFarmer.items[itemId]

    item.amount = item.amount + amount --updates amount
    item.totalValue = item.totalValue + (item.value * amount) --updates item total value
    FmFarmer.totalValue = FmFarmer.totalValue + (item.value * amount) --updates total farm value
    if #FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName] > 1 and
        FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName][
        #FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName]].timeStamp ~=
        GetTimeStamp() then
        FmFarmer.nodesFarmed = FmFarmer.nodesFarmed + 1
    end
    return item
end

function FmFarmer.Farm(itemLink, amount)
    local item = FmFarmer.Add(itemLink, amount) --adds the item to the internal list
    FmUI.OnItemFarmed(item) --triggers scroll list update
end

function FmFarmer.GetGoldPerSecond()
    if FmFarmer.totalValue == 0 then return 0 end
    return FmFarmer.totalValue / (FmFarmer.GetTimeFarmed())
end

function FmFarmer.GetNodesPerSecond()
    if FmFarmer.nodesFarmed == 0 then return 0 end
    return FmFarmer.nodesFarmed / (FmFarmer.GetTimeFarmed())
end

function FmFarmer.GetTimeFarmed()
    return GetTimeStamp() - (FmFarmer.timeStarted or GetTimeStamp()) + FmFarmer.timeToAdd --seconds
end

function FmFarmer.GetTimeFarmedFormated()
    --returns the time in 00:00:00 format
    local timeElapsed = FmFarmer.GetTimeFarmed()
    local h = math.floor(timeElapsed / 3600)
    timeElapsed = timeElapsed % 3600
    local m = math.floor(timeElapsed / 60)
    timeElapsed = timeElapsed % 60
    local s = timeElapsed
    local hString = h
    local mString = m
    local sString = s
    if h < 10 then hString = "0" .. hString end
    if m < 10 then mString = "0" .. mString end
    if s < 10 then sString = "0" .. sString end

    return hString .. ":" .. mString .. ":" .. sString
end

function FmFarmer.Reset()
    FmFarmer.timeStarted = GetTimeStamp()
    FmFarmer.timeToAdd = 0
    FmFarmer.totalValue = 0
    FmFarmer.nodesFarmed = 0
    FmFarmer.items = {}
end
