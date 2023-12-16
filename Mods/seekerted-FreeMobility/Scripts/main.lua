local Utils = require("utils")

Utils.Log("Starting Free Mobility Mod by Ted the Seeker")
Utils.Log(string.format("Version %s", Utils.ModVer))
Utils.Log(_VERSION)

-- Right now the jump mobility is to just have a very high leap with no limits. However this is a bit inconvenient.
-- TODO: Turn into infinite jump instead.
local function MakeJumpsFaster(MIACharacterMovementComponent)
	MIACharacterMovementComponent.JumpZVelocity = 1200

	Utils.Log("Jump velocity made faster.")
end

local function MakeJumpsLimitless(BP_Player_C)
	BP_Player_C.JumpMaxHoldTime = 1000

	Utils.Log("Jump height made limitless.")
end

local function DisableFallDamage(BP_Player_C)
	BP_Player_C.FallDamageScale = 0

	Utils.Log("Disabled fall damage.")
end

-- Doesn't totally disable, but simply removes the delay of stamina recovery. So in-game the stamina bar instantly
-- refills itself.
local function DisableStaminaDecrease(MIAPlayerStaminaParamSet)
	MIAPlayerStaminaParamSet.RechargeDelayTime = 0

	Utils.Log("Disabled stamina decrease.")
end

local function DisableHungerDecrease(MIACharaStatusSetting)
	local SatietySubtractions = MIACharaStatusSetting.SatietySubtractions

	-- SatietySubtractions is an array containing how much hunger is decreased depending on action. Simply set all of
	-- them to 0. Not sure how Value and BaseValue are related, but setting them both to 0 does the trick.
	SatietySubtractions:ForEach(function(_, elem)
		elem:get().Value = 0
		elem:get().BaseValue = 0
	end)

	Utils.Log("Disabled hunger decrease.")
end

local function DisableCurseEffect(MIACharaStatusSetting)
	local RisingLoadSettings = MIACharaStatusSetting.RisingLoadSettings

	-- Assumption: RisingLoadSettings is a 5-element array containing various values for each layer?
	-- Setting all RisingLoadValues to 0 seem to do the trick.
	RisingLoadSettings:ForEach(function(_, elem)
		elem:get().RisingLoadValue = 0
	end)

	Utils.Log("Disabled the Abyss Curse.")
end

-- Get the right objects to manipulate upon Player load.
local function BP_Player_C__OnLoaded_3EA1(Param_BP_Player_C)
	local BP_Player_C = Param_BP_Player_C:get()

	DisableFallDamage(BP_Player_C)
	MakeJumpsLimitless(BP_Player_C)

	local MIACharacterMovementComponent = BP_Player_C.CharacterMovement
	if MIACharacterMovementComponent:IsValid() then
		MakeJumpsFaster(MIACharacterMovementComponent)
	end
end

-- Hook into BP_Player_C (hot-reload friendly)
local function HookBP_Player_C(New_BP_Player_C)
	if New_BP_Player_C:IsValid() then
		Utils.RegisterHookOnce("/Game/MadeInAbyss/Core/Characters/Player/BP_Player.BP_Player_C:OnLoaded_3EA1D4484C94D6D6E39F31AD554C4A7A",
				BP_Player_C__OnLoaded_3EA1)
	else
		NotifyOnNewObject("/Script/MadeInAbyss.MIAPlayerBase", function(New_MIAPlayerBase)
			if New_MIAPlayerBase:IsValid() and "PersistentLevel" == New_MIAPlayerBase:GetOuter():GetFName():ToString() then
				HookBP_Player_C(New_MIAPlayerBase)
			end
		end)
	end
end
HookBP_Player_C(FindObject("BP_Player_C", "PersistentLevel"))

-- Hook into BP_MIAGameInstance_C instance (hot-reload friendly)
local function HookMIAGameInstance(New_MIAGameInstance)
	if New_MIAGameInstance:IsValid() then
		-- MIAGameInstance has been found

		local MIACharaStatusSetting = FindObject("MIACharaStatusSetting", "BP_CharaStatusSetting")

		if MIACharaStatusSetting:IsValid() then
			DisableCurseEffect(MIACharaStatusSetting)
			DisableHungerDecrease(MIACharaStatusSetting)
		end

		local MIAPlayerStaminaParamSet = FindObject("MIAPlayerStaminaParamSet", "StaminaParam_Player")

		if MIAPlayerStaminaParamSet:IsValid() then
			DisableStaminaDecrease(MIAPlayerStaminaParamSet)
		end
	else
		NotifyOnNewObject("/Script/MadeInAbyss.MIAGameInstance", HookMIAGameInstance)
	end
end
HookMIAGameInstance(FindFirstOf("MIAGameInstance"))