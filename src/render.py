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
caster=rcast.Raycaster(screen_width, screen_width, 1.5, 1.5)
grid = \
        [[1, 1, 1, 1, 1],
         [1, 0, 0, 0, 1],
         [1, 0, 0, 0, 1],
         [1, 0, 0, 0, 1],
         [1, 1, 1, 1, 1]]
caster.load_grid(grid)

#Gets the values of sky wall and ground for current position
def getView():
    output = caster.export_vision()
    for dx in range(len(output)):
        print("drawing {}".format(dx))
        drawColumn(dx, output[dx].get_sky(), output[dx].get_wall(),
                   output[dx].get_floor())

#Draws first screen
@window.event
def on_draw():
    window.clear()
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
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, 0, start+1, 0, start, ground, start+1, ground]), ('c4B', [0, 51, 0, 0]*4))
        #Drawing the walls
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, ground, start+1, ground, start, wall, start+1, wall]), ('c4B', [64, 64, 64, 0]*4))
        #Drawing the sky
        wall += ground
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, wall, start+1, wall, start, sky, start+1, start]), ('c4B', [102, 178, 255, 0]*4))

#ACTIVATE THE PYGLET
pyglet.app.run()
