if SERVER then
    util.AddNetworkString("HotSpawn")
end

if CLIENT then  
    concommand.Add( "hot_spawn", function()
        local name = LocalPlayer():GetInfo( "creator_name" )
        local args = LocalPlayer():GetInfo( "creator_name" )
        local stype = LocalPlayer():GetInfoNum( "creator_type", 0)

        net.Start("HotSpawn")
        net.WriteEntity( LocalPlayer() )
        net.WriteString( name )
        net.WriteString( args )
        net.WriteInt( stype, 4 )
        net.SendToServer()

        print('Spawned: '..name..' | '..stype)

    end )
end

net.Receive( "HotSpawn", function()
    print("recived")
    ply = net.ReadEntity()
    name = net.ReadString()
    args = net.ReadString()
    stype = net.ReadInt( 4 )

    print(stype)

    local tr = ply:GetEyeTrace() -- Create a trace to where the player is looking
    if tr.HitNonWorld then return end -- If the player is not looking at the ground then return

    if (stype == 0) then
        RunConsoleCommand("gm_spawnsent", name)
        return
    end

    if (stype == 1) then
        RunConsoleCommand("gm_spawnvehicle", name)
        return
    end

    if (stype == 2) then
        RunConsoleCommand("gmod_spawnnpc", name, args)
        return
    end

    if (stype == 3) then
        RunConsoleCommand("gm_spawnswep", name)
        return
    end

    if (stype == 4) then
        RunConsoleCommand("gm_spawn", name)
        return
    end
end)