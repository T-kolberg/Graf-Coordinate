local tables = {}

local screenWidth, screenHeight = love.graphics.getDimensions()
local screenCenterX = screenWidth / 2
local screenCenterY = screenHeight / 2

-- using functions to simulate classes, idea from Steve https://www.youtube.com/watch?v=I549C6SmUnk&t=6190s
function tables.Colors(x, y, z)
    if x > 0 or y > 0 or z > 0 then
        return {
            colorFull = {x, y, z, 1},
            colorCurrent = {x * 0.9, y * 0.9, z * 0.9, 1},
            colorStd = {x * 0.9, y * 0.9, z * 0.9, 1},
            colorHover = {x * 0.7, y * 0.7, z * 0.7, 1},
            colorClick = {x * 0.6, y * 0.6, z * 0.6, 1},
            colorActive = {x * 0.8, y * 0.8, z * 0.8, 1},
            colorTxt = {0.2, 0.2, 0.2, 1}
        }
    elseif x == 0 and y == 0 and z == 0 then
        return {
            colorFull = {x, y, z, 1},
            colorCurrent = {0.1, 0.1, 0.1, 1},
            colorStd = {0.1, 0.1, 0.1, 1},
            colorHover = {0.3, 0.3, 0.3, 1},
            colorClick = { 0.4, 0.4, 0.4, 1},
            colorActive = { 0.2, 0.2, 0.2, 1},
            colorTxt = {0.8, 0.8, 0.8, 1}
        }
    end
end


tables.colorTable = {
    table = {
        main = tables.Colors(0.9, 0.9, 0.9, 1),
        black = tables.Colors(0, 0, 0, 1),
        white = tables.Colors(1, 1, 1, 1),
        red = tables.Colors(1, 0, 0, 1),
        yellow = tables.Colors(1, 1, 0, 1),
        green = tables.Colors(0, 1, 0, 1),
        turquoise = tables.Colors(0, 1, 1, 1),
        blue = tables.Colors(0, 0, 1, 1),
        purple = tables.Colors(1, 0, 1, 1)
    },
    color = {
        main = {0.9, 0.9, 0.9, 1},
        black = {0, 0, 0, 1},
        white = {1, 1, 1, 1},
        red = {1, 0, 0, 1},
        yellow = {1, 1, 0, 1},
        green = {0, 1, 0, 1},
        turquoise = {0, 1, 1, 1},
        blue = {0, 0, 1, 1},
        purple = {1, 0, 1, 1}
    }
}


function Rectangle(x, y, width, height, value, text)
    return {
        x = x or 0,
        y = y or 0,
        width = width or 0,
        height = height or 0,
        centerX = (width / 2),
        centerY = (height / 2),
        value = value or "",
        txt = text or "",
        color = func.copyColorTable(value, tables.colorTable) or func.copyColorTable("main", tables.colorTable),
        txtSize = 12,
        isActive = false
    }
end


function Text(txt, x, y, width, align, fontSize)
    return {
        txt = txt,
        x = x,
        y = y,
        width = width,
        align = align or "center",
        fontSize = fontSize or 12
    }
end


tables.methods = {
    arc = {
        table = {},
        variables = {
            keypressCount = {0},
            x1 = {0},
            y1 = {0},
            radius = {0},
            angle1 = {0},
            angle2 = {0}
        }
    },
    circle = {
        table = {},
        variables = {
            keypress = {false},
            x1 = {0},
            y1 = {0}
        }
    },
    ellipse = {
        table = {},
        variables = {
            keypress = {false},
            x1 = {0},
            y1 = {0}
        }
    },
    line = {
        table = {},
        variables = {
            keypress = {false},
            x1 = {0},
            y1 = {0}
        }

    },
    point = {
        table = {}
    },
    polygon = {
        table = {},
        variables = {
            x1 = {0},
            y1 = {0},
            x2 = {0},
            y2 = {0}
        }
    },
    rectangle = {
        table = {},
        variables = {
            keypress = {false},
            x1 = {0},
            y1 = {0}
        }
    }
}


