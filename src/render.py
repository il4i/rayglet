import pyglet 
from pyglet.window import key

#Setting Window
window = pyglet.window.Window(720, 480)

#getting wall sky and floor heights


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

#Activating the Pyglet
pyglet.app.run()
