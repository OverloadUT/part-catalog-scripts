-- Cleanup for parts defined by Modular Kolonization System 0.21
-- MKS.fallback.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified June 17, 2014

-- Manual include of utility library
function removeFromCategory(part, category)
	for _,child in pairs(category.children) do
		removeFromCategory(part, child)
	end
	if category.parts[part.name] then
		category.parts[part.name] = nil
	end
end

function removeFromPath(part, path)
	local cat = findCategory("All/" .. path, CATEGORIES)
	removeFromCategory(part, cat)
	cat = findCategory(part.mod .. "/" .. path, CATEGORIES)
	removeFromCategory(part, cat)
end

for name,part in pairs(PARTS) do
	-- Is this part an MKS module?
	if containsModule(part, "KolonyConverter") or containsModule(part, "ProxyLogistics") 
			or containsModule(part, "OrbitalLogistics") then
		-- Secondary functions clutter up searches for e.g. probe cores
		removeFromPath(part, "Utility/Light")

		if containsModule(part, "ModuleCommand") then
			local minCrew = 0
			for command in modulesByName(part, "ModuleCommand") do
				if tonumber(command.values.minimumCrew) > tonumber(minCrew) then
					minCrew = tonumber(command.values.minimumCrew)
				end
			end
			if minCrew == 0 then
				removeFromPath(part, "Pod")
			end
		end
	end
end	-- end part loop