tables.info = {
    background = Rectangle((screenCenterX - 250), (screenCenterY - 250), 500, 500),

    text = {
        text1 = Text(
            "Graf Coordinate", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 5), 
            500, 
            "center", 
            24
        ),
        text2 = Text(
            "Instructions", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 60), 
            500, 
            "center", 
            18
        ),
        text3 = Text(
            "Space = Store the coordinate", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 100), 
            500, 
            "left"
        ),
        text4 = Text(
            "Left Mouse = Snap to the grid", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 120), 
            500, 
            "left"
        ),
        text5 = Text(
            "Backspace = Erase all drawings from the selected drawing method", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 140), 
            500, 
            "left"
        ),
        text6 = Text(
            "NUM +- or +- = Adjust values from the top menu by hovering over the titles",
            ((screenCenterX - 250) + 5),
            ((screenCenterY - 250) + 160),
            500,
            "left"
        ),
        textr7 = Text(
            "Mouse wheel = Adjust values from the top menu by hovering over the titles",
            ((screenCenterX - 250) + 5),
            ((screenCenterY - 250) + 180),
            500,
            "left"
        ),
        text7 = Text(
            "Hold Left Shift = Increases precision while adjusting values.", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 200), 
            500, 
            "left"
        ),
        text8 = Text(
            "Adjust Segments on the Grid or Title by using the mouse wheel or +- or NUM +-", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 260), 
            500, 
            "left"
        ),
        text9 = Text(
            "To save coordinates to a .txt file, drag&drop the file into the window and the coordinates will be added.", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 290), 
            500, 
            "left"
        ),
        text10 = Text(
            "To import an image, drag&drop the image into the window.", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 330), 
            500, 
            "left"
        ),
        text11 = Text(
            "Supported image types (jpg, png, bmp,tga, hdr, exr)", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 345), 
            500, 
            "left"
        ),
        text12 = Text(
            "Created by Tim Kolberg", 
            ((screenCenterX - 250) + 5), 
            ((screenCenterY - 250) + 485), 
            500, 
            "left", 
            10
        )
    }
}


tables.menu = {
    menuFrame = {
        horizontalMenu = Rectangle(0, 0, screenWidth, 50, "white"),
        verticalMenu = Rectangle(0, 0, 50, screenHeight, "white")
    },
    menuTitles = {
        grid = Text("Grid", 5, 62, 40),
        draw = Text("Draw", 5, 442, 40)
    },
    quitButton = Rectangle(screenWidth - 45, 5, 40, 40)
}


-- values of the variables are inside tables so functions can mutate them when passed as parameters
tables.controls = {
    keyBoard = "",
    tmpKey = {"BLANK"},
    keySpace = {false},
    keyMouse = "",
    leftMouse = false,
    mouseX = 0,
    mouseY = 0,
    tmpWheelY = {0}
}


-- values of the variables are inside tables so functions can mutate them when passed as parameters
tables.variables = {
    infoActive = {true},
    gridSize = {20},
    gridColor = func.copyColor("white", tables.colorTable),
    gridEnabled = {true},
    snapEnabled = {true},
    image = {nil},
    hasScaled = {false},
    scaleFactor = {1},
    drawMethod = {"line"},
    mode = {"line"},
    drawColor = func.copyColor("white", tables.colorTable)
}


tables.mouseLivePos = {
    background = Rectangle(5, 5, 80, 40, "black"),

    headerTable = {
        mouseXHead = Text("X", 5, 10, 40),
        mouseYHead = Text("Y", 45, 10, 40)
    },
    dataTable = {
        mouseXData = Text("", 5, 25, 40),
        mouseYData = Text("", 45, 25, 40)
    }
}


-- values of the variables are inside tables so functions can mutate them when passed as parameters
tables.adjData = {
    segments = {50},
    cornerRadX = {0},
    cornerRadY = {0},
    imgRotation = {0},
    imgScale = {1},
    imgPosX = {0},
    imgPosY = {0}
}


tables.adjDataField = {
    background = Rectangle(90, 5, 490, 40, "black"),
    headerTable = {
        segments = Text("Segments", 95, 10, 70),
        cornerRadX = Text("Corner X", 175, 10, 60),
        cornerRadY = Text("Corner Y", 245, 10, 60),
        imgRotation = Text("Img Rot", 315, 10, 50),
        imgScale = Text("Img Scale", 375, 10, 60),
        imgPosX = Text("Img PosX", 445, 10, 60),
        imgPosY = Text("Img PosY", 515, 10, 60)
    },
    dataTable = {
        segments = Text(tables.adjData.segments, 95, 25, 70),
        cornerRadX = Text(tables.adjData.cornerRadX, 175, 25, 60),
        cornerRadY = Text(tables.adjData.cornerRadY, 245, 25, 60),
        imgRotation = Text(tables.adjData.imgRotation, 315, 25, 50),
        imgScale = Text(tables.adjData.imgScale, 375, 25, 60),
        imgPosX = Text(tables.adjData.imgPosX, 445, 25, 60),
        imgPosY = Text(tables.adjData.imgPosY, 515, 25, 60)
    }
}


