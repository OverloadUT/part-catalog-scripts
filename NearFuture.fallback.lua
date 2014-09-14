-- Cleanup for Near Future engines
-- NearFuture.fallback.lua
-- by Starstrider42
-- Created June 17, 2014
-- Last modified July 2, 2014

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
	if isInModCategory(part, "Engine/Ion") then
		removeFromPath(part, "Engine/Misc")
		removeFromPath(part, "Engine/_ElectricCharge")
		removeFromPath(part, "Engine/_XenonGas")
		removeFromPath(part, "Engine/_ArgonGas")
		removeFromPath(part, "Engine/_LiquidHydrogen")
	end

end	-- end part loop
