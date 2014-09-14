-- Support for modules defined by Kethane
-- Kethane.rule.lua
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

--[[
Returns the set of all resources from a Kethane multi-resource config node.

Postcondition: if the resource "LFOX" is in the set, neither "LiquidFuel" nor "Oxidizer" 
	are present
Postcondition: if the resource "LFOX" is not in the set, at most one of "LiquidFuel" and 
	"Oxidizer" is present
--]]
function resourceSetKMulti(module, nodeName)
	local theSet = {}

	for node in nodesByName(module, nodeName) do
		for resource,rate in pairs(node.values) do
			theSet[resource] = true
		end
	end

	if theSet["LiquidFuel"] and theSet["Oxidizer"] then
		theSet["LFOX"]       = true
		theSet["LiquidFuel"] = nil
		theSet["Oxidizer"]   = nil
	end

	return theSet
end

--[[
Returns the set of all resources from a Kethane single-resource config node

Postcondition: if the resource "LFOX" is in the set, neither "LiquidFuel" nor "Oxidizer" 
	are present
Postcondition: if the resource "LFOX" is not in the set, at most one of "LiquidFuel" and 
	"Oxidizer" is present
--]]
function resourceSetKethane(module)
	local theSet = {}

	for node in nodesByName(module, "Resource") do
		if node.values.Name then
			theSet[node.values.Name] = true
		end
	end

	if theSet["LiquidFuel"] and theSet["Oxidizer"] then
		theSet["LFOX"]       = true
		theSet["LiquidFuel"] = nil
		theSet["Oxidizer"]   = nil
	end

	return theSet
end

for name,part in pairs(PARTS) do
	for converter in modulesByName(part, "KethaneConverter") do
		local  inlist = resourceSetKMulti(converter,  "InputRates")
		local outlist = resourceSetKMulti(converter, "OutputRatios")

		local generator = false
		for resource,_ in pairs(outlist) do
			if resource == "ElectricCharge" then
				generator = true
			end
		end

		if generator then
			-- Generator
			addToModCategory(part, "Utility/Generator", nil, nil, true)

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

			for resource,_ in pairs(inlist) do
				local name, icon = resourceLabel(resource)
				if not iconExists("Categories/Utility/Converter/In_" .. icon) then
					icon = "Misc"
				end
				addToModCategory(part, "Utility/Converter/Input/" .. name, nil, 
					"Categories/Utility/Converter/In_" .. icon, true)
			end
	
			for resource,_ in pairs(outlist) do
				local name, icon = resourceLabel(resource)
				if not iconExists("Categories/Utility/Converter/Out_" .. icon) then
					icon = "Misc"
				end
				addToModCategory(part, "Utility/Converter/Output/" .. name, nil, 
					"Categories/Utility/Converter/Out_" .. icon, true)
			end
		end	-- end converter
	end	-- end KethaneConverter loop

	for scanner in modulesByName(part, "KethaneDetector") do
		local targetlist = resourceSetKethane(scanner)

		addToModCategory(part, "Science/Survey", nil, nil, true)

		for resource,_ in pairs(targetlist) do
			local name, icon = resourceLabel(resource)
			addToModCategory(part, "Science/Survey/" .. name, nil, nil, true)
		end
	end	-- end KethaneDetector loop

	for extractor in modulesByName(part, "KethaneExtractor") do
		local outlist = resourceSetKethane(extractor)

		addToModCategory(part, "Utility/Mining", nil, nil, true)

		for resource,_ in pairs(outlist) do
			local name, icon = resourceLabel(resource)
			addToModCategory(part, "Utility/Mining/" .. name, nil, nil, true)
		end
	end	-- end KethaneExtractor loop

	if containsModule(part, "KethaneGenerator") then
		local name, icon = resourceLabel("Kethane")
		if not iconExists("Categories/Utility/Generator/" .. icon) then
			icon = "Misc"
		end
		addToModCategory(part, "Utility/Generator/" .. name, nil, 
			"Categories/Utility/Generator/" .. icon, true)
	end	-- end KethaneGenerator block

	if containsModule(part, "KethaneKerbalBlender") then
		local name, icon = resourceLabel("Kethane")
		if not iconExists("Categories/Utility/Converter/Out_" .. icon) then
			icon = "Misc"
		end
		addToModCategory(part, "Utility/Converter/Output/" .. name, nil, 
			"Categories/Utility/Converter/Out_" .. icon, true)
	end	-- end KethaneKerbalBlender block
end	-- end part loop
