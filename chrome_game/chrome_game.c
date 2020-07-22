#include "LiquidCrystal.h"

/*
 * Constants definitions */
// These are the Arduino pins used in the code const int PIN_LCD_RS = 8;
const int PIN_LCD_EN = 9;
const int PIN_LCD_D4 = 10;
const int PIN_LCD_D5 = 11;
const int PIN_LCD_D6 = 12;
const int PIN_LCD_D7 = 13;
const int PIN_PIEZO = 7;
const int PIN_POTENTIOMETER = A0;
const int PIN_BUTTON = 2;

// Constants for LCD dimensions. const int LCD_HEIGHT = 2;
const int LCD_WIDTH = 16;
// Each array is a sequence of bytes that indicate which little squares
// should be lit on each row of the custom character.
constbyteCCHAR_TREX_1[] = {
    0x07,
    0x05,
    0x17,
    0x1C,
    0x1F,
    0x0A,
    0x0B,
    0x08
};
constbyteCCHAR_TREX_2[] = {
    0x07,
    0x05,
    0x17,
    0x1C,
    0x1F,
    0x0A,
    0x0E,
    0x02
};
constbyteCCHAR_TREX_3[] = {
    0x07,
    0x05,
    0x17,
    0x1C,
    0x1F,
    0x0E,
    0x0A,
    0x00
};
const byte CCHAR_OBSTACLE[] = {
    0x03,
    0x1B,
    0x1B,
    0x1B,
    0x1F,
    0x1F,
    0x0E,
    0x0E
};
// Each constant represents the custom character in the LCD's memory.
constbyteCHAR_TREX_1 = 0;
constbyteCHAR_TREX_2 = 1;
constbyteCHAR_TREX_3 = 2;
const byte CHAR_OBSTACLE = 3;
// Each array is a sequence of characters that represent the notes (a,b,c,d) // and the pauses between notes as spaces (' '). All notes have the same
// duration.
const char NOTES_GAME[] = "ccccccdc ccdcdccbbbbbbcb bbcbcbb";
const char NOTES_END[] = " cccbbbaaaaaaaaa ";
// The duration of a single note. const int NOTE_DURATION = 200;
// These constants represent the frequencies of the notes S stands for sharp. const int FREQ_D4 = 293;
const int FREQ_AS4 = 466;
const int FREQ_B4 = 493;
const int FREQ_C5 = 523;
// Each number represents a game difficulty. constintEASY =0;
const int MEDIUM = 1;
constintHARD = 2;
// This array represents the time delay between two frames for each of the // game difficulties.
const int DIFFICULTY_DELAY[] = {
    500,
    350,
    200
};

// Define constant for maximum score const int MAX_SCORE = 65535;
/*
 * Global variables */
// Define LCD controller object
LiquidCrystal lcd(PIN_LCD_RS, PIN_LCD_EN, PIN_LCD_D4, PIN_LCD_D5, PIN_LCD_D6, PIN_LCD_D7);
// game_status is a number between 0 and 4 that represents which part of the // code we are in (start of the game, game loop, or end of game, and
// intermediary steps).
int game_status = 0;
// game_speed is a number between 0 and 2 indicating the game difficulty // (EASY, MEDIUM or HARD);
int game_speed = 0;
// jump_status indicates how far we are from reaching the ground (0 indicates // the T-Rex is on the ground).
int jump_status = 0;
// next_obstacle indicates how many frames left until the next obstacle // appears on the screen.
int next_obstacle = 0;
// collision_count indicates how many frames we are going to show the user // that a collision has happened. This is changed when a collision happens.

int collision_count = 0;
// current_note is an iterator that runs through the notes arrays above. int current_note = 0;
// score keeps track of the user score, and best_score holds the best score // until now (resets over reboots).
unsigned int score = 0;
unsigned int best_score = 0;
// trex_right_leg indicates the change of character that happens when
// the T-Rex moves (whether his left or right leg should be on the ground). bool trex_right_leg = 0;
// obstacles is an array of the obstacles currently on the screen (false for // no obstacle, true for obstacle present on the square).
bool obstacles[LCD_WIDTH] = {
    false
};
// button_pressed is used to send a button press information from // interrupt_function to the main loops.
volatile bool button_pressed = false;
/*
 * setup() initializes the Arduino board when booting up */
