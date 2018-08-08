Graphical representation of Dijkstra's Algorithm. 

![Dijkstra's Algorithm playing multiple GIFs](https://github.com/djk12587/Dijkstra-Algorithm-Graph/blob/master/example.gif?raw=true)

# Overview
This project creates and places 10 random nodes
Each node creates up to 3 bidirectional connections to 3 other random nodes

Each node eventually gets a random name from a random name generator endpoint.

Because everything is random, it might be hard to visualize the graph, so I added a reset button in the bottom left corner. Tap this a few times to get a graph that is prettier.

# How to work the app
select 2 nodes
Red = selected nodes
Yellow = connecting nodes

When you tap on a node it will turn red, the magic happens when you tap a second  node. When the 2nd node is selected the shortest path to the second node will be represented by changing the connecting nodes to yellow.

Tap on the red nodes again to deselect.

# Known Bugs
If 2 nodes are selected that do not connect they will both turn red.
Views can collide which can cause the graph to be difficult to visualize (use the reset button)
No loading indicators for nodes when the names endpoint is pending

# If I had a little more time
I would of added tests 🤷‍♂️
I would of liked to create a Graph object that would hold all the nodes. This would of removed a lot of color logic out of the view controller.
