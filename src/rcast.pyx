from cpython cimport array
import array
import math


# The circumference of the player's point of view (radians) .
cdef float POV_CIRC = (2 / 3) * math.pi

# length/width/height of walls, floors, etc.
cdef int BLOCK_LWH = 32

# maximum length of vision in blocks
cdef int MAX_SIGHT = 8

# enums
cdef int EMPTY = 0
cdef int WALL = 1

cdef int FLOOR_PIXEL = 0
cdef int WALL_PIXEL  = 1
cdef int SKY_PIXEL = 2

def two_dim_index(r, c, cols):
    return r * cols + c


cdef class Raycaster:

    cdef unsigned int pov_height  # dimensions of vision
    cdef unsigned int pov_length

    # x and y are represented in fractions of a block
    cdef float player_x, player_y, pov_angle

    # When pov_angle = 0, the player is facing to the right.

    cdef array.array vision
    cdef array.array grid
    cdef int grid_cols  # needed for reading 2-dimensionally

    def __cinit__(self, pov_height, pov_length, player_x, player_y,
                  pov_angle=0):
        self.pov_height = pov_height
        self.pov_length = pov_length
        self.player_x = player_x
        self.player_y = player_y
        self.pov_angle = pov_angle

        vis_list = [[0, ] * pov_length, ] * pov_height
        self.vision = array.array('i')

        for sub_list in vis_list:
            for pixel in sub_list:
                self.vision.append(pixel)

        
    def load_grid(self, grid, grid_cols):
        self.grid = array.array('i')
        self.grid_cols = grid_cols
        
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
                ray_len += 1
                break

        self.player_x = orig_x
        self.player_y = orig_y
        self.pov_angle = orig_angle

        return ray_len

    
    def refresh_vision(self):
        cdef int i, j, dist
        cdef int floor_pixels, sky_pixels, wall_pixels
        cdef float angle, dist_ratio
        
        for i in range(0, self.pov_length):
            # pov_angle is the center, so first set angle to the real start
            angle = self.pov_angle - POV_CIRC / 2
            angle += i / self.pov_length * POV_CIRC
            dist = self.ray_cast(angle)

            dist_ratio = dist / (MAX_SIGHT * BLOCK_LWH)

            floor_pixels = math.floor(dist_ratio * self.pov_height)
            sky_pixels = math.floor(dist_ratio * self.pov_height)
            wall_pixels = self.pov_height - floor_pixels - sky_pixels

            for j in range(0, floor_pixels):
                self.vision[two_dim_index(i, j, self.pov_height)] = FLOOR_PIXEL

            for j in range(0, wall_pixels):
                self.vision[two_dim_index(i, j, self.pov_height)] = WALL_PIXEL

            for j in range(0, sky_pixels):
                self.vision[two_dim_index(i, j, self.pov_height)] = WALL_PIXEL
        

    def export_vision(self):
        """ Returns a 2D list of pixel values that must be interpretted and
        displayed in Python 3 with Pyglet. """
        pixels = []
        for i in range(0, self.pov_height):
            pixels.append(list())
            
            for j in range(0, self.pov_length):
                pixels[i].append(self.vision[two_dim_index(i, j,
                                                           self.pov_height)])
        return pixels
