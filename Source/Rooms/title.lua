--[[
@NetMissionResources
[Image] title.png;
[TileMap] title.tmx;
[Font] ComicSansEwww.fnt;
--]]

function Init()
	setCaption(PROJECT_TITLE .. " (" .. PROJECT_YEAR .. ") by " .. PROJECT_AUTHOR)
	grabMouse(false)

end

local transitionFrame = 0;
local transitionEndFrame = 120;
local transitionProgress = 0; -- Goes from 0 to 1 during transition
local transitionProgressSqr = 0; -- Previous variable, squared
backgroundGoalRed = .2
backgroundGoalGreen = .4
backgroundGoalBlue = .7

function SetTransitionFrame(newFrame)
	transitionFrame = newFrame
	transitionProgress = newFrame/transitionEndFrame
	transitionProgressSqr = transitionProgress*transitionProgress
	setBackgroundColor(transitionProgress*backgroundGoalRed,
						transitionProgress*backgroundGoalGreen,
						transitionProgress*backgroundGoalBlue)
end

local animCounter = 0;

function Step()
	if (keyPressed(KEY_ESCAPE)) then endGame() end
	if (keyPressed(KEY_F4)) then toggleFullScreen() end
	
	-- If we are transitioning to the next room...
	if (0 < transitionFrame and transitionFrame < transitionEndFrame) then
		-- Advance the transition by 1 frame
		SetTransitionFrame(transitionFrame+1)

	-- If we are done transitioning...
	elseif (transitionFrame == transitionEndFrame) then
		-- Attempt to go to the next room (this will keep trying every frame)
		if (resourcesAreLoaded()) then forceNewRoom("gameplay") end
	end
	
	if (keyPressed(KEY_ENTER) and transitionFrame == 0) then
		SetTransitionFrame(1); -- Begin the transition
		beginResourceList()
		includeResource("Room","gameplay",0)
		endResourceList()
	end
	
	animCounter = animCounter+1
end

local displayCenterX = getDisplayWidth()/2
local displayCenterY = getDisplayHeight()/2

function RenderTitleImage()
	local titleAngle = transitionProgress*360
	local titleOffset = transitionProgressSqr*displayCenterY+80
	local titleAlpha = 1-transitionProgress
	local titleScale = 1+math.sin(animCounter*.1)*.05

	pushMatrix()
	-- Remember that these transformations apply in reverse order!
	translateMatrix(displayCenterX,displayCenterY+titleOffset,0) -- 4. Move image to center of display
	scaleMatrix(titleScale,2-titleScale) -- 3. Scale the image so that it looks cool
	rotateMatrix(titleAngle) -- 2. Rotate about the center of the image
	translateMatrix(-217,-116,0) -- 1. Move image so that the origin is in the center of image
	
	setColor(1,1,1,titleAlpha)
	drawImage(NMImage.title)
	setColor(1,1,1,1)
	
	popMatrix()
end

local leftLayer = getTileLayerKey(NMTileMap.title,"LeftSide")
local rightLayer = getTileLayerKey(NMTileMap.title,"RightSide")

function RenderTileMap()
	local reverseProgress = 1-transitionProgress
	local progressSqrSqr = transitionProgressSqr*transitionProgressSqr
	local tileOffsetX = math.floor(progressSqrSqr*getDisplayWidth())
	local tileOffsetY = math.floor(reverseProgress*reverseProgress*-120)
	local leftColor = 0.8+transitionProgress*0.2
	local rightColor = 0.7+transitionProgress*0.3
	pushMatrix()

	translateMatrix(tileOffsetX,tileOffsetY,0) -- Slide the right layer right
	setColor(rightColor,rightColor,rightColor,1)
	drawTileLayer(NMTileMap.title,rightLayer)

	translateMatrix(-tileOffsetX*2,0,0) -- Slide the left layer left
	setColor(leftColor,leftColor,leftColor,1)
	drawTileLayer(NMTileMap.title,leftLayer)

	popMatrix()
end

local pressEnterText = "Press Enter to Begin"
local pressEnterAlign = (getDisplayWidth() - getTextWidth(NMFont.ComicSansEwww,pressEnterText))/2

function Render()
	RenderTileMap()
	RenderTitleImage()

	if (transitionFrame == 0 and animCounter%100 < 50) then
		drawTextCoord(NMFont.ComicSansEwww,pressEnterText,pressEnterAlign,150)
	end
	drawTextCoord(NMFont.ComicSansEwww,"Press escape to quit",5,getDisplayHeight()-15)
end

function ShutDown()
end
