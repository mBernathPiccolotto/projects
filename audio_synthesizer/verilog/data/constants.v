`ifndef __CONSTANTS__
`define __CONSTANTS__

`define MODELSIM 0

// Ram addresses
`define F_RAM_ADDRESS               8'd0;
`define Q_RAM_ADDRESS               8'd1;
`define FILTER_CHOICE_ADDRESS       8'd2;
`define OSC_CHOICE_ADDRESS          8'd3;
`define NOTE_ON_START_ADDRESS       8'd4;
`define NOTE_PHASE_START_ADDRESS    (NOTE_ON_START_ADDRESS + 8'd24);
`define NOTE_DURATION_START_ADDRESS (NOTE_PHASE_START_ADDRESS + 8'd24);

// Event types
`define EVT_INVALID     3'h0;
`define EVT_PRESS_KEY   3'h1;
`define EVT_RELEASE_KEY 3'h2;
`define EVT_INCREASE    3'h3;
`define EVT_DECREASE    3'h4;
`define EVT_CHANGE_MENU 3'h5;

// Filter choices
`define FILTER_CHOICE_HIGHPASS    0;
`define FILTER_CHOICE_LOWPASS     1;
`define FILTER_CHOICE_BANDPASS    2;
`define FILTER_CHOICE_BAND_REJECT 3;

// Choice constant
`define OSC_CHOICE_NOISE 4;

`endif