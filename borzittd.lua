
local BorziTTD = LibStub("AceAddon-3.0"):NewAddon("BorziTTD", "AceEvent-3.0", "AceConsole-3.0")

--[[ The defaults a user without a profile will get. ]]--
local defaults = {
	profile={
		settings = {
			enable = true,
			text = "TTD: ",
			refresh = "0.1",
		},
		position = {
			arg1 = "CENTER",
			arg2 = "CENTER",
			arg3 = "0",
			arg4 = "0",
		}
	}
}

--[[ BorziTTD Initialize ]]--
function BorziTTD:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BorziTTDDB", defaults, true)
	
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileReset")
	self.db.RegisterCallback(self, "OnNewProfile", "OnNewProfile")
	
	self:SetupOptions()
end

function BorziTTD:OnEnable()
	print("|cffc41f3bBorzi TTD|r: |cffffff00/Borzittd|r for GUI menu")
end

function BorziTTD:OnProfileChanged(event, db)
 	self.db.profile = db.profile
end

function BorziTTD:OnProfileReset(event, db)
	for k, v in pairs(defaults) do
		db.profile[k] = v
	end
	self.db.profile = db.profile
end

function BorziTTD:OnNewProfile(event, db)
	for k, v in pairs(defaults) do
		db.profile[k] = v
	end
end

Borzi = {}
-- Time to Die
function Borzi.round2(num, idp)
  mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function Borzi.ttd(unit)
	unit = unit or "target";
	if thpcurr == nil then
		thpcurr = 0
	end
	if thpstart == nil then
		thpstart = 0
	end
	if timestart == nil then
		timestart = 0
	end
	if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
		if currtar ~= UnitGUID(unit) then
			priortar = currtar
			currtar = UnitGUID(unit)
		end
		if thpstart==0 and timestart==0 then
			thpstart = UnitHealth(unit)
			timestart = GetTime()
		else
			thpcurr = UnitHealth(unit)
			timecurr = GetTime()
			if thpcurr >= thpstart then
				thpstart = thpcurr
				timeToDie = 0
			else
				if ((timecurr - timestart)==0) or ((thpstart - thpcurr)==0) then
					timeToDie = 0
				else
					timeToDie = Borzi.round2(thpcurr/((thpstart - thpcurr) / (timecurr - timestart)),2) -- Может быть, взять десятичные дроби?
				end
			end
		end
	elseif not UnitExists(unit) or currtar ~= UnitGUID(unit) then
		currtar = 0 
		priortar = 0
		thpstart = 0
		timestart = 0
		timeToDie = 0
	end
	if timeToDie==nil then
		return 0
	else
		return timeToDie
	end
end	

local setttd = 0
local RotationText = 0
local ttdype = CreateFrame("Frame", "ttd indicator", UIParent)
local ttdtext = ttdype:CreateFontString("MyttdypeText", "OVERLAY")
local OneTimeBorzi = nil
local event = function()
	local position = BorziTTD.db.profile.position
	if OneTimeBorzi == nil then
	ttdype:SetWidth(240)
	ttdype:SetHeight(40)
	ttdype:SetPoint(position.arg1, nil, position.arg2, position.arg3 , position.arg4) -- На основе чата?
	local tex = ttdype:CreateTexture("BACKGROUND")
	tex:SetAllPoints()
	tex:SetTexture(0, 0, 0); tex:SetAlpha(0.5)
	OneTimeBorzi = 1	
	end

	ttdtext:SetFontObject(GameFontNormalSmall)
	ttdtext:SetJustifyH("CENTER") -- 
	ttdtext:SetPoint("CENTER", ttdype, "CENTER", 0, 0) -- Всегда по центру / ALL Сохранить местоположение в переменной.
	ttdtext:SetFont("Fonts\\FRIZQT__.TTF", 20)
	ttdtext:SetShadowOffset(1, -1)
	ttdtext:SetText("Hello")

	local t = GetTime()
	ttdype:SetScript("OnUpdate", function() --если у вас возникли проблемы, поставьте задержку с помощью GetTime()
		--if t - GetTime() <= 0.2 then
			ttdtext:SetText(BorziTTD.db.profile.settings.text .. setttd)
			--t = GetTime()
--		end
	end)
   
	ttdype:SetMovable(true)
	ttdype:EnableMouse(true)
	ttdype:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" and not self.isMoving then
		self:StartMoving();
		self.isMoving = true;
		end
	end)
	ttdype:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and self.isMoving then
		local arg1,_,arg2, arg3, arg4 = ttdype:GetPoint()
		position.arg1 = tostring(arg1)
		position.arg2 = tostring(arg2)
		position.arg3 = tostring(arg3)
		position.arg4 = tostring(arg4)
		self:StopMovingOrSizing();
		self.isMoving = false;
	end
	end)
	ttdype:SetScript("OnHide", function(self)
	if ( self.isMoving ) then
		self:StopMovingOrSizing();
		self.isMoving = false;
	end
	end)
end

local total = 0
 
local function onUpdate(self,elapsed)
    total = total + elapsed
    if total >= tonumber(BorziTTD.db.profile.settings.refresh) then
        setttd = Borzi.ttd("target")
        total = 0
    end
end
 
local f = CreateFrame("frame")
f:SetScript("OnUpdate", onUpdate)

ttdype:SetScript("OnEvent", event)
ttdype:RegisterEvent("PLAYER_LOGIN")
