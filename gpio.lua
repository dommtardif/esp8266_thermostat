gpio.mode(switch_pin, gpio.INT, gpio.PULLUP)
gpio.mode(relay_pin, gpio.OUTPUT)

function configureWifi(level, when)
   print("Got configureWifi click") 
   wifi.sta.clearconfig()
   -- node.restart()
end
gpio.trig(switch_pin, "down", configureWifi)
