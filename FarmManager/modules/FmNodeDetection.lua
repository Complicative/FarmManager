FmNodeDetection = {
    --If you are a dev for a different addon and you need this, feel free to copy it. Please add a comment allowing anyone else to use it as well :)
}

function FmNodeDetection.GetNodeId(name)
    -- 1: Blacksmithing
    -- 2: Jewelry
    -- 3: Woodworking
    -- 4: Clothing
    -- 5: Enchanting
    -- 6: Psijic Portal
    -- 7: Alchemy
    -- 8: Giant Clam (Summerset)
    -- 9: Crimson Nirnroot
    local t = {
        ["Rubedite Ore"] = 1,
        ["Ruby Ash Wood"] = 2,
        ["Ancestor Silk"] = 3,
        ["Platinum Seam"] = 4,

        ["Runestone"] = 5,
        ["Psijic Portal"] = 6,

        --["Beetle Scuttle"] = 7,
        ["Blessed Thistle"] = 7,
        ["Blue Entoloma"] = 7,
        ["Bugloss"] = 7,
        --["Butterfly Wing"] = 7,
        --["Chaurus Egg"] = 7,
        ["Clam Gall"] = 7,
        ["Columbine"] = 7,
        ["Corn Flower"] = 7,
        --["Dragon's Bile"] = 7,
        --["Dragon's Blood"] = 7,
        --["Dragon Rheum"] = 7,
        ["Dragonthorn"] = 7,
        ["Emetic Russula"] = 7,
        --["Fleshfly Larva"] = 7,
        ["Imp Stool"] = 7,
        ["Lady's Smock"] = 7,
        ["Luminous Russula"] = 7,
        ["Mountain Flower"] = 7,
        --["Mudcrab Chitin"] = 7,
        ["Namira's Rot"] = 7,
        ["Nightshade"] = 7,
        ["Nirnroot"] = 7,
        --["Powdered Mother of Pearl"] = 7,
        --["Scrib Jelly"] = 7,
        --["Spider Egg"] = 7,
        ["Stinkhorn"] = 7,
        --["Torchbug Thorax"] = 7,
        --["Vile Coagulant"] = 7,
        ["Violet Coprinus"] = 7,
        ["Water Hyacinth"] = 7,
        ["White Cap"] = 7,
        ["Wormwood"] = 7,
        ["Pure Water"] = 7,
        ["Water Skin"] = 7,

        ["Giant Clam"] = 8,

        ["Crimson Nirnroot"] = 9,

    }
    return t[name] or nil
end
