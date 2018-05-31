# cc-turtle-scripts
A collection of scripts used for the Turtles in the Minecraft mod Computercraft.

## Roles
In the roles folder there are a number of scripts for different tasks. These should be run by a startup file on the turtle which supplies all the necessary parameters.

## Von Neumann
The file VonNeumann.lua contains a script that exploits a bug in un-modded Minecraft version 1.8.9 that can be used to duplicate items.
Using this bug, a turtle running this script will make copies of itself and instruct those copies to do the same.
An optional argument is the name of a program the turtles should run after making a few copies.

http://en.wikipedia.org/wiki/Self-replicating_spacecraft#Von_Neumann_probes
