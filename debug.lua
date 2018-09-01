db = {}

function print_table(t)
  for k, v in pairs(t) do
    print("key: "..k..",\t value: "..tostring(v))
  end
end

return db