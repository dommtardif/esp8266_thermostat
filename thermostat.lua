local setTemp = thermostat_temp_desired

function saveTempSettings()
    ok, json = pcall(sjson.encode, {desired=thermostat_temp_desired, tolerance=thermostat_temp_tolerance, away=thermostat_temp_away})
    if ok then
      print(json)
    else
      print("failed to encode!")
    end
    if file.open("tempsettings", "w+") then
      file.write(json)
      file.close()
    end
end

if file.open("tempsettings", "r") then
  settings = sjson.decode(file.read())
  file.close()
  thermostat_temp_tolerance = settings.tolerance
  thermostat_temp_desired = settings.desired
  thermostat_temp_away = settings.away
  setTemp = thermostat_temp_desired
else
    thermostat_temp_tolerance = 1
    thermostat_temp_desired = 21
    thermostat_temp_away = 19
    saveTempSettings()
end

function thermostat_setAway(away)
    thermostat_away = away
    print("thermostat away " .. away)
    if away == 1 then
        setTemp = thermostat_temp_away
    else
        setTemp = thermostat_temp_desired
    end
    m:publish(mqtt_topic_awaymode,tostring(away),1,1)
    print("thermostat set temp: " .. setTemp)
end

function thermostat_control()
    if not (currentTemp == nil) then
        if currentTemp < (setTemp-thermostat_temp_tolerance) and not relay_on then
            gpio.write(relay_pin, gpio.HIGH)
            relay_on = true
            print("relay on")
            m:publish(mqtt_topic_status,tostring(relay_on),1,1)
        elseif currentTemp > (setTemp+(thermostat_temp_tolerance/2)) and relay_on then
            gpio.write(relay_pin, gpio.LOW)
            relay_on = false
            print("relay off")
            m:publish(mqtt_topic_status,tostring(relay_on),1,1)
        end
    end
end

function thermostat_setDesiredTemp(temp)
    thermostat_temp_desired = temp
    if thermostat_away == 0 then
        setTemp = temp
    end
    saveTempSettings()
    m:publish(mqtt_topic_desiredtemp,thermostat_temp_desired,1,1)
end

function thermostat_setAwayTemp(temp)
    thermostat_temp_away = temp
    if thermostat_away == 1 then
        setTemp = temp
    end
    saveTempSettings()
    m:publish(mqtt_topic_awaytemp,thermostat_temp_away,1,1)
end

function thermostat_setTolerance(delta)
    thermostat_temp_tolerance = delta
    saveTempSettings()
    m:publish(mqtt_topic_tolerance,thermostat_temp_tolerance,1,1)
end

tmr.create():alarm(temp_read_interval * 1000, tmr.ALARM_AUTO, thermostat_control)
