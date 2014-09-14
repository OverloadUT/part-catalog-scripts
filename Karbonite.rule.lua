-- Support for modules defined by Karbonite
-- Karbonite.rule.lua
-- by Starstrider42
-- Created September 13, 2014
-- Last modified September 13, 2014

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
Returns the set of all resources from an Karbonite single-resource config node

Postcondition: if the resource "LFOX" is in the set, neither "LiquidFuel" nor "Oxidizer" 
	are present
Postcondition: if the resource "LFOX" is not in the set, at most one of "LiquidFuel" and 
	"Oxidizer" is present
--]]
function resourceSetKarbonite(module)
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
	for extractor in modulesByName(part, "ORSModuleRailsExtraction") do
		local outlist = resourceSetKarbonite(extractor)

		addToModCategory(part, "Utility/Mining", nil, nil, true)

		for resource,_ in pairs(outlist) do
			local name, icon = resourceLabel(resource)
			addToModCategory(part, "Utility/Mining/" .. name, nil, nil, true)
		end
	end	-- end KarboniteModuleResourceExtraction loop

	for converter in modulesByName(part, "USI_Converter") do
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
	end	-- end USI_Converter loop

	if containsModule(part, "KarboniteAtmoExtractor") or containsModule(part, "KarboniteParticleExtractor") then
		addToModCategory(part, "Utility/Mining", nil, nil, true)

		local name, icon = resourceLabel("Karbonite")
		addToModCategory(part, "Utility/Mining/" .. name, nil, nil, true)
	end

	if containsModule(part, "KarboniteGenerator") then
		local name, icon = resourceLabel("Karbonite")
		if not iconExists("Categories/Utility/Generator/" .. icon) then
			icon = "Misc"
		end
		addToModCategory(part, "Utility/Generator/" .. name, nil, 
			"Categories/Utility/Generator/" .. icon, true)
	end	-- end KarboniteGenerator block

	if containsModule(part, "ORSModuleAirIntake") or containsModule(part, ORSModuleAirScoop) then
		addToModCategory(part, "Aero/Intake/Misc")
	end

end	-- end part loop
