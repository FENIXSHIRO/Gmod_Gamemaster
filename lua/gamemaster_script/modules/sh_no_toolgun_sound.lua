
local tggl = 1;

concommand.Add( "TGSoundTG", function()
    if(1 - tggl == 0) then
        --GetConVar( "gmod_drawtooleffects" ):SetInt( 0 )
        RunConsoleCommand( "gm_toolgun_effects", 0)
    else
        --GetConVar( "gmod_drawtooleffects" ):SetInt( 1 )
        RunConsoleCommand( "gm_toolgun_effects", 1)
    end

    tggl = 1 - tggl
end )