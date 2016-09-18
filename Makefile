CC=avr-gcc
MCU=-mmcu=atmega328p 
CPU_SPEED?=8000000
CFLAGS=$(MCU) -DF_CPU=$(CPU_SPEED)UL -Os -w
# Can other things "flash"? Or be "flashed"? The word has several definitions.
.PHONY: default
default: knightrider.hex

flash: default
	avrdude -V -c stk500v1 -p ATMEGA328P -P /dev/ttyUSB4 -b 19200 -U flash:w:knightrider.hex

%.o: %.c
	avr-gcc ${CFLAGS} -c -o $@ $<

%.out: %.o
	avr-gcc -mmcu=atmega328p $< -o $@

%.hex: %.out
	avr-objcopy -O ihex -R .eeprom $< $@

clean:
	rm -v *.hex
