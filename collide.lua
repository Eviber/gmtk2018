function filter(item, other)
	if item.id == 69 and other.id == 69 then
		return false
	elseif item.id == 69 or other.id == 69 then
		return "cross"
	end
	return "slide"
end
