function filter(item, other)
	print(item.id, other.id)
	if item.id == 69 or other.id == 69 then
		return "cross"
	end
	return "slide"
end
