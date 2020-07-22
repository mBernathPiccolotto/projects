import sys
from scipy import signal
import matplotlib.pyplot as plot
import numpy as np
import itertools

length = 256
values = [[] for i in range(4)]
raw_values = [[] for i in range(4)]

amplitude = 2**30

for n in range(length):
    # Sine wave
    if n < length/4:
        value = np.ceil(np.sin(np.pi * (2 * n / length)) * amplitude * 2)
    elif n < length/2:
        value = np.ceil(np.sin(np.pi * (2 * (length/2 - n) / length)) * amplitude * 2)
    elif n < (length * 3)/4:
        value = -np.ceil(np.sin(np.pi * (2 * (n - length/2) / length)) * amplitude * 2)
    else:
        value = -np.ceil(np.sin(np.pi * (2 * (length - n) / length)) * amplitude * 2)
    
    values[0].append(int(value))
    raw_values[0].append("{:08x}".format(int(value) & 0xffffffff))

    value = signal.square(2 * np.pi * n/length) * amplitude
    values[1].append(int(value))
    raw_values[1].append("{:08x}".format(int(value) & 0xffffffff))

    value = signal.sawtooth(2 * np.pi * n/length, width=0.5) * amplitude * 2
    values[2].append(int(value))
    raw_values[2].append("{:08x}".format(int(value) & 0xffffffff))

    value = signal.sawtooth(2 * np.pi * n/length) * amplitude
    values[3].append(int(value))
    raw_values[3].append("{:08x}".format(int(value) & 0xffffffff))

i = 0
for x in list(itertools.chain.from_iterable(raw_values)):
    if i == 15:
        print(x)
    else:
        print(x, end=' ')
    
    i = (i + 1) % 16

# plot.plot(range(length), values[0], '.', label='sine')
# plot.plot(range(length), values[1], '.', label='square')
# plot.plot(range(length), values[2], '.', label='triangle')
# plot.plot(range(length), values[3], '.', label='sawtooth')
# plot.show()