function filter(item, other)
	if item.id == "Bullet" and other.id == "Bullet" then
		return false
	elseif item.id == "Bullet" or other.id == "Bullet" then
		return "cross"
	end
	return "slide"
end
