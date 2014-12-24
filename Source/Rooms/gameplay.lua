--[[
@NetMissionResources
[Object] blockObj; blockArrayObj; startCamera; endCamera; square; mario
[Font] mainFont@ComicSansEwww.fnt;
[Music] gameplay.ogg;
--]]

local startCameraDepth = -1000
local blockDepth = 0
local marioDepth = 1
local endCameraDepth = 10

local cameraInst

function Init()

	cameraInst = startCamera:new()
	registerInst(cameraInst,startCameraDepth)
	registerInst(endCamera:new(), endCameraDepth)

	blockArray = blockArrayObj:new()
	registerInst(blockArray, blockDepth)

	marioObj = mario:new()
	registerInst(marioObj, marioDepth)
	marioObj:setBlockArray(blockArray)
end

local anim = 0

function Step()
	if (keyPressed(KEY_ESCAPE)) then endGame() end
	if (keyPressed(KEY_F4)) then toggleFullScreen() end

	if (anim % 100 == 0) then
		newSquare = square:new()
		newSquare:setX(anim)
		registerInst(newSquare,blockDepth)
	end

	-- check and handle Mario collisions
	local marioLeftCol, marioBottomRow = blockArray:getMarioIndices(marioObj.x, marioObj.y)
	local marioRightCol, marioUpperRow = blockArray:getMarioIndices(marioObj.x + 16, marioObj.y + 16)
	local marioMidLeftCol, marioBottomRow = blockArray:getMarioIndices(marioObj.x + 4, marioObj.y)
	local marioMidRightCol, marioBottomRow = blockArray:getMarioIndices(marioObj.x + 12, marioObj.y)


	--down collision detection
	if(blockArray.matrix[marioBottomRow][marioMidLeftCol] == "block" or blockArray.matrix[marioBottomRow][marioMidRightCol] == "block") then -- if there is a block underneath the left or right side of Mario's feet
		marioObj:downCollision(blockArray:getYFromRow(marioBottomRow + 1))
		marioBottomRow = marioBottomRow + 1
	end
	-- up collision detection
	if(marioObj.bigMario == false) then
		if(blockArray.matrix[marioUpperRow][marioMidLeftCol] == "block" or blockArray.matrix[marioUpperRow][marioMidRightCol] == "block") then
			marioObj:upCollision(blockArray:getYFromRow(marioUpperRow - 1))
			marioUpperRow = marioUpperRow - 1
		end
	else
		if(blockArray.matrix[marioUpperRow + 1][marioMidLeftCol] == "block" or blockArray.matrix[marioUpperRow + 1][marioMidRightCol] == "block") then
			marioObj:upCollision(blockArray:getYFromRow(marioUpperRow - 1))
			marioUpperRow = marioUpperRow - 1
		end
	end
	-- right collision detection
	if(blockArray.matrix[marioBottomRow][marioRightCol] == "block" or blockArray.matrix[marioUpperRow][marioRightCol] == "block") then
		marioObj:sideCollision(blockArray:getMarioXFromCol(marioLeftCol))
	end
	-- left collision detection
	if(blockArray.matrix[marioBottomRow][marioLeftCol] == "block" or blockArray.matrix[marioUpperRow][marioLeftCol] == "block") then
		marioObj:sideCollision(blockArray:getMarioXFromCol(marioRightCol))
	end

	anim = anim+1
end

function Render()
	-- Draw the mouse
	drawLine(mouseX(),mouseY(),mouseX()+10,mouseY()-10)
	drawLine(mouseX()+10,mouseY()-10,mouseX(),mouseY()-10)
	drawLine(mouseX(),mouseY()-10,mouseX(),mouseY())
end

function ShutDown()
	saveGame("State")
	grabMouse(false)
end
