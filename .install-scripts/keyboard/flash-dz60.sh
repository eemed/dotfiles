#!/bin/sh

# dz60 hold spc + b to enter bootloader mode and insert kewb
# Erase old
dfu-programmer atmega32u4 erase

# Flash new
dfu-programmer atmega32u4 flash $1

# Reset from bootloader mode
dfu-programmer atmega32u4 reset
