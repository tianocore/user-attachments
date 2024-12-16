All Authentication Nodes are byte-packed data structures that may appear
on any byte boundary. All code references to Authentication Nodes must
assume all fields are UNALIGNED. Since every Authentication Node
contains a length field in a known place, it is possible to traverse
Authentication Node of unknown type.

.. new text starts here

Authentication End Node
=======================

This authentication node type marks the end of the list of authentication
nodes.

**GUID **

    #define EFI_AUTHENTICATION_END_GUID \
     {0x00000000,0x0000,0x0000,\
      {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}}

**Node Definition**

**Table 32-2 Authentication End Node Structure**

======== =========== =========== ======================================
Mnemonic Byte Offset Byte Length Description
Type     0           16          EFI_AUTHENTICATION_END_GUID
Length   16	     2           18 (Length of this structure in bytes)
======== =========== =========== ======================================


CHAP (using RADIUS) Authentication Node  .. This line should be bold
=======================================

This Authentication Node type defines the CHAP authentication using RADIUS
information.

.. All following tables must be renumbered.
