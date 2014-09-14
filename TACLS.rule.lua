-- Support for modules defined by TAC Life Support
-- TACLS.rule.lua
-- by Starstrider42
-- Created June 16, 2014
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
Returns the set of all resources from a formatted string. Format gives the syntax for 
each substring that sets up one resource.

Precondition: format must capture exactly one substring, which is the resource name

Postcondition: if the resource "LFOX" is in the set, neither "LiquidFuel" nor "Oxidizer" 
	are present
Postcondition: if the resource "LFOX" is not in the set, at most one of "LiquidFuel" and 
	"Oxidizer" is present
--]]
function resourceSetString (resourceString, format)
	local theSet = {}

	local _, last, field = resourceString:find(format)
	while last do
		theSet[field] = true
		_, last, field = resourceString:find(format, last)
	end

	if theSet["LiquidFuel"] and theSet["Oxidizer"] then
		theSet["LFOX"]       = true
		theSet["LiquidFuel"] = nil
		theSet["Oxidizer"]   = nil
	end

	return theSet
end

for name,part in pairs(PARTS) do
	if containsModule(part, "LifeSupportModule") then	
		addToModCategory(part, "Utility/Life Support")
	end

	for converter in modulesByName(part, "TacGenericConverter") do
		if converter.values.outputResources:find("ElectricCharge") then
			-- Generator
			addToModCategory(part, "Utility/Generator", nil, nil, true)

			local inlist = resourceSetString(converter.values.inputResources, "([_%w]+),%s*[.%d]+")
			for resource,_ in pairs(inlist) do
				local name, icon = resourceLabel(resource)
				if not iconExists("Categories/Utility/Generator/" .. icon) then
					icon = "Misc"
				end
				addToModCategory(part, "Utility/Generator/" .. name, nil, 
					"Categories/Utility/Generator/" .. icon, true)
			end
		else
			-- Converter
			addToModCategory(part, "Utility/Converter", nil, nil, true)

			local inlist = resourceSetString(converter.values.inputResources, "([_%w]+),%s*[.%d]+")
			for resource,_ in pairs(inlist) do
				local name, icon = resourceLabel(resource)
				if not iconExists("Categories/Utility/Converter/In_" .. icon) then
					icon = "Misc"
				end
				addToModCategory(part, "Utility/Converter/Input/" .. name, nil, 
					"Categories/Utility/Converter/In_" .. icon, true)
			end
	
			local outlist = resourceSetString(converter.values.outputResources, "([_%w]+),%s*[.%d]+,%s*%w+")
			for resource,_ in pairs(outlist) do
				local name, icon = resourceLabel(resource)
				if not iconExists("Categories/Utility/Converter/Out_" .. icon) then
					icon = "Misc"
				end
				addToModCategory(part, "Utility/Converter/Output/" .. name, nil, 
					"Categories/Utility/Converter/Out_" .. icon, true)
			end
		end	-- end converter
	end	-- end TacGenericConverter loop
end	-- end part loop
