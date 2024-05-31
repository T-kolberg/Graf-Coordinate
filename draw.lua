local draw = {}


function draw.colorButtons(controls, buttonTable)
    for key, val in pairs(buttonTable) do
        if key ~= "colorField" then
            for index, obj in pairs(val) do
                func.createRectangle(obj)
                func.buttonBehavior(controls, obj)
            end
        end
    end
    return
end


function draw.drawColor(variables, controls, table, colorTable)
    local mouseKey = controls.keyMouse
    local field = table.colorField

    -- only run the loop when mouse is hovering over any of the color buttons
    if func.isHover(field.x, field.y, field.width, field.height) then
        local colorButtonTable = table.color
        
        for key, val in pairs(colorButtonTable) do
            if func.isHover(val.x, val.y, val.width, val.height) and mouseKey == 1 then
                variables.drawColor = func.copyColor(val.value, colorTable)
            end  
        end
    end
    return
end


-- code and adjustment to the angles with help from bing's copilot
function draw.storeArc(variables, controls, tables, methodTable)
    if variables.drawMethod[1] == "arc" then
        local mode = variables.mode
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local segments = tables.segments
        local coordinates = methodTable.arc.table
        local keypressCount = methodTable.arc.variables.keypressCount
        local x1 = methodTable.arc.variables.x1
        local y1 = methodTable.arc.variables.y1
        local radius = methodTable.arc.variables.radius
        local angle1 = methodTable.arc.variables.angle1
        local angle2 = methodTable.arc.variables.angle2

        if keypressCount[1] == 0 then
            x1[1] = mouseX
            y1[1] = mouseY
            keypressCount[1] = 1
        elseif keypressCount[1] == 1 then
            radius[1] = math.sqrt((mouseX - x1[1])^2 + (mouseY - y1[1])^2)
            angle1[1] = math.atan2((mouseY - y1[1]), (mouseX - x1[1]))
            keypressCount[1] = 2
        elseif keypressCount[1] == 2 then
            angle2[1] = math.atan2((mouseY - y1[1]), (mouseX - x1[1]))
            if angle2[1] < angle1[1] then
                angle2[1] = angle2[1] + (math.pi * 2)
            end
            table.insert(coordinates, {mode[1], x1[1], y1[1], func.round(radius[1], 2), func.round(angle1[1], 2), func.round(angle2[1], 2), segments[1]})
            keypressCount[1] = 0
        end
    end
    return 
end


function draw.drawArc(variables, controls, tables, methodTable)
    if variables.drawMethod[1] == "arc" then
        local color = variables.drawColor
        local mode = variables.mode
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local segments = tables.segments
        local coordinates = methodTable.arc.table
        local keypressCount = methodTable.arc.variables.keypressCount
        local x1 = methodTable.arc.variables.x1
        local y1 = methodTable.arc.variables.y1
        local radius = methodTable.arc.variables.radius
        local angle1 = methodTable.arc.variables.angle1
        local angle2 = methodTable.arc.variables.angle2
        love.graphics.setColor(color)

        -- live preview
        if keypressCount[1] == 1 then 
            local tmpRadius = math.sqrt((mouseX - x1[1])^2 + (mouseY - y1[1])^2)
            love.graphics.circle(mode[1], x1[1], y1[1], tmpRadius, segments[1])
        end

        if keypressCount[1] == 2 then
            local liveAngle = math.atan2((mouseY - y1[1]), (mouseX - x1[1]))
            if liveAngle < angle1[1] then
                liveAngle = liveAngle + (math.pi * 2)
            end
            love.graphics.arc(mode[1], x1[1], y1[1], radius[1], angle1[1], liveAngle, segments[1])  
        end

        for key, val in ipairs(coordinates) do 
            love.graphics.arc(unpack(val)) 
        end
    end  
    return 
end


