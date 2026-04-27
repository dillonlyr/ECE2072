import time
import intel_jtag
import sys
import keyboard

# Initialize JTAG connection
print("Initializing JTAG conncetion")
try:
    ju = intel_jtag.intel_jtag_uart()

except Exception as e:
    print(e)
    sys.exit(0)
print("JTAG Connected")
print("Reading Data.... (Press \"Q\" to exit)")
        
while True:
    try:
        read_packet = ju.read()
    except Exception as e:
        print(e)
    
    if len(read_packet):
        print("----------------------------------------")
        print(f"read {len(read_packet)} byte (s)") # ju.read returns a byte list of all data collected
        for byte in read_packet: # for each byte in the packet (row in the grid)
            byte = bin(byte)[2:].rjust(8, '0') # Convert to binary
            for bit in byte: # for each bit
                print(bit, end="") # prints the bytes that are recieved
            print("")

    if keyboard.is_pressed("q"):
        sys.exit(0)
        break