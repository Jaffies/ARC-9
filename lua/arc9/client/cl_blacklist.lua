ARC9.Blacklist = {}

// CLIENT

net.Receive("arc9_sendblacklist", function(len, ply)

    ARC9.Blacklist = {}

    local count = net.ReadUInt(32)

    for i = 1, count do
        local attid = net.ReadUInt(ARC9.Attachments_Bits)

        local atttbl = ARC9.GetAttTable(attid)

        local shortname = atttbl.ShortName

        ARC9.Blacklist[shortname] = true
    end
end)

function ARC9:SendClientBlacklist()
    net.Start("arc9_sendblacklist")

    net.WriteUInt(table.Count(ARC9.Blacklist), 32)

    for attname, i in pairs(ARC9.Blacklist) do
        if !i then continue end
        local atttbl = ARC9.GetAttTable(attname)

        local id = atttbl.ID

        net.WriteUInt(id, ARC9.Attachments_Bits)
    end

    net.SendToServer()
end

function ARC9:AddAttToBlacklist(att)
    ARC9.Blacklist[att] = true
end

function ARC9:RemoveAttFromBlacklist(att)
    ARC9.Blacklist[att] = false
end

concommand.Add("arc9_blacklist_show", function()
    for i, k in pairs(ARC9.Blacklist) do
        print(i)
    end
end)

concommand.Add("arc9_blacklist_add", function(ply, cmd, args)
    for _, i in ipairs(args) do
        local atttbl = ARC9.GetAttTable(i)

        if !atttbl then
            print("WARNING! ", i, " is not a valid attachment! Make sure it's spelled correctly!")
            continue
        end

        ARC9:AddAttToBlacklist(i)
    end

    ARC9:SendClientBlacklist()
end)

concommand.Add("arc9_blacklist_remove", function(ply, cmd, args)
    for _, i in ipairs(args) do
        local atttbl = ARC9.GetAttTable(i)

        if !atttbl then
            print("WARNING! ", i, " is not a valid attachment! Make sure it's spelled correctly!")
            continue
        end

        ARC9:RemoveAttFromBlacklist(i)
    end

    ARC9:SendClientBlacklist()
end)