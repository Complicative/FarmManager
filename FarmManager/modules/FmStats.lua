FmStats = {}
function FmStats.GetNodesFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if k == 1 then nodes = nodes + 1
        else
            if FarmManagerData[FarmManager.worldName][k].timeStamp ~=
                FarmManagerData[FarmManager.worldName][k - 1].timeStamp then
                nodes = nodes + 1
            end
        end
    end
    return nodes
end

function FmStats.GetBlacksmithingNodesFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 71198 or v.itemId == 135145 then
            if k == 1 then nodes = nodes + 1
            else
                if FarmManagerData[FarmManager.worldName][k].timeStamp ~=
                    FarmManagerData[FarmManager.worldName][k - 1].timeStamp then
                    nodes = nodes + 1
                end
            end
        end
    end
    return nodes
end

function FmStats.GetBlacksmithingOreFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 71198 or v.itemId == 135145 then
            nodes = nodes + v.amount
        end
    end
    return nodes
end

function FmStats.GetClothingNodesFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 71200 or v.itemId == 71239 then
            if k == 1 then nodes = nodes + 1
            else
                if FarmManagerData[FarmManager.worldName][k].timeStamp ~=
                    FarmManagerData[FarmManager.worldName][k - 1].timeStamp then
                    nodes = nodes + 1
                end
            end
        end
    end
    return nodes
end

function FmStats.GetClothingOreFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 71200 or v.itemId == 71239 then
            nodes = nodes + v.amount
        end
    end
    return nodes
end

function FmStats.GetWoodworkingNodesFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 71199 then
            if k == 1 then nodes = nodes + 1
            else
                if FarmManagerData[FarmManager.worldName][k].timeStamp ~=
                    FarmManagerData[FarmManager.worldName][k - 1].timeStamp then
                    nodes = nodes + 1
                end
            end
        end
    end
    return nodes
end

function FmStats.GetWoodworkingOreFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 71199 then
            nodes = nodes + v.amount
        end
    end
    return nodes
end

function FmStats.GetCyrodiilNodesFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.zone == "Cyrodiil" then
            if k == 1 then nodes = nodes + 1
            else
                if FarmManagerData[FarmManager.worldName][k].timeStamp ~=
                    FarmManagerData[FarmManager.worldName][k - 1].timeStamp then
                    nodes = nodes + 1
                end
            end
        end
    end
    return nodes
end

function FmStats.GetDewFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 171433 then
            nodes = nodes + v.amount
        end
    end
    return nodes
end

function FmStats.GetCraglornNodesFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.zone == "Craglorn" then
            if k == 1 then nodes = nodes + 1
            else
                if FarmManagerData[FarmManager.worldName][k].timeStamp ~=
                    FarmManagerData[FarmManager.worldName][k - 1].timeStamp then
                    nodes = nodes + 1
                end
            end
        end
    end
    return nodes
end

function FmStats.GetPotentNirncruxFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 56863 then
            nodes = nodes + v.amount
        end
    end
    return nodes
end

function FmStats.GetFortifiedNirncruxFarmed()
    local nodes = 0
    for k, v in ipairs(FarmManagerData[FarmManager.worldName]) do
        if v.itemId == 56862 then
            nodes = nodes + v.amount
        end
    end
    return nodes
end
