-- Support for modules defined by Modular Kolonization System 0.21
-- MKS.rule.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified July 6, 2014

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
	for converter in modulesByName(part, "KolonyConverter") do
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
	end	-- end KolonyConverter loop

	for transmitter in modulesByName(part, "ProxyLogistics") do
		addToModCategory(part, "Utility/Logistics", nil, "Categories/Science/Antenna", true)
		local range = transmitter.values.LogisticsRange .. " m"
		addToModCategory(part, "Utility/Logistics/" .. range)
	end

	if containsModule(part, "MKSModule") then
		addToModCategory(part, "Utility/MKS Crew Space")
	end

	if containsModule(part, "MKSLcentral") then
		addToModCategory(part, "Utility/Logistics", nil, "Categories/Science/Antenna", true)
		addToModCategory(part, "Utility/Logistics/Orbital")
	end

	if (part.name:find("MKS") or part.name:find("OKS")) and part.title:lower():find("storage") then
		addToModCategory(part, "Storage", nil, nil, true)
		for resource in resources(part) do
			if( tonumber(resource.values.maxAmount) and tonumber(resource.values.maxAmount) > 0) then
				local name, icon = resourceLabel(resource.values.name)
				if icon == "ElectricCharge" then
					icon = "EC_Battery"
				end
				if not iconExists("Categories/Storage/" .. icon) then
					icon = "Misc"
				end
				-- is there REALLY a point to making the categories so complicated???
				if name == "Rocket Fuel" or name == "LiquidFuel" or name == "Oxidizer" then
					addToModCategory(part, "Storage/" .. name, nil, 
						"Categories/Storage/" .. icon, true)
				elseif name == MonoPropellant or name == "ElectricCharge" or name == "XenonGas" 
						or name == "Kethane" or name == "kIntakeAir" then
					addToModCategory(part, "Storage/_" .. name, nil, 
						"Categories/Storage/" .. icon, true)
				else
					addToModCategory(part, "Storage/Misc", nil, nil, true)
					addToModCategory(part, "Storage/Misc/_" .. name, name, 
						"Categories/Storage/" .. icon, true)
				end
			end
		end
	end	-- end storage part branch

	-- no idea why these parts are in Utility
	if part.name == "MKS.DockingHub" or part.name == "MKS.TubeHub" or part.name == "OKS.Hub" then
		addToModCategory(part, "Structural/Misc")
	end

	if part.name == "MKS.DockingTube" or part.name == "MKS.RigidTube" or part.name:find("MKS.ExpandoTube") or part.name == "OKS.Tube"  then
		addToModCategory(part, "Structural/Misc")
	end

	if part.name:find("MKS.RadialPort") then
		addToModCategory(part, "Structural/Misc")
	end

	if part.name:find("OKS.Cap") then
		addToModCategory(part, "Structural/Misc")
	end
end	-- end part loop
