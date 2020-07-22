import os
import matplotlib.pyplot as plt
import numpy as np
import scipy.fftpack
from pprint import pprint
import math

os.system('vlib work')
os.system('vlog .\\verilog\\processor\\datapath_filter.v')
os.system('vlog .\\verilog\\processor\\datapath_noise.v')
os.system('vlog .\\verilog\\processor\\datapath_oscillator.v')
os.system('vlog .\\verilog\\data\\osc_rom.v')
os.system('vlog .\\verilog\\testbenches\\datapath_filter_tb.v')
os.system('vsim -c -do "run -all" datapath_filter_tb')

data = np.loadtxt(os.path.join(os.path.dirname(__file__), '../output.txt'), skiprows=1)

N = len(data)
T = 1 / 48000

x = np.linspace(0, T, N)
xf = np.linspace(0.0, 1.0/(2.0*T), math.floor(N/2))

y0 = list(map(lambda x : x[0], data))
yf0 = 2.0/N * np.abs(scipy.fftpack.fft(y0)[:math.floor(N/2)])

y1 = list(map(lambda x : x[1], data))
yf1 = 2.0/N * np.abs(scipy.fftpack.fft(y1)[:math.floor(N/2)])

fig, axs = plt.subplots(2)

axs[0].plot(xf[:20000], yf0[:20000])
axs[0].set_title('fft input')

axs[1].plot(xf[:20000], yf1[:20000])
axs[1].set_title('fft output')


plt.show()