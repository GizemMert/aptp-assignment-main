# Problem 2

We leverage the scenario in **Problem 1** with the following extensions, where we will have to consider an alternative way of moving boxes (e.g., trucks or helicopter or drones).

- The robotic agent can load up to four boxes onto a carrier, which all must be at the same location;
- The robotic agent can move the carrier to a location where there are people needing supplies;
- The robotic agent can unload one or more box from the carrier to a location where it is;
- The robotic agent may continue moving the carrier to another location, unloading additional boxes, and so
on, and does not have to return to the depot until after all boxes on the carrier have been delivered;
- Though a single carrier is needed for the single robotic agent, there should still be a separate type for carriers;
- For each robotic agent we need to count and keep track of i) which boxes are on each carrier; ii) how many boxes there are in total on each carrier, so that carriers cannot be overloaded.
- The capacity of the carriers (same for all carriers) should be problem specific. Thus, it should be defined in the problem file.

It might be the case additional actions, or modifications of the previously defined actions are needed to model loading/unloading/moving of the carrier (one can either keep previous actions and add new ones that operates on carriers, or modify the previous actions to operate on carriers).

The initial condition and the goal are the same as the problem discussed in **Problem 1**.

## Initial condition
- Initially all boxes are located at a single location that we may call the depot.
- All the contents to load in the boxes are initially located at the depot.
- There are no injured people at the depot.
- A single robotic agent is located at the depot to deliver boxes.
- The robotic agent is initially empty.
- Fix the capacity of the robotic agent to be 4.

## Goal
The goal should be that:
- Certain people have certain contents (e.g., medicine, food, tool);
- Some people might not need food, medicine, or tool;
- Some people might need both food and medicine, or food and tool, or the three of them, and so on.