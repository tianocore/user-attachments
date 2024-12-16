::: WordSection1
Unified Extensible Firmware Interface\
Engineering Change Request (ECR)

 

*[Draft for Review]{.underline}*

[Title: CPER Definition for CXL RCH DP Port]{style="font-size:18.0pt"}

[Document: UEFI v2.10]{style="font-size:18.0pt;color:blue"}

[Sponsors:]{style="font-size:18.0pt;color:blue"}

*[Leo Duran (AMD)]{style="font-size:14.0pt;color:blue"}*

*[Submission for Review Date:
x/xx/2024]{style="font-size:18.0pt;color:blue"}*

[Review Approval Date: *x/xx/2024*]{style="font-size:18.0pt;color:blue"}

[Submission for Technical Editing Date:
*x/xx/2024*]{style="font-size:18.0pt;color:blue"}

[Submission for Draft Review Date:
*xx/xx/2024*]{style="font-size:18.0pt;color:blue"}

[Verification Date: *x/xx/2024*]{style="font-size:18.0pt;color:blue"}

[Verifiers: *Leo Duran (AMD)*]{style="font-size:16.0pt;color:blue"}

[\
]{style="font-size:11.0pt;line-height:107%;font-family:\"Calibri\",sans-serif"}

[ ]{style="font-size:12.0pt;line-height:107%;font-family:
\"Calibri Light\",sans-serif;color:#1F3763"}

### **\# Title:**

[CPER Definition for CXL
RCH]{style="font-family:\"Times New Roman\",serif"}

**[ ]{style="font-family:\"Times New Roman\",serif"}**

### **\# Status:**

[Draft]{style="font-family:\"Times New Roman\",serif"}

[ ]{style="font-family:\"Times New Roman\",serif"}

### **\# Document:**

[UEFI Specification Version
2.10]{style="font-family:\"Times New Roman\",serif"}

[ ]{style="font-family:\"Times New Roman\",serif"}

### **\# Submitter:**

[Leo Duran (AMD)]{style="font-family:\"Times New Roman\",serif"}

[ ]{style="font-family:\"Times New Roman\",serif"}

### **\# Summary of the change**

[This ECR addresses a gap in a CPER definition to allow CXL.io errors
reported by a CXL RCH Downstream Port (RCH-DP) via AER. It also provides
some language clean-ups in the CPER definition for CXL Protocol
errors.]{style="font-family:\"Times New Roman\",serif"}

###  

### **\# Problem Statement**

[The standard PCIe CPER definition only allows for a BDF address,
whereas a CXL RCH-DP is
MMIO-based.]{style="font-family:\"Times New Roman\",serif"}

###  

### **\# Proposed Solution**

[Amend the standard PCIe CPER definition to include the MMIO base
address of a Root Complex Register Block (RCRB), as in the case of a CXL
RCH-DP.]{style="font-family:\"Times New Roman\",serif"}

###  

### **\# Benefits of the change**

[Enables Firmware-First support of CXL.io errors reported by a CXL
RCH-DP via AER.]{style="font-family:\"Times New Roman\",serif"}

### ** **

### **\# Impact of the change**

[Would require platform firmware and OSPM changes to support the
proposed CPER
definition.]{style="font-family:\"Times New Roman\",serif"}

[ ]{style="font-family:\"Times New Roman\",serif"}

