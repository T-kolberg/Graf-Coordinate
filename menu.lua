func = require("func")

local menu = {}

function menu.loadInfo(variables, infoTable)
    if variables.infoActive[1] then
        local background = infoTable.background
        local text = infoTable.text
        func.createRectangle(background)

        for key, val in pairs(text) do
            func.createText(val)
        end
    end
    return 
end


function menu.disableInfo(variables, controls, infoTable)
    local infoActive = variables.infoActive
    local mouseKey = controls.keyMouse
    local infoField = infoTable.background
    if func.isHover(infoField.x, infoField.y, infoField.width, infoField.height) and mouseKey == 1 then
        infoActive[1] = false
    end
    return
end


function menu.loadMenu(controls, table)
    local button = table.quitButton

    for key, val in pairs(table.menuFrame) do
        func.createRectangle(val)
    end

    for index, obj in pairs(table.menuTitles) do
        func.createText(obj)
    end

    func.createRectangle(button)
    func.buttonBehavior(controls, button)
    
    -- create the X for the quit button
    love.graphics.line(
        (button.x + 10), 
        (button.y + 10), 
        (button.x + button.width - 10), 
        (button.y + button.height - 10)
    )
    love.graphics.line(
        (button.x + button.width - 10), 
        (button.y + 10), 
        (button.x + 10), 
        (button.y + button.height - 10)
    )
    return
end


function menu.loadImg(file, variables)
    local image = variables.image
    local hasScaled = variables.hasScaled
    local scaleFactor = variables.scaleFactor

    local imgSupport = {".jpg", ".jpeg", ".png", ".bmp", ".tga", ".hdr", ".exr"}
    local file = file
    local fileName = file:getFilename()
    -- fileName:match("%.%w+$") from https://www.love2d.org/wiki/love.filedropped
    local fileExt = string.lower(fileName:match("%.%w+$"))

    for key, val in ipairs(imgSupport) do
        if fileExt == val then
            local opened, failed = file:open("r")
            if failed then 
                print("Failed to open image", failed)
                return
            end

            local fileData = file:read("data")
            local imgData = love.image.newImageData(fileData)
            image[1] = love.graphics.newImage(imgData)
            file:close()

            -- since the program will likely loose focus when dropping a file
            love.window.requestAttention(false)
            -- make sure every new image is scaled again
            hasScaled[1] = false
            scaleFactor[1] = 1
        end
    end
    return
end


function menu.drawImg(variables, menuFrame, adjData)
        local image = variables.image
        local hasScaled = variables.hasScaled
        local scaleFactor = variables.scaleFactor
        
    if image[1] then
        local screenWidth, screenHeight = love.graphics.getDimensions()
        local menuWidth = menuFrame.verticalMenu.width
        local menuHeight = menuFrame.horizontalMenu.height
        local screenSpaceWidth = (screenWidth - menuWidth)
        local screenSpaceHeight = (screenHeight - menuHeight)
        local imgWidth, imgHeight = image[1]:getDimensions()
        local posX = adjData.imgPosX
        local posY = adjData.imgPosY
        local imgRot = adjData.imgRotation
        local scale = adjData.imgScale
        local imgCenterX = (imgWidth / 2)
        local imgCenterY = (imgHeight / 2)

        -- resize image if it is larger than the displayable size
        if hasScaled[1] == false then
            scale[1] = 1
            while ((imgWidth * scale[1]) > screenSpaceWidth) or ((imgHeight * scale[1]) > screenSpaceHeight) do
                scale[1] = func.round((scale[1] - 0.1), 1)
            end
            hasScaled[1] = true
            scaleFactor[1] = func.round(scaleFactor[1] / scale[1]) 
        end

        local centerX = (((screenWidth + menuWidth) / 2) + posX[1])
        local centerY = (((screenHeight + menuHeight) / 2) + posY[1])
        -- setColor adjusts the brightness of the image 
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(image[1], centerX, centerY, imgRot[1], scale[1], scale[1], imgCenterX, imgCenterY)
    end
    return
end


