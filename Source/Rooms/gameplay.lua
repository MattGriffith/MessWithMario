--[[
@NetMissionResources
[Object] blockObj; blockArrayObj; startCamera; endCamera; square; mario
[Font] mainFont@ComicSansEwww.fnt;
--]]

local startCameraDepth = -1000
local blockDepth = 0
local marioDepth = 1
local endCameraDepth = 10

local cameraInst

function Init()

	cameraInst = createInst(NMObject.startCamera)
	registerInst(cameraInst,startCameraDepth)
	registerInst(createInst(NMObject.endCamera), endCameraDepth)

	blockArray = createInst(NMObject.blockArrayObj)
	registerInst(blockArray, blockDepth)

	marioObj = createInst(NMObject.mario)
	registerInst(marioObj, marioDepth)
	marioObj:setBlockArray(blockArray)
end

local anim = 0

function PostStep()
	if (keyPressed(KEY_ESCAPE)) then endGame() end
	if (keyPressed(KEY_F4)) then toggleFullScreen() end

	if (anim % 100 == 0) then
		newSquare = createInst(NMObject.square)
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

function PostRender()
	-- Draw the mouse
	drawLine(mouseX(),mouseY(),mouseX()+10,mouseY()-10)
	drawLine(mouseX()+10,mouseY()-10,mouseX(),mouseY()-10)
	drawLine(mouseX(),mouseY()-10,mouseX(),mouseY())
end

function ShutDown()
	saveGame("State")
	grabMouse(false)
end
