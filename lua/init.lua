-- init.lua - erster Versuch die ersten Schritte zu machen...

function startup()
      print("gooooo")
--      dofile("dht22_display.lua")
      dofile("dht22_bme280_display.lua")

end

wifi.setmode(wifi.NULLMODE)

print("You have 5 seconds to abort Startup")
print("Waiting...")
tmr.alarm(0,5000,0,startup)
