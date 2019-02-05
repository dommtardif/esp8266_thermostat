local tempTimer = tmr.create()
ds18b20.setup(ds18b20_pin)
ds18b20.setting({},12)

function getTemp()
    ds18b20.read(
        function(INDEX, ROM, RES, TEMP, TEMP_DEC, PAR) 
            print(INDEX, ROM, RES, TEMP, TEMP_DEC, PAR)
            currentTemp = math.floor(tonumber(TEMP)*100)/100
            print("MQTT sent successfully: " .. tostring(m:publish(mqtt_topic_currenttemp,currentTemp,0,1)))
        end
    ,{})
end

tempTimer:register(temp_read_interval * 1000, tmr.ALARM_AUTO, getTemp)
tempTimer:start()