void setup() {
    // Set up the number of columns and rows for the LCD lcd.begin(16, 2);

    // Setup pins pinMode(PIN_BUTTON, INPUT); pinMode(PIN_PIEZO, OUTPUT);
    // Setup button interrupt attachInterrupt(digitalPinToInterrupt(PIN_BUTTON),
    interrupt_function,
    RISING);
// Read current potentiometer value. game_speed = read_speed();
// Set random seed from unused analog input pin A1 randomSeed(analogRead(A1));
// Define custom characters lcd.createChar(CHAR_TREX_1, CCHAR_TREX_1); lcd.createChar(CHAR_TREX_2, CCHAR_TREX_2); lcd.createChar(CHAR_TREX_3, CCHAR_TREX_3); lcd.createChar(CHAR_OBSTACLE, CCHAR_OBSTACLE);
}
/*
 * loop() takes care of calling all the different functions that run on
 * each of the game states. It also takes care of playing the song at
 * the same time the run is gaming. This works by running every 50 ms and
 * checking whether the song loop or the screen fresh should be called on this
 * run. */
void loop() {

    // piezo_time is the time until the next piezo loop (in ms), and game_time // is the time until calling the game loop again (in ms).
    static int piezo_time = 0;
    static int game_time = 0;
    if (game_status == 0) {
        init_start();
    } else if (game_status == 1) {
        loop_start();
    } else if (game_status == 2) {
        if (game_time == 0) {
            loop_game();
            // It will take the duration of a game frame until we have to call // the game loop again.
            game_time = DIFFICULTY_DELAY[game_speed];
        }
        if (piezo_time == 0) {
            loop_piezo();
            // It will take a whole NOTE_DURATION until we have to call the // piezo loop again.
            piezo_time = NOTE_DURATION;
        }
        // Wait 50 milliseconds before checking again whether we have to call // the functions.
        delay(50);
        game_time -= 50;
        piezo_time -= 50;

    } else if (game_status == 3) {
        init_end();
    } else {
        loop_end();
    }
}
/*
 * init_start() is run only once before init_loop to initialize the screen
 * and variables. */
void init_start() {
    // Reset global variables. reset_globals();
    // Display current game difficulty to the user. lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Current game");
    lcd.setCursor(0, 1);
    lcd.print("speed: ");
    lcd.setCursor(7, 1);
    if (game_speed == EASY) lcd.print("EASY.");
    else if (game_speed == MEDIUM) lcd.print("MEDIUM.");
    else lcd.print("HARD.");
    // Wait two seconds so that the user can read the message. delay(2000);

    // Go to loop_start().
    game_status = 1;
}
/*
 * loop_start() takes care of the game start screen. It checks whether the
 * user has changed the game speed or he/she pressed the button to start
 * the game. */
void loop_start() {
    // Check if the user has changed the game speed, and display a message if // necessary.
    int new_speed = read_speed();
    if (new_speed != game_speed) {
        game_speed = new_speed;
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print("Changed speed to");
        lcd.setCursor(0, 1);
        if (game_speed == EASY) lcd.print("EASY.");
        else if (game_speed == MEDIUM) lcd.print("MEDIUM.");
        else lcd.print("HARD.");
        delay(2000);
        // Otherwise display a regular message indicating what the user can do. }else{
        lcd.clear();

        lcd.setCursor(0, 0);
        lcd.print("Press button or");
        lcd.setCursor(0, 1);
        lcd.print("change speed.");
        delay(1000);
    }
    // Check if the user has pressed the button to start the game. if (button_pressed) {
    // Change to loop_game() game_status = 2; button_pressed = false;
}
}
/*
 * loop_game() is the main game loop. It takes care of all the game refresh
 * logic, jumping and collision checking. */
