#!/bin/env python3

import time
import psutil
import subprocess

THRESHOLD = 20
CRITICAL = 5
INTERVAL = 60

def notify(level, title, message):
  urgency = "critical" if level == "critical" else "normal"
  subprocess.run(["notify-send", "-u", urgency, title, message])

first = True

while True:
  battery = psutil.sensors_battery()
  if battery is None:
    notify("normal", "Battery", "No battery detected on this system")
    break

  percent = int(battery.percent)
  is_plugged = battery.power_plugged

  if first:
    notify("normal", "Battery", f"Battery monitor enabled.\n{percent}% remaining")
    first = False

  if not is_plugged:
    if percent <= CRITICAL:
      notify("critical", "Battery Critical", f"{percent}% remaining! Shutting down...")
      time.sleep(10)
      subprocess.run(["systemctl", "poweroff"])
    elif percent <= THRESHOLD:
      notify("normal", "Battery Low", f"{percent}% remaining. Please plug in.")

  time.sleep(INTERVAL)

