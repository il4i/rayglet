import pyglet 
import rcast
from pyglet.window import key 

#Setting Window
display = pyglet.canvas.Display()
screen = display.get_default_screen()
screen_width = screen.width
screen_height = screen.height
window = pyglet.window.Window(screen_width, screen_height)

#initializing the raycaster
caster=rcast.Raycaster(screen_height, screen_width, 1.5, 1.5)
grid = \
        [[1, 1, 1, 1],
         [1, 0, 0, 1],
         [1, 0, 0, 1],
         [1, 1, 1, 1]]
caster.load_grid(grid, 4)

#Redraws window for the on_draw event
@window.event
def on_draw():
    window.clear


#Redraws window on key press
@window.event
def on_key_press(symbol, modifiers):
        if symbol == key.A:
            print('A was pressed')
            #turn left
        elif symbol == key.D:
            print('D was pressed')
            #turn right
        elif symbol == key.S:
            print('S was pressed')
            #move back
        elif symbol == key.W:
            print('W was pressed')
            #move forward

#Column Draw
def drawColumn(start, sky, wall, ground):
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, 0, start+1, 0, start+1, ground, start, ground]))
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, ground, start+1, ground, start+1, wall, start, wall]))
        pyglet.graphics.draw(4, pyglet.gl.GL_QUADS, ('v2f', [start, wall, start+1, wall, start+1, sky, start, start]))

#Activating the Pyglet
pyglet.app.run()
