local func = require("func")

local grid  = {}


local function verticalLines(menuWidth, menuHeight, gridSize, fullColor, halfColor)
    local screenWidth, screenHeight = love.graphics.getDimensions()
    -- offset to ensure that different grid sizes don't change the order of fullColor and halfColor grid lines
    local verticalOffset = math.floor((menuWidth / gridSize[1]) % 2)

    for verticalWidth = menuWidth, screenWidth, gridSize[1] do
        if math.floor((verticalWidth / gridSize[1]) % 2) == verticalOffset then
            love.graphics.setColor(unpack(fullColor))
        else 
            love.graphics.setColor(unpack(halfColor))
        end
        love.graphics.line(verticalWidth, menuHeight, verticalWidth, screenHeight)
    end
    return
end
    

local function horizontalLines(menuWidth, menuHeight, gridSize, fullColor, halfColor)
    local screenWidth, screenHeight = love.graphics.getDimensions()
    -- offset to ensure that different grid sizes don't change the order of fullColor and halfColor grid lines
    local horizontalOffset = math.floor((menuHeight / gridSize[1]) % 2)

    for horizontalHeight = menuHeight, screenHeight, gridSize[1] do
        if math.floor((horizontalHeight / gridSize[1]) % 2) == horizontalOffset then
            love.graphics.setColor(fullColor)
        else 
            love.graphics.setColor(halfColor)
        end
        love.graphics.line(menuWidth, horizontalHeight, screenWidth, horizontalHeight)
    end
    return
end


function grid.loadGrid(variables, menuFrame)
    local color = variables.gridColor
    local gridEnabled = variables.gridEnabled
    local gridSize = variables.gridSize
    local menuWidth = menuFrame.verticalMenu.width
    local menuHeight = menuFrame.horizontalMenu.height
    local fullColor = {color[1], color[2], color[3], color[4]}
    local halfColor = {color[1], color[2], color[3], color[4] - 0.2}

    if gridEnabled[1] == true then
        verticalLines(menuWidth, menuHeight, gridSize, fullColor, halfColor)
        horizontalLines(menuWidth, menuHeight, gridSize, fullColor, halfColor)
    end 
    return
end


local function snapVertical(mouseY, gridSize, verticalOffset)
    if ((mouseY % gridSize[1]) - verticalOffset) > (gridSize[1] / 2) then
        love.mouse.setY((mouseY + gridSize[1] + verticalOffset) - (mouseY % gridSize[1]))
    elseif ((mouseY % gridSize[1]) - verticalOffset) < (gridSize[1] / 2) then
        love.mouse.setY((mouseY + verticalOffset) - (mouseY % gridSize[1]))
    end
    return
end


local function snapHorizontal(mouseX, gridSize, horizontalOffset)
    if ((mouseX % gridSize[1]) - horizontalOffset) > (gridSize[1] / 2) then
        love.mouse.setX((mouseX + horizontalOffset + gridSize[1]) - (mouseX % gridSize[1]))
    elseif ((mouseX % gridSize[1]) - horizontalOffset) < (gridSize[1] / 2) then
        love.mouse.setX((mouseX + horizontalOffset)- (mouseX % gridSize[1]))
    end
    return
end


function grid.snapGrid(variables, controls, menuFrame)
    if variables.snapEnabled[1] == true then
        local gridSize = variables.gridSize
        local screenWidth, screenHeight = love.graphics.getDimensions()
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local leftMouse = controls.leftMouse
        local menuWidth = menuFrame.verticalMenu.width
        local menuHeight = menuFrame.horizontalMenu.height        

        -- offset for uneven results like 100 % 60 or 100 % 40
        local verticalOffset = menuWidth % gridSize[1]
        local horizontalOffset = menuHeight % gridSize[1]
        if leftMouse then
            if func.isHover(menuWidth, menuHeight, screenWidth, screenHeight) then
                snapVertical(mouseY, gridSize, verticalOffset)
                snapHorizontal(mouseX, gridSize, horizontalOffset)
            end 
        end
    end
    return
end


function grid.gridButtons(controls, buttonTable)
    for key, val in pairs(buttonTable) do
        if (key ~= "gridSizeField") and (key ~= "gridColorField") then
            for index, obj in pairs(val) do
                func.createRectangle(obj)
                func.buttonBehavior(controls, obj)
            end
        end
    end
    return
end


function grid.gridEnabled(variables, controls, table)
    local gridEnabled = variables.gridEnabled
    local mouseKey = controls.keyMouse
    local button = table.gridEnabler

    if func.isHover(button.x, button.y, button.width, button.height) and mouseKey == 1 then
        if gridEnabled[1] == true then
            gridEnabled[1] = false
        elseif gridEnabled[1] == false then
            gridEnabled[1] = true
        end
    end
    return
end


-- change grid size with corresponding buttons
function grid.gridSize(variables, controls, gridTable)
    local gridSize = variables.gridSize
    local mouseKey = controls.keyMouse
    local field = gridTable.gridSizeField
    local buttonTable = gridTable.gridSize
        
    -- only start the loop when cursor is hovering over the grid size buttons
    if func.isHover(field.x, field.y, field.width, field.height) then
        for key, val in pairs(buttonTable) do
            if func.isHover(val.x, val.y, val.width, val.height) and mouseKey == 1 then
                gridSize[1] = val.value
                -- change the button color to active to visualize which grid size is currently used
                val.isActive = true
            else
                val.isActive = false
            end
        end
    end
end


-- change the global gridColor value to the clicked button's value
function grid.color(variables, controls, buttonTable, colorTable)
    local mouseKey = controls.keyMouse
    local field = buttonTable.gridColorField

    -- only run the loop when mouse is hovering over any of the grid color buttons
    if func.isHover(field.x, field.y, field.width, field.height) then
        local buttonColors = buttonTable.color
    
        for key, val in pairs(buttonColors) do
            if func.isHover(val.x, val.y, val.width, val.height) and mouseKey == 1 then
                variables.gridColor = func.copyColor(val.value, colorTable)
            end  
        end
    end
    return
end



return grid