function menu.displayLiveMousePos(controls, table)
    local mouseX = controls.mouseX
    local mouseY = controls.mouseY
    func.createRectangle(table.background)

    for key, val in pairs(table.headerTable) do
        func.createText(val)
    end

    local mouseXData = table.dataTable.mouseXData
    local mouseYData = table.dataTable.mouseYData
    mouseXData.txt = mouseX
    mouseYData.txt = mouseY
    func.createText(mouseXData)
    func.createText(mouseYData)
    return
end


local function adjSegmentAndCorner(controls, data)
    local keyBoard = controls.tmpKey[1]
    local wheelY = controls.tmpWheelY[1]

    if (wheelY > 0) or (keyBoard == "+") or (keyBoard == "kp+") then 
        data = data + 1
    elseif ((wheelY < 0) or (keyBoard == "-") or (keyBoard == "kp-")) and (data > 0) then
        data = data - 1
    end
    return data
end


local function adjImgRot(controls, data)
    local keyBoard = controls.tmpKey[1]
    local wheelY = controls.tmpWheelY[1]

    if (wheelY > 0) or (keyBoard == "+") or (keyBoard == "kp+") then
        if love.keyboard.isDown("lshift") then
            data = func.round((data + 0.01), 2)
        else
            data = func.round((data + 0.1), 1)
        end
    elseif (wheelY < 0) or (keyBoard == "-") or (keyBoard == "kp-") then
        if love.keyboard.isDown("lshift") then
            data = func.round((data - 0.01), 2)
        else
            data = func.round((data - 0.1), 1)
        end
    end
    return data
end


local function adjImgScale(variables, controls, data)
    local scaleFactor = variables.scaleFactor
    local keyBoard = controls.tmpKey[1]
    local wheelY = controls.tmpWheelY[1]
    local dec = (1 / (scaleFactor[1] * 10))
    local decLen = func.decimalLength(dec)
    local decPrecise = (1 / (scaleFactor[1] * 100))
    local decPreciseLen = func.decimalLength(decPrecise)

    if (wheelY > 0) or (keyBoard == "+") or (keyBoard == "kp+") then
        if love.keyboard.isDown("lshift") then
            data = func.round((data + decPrecise ), decPreciseLen)
        else
            data = func.round((data + dec), decLen)
        end
    elseif (wheelY < 0) or (keyBoard == "-") or (keyBoard == "kp-") then
        if love.keyboard.isDown("lshift") then
            data = func.round((data - decPrecise), decPreciseLen)
        else
            data = func.round((data - dec), decLen)
        end
    end
    return data
end


local function adjustImgPos(controls, data)
    local keyBoard = controls.tmpKey[1]
    local wheelY = controls.tmpWheelY[1]

    if (wheelY > 0) or (keyBoard == "+") or (keyBoard == "kp+") then
        if love.keyboard.isDown("lshift") then
            data = func.round((data + 0.1), 1)
        else
            data = data + 1
        end
    elseif (wheelY < 0) or (keyBoard == "-") or (keyBoard == "kp-") then
        if love.keyboard.isDown("lshift") then
            data = func.round((data - 0.1), 1)
        else
            data = data - 1
        end
    end
    return data 
end


function menu.displayAdjData(table)
    -- key/value table are assigned to temporary tables to iterate in order by index
    local headerTable = {
        table.headerTable.segments, 
        table.headerTable.cornerRadX, 
        table.headerTable.cornerRadY, 
        table.headerTable.imgRotation,
        table.headerTable.imgScale, 
        table.headerTable.imgPosX, 
        table.headerTable.imgPosY, 
    }
    local dataTable = {
        table.dataTable.segments, 
        table.dataTable.cornerRadX, 
        table.dataTable.cornerRadY, 
        table.dataTable.imgRotation,
        table.dataTable.imgScale, 
        table.dataTable.imgPosX, 
        table.dataTable.imgPosY, 
    }

    func.createRectangle(table.background)

    for index = 1, #headerTable do
        func.createText(headerTable[index])
        func.createText(dataTable[index])
    end
    return
end


