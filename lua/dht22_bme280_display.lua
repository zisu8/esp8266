--
-- Programm zum auslesen des DHT22 an GPIO Pin4
-- an einem esp8266 NODEMCU
--
-- am I2C haengt GPIO 2 und 1 haengt ein OLED Display
--
-- built against the master branch and includes the following modules: bit, bme280, cjson, crypto, dht, encoder,
-- file, gpio, http, i2c, mqtt, net, node, ow, rtcfifo, rtcmem, rtctime, tmr, u8g, uart, websocket, wifi, ws2801, ws2812, tls
--
-- and fonts
--
-- font_6x10,font_7x14,font_helvR24,font_chikita,font_profont22
--
-- Display ist am GPIO 1 und 2 angeschlossen
--

-- GPIO PIN
pin = 4 -- DHT22
sda = 2 -- SDA Pin
scl = 1 -- SCL Pin

-- Meeres Höhe München ca. 515m
alt = 515

-- sleep time in µs
sleep_time = 5000000

-- I2C initialisierung
i2c.setup(0, sda, scl, i2c.SLOW)

function init_OLED(sda,scl) --Set up the u8glib lib
   sla = 0x3C
   disp = u8g.ssd1306_128x64_i2c(sla)
end


function print_OLED()
 disp:firstPage()
 disp:setFontRefHeightExtendedText()
 disp:setDefaultForegroundColor()
 disp:setFontPosTop()
 disp:setFont(u8g.font_6x10)
 --disp:setRot180()           -- Rotate Display if needed
 repeat
   --disp:drawFrame(2,2,126,62)
   disp:drawStr(2, 10, "dht22:")
   disp:drawStr(2, 20, dht22_temp.." "..dht22_humi)
   disp:drawStr(2, 40, "bme280:")
   disp:drawStr(2, 50, bme280_temp.." "..bme280_humi)
   disp:drawStr(2, 60, bme280_press)
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

function read_bme280_data()
  local temp, press, humi, qnh = bme280.read(alt)

  if temp < 0 then
     bme280_temp = string.format("T: -%d.%02d °C", -temp/100, -temp%100)
  else
     bme280_temp = string.format("T: %d.%02d °C", temp/100, temp%100)
  end

  bme280_humi = string.format("H: %d.%02d%%", humi/1000, humi%100)

  bme280_press = string.format("P: %d.%02d", press/1000, press%100)

  bme280_press_sea = string.format("PS: %d.%02d", qnh/1000, qnh%100)
--      bme280_humiy = "Humi: "..humi.." %"
--      bme280_press = "Pres: "..pressure.." HPa"
end

-- Output Display

init_OLED(sda,scl)
bme280.init(sda, scl)
read_dht22_data()
print ("DHT22 "..dht22_temp.." | "..dht22_humi)
read_bme280_data()
print ("BME280 "..bme280_temp.." | "..bme280_humi.." | "..bme280_press.." | "..bme280_press_sea)
print_OLED()
print("Going to sleep for "..(sleep_time/1000/1000).." seconds...")
--node.dsleep(sleep_time)
