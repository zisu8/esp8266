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

-- sleep time in µs
sleep_time = 5000000

function init_OLED(sda,scl) --Set up the u8glib lib
   sla = 0x3C
   i2c.setup(0, sda, scl, i2c.SLOW)
   disp = u8g.ssd1306_128x64_i2c(sla)
   disp:setFontRefHeightExtendedText()
   disp:setDefaultForegroundColor()
   disp:setFontPosTop()
   --disp:setRot180()           -- Rotate Display if needed
end

function print_OLED()
 disp:firstPage()
 repeat
   --disp:drawFrame(2,2,126,62)

   disp:setFont(u8g.font_6x10)
   disp:drawStr(2, 10, "dht22")
   disp:drawStr(2, 20, dht22_temp.." "..dht22_humi)
--   disp:drawStr(5, 30, dht22_humi)
--   disp.drawStr(5, 32, "bme280:")
--   disp:drawStr(5, 42, bme280_temp)
--   disp:drawStr(5, 52, bme280_humi)
   --disp:drawCircle(18, 47, 14)
 until disp:nextPage() == false
end

function read_dht22_data()
  local status, temp, humi, temp_dec, humi_dec = dht.read(pin)
  if status == dht.OK then
    -- Float firmware using this example
    --print("DHT Temperature:"..temp)
    --print("DHT Humidity:"..humi)
    dht22_temp = "T: "..temp.." °C"
    dht22_humi = "H: "..humi.." %"
  elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
  end
end

--function read_bme280_data()
--   bme280.init(sda, scl)
--   local temp, pressure, humi, qnh = bme280.read()
--   if temp < 0 then
--      bme280_temp = string.format("-%d.%02d", -temp/100, -_temp%100)
--   else
--      bme280_temp = string.format("%d.%02d", temp/100, temp%100)
--   end
--      bme280_humiy = "Humi: "..humi.." %"
--      bme280_prese = "Pres: "..pressure.." HPa"
--end
-- Output Display

init_OLED(sda,scl)
read_dht22_data()
print ("DHT22 "..dht22_temp.." | "..dht22_humi)
--read_bme280_data()
print_OLED()
print("Going to sleep for "..(sleep_time/1000/1000).." seconds...")
--node.dsleep(sleep_time)
