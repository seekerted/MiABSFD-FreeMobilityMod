local Utils = require("utils")

Utils.Log("Starting Free Mobility Mod by Ted the Seeker")
Utils.Log(string.format("Version %s", Utils.ModVer))
Utils.Log(_VERSION)

local function DisableFallDamage(BP_Player_C)
	BP_Player_C.FallDamageScale = 0
end

-- Hook into BP_Player_C (hot-reload friendly)
local function HookBP_Player_C(New_BP_Player_C)
	if New_BP_Player_C:IsValid() then
		DisableFallDamage(New_BP_Player_C)
	else
		NotifyOnNewObject("/Script/MadeInAbyss.MIAPlayerBase", function(New_MIAPlayerBase)
			if New_MIAPlayerBase:IsValid() and "PersistentLevel" == New_MIAPlayerBase:GetOuter():GetFName():ToString() then
				HookBP_Player_C(New_MIAPlayerBase)
			end
		end)
	end
end
HookBP_Player_C(FindObject("BP_Player_C", "PersistentLevel"))