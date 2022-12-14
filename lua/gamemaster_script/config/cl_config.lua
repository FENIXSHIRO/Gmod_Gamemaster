
GMASTER.ColorScheme = GMASTER.ColorScheme || {}
GMASTER.Theme = GMASTER.Theme || {}
GMASTER.Theme.Blur = GMASTER.Theme.Blur || {}
GMASTER.Input = GMASTER.Input || {}

GMASTER.Theme.Rounded = true
GMASTER.Theme.Blur.Disable = false
GMASTER.Theme.Blur.Amount = 3
GMASTER.Input.SwapQSpawnMenu = true

--[[---------------------------------------------------------
    Настройка цвета | Color settings
-----------------------------------------------------------]]

GMASTER.ColorScheme.Alpha = 210

GMASTER.ColorScheme.MainColor = Color(60, 47, 243, GMASTER.ColorScheme.Alpha)

GMASTER.ColorScheme.SubColor = Color(161, 161, 161, GMASTER.ColorScheme.Alpha)

GMASTER.ColorScheme.MenuColor = Color(255, 255, 255, GMASTER.ColorScheme.Alpha)

GMASTER.ColorScheme.OptionColor = Color(255, 255, 255, GMASTER.ColorScheme.Alpha)

GMASTER.ColorScheme.Background = Color(17, 17, 17, GMASTER.ColorScheme.Alpha)

GMASTER.ColorScheme.ColorButton = Color(20, 20, 20, GMASTER.ColorScheme.Alpha)

--[[---------------------------------------------------------
    Шрифты | Fonts
-----------------------------------------------------------]]

    
    surface.CreateFont( 
        "font_base_22", 
        {
            font = "Trebuchet24",
            size = 22,weight = 0,
            underline = false,
            extended = true,
        }
    )

    surface.CreateFont( 
        "font_base_26", 
        {
            font = "Trebuchet24",
            size = 26,weight = 0,
            underline = false,
            extended = true,
        }
    )

    surface.CreateFont( 
        "font_base_30", 
        {
            font = "Trebuchet24",
            size = 30,weight = 0,
            underline = false,
            extended = true,
        }
    )

    surface.CreateFont( 
        "font_base_35", 
        {
            font = "Trebuchet24",
            size = 35,weight = 0,
            underline = false,
            extended = true,
        }
    )

    surface.CreateFont( 
        "font_base_40", 
        {
            font = "Default",
            size = 40,weight = 0,
            underline = false,
            extended = true,
        }
    )