tables.menuDropdown = {
    main = {
        button = Rectangle(585, 5, 90, 40, "menu", "Menu"),
        dropdown = Rectangle(585, 45, 90, 250, "white"),
        dropdownEnabled = false
    },
    methods = {
        arc = {
            button = Rectangle(590, 50, 80, 30, "arc", "Arc"),
            dropdown = Rectangle(675, 50, 90, 105, "white"),
            nestedDropdownEnabled = false,
            mode = {
                background = Rectangle(675, 50, 90, 30, "black", "Mode"),
                button = {
                    line = Rectangle(680, 85, 80, 30, "line", "Line"),
                    fill = Rectangle(680, 120, 80, 30, "fill", "Fill")
                }
            }
        },
        circle = {
            button = Rectangle(590, 85, 80, 30, "circle", "Circle"),
            dropdown = Rectangle(675, 85, 90, 105, "white"),
            nestedDropdownEnabled = false,
            mode = {
                background = Rectangle(675, 85, 90, 30, "black", "Mode"),
                button = {
                    line = Rectangle(680, 120, 80, 30, "line", "Line"),
                    fill = Rectangle(680, 155, 80, 30, "fill", "Fill")
                }
            }
        },
        ellipse = {
            button = Rectangle(590, 120, 80, 30, "ellipse", "Ellipse"),
            dropdown = Rectangle(675, 120, 90, 105, "white"),
            nestedDropdownEnabled = false,
            mode = {
                background = Rectangle(675, 120, 90, 30, "black", "Mode"),
                button = {
                    line = Rectangle(680, 155, 80, 30, "line", "Line"),
                    fill = Rectangle(680, 190, 80, 30, "fill", "Fill")
                }
            }
        },
        line = {
            button = Rectangle(590, 155, 80, 30, "line", "Line")
        },
        point = {
            button = Rectangle(590, 190, 80, 30, "point", "Point")
        },
        polygon = {
            button = Rectangle(590, 225, 80, 30, "polygon", "Polygon"),
            dropdown = Rectangle(675, 225, 90, 105, "white"),
            nestedDropdownEnabled = false,
            mode = {
                background = Rectangle(675, 225, 90, 30, "black", "Mode"),
                button = {
                    line = Rectangle(680, 260, 80, 30,"line", "Line"),
                    fill = Rectangle(680, 295, 80, 30,"fill", "Fill")
                }
            }
        },
        rectangle = {
            button = Rectangle(590, 260, 80, 30, "rectangle", "Rectangle"),
            dropdown = Rectangle(675, 260, 90, 105, "white"),
            nestedDropdownEnabled = false,
            mode = {
                background = Rectangle(675, 260, 90, 30, "black", "Mode"),
                button = {
                    line = Rectangle(680, 295, 80, 30, "line", "Line"),
                    fill = Rectangle(680, 330, 80, 30, "fill", "Fill")
                }
            }
        } 
    }
}


