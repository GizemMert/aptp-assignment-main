# Problem 1

## Initial condition
- Initially all boxes are located at a single location that we may call the depot.
- All the contents to load in the boxes are initially located at the depot.
- There are no injured people at the depot.
- A single robotic agent is located at the depot to deliver *boxes*.

*There are no particular restrictions on the number of boxes available, and constraints on reusing boxes! These are design modeling choices left unspecified and that each student shall consider and specify in her/his solution*.

## Goal
The goal should be that:

- Certain people have certain contents (e.g., medicine, food, tool);
- Some people might not need food, medicine, or tool;
- Some people might need both food and medicine, or food and tool, or the three of them, and so on.

This means that the robotic agent has to deliver to needing people some or all of the boxes and content initially located at the depot, *and leave the content by removing the content from the box (removing a content from the box causes the people at the same location to have the content)*.

**Remarks:** people don’t care exactly which conten they get, so the goal should not be (for example) that Alice has banana2, merely that Alice has a banana.