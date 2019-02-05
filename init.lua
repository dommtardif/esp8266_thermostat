function eus()
    if wifi.sta.getip() == nil then
        enduser_setup.start(
          function()
            print("Connected to wifi as:" .. wifi.sta.getip())
            station_cfg = {}
            station_cfg.ssid=wifi.sta.getconfig(true).ssid
            station_cfg.pwd=wifi.sta.getconfig(true).pwd
            station_cfg.auto=true
            station_cfg.save=true
            wifi.sta.config(station_cfg)
          end,
          function(err, str)
            print("enduser_setup: Err #" .. err .. ": " .. str)
          end
        );
    end
end
if wifi.sta.getdefaultconfig(true).ssid == "" then
    eus()
else
    print("Trying to connect to " .. wifi.sta.getdefaultconfig(true).ssid)
end
dofile("config.lua")
dofile("thermostat.lua")
dofile("gpio.lua")
dofile("ds18b20.lua")
dofile("mqtt.lua")



