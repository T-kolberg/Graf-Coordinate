local func = {}

func.temp_coordinates = {}


-- button behavior for hovering and clicking activity
function func.buttonBehavior(controls, button)
    local leftMouse = controls.leftMouse
    if func.isHover(button.x, button.y, button.width, button.height) then
        button.color.colorCurrent = button.color.colorHover
        if leftMouse then
            button.color.colorCurrent = button.color.colorClick 
        end
    else
        -- for button color which should stay colorActive when button pressed
        if button.isActive == true then
            button.color.colorCurrent = button.color.colorActive
        else
            button.color.colorCurrent = button.color.colorStd
        end
    end 
    return
end


-- changing alpha of the provided color in combination with buttons clicked
function func.changeAlpha(color, controls, buttonTable)
    local mouseKey = controls.keyMouse

    for key, val in pairs(buttonTable.alpha) do
        if func.isHover(val.x, val.y, val.width, val.height) and mouseKey == 1 then
            if ((val.value == "up") and (color[4] < 1)) then
                color[4] = func.round((color[4] + 0.1), 1)
            elseif ((val.value == "down") and (color[4] > 0)) then
                color[4]= func.round((color[4] - 0.1), 1)
            end
        end
    end
    return
end


-- change brightness from its declared color to black and white
function func.changeBrightness(color, controls, buttonTable)
    local mouseKey = controls.keyMouse

    for key, val in pairs(buttonTable.brightness) do
        if func.isHover(val.x, val.y, val.width, val.height) and mouseKey == 1 then
            if (val.value == "lighten") and ((color[1] < 1.0) or (color[2] < 1.0) or (color[3] < 1.0)) then
                for i = 1, 3 do
                    color[i] = func.round((color[i] + 0.1), 1)
                end
            elseif (val.value == "darken") and ((color[1] > 0.0) or (color[2] > 0.0) or (color[3] > 0.0)) then
                for i = 1, 3 do 
                    color[i] = func.round((color[i] - 0.1), 1)
                end
            end
        end
    end
    return
end


-- create a shallow copy of the provided color
function func.copyColor(color, colorTable)
    if colorTable.color[color] then
        -- with help from bing's copilot since I didn't know "unpack()" can be used for deep copying
        local tmpColor = {unpack(colorTable.color[color])}
        return tmpColor
    end
end


-- create a shallow copy of the provided color table
function func.copyColorTable(color, colorTable)
    if colorTable.table[color] then
        local origColor = colorTable.table[color]
        local tmpColorTable = {}

        for key, val in pairs(origColor) do
            -- with help from bing's copilot since I didn't know "unpack()" can be used for deep copying
            tmpColorTable[key] = {unpack(val)}
        end
        return tmpColorTable
    end
end


-- creates a Rectangle either for background or as a button
function func.createRectangle(obj)
    local txtPosX = 0
    local txtPosY = 0
    -- ensure each object has the correct font size, by setting the font size to its text_size
    local tmpFontSize = love.graphics.newFont(obj.txtSize)
    love.graphics.setFont(tmpFontSize)

    if obj.txt then
        -- check if the object text fits or gets wrapped inside the object, and if so adjust the position of the text to vertically center it inside the object
        local txtWidth, numberOfLines = tmpFontSize:getWrap(obj.txt, obj.width)

        if #numberOfLines > 1 then
            txtPosX = obj.x 
            txtPosY = obj.y + (obj.centerY - obj.txtSize) - 2
        else
            txtPosX = obj.x + 1
            txtPosY = obj.y + (obj.centerY - (obj.txtSize / 2)) - 1
        end
    end
    love.graphics.setColor(obj.color.colorCurrent)
    love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height, obj.radius, obj.radius, obj.segments)
    love.graphics.setColor(obj.color.colorTxt)
    love.graphics.printf(obj.txt, txtPosX, txtPosY, obj.width, "center")
    return
end


