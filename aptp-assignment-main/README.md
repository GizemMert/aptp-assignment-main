# aptp-assignment
Assignment valid for the "Automated Planning: Theory and Practice" exam

# Scenario

Let us consider a scenario inspired by an emergency services logistics problem, where a number of persons at known a priori locations (and not moving) have been injured. The objective of the planning systems is to orchestrate the activities of a set of different robotic agents to deliver boxes containing emergency supplies to each person.

Let’s consider these assumptions:

- Each injured person is at a specific location, and does not move.
- Each box is initially at a specific location and can be filled with a specific content such as food or medicine or tools, if empty. Box contents shall be modeled in a generic way, so that new contents can easily be introduced in the problem instance (*i.e.,* we shall be able to reason on the content of each box).
- Each person either has or does not have a box with a specific content. That is, you must keep track of whether they have food or not, whether they have medicine or not, whether they have tools or not, and so on.
- There can be more than one person at any given location, and therefore it isn’t sufficient to keep track of where a box is in order to know which people have been given boxes!
- Each robotic agent can:
    - fill a box with a content, if the box is empty and the content to add in the box, the box and the agent are at the same location;
    - empty a box by leaving the content to the current location, and causing the people at the same location to have the content;
    - pick up a single box and load it on the robotic agent, if it is at the same location as the box;
    - move to another location moving the loaded box (if the box has been loaded, otherwise it simply moves);
    - deliver a box to a specific person who is at the same location.
- The robotic agents can move directly between arbitrary locations (there is no ”roadmap” with specific connections that must be taken), so the graph is fully connected.
- Since we want to be able to expand this domain for multiple robotic agents in the future, we expect to use a separate type for robotic agents, which currently happens to have a single member in all problem instances.
