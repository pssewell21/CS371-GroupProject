local Obstacle = 
{
	blackColorTable = {0, 0, 0},
	whiteColorTable = {1, 1, 1},
	transparentColorTable = {0, 0, 0, 0},
	semiTransparentColorTable = {0, 0, 0, 0.75},
	objectWidth = 30,
	objectStrokeWidth = 3,
	tileWidth = 36
}

function Obstacle:new (o)    --constructor
 	o = o or {}
 	setmetatable(o, self)
 	self.__index = self
 	return o
end

-- Adds a floor object to the level
function Obstacle:addFloor(level, xStart, xEnd, y)
    self.shape = display.newRect(xStart, y, xEnd - xStart, display.contentHeight - y + self.objectStrokeWidth)
    self.shape.strokeWidth = self.objectStrokeWidth
    self.shape:setStrokeColor(unpack(self.whiteColorTable))
    self.shape:setFillColor(unpack(self.semiTransparentColorTable))
    self.shape.myName = "Floor"
    self.shape.anchorX = 0
    self.shape.anchorY = 0
    physics.addBody(self.shape, "static", {friction = 0}) 
    table.insert(level, self.shape)  

    return level
end

-- Adds a triangle object to the level
function Obstacle:addTriangleObstacle(level, x, y)
    local rightVertexX = self.objectWidth - (2 * self.objectStrokeWidth)
    local vertices = {-self.objectStrokeWidth,-self.objectStrokeWidth, rightVertexX,-self.objectStrokeWidth, (rightVertexX / 2 - 1),-self.objectWidth}
    local physicsVertices = {-self.objectWidth/2,self.objectWidth/2, self.objectWidth/2,self.objectWidth/2, 0,-self.objectWidth/2}

    self.shape = display.newPolygon(x, y, vertices)
    self.shape.strokeWidth = self.objectStrokeWidth
    self.shape:setStrokeColor(unpack(self.whiteColorTable))
    self.shape:setFillColor(unpack(self.semiTransparentColorTable))
    self.shape.myName = "Triangle"
    self.shape.anchorX = 0
    self.shape.anchorY = 0
    physics.addBody(self.shape, "static", {shape = physicsVertices}) 
    table.insert(level, self.shape)  

    return level
end

-- Adds a square object to the level
function Obstacle:addSquareObstacle(level, x, y)    
    self.shape = display.newRect(x, y, self.objectWidth, self.objectWidth)
    self.shape.strokeWidth = self.objectStrokeWidth
    self.shape:setStrokeColor(unpack(self.whiteColorTable))
    self.shape:setFillColor(unpack(self.semiTransparentColorTable))
    self.shape.myName = "Square"
    self.shape.anchorX = 0
    self.shape.anchorY = 0
    physics.addBody(self.shape, "static") 
    table.insert(level, self.shape)  

    self.shape = display.newRect(x - 2, y - 2, self.objectWidth + 2, 5)
    self.shape.strokeWidth = self.objectStrokeWidth
    self.shape:setStrokeColor(unpack(self.transparentColorTable))
    self.shape:setFillColor(unpack(self.transparentColorTable))
    self.shape.myName = "TransparentSquare"
    self.shape.anchorX = 0
    self.shape.anchorY = 0
    physics.addBody(self.shape, "static", {friction = 0}) 
    table.insert(level, self.shape) 

    return level
end

function Obstacle:addEndFlag(level, x, y)
    self.shape = display.newRect(x, y - (2 * self.tileWidth), self.objectStrokeWidth, 3 * self.tileWidth)
    self.shape.strokeWidth = self.objectStrokeWidth
    self.shape:setStrokeColor(unpack(self.whiteColorTable))
    self.shape:setFillColor(unpack(self.semiTransparentColorTable))
    self.shape.myName = "EndFlag"
    self.shape.anchorX = 0
    self.shape.anchorY = 0
    physics.addBody(self.shape, "static") 
    self.shape.isSensor = true
    table.insert(level, self.shape)  

    self.shape = display.newRect(x + 1.5 * self.objectStrokeWidth, y - (2 * self.tileWidth), 1.5 * self.tileWidth, self.tileWidth)
    self.shape.strokeWidth = self.objectStrokeWidth
    self.shape:setStrokeColor(unpack(self.whiteColorTable))
    self.shape:setFillColor(unpack(self.semiTransparentColorTable))
    self.shape.myName = "EndFlag"
    self.shape.anchorX = 0
    self.shape.anchorY = 0
    physics.addBody(self.shape, "static") 
    self.shape.isSensor = true
    table.insert(level, self.shape)  

    self.shape = display.newText("END", x + (0.45 * self.tileWidth), y - (1.75 * self.tileWidth), native.systemFont, 14)
    self.shape.anchorX = 0
    self.shape.anchorY = 0
    table.insert(level, self.shape) 

    return level
end

function Obstacle:spawn(level, itemType, xStartTile, xEndTile, yTile)
	local xStart = xStartTile * self.tileWidth

    if xEndTile ~= nil then
        xEnd = xEndTile * self.tileWidth
    end

    local y = yTile * self.tileWidth    

    if itemType == "floor" then
        if (xEnd ~= nil) then
            level = self:addFloor(level, xStart, xEnd, y)
        else
            print("no xEnd value provided for the floor with xStart = "..xStart.." and y = "..y)
        end        
    elseif itemType == "triangle" then
        level = self:addTriangleObstacle(level, xStart, y)
    elseif itemType == "square" then
        level = self:addSquareObstacle(level, xStart, y)
    elseif itemType == "endFlag" then
        level = self:addEndFlag(level, xStart, y)
    end

    return level
end

return Obstacle