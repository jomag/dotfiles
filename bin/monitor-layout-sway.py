#!/usr/bin/env python3
import subprocess
import json
from typing import List

def run_command_with_json_output(cmd: List[str]):
  result = subprocess.run(
    cmd,
    capture_output=True,
    text=True,
    check=True
  )
  return json.loads(result.stdout)

def move_workspace(workspace_id, output_id):
  print(f"Moving workspace '{workspace_id}' to output '{output_id}'")
  cmd = ["swaymsg", f"workspace {workspace_id}; move workspace to output {output_id}"]
  subprocess.run(cmd, check=True)

outputs = run_command_with_json_output(["swaymsg", "-t", "get_outputs", "-r"])
workspaces = run_command_with_json_output(["swaymsg", "-t", "get_workspaces", "-r"])

primary = None
secondary = None

for output in outputs:
  print(output["name"])
  print("Focused?", output["focused"])
  if output["focused"]:
    if primary is not None:
      print("Warning: more than one focused output detected")
    primary = output
  else:
    if secondary is None:
      secondary = output

print("Strategy:")
print("  Primary monitor:", primary["name"])
print("  Secondary monitor: ", secondary["name"])

# Fix screen arrangement: primary on the left, secondary to the right
if primary is not None and secondary is not None:
  primary_width = primary["rect"]["width"]
  primary_x = primary["rect"]["x"]
  secondary_x = secondary["rect"]["x"]

  expected_primary_x = 0
  expected_secondary_x = primary_width

  if primary_x != expected_primary_x or secondary_x != expected_secondary_x:
    print(f"Repositioning screens: {primary['name']} -> x=0, {secondary['name']} -> x={primary_width}")
    subprocess.run(["swaymsg", f"output {primary['name']} pos 0 0"], check=True)
    subprocess.run(["swaymsg", f"output {secondary['name']} pos {primary_width} 0"], check=True)
  else:
    print("Screen positions already correct")

focused_workspace = None

for ws in workspaces:
  if ws["focused"]:
    focused_workspace = ws["name"]

if focused_workspace is None:
  print("No workspace in focus!")
else:
  print(f"Focused workspace: {focused_workspace}")

for ws in workspaces:
  workspace_id = ws["name"]

  if workspace_id in ["1", "2", "3", "4", "5", "6", "7", "8", "9"]:
    if primary is not None:
      move_workspace(workspace_id, primary["name"])

  if workspace_id in ["10"]:
    if secondary is not None:
      move_workspace(workspace_id, secondary["name"])
    else:
      move_workspace(workspace_id, primary["name"])

# Finally, make sure to move back to the originally focused workspace
subprocess.run(["swaymsg", f"workspace {focused_workspace}"])