**[Format for Markups:]{style="font-family:\"Times New Roman\",serif;
color:blue"}**

[Entries may include "**...**" to indicate unchanged
text.]{style="font-family:\"Times New Roman\",serif"}

[inserted
text]{style="font-family:\"Times New Roman\",serif;background:yellow"}

~~[deleted
text]{style="font-family:\"Times New Roman\",serif;color:red"}~~

[ ]{style="font-family:\"Arial\",sans-serif"}

**[\
]{style="font-size:12.0pt;line-height:107%;font-family:\"Arial\",sans-serif"}**

**[ ]{style="font-size:12.0pt;line-height:107%;
font-family:\"Arial\",sans-serif"}**

**[N.2.7 PCI Express Error
Section]{style="font-size:12.0pt;font-family:\"Arial\",sans-serif"}**

[Type: {0xD995E954, 0xBBC1, 0x430F, {0xAD, 0x91, 0xB4, 0x4D, 0xCB, 0x3C,
0x6F, 0x35}}]{style="font-family:\"Times New Roman\",serif"}

**[Table N.33: PCI Express Error
Record]{style="font-family:\"Times New Roman\",serif"}**

+-----------------+-----------------+-----------------+-----------------+
| *               | **[ Byte        | **[Byte         | *               |
| *[Mnemonic]{sty | Offset]{        | Length]{        | *[Description]{ |
| le="font-family | style="font-fam | style="font-fam | style="font-fam |
| :\"Times New Ro | ily:\"Times New | ily:\"Times New | ily:\"Times New |
| man\",serif"}** |  Roman\",serif; |  Roman\",serif; |  Roman\",serif; |
|                 | color:black"}** | color:black"}** | color:black"}** |
+-----------------+-----------------+-----------------+-----------------+
| [Validation     | [0]{s           | [8]{s           | [Indicates      |
| Bits]{s         | tyle="font-fami | tyle="font-fami | which of the    |
| tyle="font-fami | ly:\"Times New  | ly:\"Times New  | following       |
| ly:\"Times New  | Roman\",serif"} | Roman\",serif"} | fields is       |
| Roman\",serif"} |                 |                 | valid:]{sty     |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 0 - Port   |
|                 |                 |                 | Type            |
|                 |                 |                 | Valid]{sty      |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 1 -        |
|                 |                 |                 | Version         |
|                 |                 |                 | Valid]{sty      |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 2 -        |
|                 |                 |                 | Command Status  |
|                 |                 |                 | Valid]{sty      |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 3 - Device |
|                 |                 |                 | ID Valid [(PCI  |
|                 |                 |                 | C               |
|                 |                 |                 | onfig-Space)]{s |
|                 |                 |                 | tyle="backgroun |
|                 |                 |                 | d:yellow"}]{sty |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 4 - Device |
|                 |                 |                 | Serial Number   |
|                 |                 |                 | Valid]{sty      |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 5 - Bridge |
|                 |                 |                 | Control Status  |
|                 |                 |                 | Valid]{sty      |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 6 -        |
|                 |                 |                 | Capability      |
|                 |                 |                 | Structure       |
|                 |                 |                 | Status          |
|                 |                 |                 | Valid]{sty      |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 7 - AER    |
|                 |                 |                 | Info            |
|                 |                 |                 | Valid]{sty      |
|                 |                 |                 | le="font-size:1 |
|                 |                 |                 | 0.0pt;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 8 - Device |
|                 |                 |                 | ID Valid        |
|                 |                 |                 | (RCRB).]{styl   |
|                 |                 |                 | e="font-family: |
|                 |                 |                 | \"Times New Rom |
|                 |                 |                 | an\",serif;back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 |                 |
|                 |                 |                 | [NOTE: If this  |
|                 |                 |                 | bit is set,     |
|                 |                 |                 | then Bit 3 must |
|                 |                 |                 | be              |
|                 |                 |                 | 0.]{styl        |
|                 |                 |                 | e="font-family: |
|                 |                 |                 | \"Times New Rom |
|                 |                 |                 | an\",serif;back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit 9 - RCRB   |
|                 |                 |                 | High Address    |
|                 |                 |                 | Valid]{st       |
|                 |                 |                 | yle="font-size: |
|                 |                 |                 | 10.0pt;font-fam |
|                 |                 |                 | ily:\"Times New |
|                 |                 |                 |  Roman\",serif; |
|                 |                 |                 |   back          |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 |                 |
|                 |                 |                 | [NOTE: If this  |
|                 |                 |                 | bit is 0, the   |
|                 |                 |                 | RCRB High       |
|                 |                 |                 | Address is      |
|                 |                 |                 | assumed to be   |
|                 |                 |                 | 0.]{styl        |
|                 |                 |                 | e="font-family: |
|                 |                 |                 | \"Times New Rom |
|                 |                 |                 | an\",serif;back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bit            |
|                 |                 |                 | ~~[8]{style="co |
|                 |                 |                 | lor:red"}~~[10] |
|                 |                 |                 | {style="backgro |
|                 |                 |                 | und:yellow"}-63 |
|                 |                 |                 | --              |
|                 |                 |                 | Reserved]{s     |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
+-----------------+-----------------+-----------------+-----------------+
| [Port           | [8]{s           | [5]{s           | **[...]{sty     |
| Type]{s         | tyle="font-fami | tyle="font-fami | le="font-family |
| tyle="font-fami | ly:\"Times New  | ly:\"Times New  | :\"Times New Ro |
| ly:\"Times New  | Roman\",serif"} | Roman\",serif"} | man\",serif"}** |
| Roman\",serif"} |                 |                 |                 |
|                 |                 |                 | [4: Root        |
|                 |                 |                 | Port~~[ 5:      |
|                 |                 |                 | Upstream Switch |
|                 |                 |                 | Port]{sty       |
|                 |                 |                 | le="color:red"} |
|                 |                 |                 | ~~]{style="font |
|                 |                 |                 | -size:10.0pt;fo |
|                 |                 |                 | nt-family:Nimbu |
|                 |                 |                 | sRomNo9L-Regu"} |
|                 |                 |                 |                 |
|                 |                 |                 | [5: Upstream    |
|                 |                 |                 | Switch          |
|                 |                 |                 | P               |
|                 |                 |                 | ort]{style="fon |
|                 |                 |                 | t-size:10.0pt;f |
|                 |                 |                 | ont-family:Nimb |
|                 |                 |                 | usRomNo9L-Regu; |
|                 |                 |                 |   back          |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 |                 |
|                 |                 |                 | **[...]{sty     |
|                 |                 |                 | le="font-family |
|                 |                 |                 | :\"Times New Ro |
|                 |                 |                 | man\",serif"}** |
+-----------------+-----------------+-----------------+-----------------+
| **[...]{sty     | **[...]{sty     | **[...]{sty     | **[...]{sty     |
| le="font-family | le="font-family | le="font-family | le="font-family |
| :\"Times New Ro | :\"Times New Ro | :\"Times New Ro | :\"Times New Ro |
| man\",serif"}** | man\",serif"}** | man\",serif"}** | man\",serif"}** |
+-----------------+-----------------+-----------------+-----------------+
| ~~[Reserved]{   | [20]{s          | [4]{s           | ~~[Must be      |
| style="font-fam | tyle="font-fami | tyle="font-fami | zero]{          |
| ily:\"Times New | ly:\"Times New  | ly:\"Times New  | style="font-fam |
|  Roman\",serif; | Roman\",serif"} | Roman\",serif"} | ily:\"Times New |
| color:red"}~~[\ |                 |                 |  Roman\",serif; |
| [RCRB High      |                 |                 | color:red"}~~[\ |
| Address]        |                 |                 | Upper DW of the |
| {style="backgro |                 |                 | MMIO base       |
| und:yellow"}]{s |                 |                 | address for the |
| tyle="font-fami |                 |                 | RCR             |
| ly:\"Times New  |                 |                 | B]{style="font- |
| Roman\",serif"} |                 |                 | family:\"Times  |
|                 |                 |                 | New Roman\",ser |
|                 |                 |                 | if;background:y |
|                 |                 |                 | ellow"}[.]{styl |
|                 |                 |                 | e="font-family: |
|                 |                 |                 |   \"Times New   |
|                 |                 |                 | Roman\",serif"} |
+-----------------+-----------------+-----------------+-----------------+
| [Device         | [24]{s          | [16]{s          | [PCIe Root Port |
| ID]{s           | tyle="font-fami | tyle="font-fami | PCI/bridge PCI  |
| tyle="font-fami | ly:\"Times New  | ly:\"Times New  | compatible      |
| ly:\"Times New  | Roman\",serif"} | Roman\",serif"} | device number   |
| Roman\",serif"} |                 |                 | and             |
|                 |                 |                 | bus]{s          |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [number         |
|                 |                 |                 | information to  |
|                 |                 |                 | uniquely        |
|                 |                 |                 | identify the    |
|                 |                 |                 | root port or    |
|                 |                 |                 | bridge.]{s      |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Default values |
|                 |                 |                 | for both the    |
|                 |                 |                 | bus numbers is  |
|                 |                 |                 | zero.]{s        |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 0-1:      |
|                 |                 |                 | Vendor          |
|                 |                 |                 | ID]{s           |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 2-3:      |
|                 |                 |                 | Device          |
|                 |                 |                 | ID]{s           |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 4-6:      |
|                 |                 |                 | Class           |
|                 |                 |                 | Code]{s         |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | ~~[Byte 7:      |
|                 |                 |                 | Function        |
|                 |                 |                 | Number          |
|                 |                 |                 | ]{style="font-f |
|                 |                 |                 | amily:\"Times N |
|                 |                 |                 | ew Roman\",seri |
|                 |                 |                 | f;color:red"}~~ |
|                 |                 |                 |                 |
|                 |                 |                 | ~~[Byte 8:      |
|                 |                 |                 | Device          |
|                 |                 |                 | Number          |
|                 |                 |                 | ]{style="font-f |
|                 |                 |                 | amily:\"Times N |
|                 |                 |                 | ew Roman\",seri |
|                 |                 |                 | f;color:red"}~~ |
|                 |                 |                 |                 |
|                 |                 |                 | ~~[Byte 9-10:   |
|                 |                 |                 | Segment         |
|                 |                 |                 | Number          |
|                 |                 |                 | ]{style="font-f |
|                 |                 |                 | amily:\"Times N |
|                 |                 |                 | ew Roman\",seri |
|                 |                 |                 | f;color:red"}~~ |
|                 |                 |                 |                 |
|                 |                 |                 | [If Bit 3 is    |
|                 |                 |                 | set in          |
|                 |                 |                 | Validation      |
|                 |                 |                 | Bits:]{styl     |
|                 |                 |                 | e="font-family: |
|                 |                 |                 | \"Times New Rom |
|                 |                 |                 | an\",serif;back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 |                 |
|                 |                 |                 | [·[             |
|                 |                 |                 | ]{s             |
|                 |                 |                 | tyle="font:7.0p |
|                 |                 |                 | t \"Times New R |
|                 |                 |                 | oman\""}]{style |
|                 |                 |                 | ="font-family:S |
|                 |                 |                 | ymbol;backgroun |
|                 |                 |                 | d:yellow"}[Byte |
|                 |                 |                 | 7: Function     |
|                 |                 |                 | Numb            |
|                 |                 |                 | er]{style="font |
|                 |                 |                 | -family:\"Times |
|                 |                 |                 |  New Roman\",se |
|                 |                 |                 | rif;background: |
|                 |                 |                 |   yellow"}      |
|                 |                 |                 |                 |
|                 |                 |                 | [·[             |
|                 |                 |                 | ]{s             |
|                 |                 |                 | tyle="font:7.0p |
|                 |                 |                 | t \"Times New R |
|                 |                 |                 | oman\""}]{style |
|                 |                 |                 | ="font-family:S |
|                 |                 |                 | ymbol;backgroun |
|                 |                 |                 | d:yellow"}[Byte |
|                 |                 |                 | 8: Device       |
|                 |                 |                 | Numb            |
|                 |                 |                 | er]{style="font |
|                 |                 |                 | -family:\"Times |
|                 |                 |                 |  New Roman\",se |
|                 |                 |                 | rif;background: |
|                 |                 |                 |   yellow"}      |
|                 |                 |                 |                 |
|                 |                 |                 | [·[             |
|                 |                 |                 | ]{s             |
|                 |                 |                 | tyle="font:7.0p |
|                 |                 |                 | t \"Times New R |
|                 |                 |                 | oman\""}]{style |
|                 |                 |                 | ="font-family:S |
|                 |                 |                 | ymbol;backgroun |
|                 |                 |                 | d:yellow"}[Byte |
|                 |                 |                 | 9-10: Segment   |
|                 |                 |                 | Numb            |
|                 |                 |                 | er]{style="font |
|                 |                 |                 | -family:\"Times |
|                 |                 |                 |  New Roman\",se |
|                 |                 |                 | rif;background: |
|                 |                 |                 |   yellow"}      |
|                 |                 |                 |                 |
|                 |                 |                 | [Else if Bit 8  |
|                 |                 |                 | is set in       |
|                 |                 |                 | Validation      |
|                 |                 |                 | Bits:]{styl     |
|                 |                 |                 | e="font-family: |
|                 |                 |                 | \"Times New Rom |
|                 |                 |                 | an\",serif;back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 |                 |
|                 |                 |                 | [·[             |
|                 |                 |                 | ]{s             |
|                 |                 |                 | tyle="font:7.0p |
|                 |                 |                 | t \"Times New R |
|                 |                 |                 | oman\""}]{style |
|                 |                 |                 | ="font-family:S |
|                 |                 |                 | ymbol;backgroun |
|                 |                 |                 | d:yellow"}[Byte |
|                 |                 |                 | 7-10: Lower DW  |
|                 |                 |                 | of the MMIO     |
|                 |                 |                 | base address    |
|                 |                 |                 | for the         |
|                 |                 |                 | RC              |
|                 |                 |                 | RB]{style="font |
|                 |                 |                 | -family:\"Times |
|                 |                 |                 |  New Roman\",se |
|                 |                 |                 | rif;background: |
|                 |                 |                 |   yellow"}[.]{s |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 11: Root  |
|                 |                 |                 | Port/Bridge     |
|                 |                 |                 | Primary Bus     |
|                 |                 |                 | Number or       |
|                 |                 |                 | device bus      |
|                 |                 |                 | number]{s       |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 12: Root  |
|                 |                 |                 | Port/Bridge     |
|                 |                 |                 | Secondary Bus   |
|                 |                 |                 | Number]{s       |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 13-14:    |
|                 |                 |                 | Bit0:2:         |
|                 |                 |                 | Reserved        |
|                 |                 |                 | Bit3:15 Slot    |
|                 |                 |                 | Number]{s       |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 15        |
|                 |                 |                 | Reserved]{s     |
|                 |                 |                 | tyle="font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
+-----------------+-----------------+-----------------+-----------------+
| **[...]{sty     | **[...]{sty     | **[...]{sty     | **[...]{sty     |
| le="font-family | le="font-family | le="font-family | le="font-family |
| :\"Times New Ro | :\"Times New Ro | :\"Times New Ro | :\"Times New Ro |
| man\",serif"}** | man\",serif"}** | man\",serif"}** | man\",serif"}** |
+-----------------+-----------------+-----------------+-----------------+

[ ]{style="font-family:\"Times New Roman\",serif"}

[\
]{style="font-size:11.0pt;line-height:107%;font-family:\"Times New Roman\",serif"}

[ ]{style="font-size:10.0pt;line-height:107%;font-family:
\"Times New Roman\",serif"}

**[N.2.13 Compute Express Link (CXL) Protocol Error
Section]{style="font-size:12.0pt;font-family:\"Arial\",sans-serif"}**

[Type: { 0x80B9EFB4, 0x52B5, 0x4DE3, { 0xA7, 0x77, 0x68, 0x78, 0x4B,
0x77, 0x10, 0x48 } }]{style="font-family:\"Times New Roman\",serif"}

**[Table N.41: CXL Protocol Error
Section]{style="font-family:\"Times New Roman\",serif"}**

+-----------------+-----------------+-----------------+-----------------+
| **[Mnem         | **[Byte         | **[Byte         | **[Descrip      |
| onic]{style="fo | Of              | Le              | tion]{style="fo |
| nt-size:10.0pt; | fset]{style="fo | ngth]{style="fo | nt-size:10.0pt; |
|   line-heigh    | nt-size:10.0pt; | nt-size:10.0pt; |   line-heigh    |
| t:107%;font-fam |   line-heigh    |   line-heigh    | t:107%;font-fam |
| ily:\"Times New | t:107%;font-fam | t:107%;font-fam | ily:\"Times New |
|  Roman\",serif; | ily:\"Times New | ily:\"Times New |  Roman\",serif; |
| color:black"}** |  Roman\",serif; |  Roman\",serif; | color:black"}** |
|                 | color:black"}** | color:black"}** |                 |
+-----------------+-----------------+-----------------+-----------------+
| [CXL Agent      | [8]{style="fo   | [1]{style="fo   | [0 - This error |
| Type]{style="fo | nt-size:10.0pt; | nt-size:10.0pt; | was detected by |
| nt-size:10.0pt; |   line-height   |   line-height   | a CXL ~~[1.1    |
|   line-height   | :107%;font-fami | :107%;font-fami | device]{style=  |
| :107%;font-fami | ly:\"Times New  | ly:\"Times New  | "color:red"}~~[ |
| ly:\"Times New  | Roman\",serif"} | Roman\",serif"} | ]{style="       |
| Roman\",serif"} |                 |                 | color:red"}[RCD |
|                 |                 |                 | RCIeP]{sty      |
|                 |                 |                 | le="background: |
|                 |                 |                 | yellow"}]{style |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [1 - This error |
|                 |                 |                 | was detected by |
|                 |                 |                 | a CXL ~~[1.1    |
|                 |                 |                 | host]{style     |
|                 |                 |                 | ="color:red"}~~ |
|                 |                 |                 | [R              |
|                 |                 |                 | CH]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | ~~[d]           |
|                 |                 |                 | {style="color:r |
|                 |                 |                 | ed"}~~[D]{style |
|                 |                 |                 | ="background:ye |
|                 |                 |                 | llow"}ownstream |
|                 |                 |                 | ~~[p]{style="c  |
|                 |                 |                 | olor:red"}~~[P] |
|                 |                 |                 | {style="backgro |
|                 |                 |                 | und:yellow"}ort |
|                 |                 |                 | [RCRB]{sty      |
|                 |                 |                 | le="background: |
|                 |                 |                 | yellow"}]{style |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [2 - This error |
|                 |                 |                 | was detected by |
|                 |                 |                 | [a]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | CXL             |
|                 |                 |                 | ~~[2.0]{style=  |
|                 |                 |                 | "color:red"}~~[ |
|                 |                 |                 | ]{style="color  |
|                 |                 |                 | :red"}[ Endpoin |
|                 |                 |                 | t]{style="backg |
|                 |                 |                 | round:yellow"}[ |
|                 |                 |                 | ~~d~~]{         |
|                 |                 |                 | style="color:re |
|                 |                 |                 | d"}[D]{style="b |
|                 |                 |                 | ackground:yello |
|                 |                 |                 | w"}evice]{style |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [3 - This error |
|                 |                 |                 | was detected by |
|                 |                 |                 | [a]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | CXL             |
|                 |                 |                 | ~~[2.0]{style=  |
|                 |                 |                 | "color:red"}~~[ |
|                 |                 |                 | ]{style="col    |
|                 |                 |                 | or:red"}Logical |
|                 |                 |                 | Device]{style   |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [4 - This error |
|                 |                 |                 | was detected by |
|                 |                 |                 | [a]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | CXL             |
|                 |                 |                 | ~~[2.0]{style=  |
|                 |                 |                 | "color:red"}~~[ |
|                 |                 |                 | ]{style="co     |
|                 |                 |                 | lor:red"}Fabric |
|                 |                 |                 | Manager managed |
|                 |                 |                 | Logical         |
|                 |                 |                 | ~~[d]{st        |
|                 |                 |                 | yle="color:red" |
|                 |                 |                 | }~~[D]{style="b |
|                 |                 |                 | ackground:yello |
|                 |                 |                 | w"}evice]{style |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [5 - This error |
|                 |                 |                 | was detected by |
|                 |                 |                 | [a]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | CXL             |
|                 |                 |                 | ~~[2.0]{style=  |
|                 |                 |                 | "color:red"}~~[ |
|                 |                 |                 | ]{style="       |
|                 |                 |                 | color:red"}Root |
|                 |                 |                 | Port]{style     |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [6 - This error |
|                 |                 |                 | was detected by |
|                 |                 |                 | [a]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | CXL             |
|                 |                 |                 | ~~[2.0]{style=  |
|                 |                 |                 | "color:red"}~~[ |
|                 |                 |                 | ]{style="color: |
|                 |                 |                 | red"}Downstream |
|                 |                 |                 | Switch          |
|                 |                 |                 | Port]{style     |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [7 - This error |
|                 |                 |                 | was detected by |
|                 |                 |                 | [a]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | CXL             |
|                 |                 |                 | ~~[2.0]{style=  |
|                 |                 |                 | "color:red"}~~[ |
|                 |                 |                 | ]{style="colo   |
|                 |                 |                 | r:red"}Upstream |
|                 |                 |                 | Switch          |
|                 |                 |                 | Port]{style     |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [8-255 --       |
|                 |                 |                 | Reserved]{style |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [ ]{style       |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [In this table, |
|                 |                 |                 | the term "CXL   |
|                 |                 |                 | Device" is used |
|                 |                 |                 | to refer to     |
|                 |                 |                 | [a]{sty         |
|                 |                 |                 | le="background: |
|                 |                 |                 |   yellow"} CXL  |
|                 |                 |                 | ~~[1.1          |
|                 |                 |                 | Device]{style=  |
|                 |                 |                 | "color:red"}~~[ |
|                 |                 |                 | ]{style="       |
|                 |                 |                 | color:red"}[RCD |
|                 |                 |                 | RCiE            |
|                 |                 |                 | P]{style="backg |
|                 |                 |                 | round:yellow"}, |
|                 |                 |                 | CXL             |
|                 |                 |                 | ~~[2.0]{style   |
|                 |                 |                 | ="color:red"}~~ |
|                 |                 |                 | [Endpoi         |
|                 |                 |                 | nt]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | Device, CXL     |
|                 |                 |                 | ~~[2.0]{style   |
|                 |                 |                 | ="color:red"}~~ |
|                 |                 |                 | Logical Device  |
|                 |                 |                 | or a CXL        |
|                 |                 |                 | ~~[2.0]{style   |
|                 |                 |                 | ="color:red"}~~ |
|                 |                 |                 | Fabric Manager  |
|                 |                 |                 | ~~              |
|                 |                 |                 | [M]{style="colo |
|                 |                 |                 | r:red"}~~[m]{st |
|                 |                 |                 | yle="background |
|                 |                 |                 | :yellow"}anaged |
|                 |                 |                 | Logical         |
|                 |                 |                 | Device.]{style  |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [In this table, |
|                 |                 |                 | the term "CXL   |
|                 |                 |                 | Port" is used   |
|                 |                 |                 | to refer to     |
|                 |                 |                 | [a]{sty         |
|                 |                 |                 | le="background: |
|                 |                 |                 |   yellow"} CXL  |
|                 |                 |                 | ~~[1.1          |
|                 |                 |                 | host]{style     |
|                 |                 |                 | ="color:red"}~~ |
|                 |                 |                 | [R              |
|                 |                 |                 | CH]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | ~~[d]           |
|                 |                 |                 | {style="color:r |
|                 |                 |                 | ed"}~~[D]{style |
|                 |                 |                 | ="background:ye |
|                 |                 |                 | llow"}ownstream |
|                 |                 |                 | ~~[p]{style="c  |
|                 |                 |                 | olor:red"}~~[P] |
|                 |                 |                 | {style="backgro |
|                 |                 |                 | und:yellow"}ort |
|                 |                 |                 | [RCR            |
|                 |                 |                 | B]{style="backg |
|                 |                 |                 | round:yellow"}, |
|                 |                 |                 | CXL Root Port,  |
|                 |                 |                 | CXL Downstream  |
|                 |                 |                 | Switch Port and |
|                 |                 |                 | Upstream Switch |
|                 |                 |                 | Port.]{style    |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
+-----------------+-----------------+-----------------+-----------------+
| [Rese           | [9]{style="fo   | [7]{style="fo   | [Must be        |
| rved]{style="fo | nt-size:10.0pt; | nt-size:10.0pt; | zero]{style="fo |
| nt-size:10.0pt; |   line-height   |   line-height   | nt-size:10.0pt; |
|   line-height   | :107%;font-fami | :107%;font-fami |   line-height   |
| :107%;font-fami | ly:\"Times New  | ly:\"Times New  | :107%;font-fami |
| ly:\"Times New  | Roman\",serif"} | Roman\",serif"} | ly:\"Times New  |
| Roman\",serif"} |                 |                 | Roman\",serif"} |
+-----------------+-----------------+-----------------+-----------------+
| [CXL Agent      | [16]{style="fo  | [8]{style="fo   | [If this CXL    |
| Add             | nt-size:10.0pt; | nt-size:10.0pt; | agent is a [CXL |
| ress]{style="fo |   line-height   |   line-height   | RCD             |
| nt-size:10.0pt; | :107%;font-fami | :107%;font-fami | RCiE            |
|   line-height   | ly:\"Times New  | ly:\"Times New  | P,]{style="back |
| :107%;font-fami | Roman\",serif"} | Roman\",serif"} | ground:yellow"} |
| ly:\"Times New  |                 |                 | CXL             |
| Roman\",serif"} |                 |                 | [Endpoin        |
|                 |                 |                 | t]{style="backg |
|                 |                 |                 | round:yellow"}[ |
|                 |                 |                 | ~               |
|                 |                 |                 | ~d~~]{style="co |
|                 |                 |                 | lor:red"}[D]{st |
|                 |                 |                 | yle="background |
|                 |                 |                 | :yellow"}evice, |
|                 |                 |                 | CXL Root Port,  |
|                 |                 |                 | CXL]{style      |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Downstream     |
|                 |                 |                 | Switch Port or  |
|                 |                 |                 | CXL Upstream    |
|                 |                 |                 | Switch Port,    |
|                 |                 |                 | then the PCIe   |
|                 |                 |                 | compatible      |
|                 |                 |                 | device/function |
|                 |                 |                 | number, bus     |
|                 |                 |                 | number, and     |
|                 |                 |                 | segment number  |
|                 |                 |                 | information are |
|                 |                 |                 | used to         |
|                 |                 |                 | uniquely        |
|                 |                 |                 | identify the    |
|                 |                 |                 | Co              |
|                 |                 |                 | mponent:]{style |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 0 -       |
|                 |                 |                 | Function        |
|                 |                 |                 | number]{style   |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 1 -       |
|                 |                 |                 | Device          |
|                 |                 |                 | number]{style   |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 2 - Bus   |
|                 |                 |                 | number]{style   |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bytes 3-4 -    |
|                 |                 |                 | Segment         |
|                 |                 |                 | number]{style   |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Bytes 5-7 --   |
|                 |                 |                 | Reserved]{style |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [ ]{style       |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [If CXL agent   |
|                 |                 |                 | is a CXL        |
|                 |                 |                 |  ~~[1.1         |
|                 |                 |                 | host]{style     |
|                 |                 |                 | ="color:red"}~~ |
|                 |                 |                 | [R              |
|                 |                 |                 | CH]{style="back |
|                 |                 |                 | ground:yellow"} |
|                 |                 |                 | ~~[d]           |
|                 |                 |                 | {style="color:r |
|                 |                 |                 | ed"}~~[D]{style |
|                 |                 |                 | ="background:ye |
|                 |                 |                 | llow"}ownstream |
|                 |                 |                 | ~~[p]{style="c  |
|                 |                 |                 | olor:red"}~~[P] |
|                 |                 |                 | {style="backgro |
|                 |                 |                 | und:yellow"}ort |
|                 |                 |                 | [RCRB]{styl     |
|                 |                 |                 | e="background:y |
|                 |                 |                 | ellow"}:]{style |
|                 |                 |                 | ="font-size:10. |
|                 |                 |                 | 0pt;line-height |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
|                 |                 |                 |                 |
|                 |                 |                 | [Byte 0-7 - CXL |
|                 |                 |                 | Port RCRB Base  |
|                 |                 |                 | add             |
|                 |                 |                 | ress]{style="fo |
|                 |                 |                 | nt-size:10.0pt; |
|                 |                 |                 |   line-height   |
|                 |                 |                 | :107%;font-fami |
|                 |                 |                 | ly:\"Times New  |
|                 |                 |                 | Roman\",serif"} |
+-----------------+-----------------+-----------------+-----------------+

[ ]{style="font-family:\"Times New Roman\",serif"}
:::
