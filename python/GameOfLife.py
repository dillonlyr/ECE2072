import pygame as pg
import random
import time
import intel_jtag
import sys
import keyboard

def main():
    
    # Initialize JTAG connection
    try:
        ju = intel_jtag.intel_jtag_uart()

    except Exception as e:
        print(e)
        sys.exit(0)
    

    # Create game ap
    gamemap= []
    
    for i in range(8):
        gamemap.append([])
    oldtime = time.time_ns()
    
    pg.init()

    # Create display:
    width, height = 800, 800
    display = pg.display.set_mode((width, height))

    # Create a list of 1s and 0s
    grid = [[0 for _ in range(8)] for _ in range(8)]

    # Initialize the grid
    for i in range(8):
        for j in range(8):
            grid[i][j] = 0
            
    currentx = 0
    currenty = 0
    
    # Loop
    running = True
    while running:
        # Handle events
        for event in pg.event.get():
            if event.type == pg.QUIT:
                running = False
        
        try:
            read_packet = ju.read() 
        except Exception as e:
            print(e)

        if len(read_packet): # if the packet is not read
            for byte in read_packet: # for each byte in the packet (row in the grid)
                byte = bin(byte)[2:].rjust(8, '0') # Convert to binary
                for bit in byte: # for each bit
                    # print(bit, end="") # Brints the bytes that are recieved
                    grid[currenty][currentx] = int(bit); # 0 or 1 (on or off)

                    if currentx == 7:
                        currentx = 0
                        if currenty == 7:
                            currenty = 0
                        else:
                            currenty += 1
                    else:
                        currentx += 1
                
                # print("")

        
        
        # Draw the board
        for i in range(8):
            for j in range(8):
                if not grid[i][j]:
                    color = (0, 0, 0)
                elif grid[i][j] == 1:
                    color = (255, 255, 255)
                pg.draw.rect(display, color, (j * 100, i * 100, 100, 100))

        # Update the board:
        pg.display.update()

    # End
    pg.quit()

if __name__ == "__main__":
    main()