-- MugisVolume
-- Based on the following addons
--    Volumetric - main idea (now abandoned)
--    DruidFormManaBar - code ideas + learning


-- variables which control the bar behavior
local height = 20          -- addon position
local width = 200
local pad = 2              -- pad out the background by this much
local fadeDelay = 1        -- wait this long before playing the fade animation
local fadeTime = 0.4       -- fade animation time
local screenPosY = -0.25   -- screen position from center, from 0.5 to -0.5

-- main addon frame
local frame = CreateFrame("StatusBar", "MugisVolume", UIParent)
MugisVolume = frame
mug = frame
frame:SetFrameStrata("TOOLTIP")
frame:SetSize(width + 2*pad, height + 2*pad)
local _, y = UIParent:GetSize();
frame:SetPoint("CENTER", 0, y * screenPosY)
frame:Hide()

-- background texture
local background = frame:CreateTexture(nil, "BACKGROUND")
background:SetAllPoints(frame)
background:SetSize(width + 2*pad, height + 2*pad)
background:SetColorTexture(0, 0, 0, 0.5)

-- volume bar foreground frame
local volBar = CreateFrame("StatusBar", nil, frame)
volBar:SetSize(width, height)
volBar:SetPoint("CENTER", frame, "CENTER")
volBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
volBar:SetStatusBarColor(0, 0, 1)
volBar:SetMinMaxValues(0, 1)  -- max volume is 1, min 0

-- fade out animation
local animGroup = frame:CreateAnimationGroup()
local anim = animGroup:CreateAnimation("Alpha")
-- anim:SetTarget(frame)
anim:SetFromAlpha(1)
anim:SetToAlpha(0)
anim:SetDuration(fadeTime)
anim:SetStartDelay(fadeDelay)
anim:SetSmoothing("OUT")
animGroup:HookScript("OnFinished", function()
	frame:Hide()
end)

-- volume up/down behavior
function frame:UpdateVolume(volume)
	volBar:SetValue(volume)
	-- show the frame and reset the animation
	frame:Show()
	animGroup:Stop()
	animGroup:Play()
end

-- register onload events
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
function frame:Init()
	-- initialize bar with current volume
	volBar:SetValue(GetCVar("Sound_MasterVolume"))
	-- add CVar watcher function for the Master Volume
	hooksecurefunc("SetCVar", function(cvar, volume)
		if cvar == "Sound_MasterVolume" then
			frame:UpdateVolume(volume)
		end
	end)
end
frame:SetScript("OnEvent", frame.Init)