void loop_game() {
    // Blink characters if collision has happened if (collision_count > 0) {
    lcd.setCursor(1, 1);
    if (collision_count % 2) {
        lcd.write(CHAR_OBSTACLE);
    } else {
        lcd.write(CHAR_TREX_1);
    }

    // Exit after multiple blinks collision_count--;
    if (collision_count == 0) {
        game_status = 3;
    }
    return;
}
// Move game screen.
for (int i = 0; i < LCD_WIDTH - 1; i++) {
    obstacles[i] = obstacles[i + 1];
}
// Generate obstacle if it is the right time. if (next_obstacle == 0) {
obstacles[LCD_WIDTH - 1] = true;
next_obstacle = random(2, 5);
}
else {
    obstacles[LCD_WIDTH - 1] = false;
    next_obstacle--;
}
// A jump movement will be initiated by setting jump_status to 3
// in case the T-Rex is not yet jumping and the button has been pressed. // Otherwise the button press does nothing, and we just ignore it.
if (button_pressed && jump_status == 0) {
    jump_status = 3;

} else {
    button_pressed = false;
}
// Clear the whole screen to be re-drawn. lcd.clear();
// In case we are in the middle of a jump (jump_status from last loop > 1), // print the T-Rex on the first column, otherwise print on the second.
if (jump_status > 1) {
    jump_status--;
    lcd.setCursor(1, 0);
    lcd.write(CHAR_TREX_3);
} else {
    jump_status = 0;
    lcd.setCursor(1, 1);
    if (trex_right_leg) {
        lcd.write(CHAR_TREX_2);
    } else {
        lcd.write(CHAR_TREX_1);
    }
    trex_right_leg = !trex_right_leg;
}
// Print obstacles in the lower row. for (int i = 0; i < LCD_WIDTH; i++) {
if (obstacles[i]) {

    lcd.setCursor(i, 1);
    lcd.write(CHAR_OBSTACLE);
}
}
// Increase score if possible.
if (score <= MAX_SCORE - (game_speed + 1)) {
    score += game_speed + 1;
} else {
    score = MAX_SCORE;
}
// Display score
char score_string[6];
sprintf(score_string, "%5d", score);
lcd.setCursor(LCD_WIDTH - 6, 0);
lcd.print(score_string);
// Check for collision.
if (obstacles[1] && jump_status == 0) {
    // Set how many times we are going to blink characters. collision_count = 20;
    // Update best score.
    if (score > best_score) {
        best_score = score;
    }
    // Reset music

    current_note = 0;
}
}
/*
 * init_end() is run only once before end_loop to initialize the screen * and variables.
 */
void init_end() {
    // Stop music noTone(PIN_PIEZO);
    // Display end of game message with the score lcd.clear();
    char line1[LCD_WIDTH], line2[LCD_WIDTH];
    sprintf(line1, "You: %-5d Press", score);
    sprintf(line2, "Best: %-5d Btn", best_score);
    lcd.setCursor(0, 0);
    lcd.print(line1);
    lcd.setCursor(0, 1);
    lcd.print(line2);
    // Change to loop_end()
    game_status = 4;
}
/*

 * loop_end() checks for a button press, in which case it restarts the game.
*/
void loop_end() {
    delay(500);
    if (button_pressed) {
        button_pressed = false;
        // Restart the game by going back to init_start().
        game_status = 0;
    }
}
/*
 * loop_pieze() handles the music playing logic. */
void loop_piezo() {
    // If under collision, play end game sound, // else play game music
    char * notes;
    if (collision_count > 0) {
        notes = NOTES_END;
    } else {
        notes = NOTES_GAME;
    }
    // Find total number of notes int n_notes = strlen(notes);

    // Play silent using noTone or note using tone if (notes[current_note] == ' ') {
    noTone(PIN_PIEZO);
} else {
    int freq;
    switch (notes[current_note]) {
    case 'd':
        freq = FREQ_D4;
        break;
    case 'a':
        freq = FREQ_AS4;
        break;
    case 'b':
        freq = FREQ_B4;
        break;
    case 'c':
        freq = FREQ_C5;
        break;
    }
    tone(PIN_PIEZO, freq, NOTE_DURATION);
}
// Move to next note, only loop if playing game song if (current_note + 1 < n_notes) {
current_note++;
}
else if (collision_count == 0) {
    current_note = 0;
}
}
/*
 * reset_globals() is a helper function to clear all global variables
 * before a new game starts. */
void reset_globals() {
    jump_status = 0;

    next_obstacle = 0;
    collision_count = 0;
    current_note = 0;
    score = 0;
    for (int i = 0; i < LCD_WIDTH; i++) obstacles[i] = false;
    button_pressed = 0;
}
/*
 * read_speed() is a helper function to get the current speed from the
 * potentiometer. This works by dividing the input (from 0 to 1024) by
 * 342 (ceiling of one third of 1024), effectively returning an integer
 * between 0 and 2 (EASY, MEDIUM or HARD). */
int read_speed() {
    int speedRead = analogRead(PIN_POTENTIOMETER);
    return speedRead / 342;
}
/*
 * interrupt_function() is used to indicate to the main loops that the button
 * has been pressed. It works by setting the global variable button_pressed
 * to true. */
void interrupt_function() {
    button_pressed = true;
}