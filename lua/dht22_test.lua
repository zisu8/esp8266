-- Test Programm zum auslesen des DHT22 an GPIO2 Pin D4
-- an einem esp8266 NODEMCU


-- GPIO2 PIN D4
pin = 4

status, temp, humi, temp_dec, humi_dec = dht.read(pin)

if status == dht.OK then
    -- Float firmware using this example
    print("DHT Temperature:"..temp)
    print("DHT Humidity:"..humi)

elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
end
