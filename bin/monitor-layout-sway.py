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

focused_output = None
secondary_output = None

for output in outputs:
  print(output["name"])
  print("Focused?", output["focused"])
  if output["focused"]:
    if focused_output is not None:
      print("Warning: more than one focused output detected")
    focused_output = output["name"]
  else:
    if secondary_output is None:
      secondary_output = output["name"]

print("Strategy:")
print("  Primary monitor:", focused_output)
print("  Secondary monitor: ", secondary_output)

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
    if focused_output is not None:
      move_workspace(workspace_id, focused_output)

  if workspace_id in ["10"]:
    print("hugga...",secondary_output)
    if secondary_output is not None:
      move_workspace(workspace_id, secondary_output)
    else:
      move_workspace(workspace_id, focused_output)

# Finally, make sure to move back to the originally focused workspace
subprocess.run(["swaymsg", f"workspace {focused_workspace}"])
