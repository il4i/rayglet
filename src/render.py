import sys
import time
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
caster=rcast.Raycaster(screen_width, screen_height, 1.5, 1.5)
grid = \
        [[1, 1, 1, 1, 1],
         [1, 0, 0, 0, 1],
         [1, 0, 0, 0, 1],
         [1, 0, 0, 0, 1],
         [1, 1, 1, 1, 1]]
caster.load_grid(grid)

#Gets the values of sky wall and ground for current position
def setView():
    output = caster.export_vision()
    for dx in range(len(output)):
        print("drawing {}".format(dx))
        drawColumn(dx, output[dx].get_sky(), output[dx].get_wall(),
                   output[dx].get_floor())


keys_down = {'A' : False, 'D' : False, 'S' : False, 'W' : False}

#Draws first screen
@window.event
def on_draw():
    window.clear()
    if keys_down['W']:
        caster.move_forward(4)
    if keys_down['A']:
        caster.turn_left(3)
    if keys_down['S']:
        caster.move_backward(4)
    if keys_down['D']:
        caster.turn_right(3)
    setView()

#Redraws window on key press
@window.event
def on_key_press(symbol, modifiers):
    if symbol == key.A:
        keys_down['A'] = True
    elif symbol == key.D:
        keys_down['D'] = True
    elif symbol == key.S:
        keys_down['S'] = True
    elif symbol == key.W:
        keys_down['W'] = True
    elif symbol == key.Q:
        sys.exit(0)

@window.event
def on_key_release(symbol, modifiers):
    if symbol == key.A:
        keys_down['A'] = False
    elif symbol == key.D:
        keys_down['D'] = False
    elif symbol == key.S:
        keys_down['S'] = False
    elif symbol == key.W:
        keys_down['W'] = False


#Column Draw
def drawColumn(start, sky, wall, ground):
    wall += ground
    sky += wall
    print("sky = {}".format(sky))
    pyglet.graphics.draw(4, pyglet.gl.GL_QUADS,
                         ('v2i', [start, 0, start+1, 0, start, ground, start+1, ground]),
                         ('c4B', [0, 51, 0, 0]*4))
    #Drawing the walls
    #ground += 1
    pyglet.graphics.draw(4, pyglet.gl.GL_QUADS,
                         ('v2i', [start, ground, start+1, ground, start, wall, start+1, wall]),
                         ('c4B', [64, 64, 64, 0]*4))
    #Drawing the sky
    pyglet.graphics.draw(4, pyglet.gl.GL_QUADS,
                             ('v2i', [start, wall,
                                      start+1, wall,
                                      start, sky,
                                      start+1, sky]),
                             ('c4B', [102, 178, 255, 0]*4))

#ACTIVATE THE PYGLET
#pyglet.app.run()
while True:
    #pyglet.clock.tick()
    time.sleep(0.0001)
    
    for window in pyglet.app.windows:
        window.switch_to()
        window.dispatch_events()
        window.dispatch_event('on_draw')
        window.flip()
