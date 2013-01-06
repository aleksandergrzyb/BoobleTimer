display.setStatusBar(display.HiddenStatusBar)

print"----------------------------START---------------------------------"
--[
local BubbleTimer = require "BubbleTimer"

math.randomseed( os.time() )
math.random()
math.random()
math.random()

local bg = display.newImage("pushboil.png")

local bubbleTimer = BubbleTimer.new()
bubbleTimer.run()

--[ Uncomment to monitor app's lua memory/texture memory usage in terminal...
local mem = display.newText("0", 0,0, system.nativefont, 10)
mem:setReferencePoint(display.TopCenterReferencePoint)
mem.x, mem.y = 48,280
local tex = display.newText("0", 0,0, system.nativefont, 10)
tex:setReferencePoint(display.TopCenterReferencePoint)
tex.x, tex.y = 50, 302
local function garbagePrinting()
	collectgarbage("collect")
    local memUsage_str = string.format( "mem= %.3f KB", collectgarbage( "count" ) )
    --print( memUsage_str )
    mem.text = memUsage_str
    local texMemUsage_str = system.getInfo( "textureMemoryUsed" )
    texMemUsage_str = texMemUsage_str/1000
    texMemUsage_str = string.format( "tex = %.3f MB", texMemUsage_str )
    --print( texMemUsage_str )
    tex.text = texMemUsage_str
end

Runtime:addEventListener( "enterFrame", garbagePrinting )
--]]