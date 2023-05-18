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
