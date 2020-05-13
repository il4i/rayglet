import rcast


def print_pc(vis):
    for col in vis:
        print(str(col))


my_rcaster = rcast.Raycaster(30, 100, 1.5, 1.5)
grid = \
       [[1, 1, 1, 1],
        [1, 0, 0, 1],
        [1, 0, 0, 1],
        [1, 1, 1, 1]]

my_rcaster.load_grid(grid, 4)


print(my_rcaster.ray_cast(0))
print(my_rcaster.ray_cast(0.5))
print_pc(my_rcaster.export_vision())

print("Turning!")
my_rcaster.turn_right(45)

print_pc(my_rcaster.export_vision())
