###### Last Updated: Thursday, April 11, 2019

# Coding Convention

## QML Object Structure

Extended from [QML Coding Conventions](https://doc.qt.io/qt-5/qml-codingconventions.html), each QML object should contain the following structure:

* id
* property declarations
* signal declarations
* JavaScript functions
* object properties
* item properties
* signal handlers
* child objects
* behaviours
* animations
* states
* transitions
* connections

In some cases, the order of **Child Objects** should be well-defined (e.g. when considering z-layering).

## Object Property Structure (Item)

However the order of **Object Properties** is trivial and require a convention. The convention of structuring object properties are as follows:

* anchors
* x, y, z
* width, height
* radius
* spacing
* text
* font
* border
* enabled
* colour
* visible
* opacity
* etc.