function func.createText(txt)
    local font = love.graphics.newFont(txt.fontSize)
    love.graphics.setFont(font)
    love.graphics.printf(txt.txt, txt.x, txt.y, txt.width, txt.align)
    return    
end


function func.decimalLength(input) 
    if type(input) == "number" then
        local string = tostring(input)
        -- the pattern comes from openAi which omits the dot itself as well
        local value = string:match("%.(%d+)")
        dec = string.len(value)
        return dec
    end
    return
end


-- erase all drawings from current drawing method
function func.eraseDrawing(variables, controls, methodTable)
    local keyBoard = controls.keyBoard
    local method = variables.drawMethod
    if (keyBoard == "backspace") and methodTable[method[1]].table then
        local tables = methodTable[method[1]].table

        for index = #tables, 1, -1 do
            if method[1] ~= "line" and method[1] ~= "polygon" then
                for num = #tables[index], 1, -1  do
                    tables[index][num] = nil
                end
            end
            tables[index] = nil
        end
    end
    return
end


-- checks whether mouse is hovering over given coordinates or not
function func.isHover(posX, posY, width, height)
    local mouseX, mouseY = love.mouse.getPosition()

    if (mouseX >= posX and mouseX <= (posX + width)) 
    and (mouseY >= posY and mouseY <= (posY + height)) then
        return true
    else
        return false
    end
end


-- couldn't find any other way using the mouse wheel outside of the wheelmoved callback function
-- returns wheel position back to 0 and keyboard input from the callback function to "BLANK"
function func.normalizer(input)
    if type(input[1]) == "string" then
        input[1] = "BLANK"
    elseif type(input[1]) == "number" then
        input[1] = 0
    end
    return
end


-- prepare the coordinates for saveCoordinates by creating the correct table for the drawing method
local function prepareCoordinates(method, methodTable, tmpTable)
    if (methodTable[method[1]].table) and (#methodTable[method[1]].table > 0) then
       local value = methodTable[method[1]].table
        -- create the first line with the title of the draw method
        table.insert(tmpTable, method[1])

        if method[1] == "line" or method[1] == "polygon" then
            local data = table.concat(value, ", ")
            table.insert(tmpTable, data)
        elseif method[1] ~= "line" and method[1] ~= "polygon" then
            for key, val in pairs(value) do
                local data = table.concat(val, ", ")
                table.insert(tmpTable, data)
            end
        end
    end
    return
end


-- takes the value and a decimal number, which it rounds to the nearest value 
function func.round(val, dec)
    if (val == nil)  then
        return error("round function needs a value, additionally a decimal number")
    end

    if (dec ~= nil) and (dec < 0) then
        return error("decimal must be positive")
    end

    local num = val
    local rounder = 0.5

    -- if decimal was provided and is not set to 0
    if (dec ~= nil) and (dec ~= 0) then
        local decNum = 10
        decNum = math.pow(decNum, dec)
        num = (num * decNum) + rounder 
        num = math.floor(num)
        num = num / decNum
        return num
    end
    
    -- if decimal wasn't provided just round to an integer
    if (dec == 0) or (dec == nil) then
        num = num + rounder 
        num = math.floor(num)
        return num
    end
end


-- write the coordinates of the drawings to the dropped .txt file
function func.saveCoordinates(file, variables, methodTable)
    local method = variables.drawMethod
    local fileName = file:getFilename()
    -- file_name:match("%.%w+$") from https://www.love2d.org/wiki/love.filedropped
    local fileExt = string.lower(fileName:match("%.%w+$"))

    if fileExt == ".txt" then
        local tmpTable = {}

        prepareCoordinates(method, methodTable, tmpTable)

        local opened, failed = file:open("a")
        if failed then
            print("File couldn't be opened", failed)
            return 
        end

        for key, value in ipairs(tmpTable) do
            -- .."\n" newline from bing's copilot, couldn't find it on the internet
            file:write(value .."\n")
        end

        file:close()
        -- since the program can lose focus when dropping a file
        love.window.requestAttention(false)
    end
    return
end


return func
