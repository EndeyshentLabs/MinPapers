require("utils")
require("names")
require("country")

local font = nil

local name = "POGLIN" -- Default impossible values
local age = -11037
local country = "Luare"
local nation = "Luarean"
local sex = "femboy"
local name_s = nil

local denied = false
local approved = false
local once = false

local wrong_age = false
local wrong_name_sex = false

local function loop()
	denied = false
	approved = false
	once = false

	wrong_age = false
	wrong_name_sex = false

	math.randomseed(love.math.random(-11037, 11037))

	local name_rand = math.random(2)
	if name_rand <= 1 then
		name = male[math.random(#male)]
	elseif name_rand > 1 and name_rand <= 2 then
		name = female[math.random(#female)]
	end

	age = math.random(80)
	country = countries[math.random(#countries)]
	nation = nations[math.random(#nations)]

	local sex_rand = math.random(2)
	if sex_rand <= 1 then
		sex = "male"
	elseif sex_rand > 1 and sex_rand <= 2 then
		sex = "female"
	end
end

function love.load()
	font = love.graphics.newFont("Konstruktor-vmmxL.otf", 20)

	loop()
end

function love.update(dt) end

function love.draw()
	local third = love.graphics.getWidth() / 3
	local space = 4

	love.graphics.setColor(0.25, 0.25, 0.25)
	love.graphics.rectangle("fill", 0, 0, third, love.graphics.getHeight())
	love.graphics.setColor(0.36, 0.36, 0.36)
	love.graphics.rectangle("fill", third, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.setColor(1, 1, 1)
	love.graphics.print(
		"PASSPORT"
			.. "\n    NAME: "
			.. name
			.. "\n    AGE: "
			.. age
			.. "\n    COUNTRY: "
			.. country
			.. "\n    NATION: "
			.. nation
			.. "\n    SEX: "
			.. sex,
		font,
		third,
		0
	)

	love.graphics.print(
		"RULES:"
			.. "\n    MIN PASSPORT AGE: 16"
			.. "\n    NATION and COUNTRY: ZOCH"
			.. "\n    ONLY ONE APPROVAL STATE AT ONCE"
			.. "\nCONTROLS:"
			.. "\n    'A' - APPROVE"
			.. "\n    'S' - DENY"
			.. "\n    'L' - CLEAR APPROVE"
			.. "\n    'K' - CLEAR DENY"
			.. "\nGAMEPLAY:"
			.. "\n    1. CHECK NAME AND SEX"
			.. "\n    1.1. IF INCORRECT, PRESS 'K' THEN 'S' THEN 'ENTER'"
			.. "\n    1.2. IF CORRECT, PRESS 'L' THEN 'A' THEN 'ENTER'"
			.. "\n    2. CHECK AGE"
			.. "\n    2.1 IF INCORRECT, PRESS 'K' THEN 'S' THEN 'ENTER'"
			.. "\n    2.2 IF CORRECT, PRESS 'L' THEN 'A' THEN 'ENTER'",
		font,
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2
	)

	if check_age() == false then
		wrong_age = true
	end
	if check_name_sex() == false then
		wrong_name_sex = true
	end

	if approved == true and denied == true then
		incorrect()
	end

	if -- INCORRECT
		not (
			(check_age() == true and check_name_sex() == true and approved == true and denied == false)
			or (
				(
					(check_age() == false or check_name_sex == false)
					or (check_age() == false or check_name_sex() == false)
				)
				and denied == true
				and approved == false
			)
		) and once == true
	then
		-- if -- INCORRECT
		-- 	(
		-- 		((check_age() == false or check_name_sex == false) or (check_name_sex() == false and check_age() == false))
		-- 		and approved == true
		-- 		and denied == false
		-- 	) and once == true
		-- then
		if wrong_name_sex then
			bad_name_sex()
		end
		if wrong_age then
			bad_age()
		end

		incorrect()
	end

	if -- CORRECT
		(
			(check_age() == true and check_name_sex() == true and approved == true and denied == false)
			or (
				(
					(check_age() == false or check_name_sex == false)
					or (check_age() == false or check_name_sex() == false)
				)
				and denied == true
				and approved == false
			)
		) and once == true
	then
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("LOG:", font, 0, 0)
		if wrong_name_sex then
			bad_name_sex()
		end
		if wrong_age then
			bad_age()
		end
		correct()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "r" then
		loop()
	end
	if key == "f5" then
		love.event.quit("restart")
	end
	if key == "a" then
		approved = true
	end
	if key == "l" then
		approved = false
	end
	if key == "s" then
		denied = true
	end
	if key == "k" then
		denied = false
	end
	if key == "return" then
		once = true
	end

	if key == "f11" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
end

function check_name_sex()
	if sex == "male" and table_contains(male, name) then
		return true
	elseif sex == "female" and table_contains(female, name) then
		return true
	else
		if table_contains(female, name) then
			name_s = "female"
		elseif table_contains(male, name) then
			name_s = "male"
		end

		return false
	end
end

function check_age()
	if age < 16 then
		return false
	end
	return true
end

function bad_name_sex()
	love.graphics.setColor(1, 0, 0)
	love.graphics.print(
		"\nERROR: PASSPORT FORGED" .. "\nDETAILS:" .. "\nSEX: " .. sex .. "\nNAME: " .. name .. "\nNAME SEX: " .. name_s,
		font,
		0,
		0
	)
end

function bad_age()
	love.graphics.setColor(1, 0, 0)
	love.graphics.print(
		"\nERROR: PASSPORT FORGED" .. "\nDETAILS:" .. "\nMIN PASSPORT AGE: 16" .. "\nAGE: " .. age,
		font,
		0,
		love.graphics.getHeight() / 2
	)
end

function all()
	check_name_sex()
	check_age()
end

function correct()
	love.graphics.setColor(0, 1, 0)
	love.graphics.rectangle(
		"fill",
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2,
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2
	)

	love.graphics.setColor(1, 1, 1)
	love.graphics.print(
		"CORRECT!\nPRESS 'R' TO RESTART",
		font,
		love.graphics.getWidth() / 2 + 1,
		love.graphics.getHeight() / 2 + 1
	)
end

function incorrect()
	love.graphics.setColor(1, 0, 0)
	love.graphics.rectangle(
		"fill",
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2,
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2
	)

	love.graphics.setColor(1, 1, 1)
	love.graphics.print(
		"INCORRECT!\nPRESS 'R' TO RESTART",
		font,
		love.graphics.getWidth() / 2 + 1,
		love.graphics.getHeight() / 2 + 1
	)
end
