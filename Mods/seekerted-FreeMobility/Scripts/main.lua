local Utils = require("utils")

Utils.Init("seekerted", "FreeMobility", "1.0.1")

-- Given a GameplayTagContainer, add new GameplayTag by manually appending to FGameplayTagContainer.GameplayTags first,
-- and then to FGameplayTagContainer.ParentTags (if able).
local function AddOnGameplayTagContainer(GameplayTagContainer, GameplayTag)
	if not GameplayTagContainer:IsValid() then
		Utils.Log("GameplayTagContainer is not valid")
		return
	else
		Utils.Log("Adding new tag \"%s\" to %s", GameplayTag, GameplayTagContainer:GetFullName())
	end

	local Tags = GameplayTagContainer.GameplayTags
	if not Tags:IsValid() then
		Utils.Log("No valid GameplayTags")
		return
	end

	local TagsLength = Tags:GetArrayNum()

	Utils.Log("Count: %d, max: %d", TagsLength, Tags:GetArrayMax())

	if TagsLength + 1 > Tags:GetArrayMax() then
		Utils.Log("Unable to add any more GameplayTags")
		return
	end

	Tags[TagsLength + 2].TagName = FName("")
	Tags[TagsLength + 1].TagName = FName(GameplayTag)
	Utils.Log("Added \"%s\" to GameplayTags", GameplayTag)

	if not string.find(GameplayTag, "%.") then
		Utils.Log("No need to add parent tags for \"%s\"", GameplayTag)
	end

	local ParentTags = GameplayTagContainer.ParentTags
	if not ParentTags:IsValid() then
		Utils.Log("No valid ParentTags", GameplayTagContainer:GetFullName())
		return
	else
		Utils.Log("Adding parent tags")
	end

	local ParentTagsLength = ParentTags:GetArrayNum()

	Utils.Log("Count: %d, max: %d", ParentTagsLength, ParentTags:GetArrayMax())

	if ParentTagsLength + 1 > ParentTags:GetArrayMax() then
		Utils.Log("Unable to add any more ParentTags")
		return
	end

	-- Guess the parent tag by removing the last token from GameplayTag delimited by .
	local GameplayTagParent = GameplayTag:gsub(".[^.]*$", "")

	ParentTags[ParentTagsLength + 2].TagName = FName("")
	ParentTags[ParentTagsLength + 1].TagName = FName(GameplayTagParent)
	Utils.Log("Added \"%s\" to ParentTags", GameplayTagParent)
end

-- Player's states prevent infinite jumping by blocking GA_Player_JumpStart_C from starting when the player currently
-- has the abilities of GA_Player_JumpStart_C or GA_Player_JumpLoop_C. This adds "State.Jumping.Start" to their list of
-- tags to exclude from the block, allowing it to start.
local function UnblockJumpStart()
	local GA_Player_JumpStart_C = StaticFindObject("/Game/MadeInAbyss/Core/Abilities/GA_Player_JumpStart.Default__GA_Player_JumpStart_C")
	if not GA_Player_JumpStart_C:IsValid() then
		Utils.Log("GA_Player_JumpStart_C is not found.")
		return
	end

	AddOnGameplayTagContainer(GA_Player_JumpStart_C.ExcludeBlockAbilitiesWithTag, "State.Jumping.Start")

	local GA_Player_JumpLoop_C = StaticFindObject("/Game/MadeInAbyss/Core/Abilities/GA_Player_JumpLoop.Default__GA_Player_JumpLoop_C")
	if not GA_Player_JumpLoop_C:IsValid() then
		Utils.Log("GA_Player_JumpLoop_C is not found.")
		return
	end

	AddOnGameplayTagContainer(GA_Player_JumpLoop_C.ExcludeBlockAbilitiesWithTag, "State.Jumping.Start")

	Utils.Log("Unblocked jump start.")
end

local function MakeJumpsInfinite(BP_Player_C)
	BP_Player_C.JumpMaxCount = 1337
	BP_Player_C.JumpMaxHoldTime = 100

	Utils.Log("Made jumps infinite.")
end

local function MakeJumpsFaster(MIACharacterMovementComponent)
	MIACharacterMovementComponent.JumpZVelocity = 1200

	Utils.Log("Made jumps faster.")
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
	MakeJumpsInfinite(BP_Player_C)

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

		UnblockJumpStart()
	else
		NotifyOnNewObject("/Script/MadeInAbyss.MIAGameInstance", HookMIAGameInstance)
	end
end
HookMIAGameInstance(FindFirstOf("MIAGameInstance"))