# openSeaChest

## Cross platform utilities useful for performing various operations on SATA, SAS, NVMe, and USB storage devices

### Copyright (c) 2014-2019 Seagate Technology LLC and/or its Affiliates, All Rights Reserved

Welcome to the openSeaChest open source project!

BINARIES and SOURCE CODE files of the openSeaChest open source project have
been made available to you under the Mozilla Public License 2.0 (MPL).  The
openSeaChest project repository is maintained at
[https://github.com/Seagate/openSeaChest](https://github.com/Seagate/openSeaChest).

Compiled binary versions of the openSeaChest utilities for various operating
systems may be found at
[https://github.com/Seagate/ToolBin/tree/master/openSeaChest](https://github.com/Seagate/ToolBin/tree/master/openSeaChest)

This collection of storage device utility software is branched (forked) off of
an original utility collection called the Seagate SeaChest Utilities by Seagate
Technology LLC.  The original SeaChest Utilities are still available at
[www.seagate.com](https://www.seagate.com) or [https://github.com/Seagate/ToolBin/tree/master/SeaChest](https://github.com/Seagate/ToolBin/tree/master/SeaChest).
Binary versions are available for Linux or Windows, with the Windows versions
signed by Seagate Technology LLC.

openSeaChest is a collection of programming libraries for storage devices and
comprehensive, easy-to-use command line diagnostic tools that helps you quickly
determine the health and status of your storage product. It includes several
tests that will examine the physical media on your storage device.

### The applications are described below

* *openSeaChest_Basics*
* *openSeaChest_Configure*
* *openSeaChest_Erase*
* *openSeaChest_Firmware*
* *openSeaChest_Format*
* *openSeaChest_GenericTests*
* *openSeaChest_Info*
* *openSeaChest_Logs*
* *openSeaChest_NVMe*
* *openSeaChest_PowerControl*
* *openSeaChest_SMART*

### Important Notes

If this is your drive, you should always keep a current backup of your
important data.

Many tests and commands are completely data safe, while others will change the
drive (like firmware download or data erasure or setting the maximum capacity,
etc).  Be careful using openSeaChest because some of the features, like the
data erasure options, will cause data loss.   Some commands, like setting the
maximum LBA, may cause existing data on the drive to become inaccessible.  Some
commands, like disabling the read look ahead buffer, may affect the performance
of the drive.  Seagate is not responsible for lost user data.

**Windows note:** Your system will require the latest [Microsoft Visual C++ 2017 Redistributable](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads) to run the compiled openSeaChest tools under Windows.

**Important note:** Many tests in this tool directly reference storage device data
sectors, also known as Logical Block Addresses (LBA). Test arguments may
require a starting LBA or an LBA range.  The predefined variable 'maxLBA'
refers to the last sector on the drive.  Many older SATA and SAS storage
controllers (also known as Host Bus Adapters [HBA]) have a maximum addressable
limit of 4294967295 [FFFFh] LBAs hard wired into their design.  This equates to
2.1TB using 512 byte sectors.  This also means accessing an LBA beyond the
2.1TB limitation either will result in an error or simply the last readable LBA
(usually LBA 4294967295 [FFFFh]) depending on the actual hardware.  This
limitation can have important consequences.  For example, if you intended to
erase a 4TB drive, then only the first 2TB will actually get erased (or maybe
even twice!) and the last 2TB will remain untouched.  You should carefully
evaluate your system hardware to understand if your storage controllers provide
support for greater than 2.1TB.

**Note:** One gigabyte, or GB, equals one billion bytes when referring to hard
drive capacity. This software may use information provided by the operating
system to display capacity and volume size. The Windows file system uses a
binary calculation for gibibyte or GiB (2^30) which causes the abbreviated size
to appear smaller. The total number of bytes on a disk drive divided by the
decimal calculation for gigabyte or GB (10^9) shows the expected abbreviated
size. See this FAQ for more information
<http://knowledge.seagate.com/articles/en_US/FAQ/172191en?language=en_US>.

### About openSeaChest Command Line Diagnostics

Seagate offers both graphical user interface (GUI) and command line interface
(CLI) diagnostic tools for our storage devices.  SeaTools for Windows and
SeaTools Bootable for end users are the two most popular GUI tools.  These
tools support 15 languages.

openSeaChest diagnostics are command line utilities which are available for
expert users.  These command line tools assume the user is knowledgeable about
running software from the operating system command prompt.  CLI tools are in
the English language only and use "command line arguments" to define the
various tasks and specific devices.  openSeaChest diagnostics are available for
both Linux and Windows environments.

Linux versions of openSeaChest tools are available as stand alone 32 or 64-bit
executables you can copy to your own system.  Windows OS versions of
openSeaChest diagnostics are also available.

Technical Support for openSeaChest drive utilities is not available.  If you
have the time to send us some feedback about this software, especially if you
notice something we should fix or improve, we would greatly appreciate hearing
from you.  To report your comments and suggestions, please use this email
seaboard@seagate.com.  Please let us know the name and version of the tool you
are using.

openSeaChest drive utilities support SATA, SAS, NVMe and USB interface devices.

**openSeaChest_Basics** - Contains the most important tests and tools.

Other openSeaChest "break out" utilities are available and listed below which
offer more in-depth functionality in specific areas. These are:

**openSeaChest_Configure** - Tools to control various settings on the drives are
brought together into this one tool.  Typical commands, for example, include
Write Cache and Read Lookahead Cache enable or disable.

**openSeaChest_Erase** - The focus is on data erasure.  There are many different
choices for erasing data from simple boot track erase to full cryptographic
erasure (when supported).  Be sure to back up important data before using this
tool.  Seagate is not responsible for lost user data.  This tool only works on
Seagate drives.

**openSeaChest_Firmware** - Seagate products are run by firmware.  Having the
latest firmware can improve performance and or reliability of your product.
Seagate recommends applying new firmware to enhance the performance and or
reliability of your drive.  Most products may see one or two firmware updates
within the early life of the product.

**openSeaChest_Format** - Storage products which utilize the SAS, SCSI or Fibre
Channel interfaces are able to perform a full low-level media format in the
field.  The SCSI Format Unit command offers many specialty options to
accommodate a variety of conditions and to fine tune the procedure.  This
complex command deserves its own "break out" utility.

**openSeaChest_GenericTests** - Read Tests are the original disk drive diagnostic
which is to just read every sector on the drive, sequentially.  This tool
offers several common read tests which can be defined by either time or range.
In addition, the Long Generic test has the ability to repair problem sectors,
possibly eliminating an unnecessary drive return.

**openSeaChest_Info** - Historical generic activity logs (like total bytes written
and power on hours) and performance logs (like temperature) are available for
analytical review.  Identification and inquiry data stored on the drive is also
provided.  A view of SMART and device statistics is available when supported by
the drive.

**openSeaChest_Logs** -

**openSeaChest_NVMe** -

**openSeaChest_PowerControl** - Seagate disk drives offer a multitude of options to
manage power.  This tool manipulates the various power modes.

**openSeaChest_Security** - Various settings are available on modern Seagate disk
drives which may be locked and unlocked.  These settings may interact with the
operating systems and systems BIOS.  Options also include cryptographic erase
for Self-Encrypting Drives (SED).

**openSeaChest_SMART** - This tool provides a closer look at the collected SMART
attributes data.  SMART stands for Self-Monitoring, Analysis and Reporting
Technology.  Short Drive Self Test is included as one of the standard SMART
commands. In addition, the DST & Clean test has the ability to repair problem
sectors, possibly eliminating an unnecessary drive return.

### Names, Logos, and Brands

All product names, logos, and brands are property of their respective owners.
All company, product and service names mentioned in the source code are for
clarification purposes only. Use of these names, logos, and brands does not
imply endorsement.

### Support and Open Source Statement

Support from Seagate Technology for open source projects is different than traditional Technical Support.  If possible, please use the **Issues tab** in the individual software projects so that others may benefit from the questions and answers.  Include the output of --version information in the message. See the user guide section 'General Usage Hints' for information about saving output to a log file.


If you need to contact us through email, please choose one of these
two email addresses:

- opensource@seagate.com   for general questions and bug reports
- opensea-build@seagate.com   for specific questions about programming and building the software

Seagate offers technical support for drive installation.  If you have any questions related to Seagate products and technologies, feel free to submit your request on our web site. See the web site for a list of world-wide telephone numbers.

- http://www.seagate.com/support-home/
- Contact Us:
http://www.seagate.com/contacts/

This software uses open source packages obtained with permission from the
relevant parties. For a complete list of open source components, sources and
licenses, please see our Linux USB Boot Maker Utility FAQ for additional
information.

The newest online version of the openSeaChest Utilities documentation, open
source usage and acknowledgement licenses, and our Linux USB Boot Maker FAQ can
be found at: https://github.com/Seagate/openSeaChest.

Copyright (c) 2014-2019 Seagate Technology LLC and/or its Affiliates, All Rights Reserved

-----------------------------------------

BINARIES and SOURCE CODE files of the openSeaChest open source project have
been made available to you under the Mozilla Public License 2.0 (MPL).  Mozilla
is the custodian of the Mozilla Public License ("MPL"), an open source/free
software license.

