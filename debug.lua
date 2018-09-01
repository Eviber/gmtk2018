db = {}

function print_table(t)
  for k, v in pairs(t) do
    print("key: "..k..", value: "..v)
  end
end

db.print_table = print_table

return db