-- Support for modules defined by Extraplanetary Launchpads
-- Extraplanetary.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified July 2, 2014

-- Manual include of resource library for now
function resourceLabel (resourceName)
	local name, icon
	
	name = resourceName
	if resourceName == "LFOX" then
		name = "Rocket Fuel"
		icon = resourceName
	elseif resourceName == "ArgonGas" then
		icon = "Argon"
	elseif resourceName == "LiquidHydrogen" then
		icon = "LH2"
	elseif resourceName == "XenonGas" then
		icon = "Xenon"
	elseif resourceName == "KIntakeAir" then
		icon = "Kethane"
	elseif resourceName == "StoredCharge" then
		icon = "ElectricCharge"
	else
		icon = resourceName
	end

	return name, icon
end

for name,part in pairs(PARTS) do
	if containsModule(part, "ExLaunchPad") then
		addToModCategory(part, "Utility/Construction")
	end

	if containsModule(part, "ExWorkshop") and part.crewCapacity ~= "0" then
		addToModCategory(part, "Utility/Construction")
	end

	if containsModule(part, "ExRecycler") then
		local name, icon = resourceLabel("Metal")
		if not iconExists("Categories/Utility/Converter/Out_" .. icon) then
			icon = "Misc"
		end
		addToModCategory(part, "Utility/Converter/Output/" .. name, nil, 
			"Categories/Utility/Converter/Out_" .. icon, true)
	end
end	-- end part loop