-- main function for adjusting the data of the horizontal menu 
function menu.adjDataInteraction(variables, controls, adjData, dataField, menuFrame)
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local posX = menuFrame.verticalMenu.width
    local posY = menuFrame.horizontalMenu.height
    local width = screenWidth - posX
    local height = screenHeight - posY

    for key, val in pairs(dataField.headerTable) do 
        if (key == "segments") and 
        (
            func.isHover(posX, posY, width, height) or func.isHover(val.x, val.y, val.width, 30) 
        ) then

            adjData[key][1] = adjSegmentAndCorner(controls, adjData[key][1])

        elseif func.isHover(val.x, val.y, val.width, 30) then
            -- value stays integer for these data types
            if (key == "cornerRadX") or (key == "cornerRadY") then 
                adjData[key][1] = adjSegmentAndCorner(controls, adjData[key][1])
            -- value changes from 1 to 2 decimal points based on the use of lshift
            elseif (key == "imgRotation") then
                adjData[key][1] = adjImgRot(controls, adjData[key][1])
            -- decimal points change based on the size of the image
            elseif (key == "imgScale") then
                adjData[key][1] = adjImgScale(variables, controls, adjData[key][1])
            --value changes from integer to 1 decimal point based on the use of lshift
            elseif (key == "imgPosX") or (key == "imgPosY") then
                adjData[key][1] = adjustImgPos(controls, adjData[key][1])
            end
        end    
    end
    return
end


local function menuButton(main, controls, snapEnabled)
    local leftMouse = controls.leftMouse
    -- create the menu button
    func.createRectangle(main.button)
    func.buttonBehavior(controls, main.button)

    if func.isHover(main.button.x, main.button.y, main.button.width, main.button.height) and leftMouse then
        main.dropdownEnabled = true
        snapEnabled[1] = false
    end
    return
end


local function createDropdownButtons(method, controls, drawMethod)
    local leftMouse = controls.leftMouse
    -- create the nested buttons
    func.createRectangle(method.button)
    func.buttonBehavior(controls, method.button)

    -- if method doesn't contain a dropdown and is clicked, change global drawMethod to the buttons value
    if func.isHover(method.button.x, method.button.y, method.button.width, method.button.height) and leftMouse then
        drawMethod[1] = method.button.value
    end
    return
end


-- create the nested dropdown, the title with its background changed to colorActive, and the buttons of the nested dropdown
local function createNestedDropdown(method, controls, mode)
    local colorCurrent = method.mode.background.color.colorCurrent
    local colorActive = method.mode.background.color.colorActive
    local leftMouse = controls.leftMouse

    func.createRectangle(method.dropdown)
    method.mode.background.color.colorCurrent = method.mode.background.color.colorActive
    --colorCurrent = colorActive
    func.createRectangle(method.mode.background)

    for key, val in pairs(method.mode.button) do
        func.createRectangle(val)
        func.buttonBehavior(controls, val)

        -- set mode to the button's value if clicked either line or fill
        if func.isHover(val.x, val.y, val.width, val.height) and leftMouse then 
            mode[1] = val.value 
        end
    end
    return
 
end


-- make sure the nested dropdown closes when user isn't hovering over it or the corresponding button
local function nestedDropdownCheck(method)
    if (func.isHover(method.button.x - 10, method.button.y, method.button.width + 10, method.button.height) == false ) then
        if (func.isHover(method.dropdown.x - 10, method.dropdown.y, method.dropdown.width + 10, method.dropdown.height) == false) then
            method.nestedDropdownEnabled = false
        end
    end 
    return
end


-- checking whether user hovers over any part of the complete dropdown menu
local function dropdownIsHover(main, method, snapEnabled)
    -- check if user is hovering over any part of the dropdown list including the nested dropdowns
    if (func.isHover(main.button.x, main.button.y, main.button.width, main.button.height) == false) then
        if (func.isHover(main.dropdown.x, main.dropdown.y, main.dropdown.width + 10, main.dropdown.height) == false) then
            local check = false

            for key, val in pairs(method) do
                if val.nestedDropdownEnabled == true then
                    check = true 
                end
            end

            if check == false then 
                main.dropdownEnabled = false
                snapEnabled[1] = true
            end
        end
    end
    return
end


