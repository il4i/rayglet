from cpython cimport array
import array
import math


# The circumference of the player's point of view (radians) .
cdef float POV_CIRC = (2 * math.pi / 3)

# length/width/height of walls, floors, etc.
cdef int BLOCK_LWH = 32

# maximum length of vision in blocks
cdef int MAX_SIGHT = 8

# enums
cdef int EMPTY = 0
cdef int WALL = 1


cdef class Raycaster:

    cdef unsigned int pov_height  # dimensions of vision
    cdef unsigned int pov_length

    # x and y are represented in fractions of a block
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


    def wall_collision(self):
        """ Returns whether or not the player has hit a wall. """

        cdef int x, y
        x = math.floor(self.player_x)
        y = math.floor(self.player_y)
        
        return self.grid[y][x] == WALL

    def move_forward(self, dist):
        """ Each dist unit is 1/BLOCK_LWH of a block. Returns whether or not
        the movement successfully avoided a wall. """
        self.player_x += (dist / BLOCK_LWH) * math.cos(self.pov_angle)
        self.player_y += (dist / BLOCK_LWH) * math.sin(self.pov_angle)

        if self.wall_collision():
            self.move_backward(dist)
            return False

        return True

    def move_backward(self, dist):
        self.player_x -= (dist / BLOCK_LWH) * math.cos(self.pov_angle)
        self.player_y -= (dist / BLOCK_LWH) * math.sin(self.pov_angle)

        if self.wall_collision():
            self.move_forward(dist)
            return False

        return True

    def turn_left(self, angle):
        """ The turn_* methods take angle in degrees. """
        self.pov_angle += angle * (math.pi / 180)

    def turn_right(self, angle):
        self.pov_angle -= angle * (math.pi / 180)
    
    
    def ray_cast(self, angle):
        """ Returns the distance to the nearest wall from angle. """
        cdef int ray_len
        cdef float orig_x, orig_y, orig_angle

        orig_x = self.player_x
        orig_y = self.player_y
        orig_angle = self.pov_angle
        
        self.pov_angle = angle
        
        for ray_len in range(0, BLOCK_LWH * MAX_SIGHT):
            if self.move_forward(1) == False:
                break

        self.player_x = orig_x
        self.player_y = orig_y
        self.pov_angle = orig_angle

        return ray_len

    
    def refresh_vision(self):
        cdef int i, dist
        cdef float angle, height_ratio
        
        for i in range(0, self.pov_length):
            angle = self.pov_angle - POV_CIRC / 2
            angle += i / self.pov_length * POV_CIRC
            dist = self.ray_cast(angle)

            height_ratio = dist / (MAX_SIGHT * BLOCK_LWH)
            # TODO: display wall in vision

    def export_vision(self):
        """ Returns a 2D list of pixel values that must be interpretted and
        displayed in Python 3 with Pyglet. """
        pass
