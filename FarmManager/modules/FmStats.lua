FmStats = {}

function FmStats.Init()

    -- Delete old data
    --[[ for k, _ in pairs(FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName]) do
        if type(k) ~= "number" then FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName][k] = nil end
    end ]]
end

function FmStats.GetNodesFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName]) do
        if FmNodeDetection.GetNodeId(v.nodeType) then
            if k == 1 then nodes = nodes + 1
            else
                if FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName][k].timeStamp ~=
                    FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName][k - 1].timeStamp then
                    nodes = nodes + 1
                end
            end
        end
    end
    return nodes
end

function FmStats.GetBlacksmithing()
    return FmStats.GetNodeTypeFarmed(1), FmStats.GetItemFarmedFromSpecificNodeType(71198, 1)
end

function FmStats.GetWoodworking()
    return FmStats.GetNodeTypeFarmed(2), FmStats.GetItemFarmedFromSpecificNodeType(71199, 2)
end

function FmStats.GetClothing()
    return FmStats.GetNodeTypeFarmed(3), FmStats.GetItemFarmedFromSpecificNodeType(71200, 3)
end

function FmStats.GetJewelry()
    return FmStats.GetNodeTypeFarmed(4), FmStats.GetItemFarmedFromSpecificNodeType(135145, 4)
end

function FmStats.GetCyrodiil()
    return FmStats.GetNodesInZoneFarmed(181), FmStats.GetItemFarmedFromNodeType(171433)
end

function FmStats.GetCraglorn()
    return FmStats.GetNodesInZoneFarmed(888), FmStats.GetItemFarmedFromNodeType(56863),
        FmStats.GetItemFarmedFromNodeType(56862)
end

function FmStats.GetGiantClam()
    return FmStats.GetNodeTypeFarmed(8), FmStats.GetItemFarmedFromNodeType(139020),
        FmStats.GetItemFarmedFromNodeType(139019)
end

function FmStats.GetCrimsonNirnroot()
    return FmStats.GetNodeTypeFarmed(9), FmStats.GetItemFarmedFromNodeType(150672)
end

function FmStats.GetBaseGameZones()
    local nodes = 0
    nodes = nodes + FmStats.GetNodesInZoneFarmed(104) --Alikr
    nodes = nodes + FmStats.GetNodesInZoneFarmed(381) --Auridon
    nodes = nodes + FmStats.GetNodesInZoneFarmed(281) --Bal FOyen
    nodes = nodes + FmStats.GetNodesInZoneFarmed(92) --Bangkorai
    nodes = nodes + FmStats.GetNodesInZoneFarmed(535) --Betnikh
    nodes = nodes + FmStats.GetNodesInZoneFarmed(280) --Bleakrock Isle
    nodes = nodes + FmStats.GetNodesInZoneFarmed(347) --Coldharbour
    nodes = nodes + FmStats.GetNodesInZoneFarmed(181) --Cyrodiil
    nodes = nodes + FmStats.GetNodesInZoneFarmed(57) --Deshaan
    nodes = nodes + FmStats.GetNodesInZoneFarmed(101) --Eastmarch
    nodes = nodes + FmStats.GetNodesInZoneFarmed(3) --Glenumbra
    nodes = nodes + FmStats.GetNodesInZoneFarmed(383) --Grathwood
    nodes = nodes + FmStats.GetNodesInZoneFarmed(108) --Greenshade
    nodes = nodes + FmStats.GetNodesInZoneFarmed(537) --Khenarthi's Roost
    nodes = nodes + FmStats.GetNodesInZoneFarmed(58) --Malabal Tor
    nodes = nodes + FmStats.GetNodesInZoneFarmed(382) --Reaper's March
    nodes = nodes + FmStats.GetNodesInZoneFarmed(103) --The Rift
    nodes = nodes + FmStats.GetNodesInZoneFarmed(20) --Rivenspire
    nodes = nodes + FmStats.GetNodesInZoneFarmed(117) --Shadowfen
    nodes = nodes + FmStats.GetNodesInZoneFarmed(41) --Stonefalls
    nodes = nodes + FmStats.GetNodesInZoneFarmed(19) --Stormhaven
    nodes = nodes + FmStats.GetNodesInZoneFarmed(534) --Stros MKai

    return nodes, FmStats.GetItemFarmedFromNodeType(115026)

end

function FmStats.GetNodeTypeFarmed(type)
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName]) do
        if FmNodeDetection.GetNodeId(v.nodeType) == type then
            if k == 1 then nodes = nodes + 1
            else
                if FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName][k].timeStamp ~=
                    FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName][k - 1].timeStamp then
                    nodes = nodes + 1
                end
            end
        end
    end
    return nodes
end

function FmStats.GetNodesInZoneFarmed(zoneId)
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName]) do
        if v.zone == zoneId and FmNodeDetection.GetNodeId(v.nodeType) ~= nil then
            if k == 1 then nodes = nodes + 1
            else
                if FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName][k].timeStamp ~=
                    FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName][k - 1].timeStamp then
                    nodes = nodes + 1
                end
            end
        end
    end
    return nodes
end

function FmStats.GetItemFarmedFromSpecificNodeType(itemId, type)
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName]) do
        if FmNodeDetection.GetNodeId(v.nodeType) == type and GetItemLinkItemId(v.itemLink) == itemId then
            nodes = nodes + v.amount
        end
    end
    return nodes
end

function FmStats.GetItemFarmedFromNodeType(itemId)
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName][FarmManager.accountName][FarmManager.charName]) do
        if FmNodeDetection.GetNodeId(v.nodeType) ~= nil and GetItemLinkItemId(v.itemLink) == itemId then
            nodes = nodes + v.amount
        end
    end
    return nodes
end
