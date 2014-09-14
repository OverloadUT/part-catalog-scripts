-- Support for modules defined by Open Resource System
-- ORS.rule.lua
-- by Starstrider42
-- Created June 18, 2014
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

--[[
Returns the set of all resources from an ORS single-resource config node

Postcondition: if the resource "LFOX" is in the set, neither "LiquidFuel" nor "Oxidizer" 
	are present
Postcondition: if the resource "LFOX" is not in the set, at most one of "LiquidFuel" and 
	"Oxidizer" is present
--]]
function resourceSetORS(module)
	local theSet = {}

	if module.values.resourceName then
		theSet[module.values.resourceName] = true
	end

	if theSet["LiquidFuel"] and theSet["Oxidizer"] then
		theSet["LFOX"]       = true
		theSet["LiquidFuel"] = nil
		theSet["Oxidizer"]   = nil
	end

	return theSet
end

for name,part in pairs(PARTS) do
	for scanner in modulesByName(part, "ORSResourceScanner") do
		local targetlist = resourceSetORS(scanner)

		addToModCategory(part, "Science/Survey", nil, nil, true)

		for resource,_ in pairs(targetlist) do
			local name, icon = resourceLabel(resource)
			addToModCategory(part, "Science/Survey/" .. name, nil, nil, true)
		end
	end	-- end ORSResourceScanner loop

	for extractor in modulesByName(part, "ORSModuleResourceExtraction") do
		local outlist = resourceSetORS(extractor)

		addToModCategory(part, "Utility/Mining", nil, nil, true)

		for resource,_ in pairs(outlist) do
			local name, icon = resourceLabel(resource)
			addToModCategory(part, "Utility/Mining/" .. name, nil, nil, true)
		end
	end	-- end ORSModuleResourceExtraction loop

end	-- end part loop
