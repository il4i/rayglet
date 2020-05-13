from cpython cimport array
import array
import math


# The circumference of the player's point of view (radians) .
cdef float POV_CIRC = (1 / 4) * math.pi  #(2 / 3) * math.pi

# length/width/height of walls, floors, etc.
cdef int BLOCK_LWH = 24

# maximum length of vision in blocks
cdef int MAX_SIGHT = 8

# enums
cdef int EMPTY = 0
cdef int WALL = 1

def two_dim_index(r, c, cols):
    return r * cols + c


cdef class PixelColumn:
    cdef int floor, wall, sky
    
    def __cinit__(self, floor, wall, sky):
        """ Counts of how many of each pixel should be printed in this column.
        Displayed with floor on the bottom, then wall, then sky. """
        self.floor = floor
        self.wall = wall
        self.sky = sky

    def __str__(self):
        return "floor_pixels={} sky_pixels={} wall_pixels={}".format(
            self.floor, self.sky, self.wall)

    def get_floor(self):
        return self.floor

    def get_wall(self):
        return self.wall

    def get_sky(self):
        return self.sky


cdef class Raycaster:

    cdef unsigned int pov_height  # dimensions of vision
    cdef unsigned int pov_length

    # x and y are represented in fractions of a block
    cdef float player_x, player_y, pov_angle

    # When pov_angle = 0, the player is facing to the right.

    cdef array.array grid
    cdef int grid_cols  # needed for reading 2-dimensionally

    cdef object vision

    def __cinit__(self, pov_length, pov_height, player_x, player_y,
                  pov_angle=0):
        self.pov_height = pov_height
        self.pov_length = pov_length
        self.player_x = player_x
        self.player_y = player_y
        self.pov_angle = pov_angle

        self.vision = [None, ] * pov_length

        
    def load_grid(self, grid):
        self.grid = array.array('i')
        self.grid_cols = len(grid[0])
        
        for sub_list in grid:
            for block in sub_list:
                self.grid.append(block)


    def wall_collision(self):
        """ Returns whether or not the player has hit a wall. """

        cdef int x, y
        x = math.floor(self.player_x)
        y = math.floor(self.player_y)

        try:
            return self.grid[two_dim_index(y, x, self.grid_cols)] == WALL
        except IndexError:
            return True  # The player is looking or standing off of the grid

    
    def move_forward(self, dist):
        """ Each dist unit is 1/BLOCK_LWH of a block. Returns whether or not
        the movement successfully avoided a wall. """
        cdef float undo_x, undo_y
        undo_x = self.player_x
        undo_y = self.player_y
        
        self.player_x += (dist / BLOCK_LWH) * math.cos(self.pov_angle)
        self.player_y += (dist / BLOCK_LWH) * math.sin(self.pov_angle)

        if self.wall_collision():
            self.player_x = undo_x
            self.player_y = undo_y
            return False

        return True

    def move_backward(self, dist):
        cdef float undo_x, undo_y
        undo_x = self.player_x
        undo_y = self.player_y
        
        self.player_x -= (dist / BLOCK_LWH) * math.cos(self.pov_angle)
        self.player_y -= (dist / BLOCK_LWH) * math.sin(self.pov_angle)

        if self.wall_collision():
            self.player_x = undo_x
            self.player_y = undo_y
            return False

        return True

    def turn_left(self, angle):
        """ The turn_* methods take angle in degrees. """
        self.pov_angle -= angle * (math.pi / 180)

    def turn_right(self, angle):
        self.pov_angle += angle * (math.pi / 180)
    
    
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
                ray_len += 1
                break

        self.player_x = orig_x
        self.player_y = orig_y
        self.pov_angle = orig_angle

        return ray_len

    
    def export_vision(self):
        """ Returns a 2D list of pixel values that must be interpretted and
        displayed in Python 3 with Pyglet. """
        cdef int i, j, dist, offset
        cdef int floor_pixels, sky_pixels, wall_pixels
        cdef float angle, dist_ratio
        
        for i in range(0, self.pov_length):
            # pov_angle is the center, so first set angle to the real start
            angle = self.pov_angle - POV_CIRC / 2
            angle += i / self.pov_length * POV_CIRC
            dist = self.ray_cast(angle)

            dist_ratio = dist / (MAX_SIGHT * BLOCK_LWH)

            floor_pixels = math.floor(dist_ratio * self.pov_height / 2)
            sky_pixels = floor_pixels
            wall_pixels = self.pov_height - floor_pixels - sky_pixels

            self.vision[i] = PixelColumn(floor_pixels, wall_pixels, sky_pixels)

        return self.vision
