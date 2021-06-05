# Shoot-em-up-Game
 A horizontal scrolling space game made using MARS Simulator and MIPS Assembly Language
 
 ### Link to video demonstration for final submission: https://youtu.be/lp3Lp8bR9k0

 ### Downloading the MARS Simulator
 
 Since the computers we use today are not MIPS machines, we will need to simulate one. The simulator weare using is called MARS, and it is written in JAVA. You can easily download it from the MARS web page: http://courses.missouristate.edu/kenvollmar/mars/download.htm.
 
 ### Running the Simulator
 
 Open the Bitmap Display from the Tools option and set the following parameters as indicated: 
- Unit width in pixels: 8 (update this as needed)
- Unit height in pixels: 8 (update this as needed)
- Display width in pixels: 256 (update this as needed) 
- Display height in pixels: 256 (update this as needed)
- Base Address for Display: 0x10008000 ($gp)

Once this is set up, open the MMIO Keyboard Simulator alongw with bitmap display, click 'Connect to MIPS', and compile and run the 'game.asm' file to play the game!

Input the character a or d or w or s in Keyboard area (bottom white box) in Keyboard and Display MMIO Simulator window, to move your ship! 

### Features supported by this game

- Obstacles and ship keep moving from left to right continuously. Obstacles, on reaching the right end of the screen are redrawn randomly using a random number generator. 
- Player can move the ship around the screen using the movement keys. The ship cannot move past the edges of the screen as expected
- There is collision detection that takes place when an obstacle touches the ship
