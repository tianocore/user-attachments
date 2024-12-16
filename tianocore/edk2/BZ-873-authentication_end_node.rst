All Authentication Nodes are byte-packed data structures that may appear
on any byte boundary. All code references to Authentication Nodes must
assume all fields are UNALIGNED. Since every Authentication Node
contains a length field in a known place, it is possible to traverse
Authentication Node of unknown type.

CHAP (using RADIUS) Authentication Node  .. This line should be bold
=======================================

This Authentication Node type defines the CHAP authentication using RADIUS
information.
