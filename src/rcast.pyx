import pyglet


cdef class Map:
    cdef unsigned int width, height
    cdef list grid
    
    cdef __init__(self, grid, width, height):
        self.grid = grid
        self.width = width
        self.height = height


cdef class ScreenBuffer:
    """"""
    cdef unsigned int width, height

    cdef __init__(self, width, height):
        self.width = width
        self.height = height

