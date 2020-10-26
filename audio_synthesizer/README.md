# Audio Synthesizer

## Description

This group project was centered on building an audio synthesizer using a PS/2 keyboard as input, LCD as a settings menu and VGA as wave and keypress visualization. The team managed to build an oscillator that handles synthesizes a sine,square,triangular, sawtooth wave, or noise for each of the 24-keys independently, which are then mixed and optionally passed through a Infinite Impulse Response Filter. All of this was done using an HLSM design. User parameters, current notes being played and their phases, and a history of recent samples output are kept through a RAM. The samples history can be visualized on the VGA, providing a clear image of the waveform being output. A piano keyboard is also displayed, dynamically highlighting which keys are being pressed.
