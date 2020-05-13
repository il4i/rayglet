import pyglet 
import rcast
from pyglet.window import key 

#Setting Window
#display = pyglet.canvas.Display()
#screen = display.get_default_screen()
screen_width = 720
screen_height = 480
window = pyglet.window.Window(screen_width, screen_height)

#initializing the raycaster
caster=rcast.Raycaster(screen_height, screen_width, 1.5, 1.5)
grid = \
        [[1, 1, 1, 1, 1],
         [1, 0, 0, 0, 1],
         [1, 0, 0, 0, 1],
         [1, 0, 0, 0, 1],
         [1, 1, 1, 1, 1]]
caster.load_grid(grid)

#Gets the values of sky wall and ground for current position
def getView():
    #Feeds the output from export_vision into the function drawColumn one column at a time
    # - Daniel
    
    # WRITE ME PUCHENG!!!
    # Loop through all of the PixelColumns in export_vision(). There should be
    # the same number as the screen's width in pixels.
    # - Ian
    output = caster.export_vision()
    for dx in range(len(output)):
        drawColumn(dx, output[dx].sky, output[dx].wall, output[dx].floor)
    #print("needs to be implemented")

#Draws first screen
@window.event
def on_draw():
    window.clear
    getView()

#Redraws window on key press
@window.event
def on_key_press(symbol, modifiers):
        window.clear
        if symbol == key.A:
            caster.turn_left(1)
            getView()
            #turn left
        elif symbol == key.D:
            caster.turn_right(1)
            getView()
            #turn right
        elif symbol == key.S:
            caster.move_backward(1)
            getView()
            #move back
        elif symbol == key.W:
            caster.move_forward(1)
            getView()
            #move forward

#Column Draw
def drawColumn(start, sky, wall, ground):
        #Drawing the ground
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, 0, start+1, 0, start+1, ground, start, ground]), ('c48', [0, 51, 0, 0]*4))
        #Drawing the walls
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, ground, start+1, ground, start+1, wall, start, wall]), ('c48', [64, 64, 64, 0]*4))
        #Drawing the sky
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, wall, start+1, wall, start+1, sky, start, start])('c48', [102, 178, 255, 0]*4))

#ACTIVATE THE PYGLET
pyglet.app.run()
