local GTween = require "GTween"


--Controller
local BubbleTimer = {}

BubbleTimer.new = function()
-- functions
	local construct
	local createTopBubbles
	local createDownBubbles
	local placeBubble
	local startBubbleAnimation
	local bubbleAnimation
	local lightTheBubbles
	local lightenBubble
	local changeColorOfBubble
	
	local radiuses = {6,8,10,12}
	local bubble = nil
	local isPlace = true
	local wasPlaced = false
	local wasExceeded = false
	local gotToTheTop = true
	local wasPhaseCalculated = false
	local counter = 0
	local colorNumber = 1
	local radius = 0
	local position = 0
	local numberOfBubbles = 180
	local a = 1
	local omega = 0.01
	local phase = {}
	
	
	local colors = {{r=0,g=255,b=0}, {r=0,g=205,b=0}, {r=0,g=139,b=0}, {r=255,g=255,b=0}, {r=255,g=215,b=0}, {r=250,g=140,b=0}, {r=255,g=127,b=80}, {r=205,g=85,b=85}, {r=238,g=44,b=44}, {r=139,g=26,b=26}}

	
	local m = display.newGroup()
	m.topBubblesGroup = display.newGroup()
	m.downBubblesGroup = display.newGroup()
	
	m:insert(m.topBubblesGroup)
	m:insert(m.downBubblesGroup)
	
	m.topBubbles = {}
	m.downBubbles = {}
	
	m.bubbleTopRadiuses = {}
	m.bubbleDownRadiuses = {}
	
	function construct()
		print "BubbleTimer created"
	end
	
	function m:run()
		createTopBubbles()
		createDownBubbles()
		createPhase()
		Runtime:addEventListener("enterFrame", moveBubbles)
		timer.performWithDelay(1000, startBubbleAnimation, #m.downBubbles)
	end
	
	function startBubbleAnimation()
		m.downBubbles[a].isMoving = true
		a = a + 1
	end
	
	function createPhase()
		for i = 1,#m.downBubbles do
			phase[i] = i
		end
	end
	
	function moveBubbles()
		for i = 1, #m.downBubbles do
			if m.downBubbles[i].isMoving then
				local delta = math.random(1,16) - 8

				if m.downBubbles[i].y < 80 + delta then
					m.downBubbles[i].isMoving = false
					m.downBubbles[i].tween1 = GTween.new(m.downBubbles[i], 1, {alpha = 0, y = m.downBubbles[i].y-30})
					if gotToTheTop then
						lightTheBubbles()
						gotToTheTop = false
				 	end
				else
					m.downBubbles[i].y = m.downBubbles[i].y - 1
					m.downBubbles[i].x = m.downBubbles[i].x + math.sin(omega + phase[i])
					
				end
			end
		end
		omega = omega + 0.04
	end
	
	
	function lightenBubble(e)
		local a = e.count
		local period = #m.topBubbles / 10 + 0.5
		period = math.floor(period)
		local function changeColor()
			if a % period == 0 then
				print("wszedl")
				if colorNumber < 10 then
					colorNumber = colorNumber + 1
				end
				print(colorNumber)
			end
			m.topBubbles[a]:setFillColor(colors[colorNumber].r,colors[colorNumber].g,colors[colorNumber].b)
			m.topBubbles[a].tween3 = GTween.new(m.topBubbles[a], (numberOfBubbles / (#m.topBubbles - 2)) * 0.8, {alpha = 1})
		end
		m.topBubbles[a].tween2 = GTween.new(m.topBubbles[a], (numberOfBubbles / (#m.topBubbles - 2)) * 0.2, {alpha = 0.2}, {onComplete = changeColor})
	end
	
	function lightTheBubbles()
		print("start top bubbles ---------------")
		timer.performWithDelay(numberOfBubbles * 1000 / (#m.topBubbles - 2), lightenBubble, #m.topBubbles - 2)
	end
	
	function createDownBubbles()
		for i = 1,numberOfBubbles do
			radius = radiuses[math.random(1,4)]
			placeX = math.random(40, 440)
			
			bubble = display.newCircle(placeX, 380, radius)
			bubble:setFillColor(166,42,42)
			m.downBubblesGroup:insert(bubble)
			
			m.downBubbles[i] = bubble
			m.downBubbles[i].isMoving = false
			m.bubbleDownRadiuses[i] = radius
		end
	end
	
	function createTopBubbles()
		counter = counter + 1
		radius = radiuses[math.random(1,4)]
		
		bubble = display.newCircle(0, 0, radius)
		bubble:setFillColor(61,61,61)
		m.topBubblesGroup:insert(bubble)
		
		m.topBubbles[counter] = bubble
		m.bubbleTopRadiuses[counter] = radius
		
		placeBubble()
		
		if isPlace then
			createTopBubbles()
		end
	end
	
	function placeBubble()
		bubbleX = 15 + m.bubbleTopRadiuses[counter]
		bubbleY = 15 + m.bubbleTopRadiuses[counter]
		
		for i = 1, #m.topBubbles do
			if i == 1 then
				m.topBubbles[i].x = bubbleX
				m.topBubbles[i].y = bubbleY
			else
				if m.topBubbles[i - 1].x + m.bubbleTopRadiuses[i - 1] > 450 then
					isPlace = false
					wasExceeded = true
					m.topBubbles[i - 1].isVisible = false
				end
				if (m.topBubbles[i - 1].y + m.bubbleTopRadiuses[i - 1]) == 45 and not wasExceeded then
					if (45 - m.topBubbles[i - 1].y - m.bubbleTopRadiuses[i - 1]) >= 2 * m.bubbleTopRadiuses[i] and not wasPlaced then
						m.topBubbles[i].y = 15 + m.bubbleTopRadiuses[i]
						m.topBubbles[i].x = m.topBubbles[i - 1].x + m.bubbleTopRadiuses[i] - m.bubbleTopRadiuses[i - 1] + 4
						wasPlaced = true
					else
						m.topBubbles[i].y = 15 + m.bubbleTopRadiuses[i]
						if wasPlaced then
							m.topBubbles[i].x = m.topBubbles[i - 1].x + m.bubbleTopRadiuses[i] + m.bubbleTopRadiuses[i - 1] + 6
						else
							m.topBubbles[i].x = m.topBubbles[i - 1].x + m.bubbleTopRadiuses[i] + m.bubbleTopRadiuses[i - 1] + 4
						end
						wasPlaced = false
					end
				elseif not wasExceeded then
					if (45 - m.topBubbles[i - 1].y - m.bubbleTopRadiuses[i - 1]) >= 2 * m.bubbleTopRadiuses[i] and not wasPlaced then
						m.topBubbles[i].y = 45 - m.bubbleTopRadiuses[i]
						m.topBubbles[i].x = m.topBubbles[i - 1].x + m.bubbleTopRadiuses[i] - m.bubbleTopRadiuses[i - 1] + 4
						wasPlaced = true
					else
						m.topBubbles[i].y = 45 - m.bubbleTopRadiuses[i]
						if wasPlaced then
							m.topBubbles[i].x = m.topBubbles[i - 1].x + m.bubbleTopRadiuses[i] + m.bubbleTopRadiuses[i - 1] + 6
						else
							m.topBubbles[i].x = m.topBubbles[i - 1].x + m.bubbleTopRadiuses[i] + m.bubbleTopRadiuses[i - 1] + 4
						end
						wasPlaced = false
					end
				end
			end
			if m.topBubbles[i].x == 0 or m.topBubbles[i].y == 0 then
				m.topBubbles[i].isVisible = false
			end
		end
	end

	m.oldRemoveSelf = m.removeSelf
	function m:removeSelf()
		print "Manager destroyed"
		self:oldRemoveSelf()
		self = nil
	end
	
	construct()
	
	return m
end

return BubbleTimer