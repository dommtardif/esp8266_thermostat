relay_pin = 1
switch_pin = 3
ds18b20_pin = 4

mqtt_room = "sdb"
mqtt_type = "thermostat"
mqtt_server = "192.168.1.4"

mqtt_client_name = mqtt_room .. mqtt_type
mqtt_prefix = mqtt_room .. "/" .. mqtt_type .. "/"
mqtt_topic_currenttemp = mqtt_prefix .. "currenttemp"
mqtt_topic_status = mqtt_prefix .. "status"
mqtt_topic_desiredtemp = mqtt_prefix .. "desiredtemp"
mqtt_topic_tolerance = mqtt_prefix .. "tolerance"
mqtt_topic_awaytemp = mqtt_prefix .. "awaytemp"
mqtt_topic_awaymode = mqtt_prefix .. "awaymode"


temp_read_interval = 30
currentTemp = nil
relay_on = false
thermostat_temp_tolerance = 1
thermostat_temp_desired = 21
thermostat_temp_away = 19
thermostat_away = 0
m = mqtt.Client(mqtt_client_name, 120)
