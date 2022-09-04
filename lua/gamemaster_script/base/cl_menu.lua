
--TODO Перенести в отдельную библу

local rang = GMASTER.Theme.Rounded && 7 || 0

local blur = Material("pp/blurscreen")
function draw.Blurpanel( panel)
    if (GMASTER.Theme.Blur.Disable) then return end
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )

	for i = 1, ( GMASTER.Theme.Blur.Amount || 3 ) do
		blur:SetFloat( "$blur", ( i / 3 ) * ( GMASTER.Theme.Blur.Amount || 6 ) )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )
	end
end

local function ColorToneTo(Color, tone)
    local newColor = newColor || {}
    newColor.r = Color.r + tone
    newColor.g = Color.g + tone
    newColor.b = Color.b + tone
    newColor.a = Color.a
    return newColor
end

------------------------------------------------------------------------------------------

local menuIsActive = false

function OpenSettingsMenu()
    ------------------------------------------------
    --local vars
    ------------------------------------------------
    local MainWide = ScrW()/1.2
	local MainTall = MainWide/1.8
    local AnimSpeed = 0.2

    ------------------------------------------------
    --MainPanel
    ------------------------------------------------
    if (menuIsActive) then return end

    local Main = vgui.Create('DFrame')
	Main:SetSize( MainWide, 0 )
	Main:SetPos( ScrW()/2 - MainWide/2, ScrH()/2 )
    Main:MoveTo( ScrW()/2 - MainWide/2, ScrH()/2 - MainTall/2, AnimSpeed, 0, -1 )
    Main:SizeTo( -1, MainTall, AnimSpeed, 0, -1, function() menuIsOpen = true end )
	Main:ShowCloseButton( false )
	Main:SetTitle('')
	Main:MakePopup()
    Main:SetKeyboardInputEnabled(false)
    Main.Paint = function( self, w, h )
		draw.Blurpanel(Main)
		draw.RoundedBox( rang, 0, 0, w, h, GMASTER.ColorScheme.Background )
    end
    
    menuIsActive = true

    local function CLoseMain()
        gui.HideGameUI()
        Main:SetKeyBoardInputEnabled( false )
        Main:SetMouseInputEnabled( false )
        Main:SizeTo( -1, 0, AnimSpeed, 0, -1, function() menuIsOpen = false end)
        Main:MoveTo( ScrW()/2 - MainWide/2, ScrH()/2, AnimSpeed, 0, -1)
	    timer.Simple( AnimSpeed+0.1, function() Main:Remove() end )
        menuIsActive = false
    end

--[[ DEBUG CLOSE

    local Button_Close = vgui.Create('DButton',Main)
	Button_Close:SetSize( 30, 30 )
	Button_Close:SetPos(MainWide-Button_Close:GetWide()-10, 10)
	Button_Close:SetText(' ')
	Button_Close.DoClick = function()
        CLoseMain()
	end
	Button_Close.Paint = function( self, w, h )
        local buuton = ( self:IsHovered() and Color( 187, 34, 34) ) || GMASTER.ColorScheme.Background
        draw.RoundedBox( rang, 0, 0, w, h, GMASTER.ColorScheme.Background )
        draw.RoundedBox( rang, 1, 1, w-2, h-2, buuton )
		draw.SimpleText( "✕", "font_base_22",w/2-1, h/2, Color( 225, 225, 225, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

]]

    local lastTick = false

    function Main:Think()
		if ( input.IsKeyDown(KEY_ESCAPE) || !input.IsKeyDown(KEY_Q) && lastTick && menuIsOpen )then
            CLoseMain()
			return false
		end
	end

    hook.Add( "Tick", "Release", function()
        lastTick = input.IsKeyDown(KEY_Q)
    end )

    ------------------------------------------------
    --TopMenuBar
    ------------------------------------------------
    local function TopBarButtonsPaint( self, w, h, text )
        local bg = (self.Depressed and GMASTER.ColorScheme.Background) or (self:IsHovered() and GMASTER.ColorScheme.Background) or GMASTER.ColorScheme.Background

        --draw.RoundedBoxEx(0, 0, 0, w, h, bg, false, false, false, true)
        draw.SimpleText( text, "font_base_22",w/2,h/2, Color( 225, 225, 225, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTOM )
    end

    local TopMenuBar = vgui.Create('DPanel', Main)
	TopMenuBar:SetSize( MainWide, MainTall/15 )
	TopMenuBar:SetPos( 0, 0 )
    TopMenuBar.Paint = function( self, w, h )
		draw.RoundedBoxEx( rang, 0, 0, w, h-3, GMASTER.ColorScheme.Background, true, true, false, false)
        draw.RoundedBox( rang, 0, h-3, w, 3, ColorToneTo(GMASTER.ColorScheme.Background, -2))
    end

    --Top menu bar button sizes
    TMB_Wide = 200
    TMB_Tall = TopMenuBar:GetTall()-10

    --FeaturesButton | CENTER BUTON |
    local TMB_Button_Features = vgui.Create( "DButton", TopMenuBar )
    TMB_Button_Features:SetSize( TMB_Wide, TMB_Tall )
    TMB_Button_Features:SetPos( MainWide/2 - TMB_Wide/2, 5)
    TMB_Button_Features:SetText('')
    TMB_Button_Features.Paint = function( self, w, h )
        TopBarButtonsPaint( self, w, h, "Features" )
    end

    --Spawn Menu
    local TMB_Button_SpawnMenu = vgui.Create( "DButton", TopMenuBar )
    TMB_Button_SpawnMenu:SetText('')
    TMB_Button_SpawnMenu:SetPos( 0, 5)
    TMB_Button_SpawnMenu:SetSize( TMB_Wide, TMB_Tall )
    TMB_Button_SpawnMenu:MoveLeftOf( TMB_Button_Features, 5 )
    TMB_Button_SpawnMenu.Paint = function( self, w, h )
        TopBarButtonsPaint( self, w, h, "Spawn menu" )
    end

    --GMaster Settings
    local TMB_Button_GMasterSettings = vgui.Create( "DButton", TopMenuBar )
    TMB_Button_GMasterSettings:SetText('')
    TMB_Button_GMasterSettings:SetPos( 0, 5)
    TMB_Button_GMasterSettings:SetSize( TMB_Wide, TMB_Tall )
    TMB_Button_GMasterSettings:MoveRightOf( TMB_Button_Features, 5 )
    TMB_Button_GMasterSettings.Paint = function( self, w, h )
        TopBarButtonsPaint( self, w, h, "GMaster settings" )
    end

    
    --DEBUG
    --Button_Close:MoveToFront()
end

concommand.Add( "gmaster_menu", OpenSettingsMenu )

hook.Add("SpawnMenuOpen", "spawn_menu_ranks", function()
    if ( input.IsKeyDown(KEY_E) && !GMASTER.Input.SwapQSpawnMenu) then
        OpenSettingsMenu()
        return false
    end

    if ( input.IsKeyDown(KEY_E) && GMASTER.Input.SwapQSpawnMenu) then
        return true
    end

    if (GMASTER.Input.SwapQSpawnMenu) then
        OpenSettingsMenu()
        return false
    end
end)