-- main dropdown function
function menu.dropdown(variables, controls, table)
    local leftMouse = controls.leftMouse
    local main = table.main
    local methods = table.methods
    local mode = variables.mode
    local drawMethod = variables.drawMethod
    local snapEnabled = variables.snapEnabled

    menuButton(main, controls, snapEnabled)

    if main.dropdownEnabled == true then
        -- create the main dropdown with its buttons
        func.createRectangle(main.dropdown)
        for key, val in pairs(methods) do
            
            createDropdownButtons(val, controls, drawMethod)
            -- if the method has a dropdown 
            if val.nestedDropdownEnabled ~= nil then
                if func.isHover(val.button.x, val.button.y, val.button.width, val.button.height) and leftMouse then
                    val.nestedDropdownEnabled = true
                end

                if val.nestedDropdownEnabled == true then
                    createNestedDropdown(val, controls, mode)
                end
                nestedDropdownCheck(val)
            end
            -- check if user is hovering over any part of the dropdowns otherwise turn dropdownEnabled to false
            dropdownIsHover(main, methods, snapEnabled)
        end        
    end
    return
end


local function linePolygonCoordinates(method, value, headerTable) 
    -- using tableIndex to iterate over the keys stored at the index position
    -- these keys are then used to iterate over the tableData which consists of key/value pairs
    local tableIndex = headerTable[method].index
    local tableData = headerTable[method].table
    local data = ""
    local num = 0

    -- since line and polygon adding positions to the data instead of creating a new set of positions
    -- they both need to be iterated backwards from their length
    if method == "line" then 
        num = 3
    elseif method == "polygon" then
        -- since polygon has a Mode of "line" or "fill" which needs to stay at the first position
        -- without being overwritten by the data of the coordinates
        num = 5
        local polyHeader = tableData["mode"]
        local polyData = Text(value[1], tableData["mode"].x, 25, tableData["mode"].width)
        func.createText(polyHeader)
        func.createText(polyData)
    end

    for index = 0, num  do
        local tableValues = tableData[tableIndex[#tableIndex - index]]
        if type(value[#value - index]) == "number" then
            data = func.round(value[#value - index])
        else 
            data = value[#value - index]
        end

        local tempHeader = tableValues
        local tempData = Text(data, tableValues.x, 25, tableValues.width)
        func.createText(tempHeader)
        func.createText(tempData)
    end
    return
end


local function allOtherCoordinates(method, value, headerTable)
    -- using tableIndex to iterate over the keys stored at the index position
    -- these keys are then used to iterate over the tableData which consists of key, value pairs
    local tableIndex = headerTable[method].index
    local tableData = headerTable[method].table
    local data = ""

    for index = 1, #value do
        local tableValues = tableData[tableIndex[index]]
        data = value[index]
        local tempHeader = tableValues
        local tempData = Text(data, tableValues.x, 25, tableValues.width)
        func.createText(tempHeader)
        func.createText(tempData)
    end
    return
end


function menu.displayCoordinates(variables, methodTable, displayCoordinates)
    local value = {}
    local method = variables.drawMethod
    func.createRectangle(displayCoordinates.background)

    -- if the methodTable exists with the current draw method
    if methodTable[method[1]].table then      
        -- method line and polygon can be directly accessed while others need to be iterated before being assigned to value
        if (method[1] == "line" or method[1] == "polygon") then
            value = methodTable[method[1]].table
        elseif (method[1] ~= "line" and method[1] ~= "polygon") then   
            for key, val in pairs(methodTable[method[1]].table) do
                value = val
            end
        end

        if value then 
            -- method line and polygon are appending data to their coordinates instead of creating a new set of coordinates
            if (method[1] == "line" or method[1] == "polygon") and #value > 5 then
                linePolygonCoordinates(method[1], value, displayCoordinates.headerTable)
            else
                allOtherCoordinates(method[1], value, displayCoordinates.headerTable) 
            end
        end
    end
    return
end


function menu.quit(controls, button) 
    local mouseKey = controls.keyMouse
    
    if func.isHover(button.x, button.y, button.width, button.height) and mouseKey == 1 then
        love.event.quit()
    end
    return
end 











return menu
