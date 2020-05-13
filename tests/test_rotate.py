import rcast


def print_pc(vis):
    for col in vis:
        print(str(col))


my_rcaster = rcast.Raycaster(30, 100, 1.5, 1.5)
grid = \
       [[1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1]]
"""
       [[1, 1, 1, 1],
        [1, 0, 0, 1],
        [1, 0, 0, 1],
        [1, 1, 1, 1]]
"""

my_rcaster.load_grid(grid, 5)


#print(my_rcaster.ray_cast(0))
#print(my_rcaster.ray_cast(0.5))

for i in range(0, 360, 45):
    print("After turning {} degrees:".format(i))
    print_pc(my_rcaster.export_vision())
    my_rcaster.turn_right(45)
