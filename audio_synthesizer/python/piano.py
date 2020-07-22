import math
import pygame, sys
from pygame.locals import *

pygame.init()

DISPLAY = pygame.display.set_mode((5 * 77, 5 * 60), 0, 32)

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
BLUE = (0, 0, 255)
RED = (255, 0, 0)

color = [WHITE, BLACK, WHITE, BLACK, WHITE, WHITE, BLACK, WHITE, BLACK, WHITE, BLACK, WHITE] * 2

in_key = [False] * 12
in_key[1] = 1

for xx in range(5 * 77):
    for yy in range(5 * 60):
        x = math.floor(xx / 5)
        y = math.floor(yy / 5)

        is_top = y <= 39
        
        idx = math.floor(x / 11)
        rem = x % 11

        is_in = [(x >= 0 and x <= 10 and not is_top) or (x >= 0 and x <= 6),
                 x >= 7 and x <= 15 and is_top,
                 (x >= 12 and x <= 21 and not is_top) or (x >= 16 and x <= 17),
                 x >= 18 and x <= 26 and is_top,
                 (x >= 23 and x <= 32 and not is_top) or (x >= 27 and x <= 32),
                 (x >= 34 and x <= 43 and not is_top) or (x >= 34 and x <= 39),
                 x >= 40 and x <= 48 and is_top,
                 (x >= 45 and x <= 54 and not is_top) or (x >= 49 and x <= 50),
                 x >= 51 and x <= 59 and is_top,
                 (x >= 56 and x <= 65 and not is_top) or (x >= 60 and x <= 61),
                 x >= 62 and x <= 70 and is_top,
                 (x >= 67 and x <= 76 and not is_top) or (x >= 71 and x <= 76)]
        
        if sum(is_in) > 1:
            print(x, y, is_in)

        clr = BLACK
        for i in range(len(is_in)):
            if is_in[i]:
                clr = RED if in_key[i] else color[i]
                break

        pygame.draw.circle(DISPLAY, clr, (xx, yy), 0)

while True:
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()
    pygame.display.update()

