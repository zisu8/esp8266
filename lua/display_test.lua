-- oledGraphTest
-- Written by John Longworth July 2016



function initI2C()
   local sda = 2 -- GPIO2
   local scl = 1 -- GPIO0
   local sla = 0x3c
   i2c.setup(0, sda, scl, i2c.SLOW)
   disp = u8g.ssd1306_128x64_i2c(sla)
end

function initDisplay()
   disp:setFont(u8g.font_6x10)
   --disp:setDefaultForegroundColor()
end

function target()
   disp:setColorIndex(1)
   disp:drawBox(0, 0, 128, 64)
   disp:setColorIndex(0)
   disp:setFont(u8g.font_6x10)
   disp:drawStr(61, 12, "Hello World")
   disp:drawLine(0, 32, 64, 32)
   disp:drawLine(32, 0, 32, 64)
   disp:drawCircle(32, 32, 30)
   disp:setFont(u8g.font_chikita)
   disp:drawStr(75, 30, "On Target")
   disp:drawStr(65, 52, "NodeMCU LUA")
end

function circles()
   disp:setColorIndex(1)
   disp:drawStr(65, 20, "Concentric")
   disp:drawStr(72, 40, "Circles")
   for i=0, 32, 3 do
      disp:drawCircle(32, 32, i) -- 128 ->  x 64
   end
end

function boxes()
   disp:setColorIndex(1)
   disp:drawStr(1, 10, "drawBox")
   disp:drawBox(5, 15, 40, 10)
   disp:drawBox(50, 20, 30, 15)
   disp:drawBox(90, 15, 20, 18)
   disp:drawStr(0, 40, "drawFrame")
   disp:drawFrame(5, 45, 40, 10)
   disp:drawFrame(50, 45, 30, 15)
   disp:drawFrame(90, 45, 20, 18)
end

function alphabet()
   --disp:setFont(u8g.font_unifont)
   --disp:setFont(u8g.font_6x10)
   --disp:setFont(u8g.font_chikita)
   --disp:setFont(u8g.font_10x20)
   disp:setColorIndex(1)
   disp:setScale2x2()
   disp:drawStr(0, 8, "ABCDEFGHIJK")
   disp:drawStr(2, 16, "LMNOPQRSTU")
   disp:drawStr(14, 24, "VWXYZ")
   disp:drawStr(4, 32, "1234567890")
   disp:undoScale()
end

function lines()
   disp:setColorIndex(1)
   for i=0, 64, 5 do
      disp:drawLine(0, 0, 128, i)
   end
   for i=0, 128, 6 do
      disp:drawLine(0, 0, i, 64)
   end
end

function rotation()
   disp:setColorIndex(1)
   disp:setScale2x2()
   disp:drawStr(0, 10, "Hello")
   disp:setRot90()
   disp:drawStr(0, 10, "Hello")
   disp:setRot180()
   disp:drawStr(0, 10, "Hello")
   disp:setRot270()
   disp:drawStr(0, 10, "Hello")
   disp:undoRotation()
   disp:undoScale()
end

function triangles()
   disp:setColorIndex(1)
   disp:drawBox(0, 0, 128, 64)
   disp:setColorIndex(0)
   disp:drawStr(2, 10, "Triangles")
   for i = 0, 30, 6 do
      disp:drawLine(0+i+i, 32, 127-i, 0+i)
      disp:drawLine(0+i+i, 32, 127-i, 64-i)
      disp:drawLine(127-i, 0+i, 127-i, 64-i)
   end
end

function corners()
   for i = 0, 63, 6 do
      disp:drawLine(0, 64-i, 0+i+i, 0)
   end
   for i = 0, 63, 6 do
      disp:drawLine(0+i+i, 0, 128, 0+i)
   end
end

function ticker()
   disp:firstPage()
   repeat
      if count == 0 then
         disp:setColorIndex(1)
         corners()
         disp:setRot180()
         corners()
         disp:undoRotation()
      elseif count == 1 then triangles()
      elseif count == 2 then target()
      elseif count == 3 then alphabet()
      elseif count == 4 then lines()
      elseif count == 5 then circles()
      elseif count == 6 then boxes()
      elseif count == 7 then rotation()
      end
   until disp:nextPage() == false
end

count = 0
initI2C()
initDisplay()
tmr.alarm(0, 5000, 1, function()
   ticker()
   count = count + 1
   if count > 7 then
      count = 0
      --tmr.stop(0)
   end
end)
