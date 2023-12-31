local Utils = {}

local RegisteredHooks = {}

Utils.ModName = "FreeMobility"
Utils.ModAuthor = "seekerted"
Utils.ModVer = "1.0.1"

function Utils.Log(Format, ...)
	print(string.format("[%s-%s] %s\n", Utils.ModAuthor, Utils.ModName, string.format(Format, ...)))
end

function Utils.RegisterHookOnce(FunctionName, Function)
	if not RegisteredHooks[FunctionName] then
		RegisteredHooks[FunctionName] = true
		RegisterHook(FunctionName, Function)
	end
end

function Utils.TestFunc(FunctionName)
	Utils.RegisterHookOnce(FunctionName, function()
		Utils.Log(string.format("CALLED: %s", FunctionName))
	end)
end

return Utils