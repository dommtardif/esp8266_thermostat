
function handle_mqtt_error(client, reason) 
  print("MQTT Client failed, trying to reconnect")
  tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end

function do_mqtt_connect()
  m:connect(mqtt_server, mqtt_on_connect, handle_mqtt_error)
end

function mqtt_on_connect(client) 
    print ("MQTT connected")
    m:subscribe(mqtt_prefix .. "#",2, function(conn) print("subscribe success") end)

end

m:on("offline", function(client)
    print ("MQTT offline")
end)

m:on("message", function(client, topic, data) 
  if data ~= nil then
    if topic == mqtt_topic_status .. "/query" then
            m:publish(mqtt_topic_status,tostring(relay_on),1,1)
    elseif topic == mqtt_topic_desiredtemp .. "/query" then
            m:publish(mqtt_topic_desiredtemp,thermostat_temp_desired,1,1)
    elseif topic == mqtt_topic_desiredtemp .. "/set" then
            thermostat_setDesiredTemp(tonumber(data)) 
    elseif topic == mqtt_topic_tolerance .. "/query" then
            m:publish(mqtt_topic_tolerance,thermostat_temp_tolerance,1,1)
    elseif topic == mqtt_topic_tolerance .. "/set" then
            thermostat_setTolerance(tonumber(data))
    elseif topic == mqtt_topic_awaytemp .. "/query" then
            m:publish(mqtt_topic_awaytemp,thermostat_temp_away,1,1)
    elseif topic == mqtt_topic_awaytemp .. "/set" then
            thermostat_setAwayTemp(tonumber(data))
    elseif topic == mqtt_topic_awaymode .. "/query" then
            m:publish(mqtt_topic_awaymode,tostring(thermostat_away),1,1)
    elseif topic == mqtt_topic_awaymode .. "/set" then
            thermostat_setAway(tonumber(data))  
    end
  end
end)

do_mqtt_connect()
