
function gs.game:mousepressed(x, y, button, istouch, presses)
	local minProx = nil
	local closest = nil
	for i, entity in pairs(EntitiesList) do
		local proximity = math.sqrt(math.pow(math.abs(entity.x + 8 - x), 2) + math.pow(math.abs(entity.y + 8 - y), 2))
		if  proximity < 20 and (minProx == nil or minProx > proximity) then
			minProx = proximity
			closest = entity
		end
	end
	--print(closest)
	if closest ~= nil then
		player.swap(player, closest)
	end
end