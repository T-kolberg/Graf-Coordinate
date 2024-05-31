-- tip from openAi since I was unable to pass local functions from other files over to main
-- I didn't think of passing the functions inside a local table over to main

local menu = require("menu")
local grid = require("grid")
local tables = require("tables")
local draw = require("draw")
local func = require("func")


function love.filedropped(file)
    if tables.variables.infoActive[1] == false then
        func.saveCoordinates(file, tables.variables, tables.methods)
        menu.loadImg(file, tables.variables)
    end
end


function love.keypressed(keyBoard)
    tables.controls.keyBoard = keyBoard
    tables.controls.tmpKey[1] = keyBoard
    if keyBoard == "space" then
        tables.controls.keySpace = true
    end

    if tables.variables.infoActive[1] == false then
        if keyBoard == "space" then
            draw.storeArc(tables.variables, tables.controls, tables.adjData, tables.methods)
            draw.storeCircle(tables.variables, tables.controls, tables.adjData, tables.methods)
            draw.storeEllipse(tables.variables, tables.controls, tables.adjData, tables.methods)
            draw.storeLine(tables.variables, tables.controls, tables.methods)
            draw.storePoint(tables.variables, tables.controls, tables.methods)
            draw.storePolygon(tables.variables, tables.controls, tables.methods) 
            draw.storeRectangle(tables.variables, tables.controls, tables.adjData, tables.methods)   
        end
        func.eraseDrawing(tables.variables, tables.controls, tables.methods)
    end
end


function love.mousepressed(posX, posY, mouseKey)
    tables.controls.keyMouse = mouseKey

    menu.disableInfo(tables.variables, tables.controls, tables.info)

    if tables.variables.infoActive[1] == false then
        func.changeAlpha(tables.variables.drawColor, tables.controls, tables.colorButtons)
        func.changeAlpha(tables.variables.gridColor, tables.controls, tables.gridButtons)
        func.changeBrightness(tables.variables.drawColor, tables.controls, tables.colorButtons)
        func.changeBrightness(tables.variables.gridColor, tables.controls, tables.gridButtons)
        grid.gridSize(tables.variables, tables.controls, tables.gridButtons)
        grid.color(tables.variables, tables.controls, tables.gridButtons, tables.colorTable)
        grid.gridEnabled(tables.variables, tables.controls, tables.gridButtons.gridEnabled)
        draw.drawColor(tables.variables, tables.controls, tables.colorButtons, tables.colorTable)
        menu.quit(tables.controls, tables.menu.quitButton)
    end
end


function love.wheelmoved(wheelX, wheelY) 
    tables.controls.tmpWheelY[1] = wheelY
end


function love.update(dt)
    tables.controls.mouseX, tables.controls.mouseY = love.mouse.getPosition()
    tables.controls.leftMouse = love.mouse.isDown(1)

    if tables.variables.infoActive[1] == false then
        grid.snapGrid(tables.variables, tables.controls, tables.menu.menuFrame)
        menu.adjDataInteraction(tables.variables, tables.controls, tables.adjData, tables.adjDataField, tables.menu.menuFrame)
        func.normalizer(tables.controls.tmpWheelY)
        func.normalizer(tables.controls.tmpKey)
    end
end


function love.draw()
    -- scaling, to avoid blurring
    love.graphics.setDefaultFilter("nearest", "nearest")

    menu.loadInfo(tables.variables, tables.info)

    if tables.variables.infoActive[1] == false then
        menu.drawImg(tables.variables, tables.menu.menuFrame, tables.adjData)

        draw.drawArc(tables.variables, tables.controls, tables.adjData, tables.methods)
        draw.drawCircle(tables.variables, tables.controls, tables.adjData, tables.methods)
        draw.drawEllipse(tables.variables, tables.controls, tables.adjData, tables.methods)
        draw.drawLine(tables.variables, tables.controls, tables.methods)
        draw.drawPoint(tables.variables, tables.controls, tables.methods)
        draw.drawPolygon(tables.variables, tables.controls, tables.methods)
        draw.drawRectangle(tables.variables, tables.controls, tables.adjData, tables.methods)

        -- in order how they are displayed, first grid, then menu horizontal and vertical
        grid.loadGrid(tables.variables, tables.menu.menuFrame)
        menu.loadMenu(tables.controls, tables.menu)
        menu.displayLiveMousePos(tables.controls, tables.mouseLivePos)
        menu.displayAdjData(tables.adjDataField)
        menu.dropdown(tables.variables, tables.controls, tables.menuDropdown)
        menu.displayCoordinates(tables.variables, tables.methods, tables.displayCoordinates)
        grid.gridButtons(tables.controls, tables.gridButtons)
        draw.colorButtons(tables.controls, tables.colorButtons)
    end
end

