GMASTER = GMASTER || {}
GMASTER.Script = GMASTER.Script || {}
GMASTER.Script.Author = "FENIXSHIRO"
GMASTER.Script.Folder = "gamemaster_script"

--Config init

AddCSLuaFile( "gamemaster_script/config/cl_config.lua" )
if CLIENT then include( "gamemaster_script/config/cl_config.lua" ) end

CreateConVar('gm_toolgun_effects', 1, FCVAR_ARCHIVE, 'toolgun_sound', 0, 1)

--Server init

if SERVER then

    local fol = GMASTER.Script.Folder .. "/"
    local files, folders = file.Find(fol .. "*", "LUA")

    for k, v in pairs( files ) do
        include(fol .. v)
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." || folder == ".." then continue end

        for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
            AddCSLuaFile(fol .. folder .. "/" .. File)
            include(fol .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." || folder == ".." then continue end

        for _, File in SortedPairs(file.Find(fol .. folder .. "/sv_*.lua", "LUA"), true) do
            include(fol .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." || folder == ".." then continue end

        for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
            AddCSLuaFile(fol .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." || folder == ".." then continue end

        for _, File in SortedPairs(file.Find(fol .. folder .. "/vgui_*.lua", "LUA"), true) do
            AddCSLuaFile(fol .. folder .. "/" .. File)
        end
    end

end

--Client init

if CLIENT then

    local root = GMASTER.Script.Folder .. "/"
    local _, folders = file.Find(root .. "*", "LUA")

    for _, folder in SortedPairs(folders, true) do
        if folder == "." || folder == ".." then continue end

        for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
            include(root .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." || folder == ".." then continue end

        for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
            include(root .. folder .. "/" .. File)
        end
    end

end
