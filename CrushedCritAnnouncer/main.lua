-- Sources used: 
-- https://www.wowinterface.com/forums/showthread.php?t=56143
-- https://wowpedia.fandom.com/wiki/COMBAT_LOG_EVENT

local playerGUID = UnitGUID("player")
local name = UnitName("player");

print(name)
local f1 = CreateFrame("Frame",nil,UIParent)
f1:SetWidth(1)
f1:SetHeight(1)
f1:SetAlpha(.50);
f1:SetPoint("CENTER",-140,-340)
f1.text = f1:CreateFontString(nil,"ARTWORK")
f1.text:SetFont("Fonts\\ARIALN.ttf", 20, "OUTLINE")
f1.text:SetPoint("LEFT",0,0)
f1:Hide()

local function displayupdate(show, message)
    if show == 1 then
        f1.text:SetText(message)
        f1:Show()
    else
        f1:Hide()
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
	self:COMBAT_LOG_EVENT_UNFILTERED(CombatLogGetCurrentEventInfo())
end)

function f:COMBAT_LOG_EVENT_UNFILTERED(...)
    -- init all data from combat log
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

	if subevent == "SWING_DAMAGE" then
		amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	elseif subevent == "SPELL_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	end

    if crushing and (sourceGUID ~= playerGUID) and (name == destName) then
        local msg1 = "|cffff0000CRUSHED for " .. amount .. "|r by " .. sourceName
        displayupdate(1, msg1)
    end
    
    if critical and (sourceGUID ~= playerGUID) and (name == destName) then
        local msg2 = "|cffffff00CRITED for " .. amount .. "|r by " .. sourceName
        displayupdate(1, msg2)
    end
end
