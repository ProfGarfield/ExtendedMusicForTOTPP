history_file = "../console.history"

local readHistory = function ()
   pcall(dofile, history_file)
end

require("extendedMusic")

local writeHistory = function ()
   io.output(history_file)
   io.write("_ih = {\n")
   for _, v in pairs(_ih) do
      io.write(string.format("%q,\n", v))
   end
   io.write("}\n")
   io.close()
end

readHistory()
return writeHistory
