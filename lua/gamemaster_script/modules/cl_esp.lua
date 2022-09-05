surface.CreateFont("esp_font1", {
	font = "Roboto Regular",
	size = 16,
	extended = true,
	weight = 500
})

surface.CreateFont("esp_font2", {
	font = "Roboto Regular",
	size = 18,
	extended = true,
	weight = 500
})

local cache = {}

local function GetTextSize(text, font, bNoCache)
	font = font or "esp_font2"

	if (!bNoCache and cache[text] and cache[text][font]) then
		local textSize = cache[text][font]

		return textSize[1], textSize[2]
	else
		surface.SetFont(font)

		local result = {surface.GetTextSize(text)}

		if (!bNoCache) then
			cache[text] = {}
			cache[text][font] = result
		end

		return result[1], result[2]
	end
end

local color_lightred = Color(255, 100, 100)
local color_grey = Color(100, 100, 100)
local color_red = Color(255, 0, 0)
local color_blue = Color(0, 0, 255)

hook.Add("HUDPaint", "gamemasterESP",function()
	local ply = LocalPlayer()
	if (ply:IsAdmin()) then
		local scrW, scrH = ScrW(), ScrH()
		local clientPos = ply:GetPos()

		for k, v in ipairs(player.GetAll()) do
			if (v == ply) or (ply:GetPos():DistToSqr(v:GetPos()) < 200 * 200) then continue end

			local pos = v:GetPos()
			local head = Vector(pos.x, pos.y, pos.z + 60)
			local screenPos = pos:ToScreen()
			local headPos = head:ToScreen()
			local textPos = Vector(head.x, head.y, head.z + 20):ToScreen()
			local x, y = headPos.x, headPos.y
			local size = 52 * math.abs(350 / math.sqrt(clientPos:DistToSqr(pos)))
			local teamColor = Color(255, 255, 255)

			local w, h = GetTextSize(v:Name(), "esp_font2")
			local noclip = ""

			if v:GetMoveType() == MOVETYPE_NOCLIP then noclip = " (Noclip)" end
			draw.SimpleText(v:Name()..noclip, "esp_font2", textPos.x - w * 0.5, textPos.y, teamColor, TEXT_ALIGN_LEFT)

			local w, h = 200

			if (v:Alive() and ply:GetPos():DistToSqr(v:GetPos()) < 1000 * 1000) then
					surface.SetDrawColor(teamColor)
					surface.DrawOutlinedRect(x - size * 0.5, y - size * 0.5, size, (screenPos.y - y) * 1.25)
			elseif (!v:Alive()) then
				local w, h = GetTextSize("*DEAD*", "esp_font1")
				draw.SimpleText("*DEAD*", "esp_font1", textPos.x - w * 0.5, textPos.y + 42, color_lightred)
			end

			if (ply:GetPos():DistToSqr(v:GetPos()) < 1000 * 1000) then
				local bx, by = x - size * 0.5, y - size * 0.5 + (screenPos.y - y) * 1.25
				local hpM = math.Clamp((v:Health() or 0) / v:GetMaxHealth(), 0, 1)

				if (hpM > 0) then
					draw.RoundedBox(0, bx, by, size, 2, color_grey)
					draw.RoundedBox(0, bx, by, size * hpM, 2, color_red)
				end

				local arM = math.Clamp((v:Armor() or 0) / 100, 0, 1)

				if (arM > 0) then
					draw.RoundedBox(0, bx, by + 3, size, 2, color_grey)
					draw.RoundedBox(0, bx, by + 3, size * arM, 2, color_blue)
				end
			end
		end
	end
end)