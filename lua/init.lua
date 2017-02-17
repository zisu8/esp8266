-- init.lua - erster Versuch die ersten Schritte zu machen...

function startup()
      print("gooooo")
      dofile("dht22_display.lua")
end


print("You have 5 seconds to abort Startup")
print("Waiting...")
tmr.alarm(0,5000,0,startup)
