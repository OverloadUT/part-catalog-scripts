-- Support for NRAP Test Weight
-- NRAP.fallback.lua
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

for name,part in pairs(PARTS) do
	if part.name == "kerbnraptest" then
		removeFromCategory(part, CATEGORIES)
		addToModCategory(part, "Utility/Misc")
	end

end	-- end part loop