function draw.storeCircle(variables, controls, tables, methodTable)
    if variables.drawMethod[1] == "circle" then
        local mode = variables.mode
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local segments = tables.segments
        local coordinates = methodTable.circle.table
        local keypress = methodTable.circle.variables.keypress
        local x1 = methodTable.circle.variables.x1
        local y1 = methodTable.circle.variables.y1

        if keypress[1] == false then
            x1[1] = mouseX
            y1[1] = mouseY
            keypress[1] = true
        elseif keypress[1] == true then
            local radius = math.sqrt((mouseX - x1[1])^2 + (mouseY - y1[1])^2)
            table.insert(coordinates, {mode[1], x1[1], y1[1], func.round(radius, 2), segments[1]})
            keypress[1] = false
        end
    end
end


function draw.drawCircle(variables, controls, tables, methodTable)
    if variables.drawMethod[1] == "circle" then
        local color = variables.drawColor
        local mode = variables.mode 
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local segments = tables.segments
        local coordinates = methodTable.circle.table
        local keypress = methodTable.circle.variables.keypress
        local x1 = methodTable.circle.variables.x1
        local y1 = methodTable.circle.variables.y1
        love.graphics.setColor(color)

        if keypress[1] == true then
            local tmpRadius = math.sqrt((mouseX - x1[1])^2 + (mouseY - y1[1])^2)
            love.graphics.circle(mode[1], x1[1], y1[1], tmpRadius, segments[1])
        end

        for key, val in ipairs(coordinates) do    
            love.graphics.circle(unpack(val))
        end
    end
end


function draw.storeEllipse(variables, controls, tables, methodTable)
    if variables.drawMethod[1] == "ellipse" then
        local mode = variables.mode
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local segments = tables.segments
        local coordinates = methodTable.ellipse.table
        local keypress = methodTable.ellipse.variables.keypress
        local x1 = methodTable.ellipse.variables.x1
        local y1 = methodTable.ellipse.variables.y1

        if keypress[1] == false then
            x1[1] = mouseX
            y1[1] = mouseY
            keypress[1] = true
        elseif keypress[1] == true then
            table.insert(coordinates, {mode[1], x1[1], y1[1], (mouseX - x1[1]), (mouseY - y1[1]), segments[1]})
            keypress[1] = false
        end
    end
    return
end


function draw.drawEllipse(variables, controls, tables, methodTable)
    if variables.drawMethod[1] == "ellipse" then
        local color = variables.drawColor
        local mode = variables.mode
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local segments = tables.segments
        local coordinates = methodTable.ellipse.table
        local keypress = methodTable.ellipse.variables.keypress
        local x1 = methodTable.ellipse.variables.x1
        local y1 = methodTable.ellipse.variables.y1
        love.graphics.setColor(color)

        if keypress[1] == true then
            love.graphics.ellipse(mode[1], x1[1], y1[1], (mouseX - x1[1]), (mouseY - y1[1]), segments[1])
        end

        for key, val in ipairs(coordinates) do
            love.graphics.ellipse(unpack(val))
        end
    end
    return
end


function draw.storeLine(variables, controls, methodTable)
    if variables.drawMethod[1] == "line" then
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local coordinates = methodTable.line.table
        local keypress = methodTable.line.variables.keypress
        local x1 = methodTable.line.variables.x1
        local y1 = methodTable.line.variables.y1
        x1[1] = mouseX
        y1[1] = mouseY
        table.insert(coordinates, x1[1])
        table.insert(coordinates, y1[1])
    end
    return
end


function draw.drawLine(variables, controls, methodTable)
    if variables.drawMethod[1] == "line" then
        local color = variables.drawColor
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local coordinates = methodTable.line.table
        local x1 = methodTable.line.variables.x1
        local y1 = methodTable.line.variables.y1
        love.graphics.setColor(unpack(color))

        -- line preview
        if #coordinates > 1 then 
            love.graphics.line(x1[1], y1[1], mouseX, mouseY)
        end

        if #coordinates > 2 then
            love.graphics.line(unpack(coordinates))
        end
    end
    return
end


function draw.storePoint(variables, controls, methodTable)
    if variables.drawMethod[1] == "point" then
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local coordinates = methodTable.point.table
        table.insert(coordinates, {mouseX, mouseY})
    end
    return
