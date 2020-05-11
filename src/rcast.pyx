from cpython cimport array
import array
import math


# The circumference of the player's point of view (radians) .
cdef int POV_CIRC = 0

# length/width/height of walls, floors, etc.
cdef int BLOCK_LWH = 32

# maximum length of vision in blocks
cdef int MAX_SIGHT = 8

cdef class Raycaster:

    cdef unsigned int pov_height  # dimensions of vision
    cdef unsigned int pov_length

    cdef float player_x, player_y, pov_angle

    # When pov_angle = 0, the player is facing to the right.

    cdef array.array vision
    cdef array.array grid

    def __cinit__(self, pov_height, pov_length, player_x, player_y,
                  pov_angle=0):
        self.pov_height = pov_height
        self.pov_length = pov_length
        self.player_x = player_x
        self.player_y = player_y
        self.pov_angle = pov_angle

        vis_list = [[0, ] * pov_length, ] * pov_height
        self.vision = array.array(*vis_list)

        
    def load_grid(self, grid):
        self.grid = array.array(*grid)
    

    def move_forward(self, dist):
        """ Each dist unit is 1/BLOCK_LWH of a block. """
        self.player_x += (dist / BLOCK_LWH) * math.cos(self.pov_angle)
        self.player_y += (dist / BLOCK_LWH) * math.sin(self.pov_angle)

    def move_backward(self, dist):
        self.player_x -= (dist / BLOCK_LWH) * math.cos(self.pov_angle)
        self.player_y -= (dist / BLOCK_LWH) * math.sin(self.pov_angle)

    def turn_left(self, angle):
        """ The turn_* methods take angle in degrees. """
        self.pov_angle += angle * (math.pi / 180)

    def turn_right(self, angle):
        self.pov_angle -= angle * (math.pi / 180)
    
    
    def ray_cast(angle):
        """ Returns the distance to the nearest wall from angle. """
        cdef int ray_len
        
        for ray_len in range(0, BLOCK_LWH * MAX_SIGHT):
            pass
