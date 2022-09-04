
--TODO Перенести в отдельную библу

local rang = GMASTER.Theme.Rounded && 10 || 0

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

local function ColorAlphaTo(Color, alpha)
    local newColor = newColor || {}
    newColor.r = Color.r
    newColor.g = Color.g
    newColor.b = Color.b
    newColor.a = alpha
    return newColor
end

------------------------------------------------------------------------------------------

local menuIsActive = false

local spawnMenu = Material( "materials/icons/spawn_light.png", "noclamp smooth" )
local features = Material( "materials/icons/features_light.png", "noclamp smooth" )
local players = Material( "materials/icons/player_light.png", "noclamp smooth" )
local settings = Material( "materials/icons/settings_light.png", "noclamp smooth" )

function OpenSettingsMenu()
    if (!LocalPlayer():IsAdmin()) then return end
    ------------------------------------------------
    --local vars
    ------------------------------------------------
    local MainWide = ScrW()/1.2
	local MainTall = MainWide/1.8
    local AnimSpeed = 0.2
    local ButtonAnimSpeed = 0.4

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
    local TopMenuBar = vgui.Create('DPanel', Main)
	TopMenuBar:SetSize( MainWide, MainTall/10 )
	TopMenuBar:SetPos( 0, 0 )
    TopMenuBar.Paint = function( self, w, h )
		draw.RoundedBoxEx( rang, 0, 0, w, h-3, GMASTER.ColorScheme.Background, true, true, false, false)
        draw.RoundedBox( rang, 0, h-3, w, 3, ColorToneTo(GMASTER.ColorScheme.Background, -7))
    end


    ------------------------------------------------
    --Top menu bar buttons
    ------------------------------------------------

    local TMB_Buttons = {}

    local TMB_Tall
    local TMB_Wide

    local function CreateTMBButton( text, icon, isDefault , doOnClick )

        local TMB_Button = vgui.Create( "DButton", TopMenuBar )
        table.insert( TMB_Buttons, TMB_Button )

        TMB_Button.Active = isDefault
        TMB_Tall = TopMenuBar:GetTall()*0.7
        surface.SetFont( "font_base_40" )
        TMB_Wide = (TMB_Button.Active && select( 1, surface.GetTextSize( text ) ) + 20 || !TMB_Button.Active && TMB_Tall)
        TMB_Button.ResizeWideValue = TMB_Wide
        TMB_Button:SetSize( TMB_Button.ResizeWideValue, TMB_Tall )

        local activeXPos = MainWide/2 - TMB_Button:GetWide()/2
        TMB_Button:SetPos( activeXPos, TopMenuBar:GetTall() - TMB_Tall - 3 )
        TMB_Button.XMoveValue = TMB_Button:GetX()

        TMB_Button:SetText('')

        TMB_Button.Paint = function( self, w, h )
            local bg = (self.Depressed && GMASTER.ColorScheme.Background) || (self:IsHovered() && GMASTER.ColorScheme.Background) || GMASTER.ColorScheme.Background
            
            --draw.RoundedBox( rang, 0, 0, w, h, GMASTER.ColorScheme.Background )

            if self.Active then
                draw.SimpleText( text, "font_base_40",w/2,h-2, Color( 225, 225, 225, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
                surface.SetDrawColor( GMASTER.ColorScheme.MainColor )
                surface.DrawLine( 0, h-1, w, h-1 )
            else
                --draw.SimpleText( icon, "font_base_26",w/2,h-2, Color( 225, 225, 225, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

                surface.SetMaterial( icon )
                surface.SetDrawColor( 255, 255, 255, 255 )
                surface.DrawTexturedRect( TMB_Tall*0.6/2-5, TMB_Tall*0.6/2, TMB_Tall*0.6, TMB_Tall*0.6 )

                if (self:IsHovered()) then
                    draw.RoundedBoxEx( rang, 0, h/12, w, h-3, Color(255,255,255,3), true, true, true, true)
                end

            end
        end

        TMB_Button.Relativity = function( smooth )
            if !table.IsEmpty( TMB_Buttons ) then
                local prevV = NULL
                for k, v in ipairs( TMB_Buttons ) do
                    if (v == TMB_Button && k > 1 && smooth) then
                        TMB_Button.XMoveValue = prevV.XMoveValue + prevV.ResizeWideValue + 5
                        TMB_Button:MoveTo( TMB_Button.XMoveValue, TopMenuBar:GetTall() - TMB_Tall - 3, ButtonAnimSpeed, 0, -1 )
                    elseif (v == TMB_Button && k > 1) then
                        TMB_Button:SetPos( prevV:GetX() + prevV.ResizeWideValue + 5, TopMenuBar:GetTall() - TMB_Tall - 3)
                    end
                    prevV = v
                end
            end
        end

        TMB_Button.Relativity()

        function TMB_Button:DoClick()
            TMB_Button.Active = true

            surface.SetFont( "font_base_40" )
            TMB_Button.ResizeWideValue = (TMB_Button.Active && select( 1, surface.GetTextSize( text ) ) + 20 || !TMB_Button.Active && TMB_Tall)
            TMB_Button:SizeTo( TMB_Button.ResizeWideValue, -1, ButtonAnimSpeed, 0, -1)

            for k, v in ipairs( TMB_Buttons ) do
                if v != TMB_Button then
                    v.Active = false
                    v.ResizeWideValue = TMB_Tall
                    v:SizeTo( v.ResizeWideValue, -1, ButtonAnimSpeed, 0, -1)
                end
            end

            for k, v in ipairs( TMB_Buttons ) do
                if ( v.Active ) then
                    activeXPos = k - 1 > 0 && (MainWide/2 - (TMB_Tall+5) * (k-1) - v.ResizeWideValue/2) || (MainWide/2 - v.ResizeWideValue/2)
                    break
                end
            end

            TMB_Buttons[1].XMoveValue = activeXPos
            TMB_Buttons[1]:MoveTo( activeXPos, TopMenuBar:GetTall() - TMB_Tall - 3, ButtonAnimSpeed, 0, -1 )

            for k, v in ipairs( TMB_Buttons ) do
                v.Relativity(true)
            end

            surface.PlaySound( Sound( "ui/buttonclick.wav" ) )

            doOnClick()
        end

        if (TMB_Button.Active) then
            doOnClick()
        end

    end 

    local function CenterByActive()
        for k, v in ipairs( TMB_Buttons ) do
            if !v.Active then
                v.ResizeWideValue = TMB_Tall
                v:SizeTo( v.ResizeWideValue, -1, ButtonAnimSpeed, 0, -1)
            end
        end

        for k, v in ipairs( TMB_Buttons ) do
            if ( v.Active ) then
                activeXPos = k - 1 > 0 && (MainWide/2 - (TMB_Tall+5) * (k-1) - v.ResizeWideValue/2) || (MainWide/2 - v.ResizeWideValue/2)
                break
            end
        end

        TMB_Buttons[1].XMoveValue = activeXPos
        TMB_Buttons[1]:MoveTo( activeXPos, TopMenuBar:GetTall() - TMB_Tall - 3, ButtonAnimSpeed, 0, -1 )
    end

    

    local function OpenCategory( name )
        local CategoryPanel = vgui.Create('DPanel', Main)

        CategoryPanel:SetSize( MainWide, MainTall - MainTall/10 )
	    CategoryPanel:SetPos( 0, MainTall/10 )
        CategoryPanel.Paint = function( self, w, h )
		    draw.RoundedBoxEx( rang, 0, 0, w/4, h, ColorToneTo(GMASTER.ColorScheme.Background, 10), false, false, true, false)
        end

        local CategoryMenu = vgui.Create('DPanel', CategoryPanel)

        CategoryMenu:SetSize( MainWide/4, MainTall - MainTall/10 )
	    CategoryMenu:SetPos( 0, MainTall/10 )
        CategoryMenu.Paint = function() end

        local CategoryContent = vgui.Create('DPanel', CategoryPanel)

        CategoryContent:SetSize( MainWide - MainWide/4, MainTall - MainTall/10 )
	    CategoryContent:SetPos( MainWide/4, MainTall/10 )
        CategoryContent.Paint = function() end
    end


    CreateTMBButton( "Спавн меню", spawnMenu, true, function()  end )
    CreateTMBButton( "Геймплей", features, false,  function()  end )
    CreateTMBButton( "Игроки", players, false,  function()  end )
    CreateTMBButton( "Настройки", settings, false,  function() OpenCategory( "settings" ) end )

    CenterByActive()

end

concommand.Add( "gmaster_menu", OpenSettingsMenu )


hook.Add("SpawnMenuOpen", "gamemaster_menu", function()
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