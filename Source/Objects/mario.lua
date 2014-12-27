--[[
@NetMissionResources
[Image] mario.png;
--]]

local BIG_MARIO_HEIGHT = 32
local SMALL_MARIO_HEIGHT = 16
local TWO_MARIOS_HEIGHT = BIG_MARIO_HEIGHT+SMALL_MARIO_HEIGHT
local MARIO_WIDTH = 16
local SPRITE_SHEET_X = 80
local JUMP_VELOCITY = 6
local GRAVITY = 0.3

local PHYS_STATE = {
	upright = { accelRate = 0.2, friction = 0.90, minXspeed = 0.1, maxXspeed = 2, maxYspeed = 5 },
	air = { accelRate = 0.05, friction = 0.98, minXspeed = 0.01, maxXspeed = 2, maxYspeed = 5 },
	crouching = { accelRate = 0, friction = 0.95, minXspeed = 2.5, maxXspeed = 2, maxYspeed = 5 },
}

function MyObject:SetAnim(left, right)
	self.animRange[0] = left
	if (right == nil) then self.animRange[1] = left+1
	else self.animRange[1] = right+1 end
	self.animLength = self.animRange[1]-self.animRange[0]
end

function MyObject:Init()
	self.physState = PHYS_STATE.upright

	self.x, self.y = getDisplayWidth()/2, getDisplayHeight()/2
	self.xvel, self.yvel = 0, 0
	
	self.spriteCol = 0
	self.marioColor = 10
	self.bigMario = true
	self.faceLeft = false
	self.inAir = false
	
	self.animRange = {0,0}
	self.animVelInfluence = 0.16
	self:SetAnim(0)

	self.blockArray = ""

end

function MyObject:setBlockArray(bA)
	self.blockArray = bA
end

function MyObject:downCollision(y)
	self.y = y
	self.inAir = false;
	if(self.yvel < 0) then
		self.yvel = 0
	end
	self.physState = PHYS_STATE.upright
end

function MyObject:sideCollision(x)
	self.x = x
--	self.xvel = 0
end

function MyObject:upCollision(y)
	self.y = y
	self.yvel = -1 * self.yvel
end

function MyObject:getY()
	return self.y
end

function MyObject:getX()
	return self.x + MARIO_WIDTH/2
end


function MyObject:Step()

	-- Physics!
	self.x, self.y = self.x+self.xvel, self.y+self.yvel
	self.yvel = self.yvel-GRAVITY
	
	-- Fix position! (Collisions)
	if (self.y < 0) then
		self:downCollision(0)
	end

	-- Player input!
	local keyDirs = { keyDown(KEY_LEFT), keyDown(KEY_RIGHT), keyDown(KEY_UP), keyDown(KEY_DOWN) }
	local numDirKeys = 0
	for _,v in ipairs(keyDirs) do if (v) then numDirKeys = numDirKeys+1 end end
	local budging = false
	if (numDirKeys == 1) then
		if (keyDown(KEY_LEFT)) then
			self.xvel = self.xvel - self.physState.accelRate
			if (not self.inAir) then self.faceLeft = true end
			budging = true
		elseif (keyDown(KEY_RIGHT)) then
			self.xvel = self.xvel + self.physState.accelRate
			if (not self.inAir) then self.faceLeft = false end
			budging = true
		end
	end
	if (keyPressed(KEY_ENTER)) then self.bigMario = not self.bigMario end
	if (not self.inAir and keyPressed(KEY_SPACE)) then
		self.yvel = JUMP_VELOCITY
		self.physState = PHYS_STATE.air
		self.inAir = true
		self:SetAnim(5)
	end
	-- Fix velocity!
	if (not budging) then self.xvel = self.xvel * self.physState.friction end
	if (self.yvel < -self.physState.maxYspeed) then self.yvel = -self.physState.maxYspeed end
	self.xvel = restrictRange(-self.physState.maxXspeed, self.xvel, self.physState.maxXspeed)
	if (math.abs(self.xvel) < self.physState.minXspeed) then self.xvel = 0 end
	
	
	-- Set the correct Mario position/animation
	if (not self.inAir) then
		if (self.xvel ~= 0) then
			self:SetAnim(1,3)
			if ((self.xvel > 0 and self.faceLeft == true) or
				(self.xvel < 0 and self.faceLeft == false)) then
				if (budging) then self:SetAnim(4) else self:SetAnim(0) end
			end
		elseif (self.physState == PHYS_STATE.crouching) then self:SetAnim(6)
		else self:SetAnim(0) end
	end

	-- Animate
	local animSpeed = 0
	if (not self.inAir) then animSpeed = self.animVelInfluence*math.abs(self.xvel) end
	if (self.animLength == 1) then self.spriteCol = self.animRange[0]
	else self.spriteCol = self.spriteCol + animSpeed end
	if (self.spriteCol < self.animRange[0]) then self.spriteCol = self.spriteCol+self.animLength end
	if (self.spriteCol >= self.animRange[1]) then self.spriteCol = self.spriteCol-self.animLength end
end

function MyObject:Render()
	pushMatrix()
--	translateMatrix(math.floor(self.x),math.floor(self.y),0)
	translateMatrix(self.x, self.y, 0)
	if (self.faceLeft) then
		translateMatrix(MARIO_WIDTH,0,0)
		scaleMatrix(-1,1)
	end
	local x1 = SPRITE_SHEET_X + math.floor(self.spriteCol)*MARIO_WIDTH
	local x2 = x1 + MARIO_WIDTH
	local y1,y2
	if self.bigMario then
		y1 = self.marioColor*TWO_MARIOS_HEIGHT+SMALL_MARIO_HEIGHT
		y2 = y1 + BIG_MARIO_HEIGHT
	else
		y1 = self.marioColor*TWO_MARIOS_HEIGHT
		y2 = y1 + SMALL_MARIO_HEIGHT
	end
	drawImagePart(NMImage.mario, x1,y1, x2,y2)
	popMatrix()
end

function MyObject:ShutDown()

end
