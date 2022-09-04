
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
    local FastAnimSpeed = 0.1

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

        surface.SetDrawColor( 219, 219, 219)
        surface.DrawLine( w/2, 0, w/2, h )
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
        local buuton = ( self:IsHovered() && Color( 187, 34, 34) ) || GMASTER.ColorScheme.Background
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
    local TopMenuBar = vgui.Create('DPanel', Main)
	TopMenuBar:SetSize( MainWide, MainTall/10 )
	TopMenuBar:SetPos( 0, 0 )
    TopMenuBar.Paint = function( self, w, h )
		draw.RoundedBoxEx( rang, 0, 0, w, h-3, GMASTER.ColorScheme.Background, true, true, false, false)
        draw.RoundedBox( rang, 0, h-3, w, 3, ColorToneTo(GMASTER.ColorScheme.Background, -2))
    end

    --Top menu bar buttons

    local TMB_Buttons = {}

    local function CreateTMBButton( text, isDefault , doOnClick )

        local TMB_Button = vgui.Create( "DButton", TopMenuBar )
        table.insert( TMB_Buttons, TMB_Button )

        TMB_Button.Active = isDefault
        local TMB_Tall = TopMenuBar:GetTall()/2
        surface.SetFont( "font_base_30" )
        local TMB_Wide = select( 1, surface.GetTextSize( TMB_Button.Active && text || !TMB_Button.Active && TMB_Tall ) ) + 20 || 120
        TMB_Button:SetSize( TMB_Wide, TMB_Tall )

        local activeXPos = MainWide/2 - TMB_Button:GetWide()/2
        TMB_Button:SetPos( activeXPos, TopMenuBar:GetTall() - TMB_Tall - 3 )

        TMB_Button:SetText('')

        TMB_Button.Paint = function( self, w, h )
            local bg = (self.Depressed && GMASTER.ColorScheme.Background) || (self:IsHovered() && GMASTER.ColorScheme.Background) || GMASTER.ColorScheme.Background
            
            draw.RoundedBox( rang, 0, 0, w, h, GMASTER.ColorScheme.Background )

            if self.Active then
                draw.SimpleText( text, "font_base_30",w/2,h-2, Color( 225, 225, 225, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
                surface.SetDrawColor( 219, 219, 219)
                surface.DrawLine( 0, h/4, 0, h )
                surface.DrawLine( w-1, h/4, w-1, h )
            else
                draw.SimpleText( text[1], "font_base_26",w/2,h-2, Color( 225, 225, 225, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
                surface.SetDrawColor( 219, 219, 219)
                surface.DrawLine( 0, h/2, 0, h )
                surface.DrawLine( w-1, h/2, w-1, h )
            end
        end

        TMB_Button.ResizeWideValue = TMB_Button:GetWide()

        TMB_Button.Relativity = function( smooth )
            if !table.IsEmpty( TMB_Buttons ) then
                local prevV = NULL
                for k, v in ipairs( TMB_Buttons ) do
                    if (v == TMB_Button && k > 1 && smooth) then
                        TMB_Button:MoveTo( prevV:GetX() + prevV.ResizeWideValue + 5, TopMenuBar:GetTall() - TMB_Tall - 3, AnimSpeed, 0, -1 )
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

            TMB_Button.ResizeWideValue = 180
            TMB_Button:SizeTo( TMB_Button.ResizeWideValue, -1, AnimSpeed, 0, -1)
            TMB_Button.Relativity()

            for k, v in ipairs( TMB_Buttons ) do
                if v != TMB_Button then
                    v.Active = false
                    v.ResizeWideValue = TMB_Tall
                    v:SizeTo( v.ResizeWideValue, -1, AnimSpeed, 0, -1)
                    v.Relativity()
                end
            end

            for k, v in ipairs( TMB_Buttons ) do
                if ( v.Active ) then
                    activeXPos = k - 1 > 0 && (MainWide/2 - (TMB_Tall+5) * (k-1) - v.ResizeWideValue/2) || (MainWide/2 - v.ResizeWideValue/2)
                    break
                end
            end
            TMB_Button.Relativity()

            TMB_Buttons[1]:SetPos( activeXPos, TopMenuBar:GetTall() - TMB_Tall - 3 )

            for k, v in ipairs( TMB_Buttons ) do
                v.Relativity()
            end

            doOnClick()
        end

    end 

    local function CenterByActive()
        for k, v in ipairs( TMB_Buttons ) do
            if ( v.Active ) then
                activeXPos = k - 1 > 0 && (MainWide/2 - (TMB_Tall+5) * (k-1) - v.ResizeWideValue/2) || (MainWide/2 - v.ResizeWideValue/2)
                break
            end
        end

        TMB_Buttons[1]:SetPos( activeXPos, TopMenuBar:GetTall() - TMB_Tall - 3 )

        for k, v in ipairs( TMB_Buttons ) do
            v.Relativity()
        end
    end

    CreateTMBButton( "Spawnmenu", false, function() print("++") end )
    CreateTMBButton( "Features", true,  function() print("++") end )
    CreateTMBButton( "Players", false,  function() print("++") end )
    CreateTMBButton( "Settings", false,  function() print("++") end )

    CenterByActive()
    
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