end


function draw.drawPoint(variables, controls, methodTable)
    if variables.drawMethod[1] == "point" then
        local color = variables.drawColor
        local coordinates = methodTable.point.table
        love.graphics.setColor(color)
        love.graphics.setPointSize(2)

        for key, val in ipairs(coordinates) do
            love.graphics.points(unpack(val))
        end
    end
    love.graphics.setPointSize(1)
    return
end


function draw.storePolygon(variables, controls, methodTable)
    if variables.drawMethod[1] == "polygon" then
        local mode = variables.mode
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local coordinates = methodTable.polygon.table
        local x1 = methodTable.polygon.variables.x1
        local y1 = methodTable.polygon.variables.y1
        local x2 = methodTable.polygon.variables.x2
        local y2 = methodTable.polygon.variables.y2

        if #coordinates == 0 then
            x1[1] = mouseX
            y1[1] = mouseY
            table.insert(coordinates, mode[1])
            table.insert(coordinates, x1[1])
            table.insert(coordinates, y1[1])
        elseif #coordinates > 2 then
            x2[1] = mouseX
            y2[1] = mouseY
            table.insert(coordinates, x2[1])
            table.insert(coordinates, y2[1]) 
        end
    end
    return
end


function draw.drawPolygon(variables, controls, methodTable)
    if variables.drawMethod[1] == "polygon" then
        local color = variables.drawColor
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local coordinates = methodTable.polygon.table
        local x1 = methodTable.polygon.variables.x1
        local y1 = methodTable.polygon.variables.y1
        local x2 = methodTable.polygon.variables.x2
        local y2 = methodTable.polygon.variables.y2
        love.graphics.setColor(color)

        if #coordinates > 0 then
            love.graphics.line(x1[1], y1[1], mouseX, mouseY)
        end

        if #coordinates > 3 then
            love.graphics.line(x1[1], y1[1], x2[1], y2[1], mouseX, mouseY)
        end

        if #coordinates > 5 then
            love.graphics.polygon(unpack(coordinates))
        end
    end
    return
end


function draw.storeRectangle(variables, controls, adjData, methodTable)
    if variables.drawMethod[1] == "rectangle" then
        local mode = variables.mode
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local cornerRadX = adjData.cornerRadX
        local cornerRadY = adjData.cornerRadY
        local segments = adjData.segments
        local coordinates = methodTable.rectangle.table
        local keypress = methodTable.rectangle.variables.keypress
        local x1 = methodTable.rectangle.variables.x1
        local y1 = methodTable.rectangle.variables.y1

        if keypress[1] == false then
            x1[1] = mouseX
            y1[1] = mouseY
            keypress[1] = true
        elseif keypress[1] == true then
            local width = mouseX - x1[1]
            local height = mouseY - y1[1]
            table.insert(coordinates, {mode[1], x1[1], y1[1], width, height, cornerRadX[1], cornerRadY[1], segments[1]}) 
            keypress[1] = false
        end 
    end
    return
end


function draw.drawRectangle(variables, controls, adjData, methodTable)
    if variables.drawMethod[1] == "rectangle" then
        local color = variables.drawColor
        local mode = variables.mode
        local mouseX = controls.mouseX
        local mouseY = controls.mouseY
        local cornerRadX = adjData.cornerRadX
        local cornerRadY = adjData.cornerRadY
        local segments = adjData.segments
        local coordinates = methodTable.rectangle.table
        local keypress = methodTable.rectangle.variables.keypress
        local x1 = methodTable.rectangle.variables.x1
        local y1 = methodTable.rectangle.variables.y1
        love.graphics.setColor(color)

        -- live preview 
        if keypress[1] == true then
            local width = mouseX - x1[1]
            local height = mouseY - y1[1]
            love.graphics.rectangle(mode[1], x1[1], y1[1], width, height, cornerRadX[1], cornerRadY[1], segments[1]) 
        end

        for key, val in ipairs(coordinates) do
            love.graphics.rectangle(unpack(val))
        end
    end  
    return         
end


return draw