
function gs.game:mousepressed(x, y, button, istouch, presses)
	local minProx = nil
	local closest = nil
	print(player)
	for i, entity in pairs(EntitiesList) do
		local proximity = math.sqrt((entity.x + 8 - x)^2 + (entity.y + 8 - y)^2)
		if  proximity < 20 and (minProx == nil or minProx > proximity) then
			minProx = proximity
			closest = entity
		end
	end
	print(closest)
	if closest ~= nil then
		player:swap(closest)
	end
end