tables.displayCoordinates = {
    background = Rectangle(680, 5, 550, 40, "black"),

    headerTable = {
        arc = {
            index = {"mode", "x", "y", "radius", "angle1", "angle2", "segments"},
            table = {
                mode = Text("Mode", 685, 10, 40),
                x = Text("X", 735, 10, 40),
                y = Text("Y", 785, 10, 40),
                radius = Text("Radius", 835, 10, 50),
                angle1 = Text("Angle 1", 895, 10, 60),
                angle2 = Text("Angle 2", 965, 10, 60),
                segments = Text("Segments", 1035, 10, 70)
            }
        },
        circle = {
            index = {"mode", "x", "y", "radius", "segments"},
            table = {
                mode = Text("Mode", 685, 10, 40),
                x = Text("X", 735, 10, 40),
                y = Text("Y", 785, 10, 40),
                radius = Text("Radius", 835, 10, 50),
                segments = Text("Segments", 895, 10, 70)
            }
        },
        ellipse = {
            index = {"mode", "x", "y", "radiusX", "radiusY", "segments"},
            table = {
                mode = Text("Mode", 685, 10, 40),
                x = Text("X", 735, 10, 40),
                y = Text("Y", 785, 10, 40),
                radiusX = Text("Radius X", 835, 10, 60),
                radiusY = Text("Radius Y", 905, 10, 60),
                segments = Text("Segments", 975, 10, 70)
            }
        },
        line = {
            index = {"x1", "y1", "x2", "y2"},
            table = {
                x1 = Text("X 1", 685, 10, 40),
                y1 = Text("Y 1", 735, 10, 40),
                x2 = Text("X 2", 785, 10, 40),
                y2 = Text("Y 2", 835, 10, 40)
            }
        },
        point = {
            index = {"x", "y"},
            table = {
                x = Text("X", 685, 10, 40),
                y = Text("Y", 735, 10, 40)
            }

        },
        polygon = {
            index = {"mode", "x1", "y1", "x2", "y2", "x3", "y3"},
            table = {
                mode = Text("Mode", 685, 10, 40),
                x1 = Text("X 1", 735, 10, 40),
                y1 = Text("Y 1", 785, 10, 40),
                x2 = Text("X 2", 835, 10, 40),
                y2 = Text("Y 2", 885, 10, 40),
                x3 = Text("X 3", 935, 10, 40),
                y3 = Text("Y 3", 985, 10, 40)
            }
        },
        rectangle = {
            index = {"mode", "x", "y", "width", "height", "cornerX", "cornerY", "segments"},
            table = {
                mode = Text("Mode", 685, 10, 40),
                x = Text("X", 735, 10, 40),
                y = Text("Y", 785, 10, 40),
                width = Text("Width", 835, 10, 40),
                height = Text("Height", 885, 10, 40),
                cornerX = Text("Corner X", 935, 10, 60),
                cornerY = Text("Corner Y", 1005, 10, 60),
                segments = Text("Segments", 1075, 10, 70)
            }
        }
    }
}


tables.gridButtons = {
    gridSizeField = Rectangle(0, 140, 50, 60),
    gridColorField = Rectangle(0, 290, 50, 60),

    gridEnabled = {
        gridEnabler = Rectangle(0, 90, 50, 40, "", "Grid ON/OFF"),
    },
    gridSize = {
        button10 = Rectangle(0, 140, 25, 20, 10, "10"),
        button20 = Rectangle(25, 140, 25, 20, 20, "20"),
        button30 = Rectangle(0, 160, 25, 20, 30, "30"),
        button40 = Rectangle(25, 160, 25, 20, 40, "40"),
        button50 = Rectangle(0, 180, 25, 20, 50, "50"),
        button60 = Rectangle(25, 180, 25, 20, 60, "60")
    },
    alpha = {
        buttonAlphaUp = Rectangle(0, 210, 50, 40, "up", "Alpha Up"),
        buttonAlphaDown = Rectangle(0, 390, 50, 40, "down", "Alpha Down")
    },
    brightness = {       
        buttonLighten = Rectangle(0, 260, 50, 20, "lighten", "Lighten"),
        buttonDarken = Rectangle(0, 360, 50, 20, "darken", "Darken")
    },
    color = {
        buttonRed = Rectangle(0, 290, 25, 20, "red"),
        buttonYellow = Rectangle(25, 290, 25, 20, "yellow"),
        buttonGreen = Rectangle(0, 310, 25, 20, "green"),
        buttonBlue = Rectangle(25, 310, 25, 20, "blue"),
        buttonTurquoise = Rectangle(0, 330, 25, 20, "turquoise"),
        buttonPurple = Rectangle(25, 330, 25, 20, "purple")
    }
}


tables.colorButtons = {
    colorField = Rectangle(0, 550, 50, 60),

    alpha = {
        buttonAlphaUp = Rectangle(0, 470, 50, 40, "up", "Alpha Up"),
        buttonAlphaDown = Rectangle(0, 650, 50, 40, "down", "Alpha Down")
    },
    brightness = {
        buttonLighten = Rectangle(0, 520, 50, 20, "lighten", "Lighten"),
        buttonDarken = Rectangle(0, 620, 50, 20, "darken", "Darken")
    },
    color = {
        buttonRed = Rectangle(0, 550, 25, 20, "red", ""),
        buttonYellow = Rectangle(25, 550, 25, 20, "yellow", ""),
        buttonGreen = Rectangle(0, 570, 25, 20, "green", ""),
        buttonBlue = Rectangle(25, 570, 25, 20, "blue", ""),
        buttonTurquoise = Rectangle(0, 590, 25, 20, "turquoise", ""),
        buttonPurple = Rectangle(25, 590, 25, 20, "purple", "")
    }
}


return tables
