-- Support for modules defined by Near Future packs
-- NearFuture.rule.lua
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
	-- Construction
	-- The SM-series couplers don't get recognized by default.rule.lua, but I can't follow the logic yet

	-- Electrical
	if containsModule(part, "FissionReprocessor") then
		addToModCategory(part, "Utility/Converter", nil, nil, true)

		local name, icon = resourceLabel("DepletedUranium")
		if not iconExists("Categories/Utility/Converter/In_" .. icon) then
			icon = "Misc"
		end
		addToModCategory(part, "Utility/Converter/Input/" .. name, nil, 
			"Categories/Utility/Converter/In_" .. icon, true)
		name, icon = resourceLabel("EnrichedUranium")
		if not iconExists("Categories/Utility/Converter/Out_" .. icon) then
			icon = "Misc"
		end
		addToModCategory(part, "Utility/Converter/Output/" .. name, nil, 
			"Categories/Utility/Converter/Out_" .. icon, true)
	end
	if containsModule(part, "FissionGenerator") then
		addToModCategory(part, "Utility/Generator/Fission", nil, "Categories/Utility/Generator/Nuc")
	end

	-- Propulsion
	for engine in modulesByName(part, {"ModuleEngines", "ModuleEnginesFX"}) do
		if containsNodeTypeName(engine, "PROPELLANT", "ElectricCharge") then
			-- BEWARE: not all energy-demanding engines need be ion-based
			-- 	Check for a known ion fuel first
			function makeIonEngine(reactionMass)
				if containsNodeTypeName(engine, "PROPELLANT", reactionMass) then
					local name, icon = resourceLabel(reactionMass)
					local regex = string.match(name, '(.+)Gas')
					if regex ~= nil then
						name = regex
					end
					addToModCategory(part, "Engine/Ion", nil, nil, true)
					if iconExists("Categories/Engine/Ion_" .. icon) then
						addToModCategory(part, "Engine/Ion/" .. name, nil, 
							"Categories/Engine/Ion_" .. icon)
					else
						addToModCategory(part, "Engine/Ion/" .. name, nil, 
							"Categories/Engine/Ion")
					end
				end
			end
			makeIonEngine("XenonGas")
			makeIonEngine("ArgonGas")
			makeIonEngine("LiquidHydrogen")
		end
	end
	if containsModule(part, "VariableISPEngine") then
		addToModCategory(part, "Engine/MultiMode")
	end

	-- Solar
	for panel in modulesByName(part, "ModuleCurvedSolarPanel") do
--		if panel.values.sunTracking == "false" then
			addToModCategory(part, "Utility/SolarPanel/Static")
--		else			
--			addToModCategory(part, "Utility/SolarPanel/Deployable")
--		end
	end

	-- Spacecraft
	if part.name == "futuresm-engine" then
		addToModCategory(part, "Storage/LFOX")
	end
	if part.name == "futuresm-fueltank" then
		addToModCategory(part, "Storage/ServiceModule")
	end

end	-- end part loop
