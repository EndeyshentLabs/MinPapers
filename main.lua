require("utils")
require("names")
require("country")

--[[
	Palette:
	HEX      NAME
	#292023  BG
	#ff3139  LIGHT RED
	#861322  DARK RED
	#c7e995  LIGHT GREEN
	#7c9e83  FOREST GREEN
]]
--

local font = nil
local music_filepath = "test01.ogg"
local music = nil

-- Constants
local MAX_AGE = 80
local MIN_PASSPORT_AGE = 16

-- NOTE: impossible values
local name = "POGLIN"
local age = -11037
local country = "Luare"
local nation = "Luarean"
local sex = "femboy"
local real_sex = nil

local denied = false
local approved = false
local once = false

local wrong_age = false
local wrong_name_sex = false

local help_mode = true

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

  age = math.random(MAX_AGE)
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

  if false --[[isDebug()]] then
    music = love.audio.newSource(music_filepath, "static")
    music:setLooping(true)

    love.audio.play(music)
  end

  loop()
end

function love.draw()
  local third = love.graphics.getWidth() / 3

  setColorHEX("#7c9e83")
  love.graphics.rectangle("fill", 0, 0, third, love.graphics.getHeight())
  setColorHEX("#292023")
  love.graphics.rectangle("fill", third, 0, love.graphics.getWidth(), love.graphics.getHeight())

  setColorHEX("#c7e995")
  love.graphics.print((
    "PASSPORT" ..
    "\n    NAME: %s" ..
    "\n    AGE: %d" ..
    "\n    COUNTRY: %s" ..
    "\n    NATION: %s" ..
    "\n    SEX: %s"
    ):format(name, age, country, nation, sex),
    font, third, 0
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

  -- CORRECT
  if
      (
      (check_age() == true and check_name_sex() == true and approved == true and denied == false)
      or (
      (
      (check_age() == false or check_name_sex() == false)
      or (check_age() == false and check_name_sex() == false)
      )
      and denied == true
      and approved == false
      )
      ) and once == true
  then
    wrong()
    correct()

    -- INCORRECT
  elseif
      not (
      (check_age() == true and check_name_sex() == true and approved == true and denied == false)
      or (
      (
      (check_age() == false or check_name_sex() == false)
      or (check_age() == false and check_name_sex() == false)
      )
      and denied == true
      and approved == false
      )
      ) and once == true
  then
    wrong()
    if wrong_name_sex then
      bad_name_sex()
    end
    if wrong_age then
      bad_age()
    end

    incorrect()
  end

  if help_mode then
    setColorHEX("#292023")
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    setColorHEX("#c7e995")
    love.graphics.print(
      "RULES:"
      .. "\n    MIN PASSPORT AGE: " .. MIN_PASSPORT_AGE
      .. "\n    NATION and COUNTRY: ZOCH"
      -- .. "\n    FOREIGNERS MUST PROVIDE A VALID VISA" -- TODO: New countries and nations <12-03-23, EndeyshentLabs> --
      .. "\n    ONLY ONE APPROVAL STATE AT ONCE"
      .. "\nCONTROLS:"
      .. "\n    'A' - APPROVE"
      .. "\n    'S' - DENY"
      .. "\n    'L' - CLEAR APPROVE"
      .. "\n    'K' - CLEAR DENY"
      .. "\n    'ENTER' - CONFIRM"
      .. "\n    'R' - RESTART"
      .. "\n    'F5' - RELOAD THE GAME"
      .. "\nHOW TO PLAY:"
      .. "\n    1. CHECK NAME AND SEX"
      .. "\n    1.1. IF INCORRECT, PRESS 'L' THEN 'S' THEN 'ENTER'"
      .. "\n    2. CHECK AGE"
      .. "\n    2.1 IF INCORRECT, PRESS 'L' THEN 'S' THEN 'ENTER'"
      .. "\n    3. IF ALL IS CORRECT PRESS 'K' THEN 'A' THEN 'ENTER'",
      font,
      0,
      0
    )
  end

  setColorHEX("#c7e995")
  love.graphics.print(
    "F1 - TOGGLE HELP",
    font,
    third * 2,
    0
  )
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
  if key == "a" and once == false then
    approved = true
  end
  if key == "l" and once == false then
    approved = false
  end
  if key == "s" and once == false then
    denied = true
  end
  if key == "k" and once == false then
    denied = false
  end
  if key == "return" and not help_mode then
    once = true
  end
  if key == "f1" then
    help_mode = not help_mode
  end

  if key == "f11" then
    love.window.setFullscreen(not love.window.getFullscreen())
  end

  if key == "f10" and music then
    love.audio.stop(music)
  end
  if key == "f9" and music and music:isPlaying() == false then
    love.audio.play(music)
  end
end

function check_name_sex()
  if sex == "male" and table_contains(male, name) then
    return true
  elseif sex == "female" and table_contains(female, name) then
    return true
  else
    if table_contains(female, name) then
      real_sex = "female"
    elseif table_contains(male, name) then
      real_sex = "male"
    end

    return false
  end
end

function check_age()
  if age < MIN_PASSPORT_AGE then
    return false
  end
  return true
end

function bad_name_sex()
  setColorHEX("#861322")
  love.graphics.print(
    ("\nERROR: PASSPORT FORGED"
    .. "\nDETAILS:"
    .. "\n    SEX: %s"
    .. "\n    NAME: %s"
    .. "\n    REAL SEX: %s"):format(sex, name, real_sex),
    font,
    0,
    0
  )
end

function bad_age()
  setColorHEX("#861322")
  love.graphics.print(
    ("\n\n\n\n\n" -- NOTE: 6 new lines coz bad_name_sex() takes 5 lines
    .. "\nERROR: PASSPORT FORGED"
    .. "\nDETAILS:"
    .. "\n    MIN PASSPORT AGE: "
    .. "\n    ACTUAL AGE: "):format(MIN_PASSPORT_AGE, age),
    font,
    0,
    0
  )
end

function bad_nation() -- germans in ww2 be like
  setColorHEX("#861322")
  love.graphics.print(
    ("\n\n\n\n\n\n\n\n\n" -- NOTE: see line 281
    .. "\nERROR: PASSPORT FORGED"
    .. "\nDETAILS:"
    .. "\n    COUNTRY: %s"
    .. "\n    NATION: %s"):format(country, nation),
    font,
    0,
    0
  )
end

function correct()
  setColorHEX("#7c9e83")
  love.graphics.rectangle(
    "fill",
    love.graphics.getWidth() / 2,
    love.graphics.getHeight() / 2,
    love.graphics.getWidth() / 2,
    love.graphics.getHeight() / 2
  )

  setColorHEX("#292023")
  love.graphics.print(
    "CORRECT!\nPRESS 'R' TO RESTART",
    font,
    love.graphics.getWidth() / 2 + 1,
    love.graphics.getHeight() / 2 + 1
  )
end

function incorrect()
  setColorHEX("#ff3139")
  love.graphics.rectangle(
    "fill",
    love.graphics.getWidth() / 2,
    love.graphics.getHeight() / 2,
    love.graphics.getWidth() / 2,
    love.graphics.getHeight() / 2
  )

  setColorHEX("#292023")
  love.graphics.print(
    "INCORRECT!\nPRESS 'R' TO RESTART",
    font,
    love.graphics.getWidth() / 2 + 1,
    love.graphics.getHeight() / 2 + 1
  )
end

function wrong()
  setColorHEX("#292023")
  love.graphics.print("WHAT WAS WRONG HERE:", font, 0, 0)
  if wrong_name_sex then
    bad_name_sex()
  end
  if wrong_age then
    bad_age()
  end
end
