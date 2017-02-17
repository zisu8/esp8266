--
-- Test Programm zum auslesen des DHT22 an GPIO Pin4
-- an einem esp8266 NODEMCU
--
-- compiled with bit, cjson, crypto, dht, encoder, file, gpio, http, i2c, mqtt, net,
-- node, ow, rtcfifo, rtcmem, rtctime, tmr, u8g, uart, websocket, wifi, ws2801, ws2812, tls
--
-- and fonts
--
-- font_10x20,font_6x10,font_7x14B,font_7x14,font_helvR14,font_chikita
--
-- Display ist am GPIO 1 und 2 angeschlossen
--

-- GPIO PIN
pin = 4 -- DHT22
sda = 2 -- SDA Pin
scl = 1 -- SCL Pin

# sleep time in µs
sleep_time = 5000000

function init_OLED(sda,scl) --Set up the u8glib lib
   sla = 0x3C
   i2c.setup(0, sda, scl, i2c.SLOW)
   disp = u8g.ssd1306_128x64_i2c(sla)
   disp:setFont(u8g.font_helvR14)

   disp:setFontRefHeightExtendedText()
   disp:setDefaultForegroundColor()
   disp:setFontPosTop()
   --disp:setRot180()           -- Rotate Display if needed
end

function print_OLED()
 disp:firstPage()
 repeat
   --disp:drawFrame(2,2,126,62)
   disp:drawStr(5, 10, str1)
   disp:drawStr(5, 30, str2)
   --disp:drawCircle(18, 47, 14)
 until disp:nextPage() == false
end

function read_clima_data()
  status, temp, humi, temp_dec, humi_dec = dht.read(pin)
  if status == dht.OK then
    -- Float firmware using this example
    --print("DHT Temperature:"..temp)
    --print("DHT Humidity:"..humi)
    str1 = "Temp: "..temp.." °C"
    str2 = "Humi: "..humi.." %"
    print(str1)
    print(str2)
    print_OLED()
  elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
  end
end

-- Output Display
init_OLED(sda,scl)
read_clima_data()
node.dsleep(sleep_time)
