history_file = "../console.history"

-- To disable extended music, comment out the next line
require("extendedMusic")

local readHistory = function ()
   pcall(dofile, history_file)
end


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
