
function gs.game:mousepressed(x, y, button, istouch, presses)
	local minProx = nil
	local closest = nil
	for i, entity in pairs(EntitiesList) do
		local proximity = math.sqrt((entity.x + 8 - x)^2 + (entity.y + 8 - y)^2)
		if  proximity < 20 and (minProx == nil or minProx > proximity) and entity ~= player then
			minProx = proximity
			closest = entity
		end
	end
	if closest ~= nil and not player.swapping and not player.swap_fx then
		player:swap_prepare(closest)
	end
end
