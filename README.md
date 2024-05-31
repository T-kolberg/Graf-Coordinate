
# Graf Coordinate

![demo](https://github.com/T-kolberg/Graf-Coordinate/assets/151522655/268960a1-18c3-4641-b5a3-c2583b8ca9b0)


The Graf Coordinate uses the Löve framework and allows users to draw objects and return their coordinates based on the love.graphics functions. Users can either draw an object or redraw a shape presented in an image by dragging the image into the program. The latest coordinates can then be viewed at the top right-hand side of the menu, or by dragging an empty .txt file into the program. This stores the information needed for the corresponding function in the .txt file.


## Introduction

This program was my very first programming project as well as my final project for CS50. It started as a small program that I used to visualize the Löve mesh function and its different modes, for example "fan", "strip", and "triangles". It also provided me with the coordinates for the collision detection by roughly redrawing the shapes of objects. This led me to my decision to expand this program and use it as my final project. 


## List of features

- Drawing methods 
    - Methods
        - Arc
        - Circle
        - Ellipse
        - Line
        - Point
        - Polygon
        - Rectangle
    - mode of "line" or "fill"
    - different colors
    - adjustable opacity
    - adjustable brightness

- The Grid
    - Switchable Grid (on/off)
    - adjustable size
    - snap functionality
    - different colors
    - adjustable opacity
    - adjustable brightness

- Inputs
    - image types supported (.jpg, .jpeg, .png, .bmp, .tga, .hdr, .exr)
    - text file (.txt)


## How to run

- Windows 10
    - Unfortunately, Windows 10 won't recognize the installer from Love2D and will trigger the "Windows protected your PC" prompt
        - If you wish to continue installing Love2D
            - Download the Love2D installer (version 11.5) from the [official Love2D website](https://www.love2d.org/)
            - Double-click on the Love installer. When the prompt "Windows protected your PC" appears, select "more info" and click on "Run anyway" to proceed with the installation
    - Download the GrafCoordinate.zip and extract the lose files
    - Select the loose files, right click on one of the selected files and choose the option "send to" and select "compressed (zipped) folder" to compress the files into a single zip file
    - After compressing the files into a single zip file
        - Either right click on the GrafCoordinate.zip, choose "open with" and select Löve
        - Or enable the "file name extensions" in Windows inside the Explorer's View tab 
            - Change the GrafCoordinate.zip to GrafCoordinate.love
            - Double-click on GrafCoordinate.love
        

## How to use

- To use an image, simply drag the supported image into the program
- To change the position, scale, or rotation of the image, hover over the corresponding value and use the mouse wheel or +/- keys
- While using the mouse wheel or +/- keys, press the left shift key to adjust the values more precisely 
- Choose grid color, draw color, brightness and opacity (alpha) from the vertical menu
- From the menu, choose the appropriate draw method. If available, choose between mode "line" and "fill"
- To snap the cursor to the grid, press the left mouse button
- To store the coordinates of the current cursor position, press the spacebar key
- If available, change the object's values with the mouse wheel or +/- key while hovering over the corresponding value
    - The Segments value can be directly adjusted from the grid with the mouse wheel or the +/- keys
- To erase the current drawings, press the backspace key
- To save the drawn coordinates onto a .txt file, drag an empty text file into the program


## Additional information
    
When an image or .txt file is being dragged into the program, it may occur that certain inputs, such as the left shift key for adjusting values more precisely, are unresponsive. This is typically caused by a loss of focus by the program, meaning the program doesn't react to mouse and/or keyboard input. To regain focus, the program's taskbar icon will begin to flash, notifying the user of its loss of focus. A click into the program's window will restore its focus.


## Known issues

- While using the grid size of 60, the cursor won't always snap to the nearest grid line
- The quit button doesn't always quit the program immediately
- The live preview of the drawable object might not behave smoothly.


## Possible improvements

- Removing unnecessary code
    - I was close to finishing my final project when I realized that the functions responsible for the button color changes at hover and click events might also handle the execution of the corresponding functions by simply changing a boolean. If it works as intended, it would render certain functions obsolete and improve efficiency.
- Handling the mutation of variables differently
    - Variables that are used between different functions are currently storing their values inside tables to allow mutation when passing them as parameters through functions. This is not ideal, but I couldn't find a better solution at that moment.


## Reflection

As this was my very first programming project, I discovered that I need to improve my preparations for future projects, following a [mise en place](https://en.wikipedia.org/wiki/Mise_en_place) for programming. Despite creating the functions for the drawing methods first, I still struggled to establish a roadmap to follow. This also led to the creation of functions with multiple purposes, which I tried to refactor later on. Despite finding places for improvement, I had to prioritize due to time constraints and decided to complete the project. Although this project was a small step, it highlighted how much I still have to learn, as well as the areas in which I have to improve and the changes I need to make for future projects.
