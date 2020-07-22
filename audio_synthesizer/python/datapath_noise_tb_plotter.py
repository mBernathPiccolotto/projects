import os
import matplotlib.pyplot as plt
import numpy as np

os.system('vlib work')
os.system('vlog .\\verilog\\testbenches\\datapath_noise_tb.v')
os.system('vsim -c -do "run -all" datapath_noise_tb')

data = np.loadtxt(os.path.join(os.path.dirname(__file__), '../output.txt'), skiprows=1)

values = data

fig, axs = plt.subplots(3)

axs[0].hist(values, bins=100)
axs[0].set_title('100-bins histogram')

axs[1].plot(range(len(values)), values, '.')
axs[1].set_title('full wave')

axs[2].plot(range(1000), values[:1000], '.')
axs[2].set_title('1000 first values')
plt.show()