#!/bin/bash

# This script should be run whenever source of power changes.
# Best way is to create a udev rule:
#
# Put the following in /etc/udev/rules.d/95-hypridle-power.rules:
#
# SUBSYSTEM=="power_supply", ATTR{online}=="*", RUN +="/.../bin/update-hypridle-power.sh"
#
# Then reload:
#
# udevadm control --reload-rules

power_source=$(cat /sys/class/power_supply/AC/online)

if [ "$power_source" -eq 1 ]; then
  echo "Mains powered"
  notify-send -i face-smirk "Mains powered and charging"
  echo "Killing previous instance of hypridle (if any)"
  pkill -x hypridle
  echo "Starting hypridle with mains config"
  hypridle -c ~/.config/hypr/hypridle-mains.conf &
else
  echo "Battery powered"
  notify-send -i battery "Battery powered"
  echo "Killing previous instance of hypridle (if any)"
  pkill -x hypridle
  echo "Starting hypridle with battery config"
  hypridle -c ~/.config/hypr/hypridle-battery.conf &
fi

