ReadMeFirst.SeaChest.txt                                  Revision: 16-Jul-2017
===============================================================================
 Seagate Utilities
 Copyright (c) 2017 Seagate Technology LLC, All Rights Reserved
===============================================================================
Please READ ME FIRST

Thank you for downloading SeaChest Utilities, build 14-July-2017

This is a limited Engineering Preview Release, just prior to being made
available to the general public.

SeaChest Utilities are command line utilities which are available for expert
users.  These command line tools assume the user is knowledgeable about running
software from the operating system command prompt.  CLI tools are in the
English language only and use "command line arguments" to define the various
tasks and specific devices.  SeaChest Utilities are available for both Linux
and Windows environments.

Linux versions of SeaChest Utilities are available as stand alone 32 or 64-bit
executables you can copy to your own system.  Windows OS versions of SeaChest
Utilities are installed through a typical setup wizard and can be removed via
the Control Panel.  Versions for FreeBSD, PowerPC and Solaris are available by
request.

A tool to create a bootable USB flash drive version of SeaChest is available in
the "USB boot maker" folder.  This EXE runs from Windows and will require a
dedicated USB flash drive.  Any data on the USB flash drive will be lost when
the USB boot maker tool runs.  The bootable flash drive boots to the 32-bit or
64-bit Tiny Core Linux distribution.

SeaChest Utilities supports non-RAID SATA, SAS and USB interface drives.

The other files in the ZIP download are:

        SeaChest Basics - Contains the most important tests and tools.

Other SeaChest "break out" utilities are available and listed below which offer
more in-depth functionality in specific areas. These are:

        SeaChest Configure - Tools to control various settings on the drives
        are brought together into this one tool.  Typical commands, for
        example, include Write Cache and Read Lookahead Cache enable or disable.

        SeaChest Erase - The focus is on data erasure.  There are many
        different choices for erasing data from simple boot track erase to full
        cryptographic erasure (when supported).  Be sure to back up important
        data before using this tool.  Seagate is not responsible for lost user
        data.  This tool only works on Seagate drives.

        SeaChest Firmware - Seagate products are run by firmware.  Having the
        latest firmware can improve performance and or reliability of your
        product.  Seagate recommends applying new firmware to enhance the
        performance and or reliability of your drive.  Most products may see
        one or two firmware updates within the early life of the product.

        SeaChest FormatUnit - Storage products which utilize the SAS, SCSI or
        Fibre Channel interfaces are able to perform a full low-level media
        format in the field.  SCSI command devices are able to rescan the
        surface of the media while managing defective sectors (if any) and even
        change the drive sector size.  The SCSI Format Unit command offers many
        specialty options to accommodate a variety of conditions and to fine
        tune the procedure.

        SeaChest GenericTests - Read Tests are the original disk drive
        diagnostic which is to just read every sector on the drive,
        sequentially.  This tool offers several common read tests which can be
        defined by either time or range.  In addition, the Long Generic test
        has the ability to repair problem sectors, possibly eliminating an
        unnecessary drive return.

        SeaChest Info - Historical generic activity logs (like total bytes
        written and power on hours) and performance logs (like temperature) are
        available for analytical review.  Identification and inquiry data
        stored on the drive is also provided.  A view of SMART and device
        statistics is available when supported by the drive.

        SeaChest PowerChoice - Seagate disk drives offer a multitude of options
        to manage power.  This tool manipulates the various power modes.

        SeaChest Security - Various settings are available on modern Seagate
        disk drives which may be locked and unlocked.  These settings may
        interact with the operating systems and systems BIOS.  Options also
        include cryptographic erase for Self-Encrypting Drives (SED).

        SeaChest SMART - This tool provides a closer look at the collected
        SMART attributes data.  SMART stands for Self-Monitoring, Analysis and
        Reporting Technology.  Short Drive Self Test is included as one of the
        standard SMART commands. In addition, the DST & Clean test has the
        ability to repair problem sectors, possibly eliminating an unnecessary
        drive return.

Technical Support for SeaChest drive utilities is not available.  If you have
the time to send us some feedback about this software, especially if you notice
something we should fix or improve, we would greatly appreciate hearing from
you.  To report your comments and suggestions, please include the version
information and use this email seaboard@seagate.com

If SeaChest Utilities does not serve your needs for any reason, please try the
original GUI utility software SeaTools for Windows or SeaTools Bootable
available at www.seagate.com/seatools.

Thanks again, and we hope you'll enjoy using SeaChest Utilities to test your
Seagate hard disk drive.

- SeaChest Utilities Development Team

=================================
Support and Open Source Statement
=================================
Seagate offers technical support for disk drive installation.  If you have any
questions related to Seagate products and technologies, feel free to submit
your request on our web site. See the web site for a list of world-wide
telephone numbers.

Seagate Support:
http://www.seagate.com/support-home/
Contact Us:
http://www.seagate.com/contacts/

Please report bugs/suggestions to seaboard@seagate.com. Include the output of
--version information in the email. See the user guide section 'General Usage
Hints' for information about saving output to a log file.

This software uses open source packages obtained with permission from the
relevant parties. For a complete list of open source components, sources and
licenses, please see our Linux USB Boot Maker Utility FAQ for additional
information.

The newest online version of the SeaChest Utilities documentation, open source
usage and acknowledgement licenses, and our Linux USB Boot Maker FAQ can be
found at:
http://support.seagate.com/firmware/usbbootmaker_faq.html

Copyright (c) 2017 Seagate Technology LLC. All rights reserved.

======================================================================

                        END USER LICENSE AGREEMENT
                            FOR SEAGATE SOFTWARE


PLEASE READ THIS END USER LICENSE AGREEMENT ("EULA") CAREFULLY.  BY CLICKING
"I AGREE" OR TAKING ANY STEP TO DOWNLOAD, SET-UP, INSTALL OR USE ALL OR ANY
PORTION OF THIS PRODUCT (INCLUDING, BUT NOT LIMITED TO, THE SOFTWARE AND
ASSOCIATED FILES (THE "SOFTWARE"), HARDWARE ("HARDWARE"), DISK (S), OR OTHER
MEDIA) (COLLECTIVELY, THE "PRODUCT") YOU AND YOUR COMPANY ACCEPT ALL THE
TERMS AND CONDITIONS OF THIS EULA.  IF YOU ACQUIRE THIS PRODUCT FOR YOUR
COMPANY’S USE, YOU REPRESENT THAT YOU ARE AN AUTHORIZED REPRESENTATIVE WHO
HAS THE AUTHORITY TO LEGALLY BIND YOUR COMPANY TO THIS EULA.  IF YOU DO NOT
AGREE, DO NOT CLICK "I AGREE" AND DO NOT DOWNLOAD, SET-UP, INSTALL OR USE THE
SOFTWARE.


1.  Ownership.  This EULA applies to the Software and Products of Seagate
Technology LLC and the affiliates controlled by, under common control with,
or controlling Seagate Technology LLC, including but not limited to
affiliates operating under the LaCie name or brand, (collectively, "Seagate",
"we", "us", "our").  Seagate and its suppliers own all right, title, and
interest in and to the Software, including all intellectual property rights
therein.  The Software is licensed, not sold.  The structure, organization,
and code of the Software are the valuable trade secrets and confidential
information of Seagate and its suppliers.  The Software is protected by
copyright and other intellectual property laws and treaties, including,
without limitation, the copyright laws of the United States and other
countries. The term "Software" does not refer to or include "Third-Party
Software".  "Third-Party Software" means certain software licensed by Seagate
from third parties that may be provided with the specific version of Software
that you have licensed.  The Third-Party Software is generally not governed
by the terms set forth below but is subject to different terms and conditions
imposed by the licensors of such Third-Party Software.  The terms of your use
of the Third-Party Software are subject to and governed by the respective
license terms, except that this Section 1 and Sections 5 and 6 of this
Agreement also govern your use of the Third-Party Software.  You may identify
and view the relevant licenses and/or notices for such Third-Party Software
for the Software you have received pursuant to this EULA at
http://www.seagate.com/support/by-topic/downloads/ , or at
http://www.lacie.com/support/ for LaCie branded product. You agree to comply
with the terms and conditions contained in all such Third-Party Software
licenses with respect to the applicable Third-Party Software. Where
applicable, the URLs for sites where you may obtain source code for the Third
Party Software can be found at
http://www.seagate.com/support/by-topic/downloads/, or at
http://www.lacie.com/support/ for LaCie branded product.

2.  Product License.  Subject to your compliance with the terms of this EULA,
Seagate grants you a personal, non-exclusive, non-transferable, limited
license to install and use one (1) copy of the Software on one (1) device
residing on your premises, internally and only for the purposes described in
the associated documentation. Use of some third party software included on
the media provided with the Product may be subject to terms and conditions of
a separate license agreement; this license agreement may be contained in a
"Read Me" file located on the media that accompanies that Product.  The
Software includes components that enable you to link to and use certain
services provided by third parties ("Third Party Services").  Your use of the
Third Party Services is subject to your agreement with the applicable third
party service provider.  Except as expressly stated herein, this EULA does
not grant you any intellectual property rights in the Product. Seagate and
its suppliers reserve all rights not expressly granted to you.  There are no
implied rights.

2.1     Software.  You are also permitted to make a single copy of the
Software strictly for backup and disaster recovery purposes.  You may not
alter or modify the Software or create a new installer for the Software.  The
Software is licensed and distributed by Seagate for use with its storage
products only, and may not be used with non-Seagate storage product.

3.  Restrictions.  You are not licensed to do any of the following:
        a.      Create derivative works based on the Product or any part or
                component thereof, including, but not limited to, the
                Software;

        b.      Reproduce the Product, in whole or in part;

        c.      Except as expressly authorized by Section 11 below, sell,
                assign, license, disclose, or otherwise transfer or make
                available the Product, in whole or in part, to any third
                party;

        d.      Alter, translate, decompile, or attempt to reverse engineer
                the Product or any part or component thereof, except and only
                to the extent that such activity is expressly permitted by
                applicable law notwithstanding this contractual prohibition;

        e.      Use the Product to provide services to third parties;

        f.      Take any actions that would cause the Software to become
                subject to any open source license agreement if it is not
                already subject to such an agreement; and

        g.      Remove or alter any proprietary notices or marks on the
                Product.

4.  Updates.  If you receive an update or an upgrade to, or a new version of,
any Software ("Update") you must possess a valid license to the previous
version in order to use the Update.  All Updates provided to you shall be
subject to the terms and conditions of this EULA.  If you receive an Update,
you may continue to use the previous version(s) of the Software in your
possession, custody or control.  Seagate shall have no obligation to support
the previous versions of the Software upon availability of an Update. Seagate
has no obligation to provide support, maintenance, Updates, or modifications
under this EULA.

5.  NO WARRANTY.  THE PRODUCT AND THE THIRD-PARTY SOFTWARE ARE OFFERED ON AN
"AS-IS" BASIS AND NO WARRANTY, EITHER EXPRESS OR IMPLIED, IS GIVEN.  SEAGATE
AND ITS SUPPLIERS EXPRESSLY DISCLAIM ALL WARRANTIES OF ANY KIND, WHETHER
STATUTORY, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NON-INFRINGEMENT.  SEAGATE DOES NOT PROVIDE THE THIRD PARTY SERVICES AND
MAKES NO WARRANTIES WITH RESPECT TO THE THIRD PARTY SERVICES.  YOUR USE OF
THE THIRD PARTY SERVICES IS AT YOUR RISK.

6.  EXCLUSION OF INCIDENTAL, CONSEQUENTIAL, AND CERTAIN OTHER DAMAGES.  TO
THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL SEAGATE OR
ITS LICENSORS OR SUPPLIERS BE LIABLE FOR ANY SPECIAL, INCIDENTAL, PUNITIVE,
INDIRECT, OR CONSEQUENTIAL DAMAGES WHATSOEVER (INCLUDING, BUT NOT LIMITED TO,
DAMAGES FOR LOSS OF PROFITS OR CONFIDENTIAL OR OTHER INFORMATION, FOR
BUSINESS INTERRUPTION, FOR PERSONAL INJURY, FOR LOSS OF PRIVACY, FOR FAILURE
TO MEET ANY DUTY INCLUDING OF GOOD FAITH OR REASONABLE CARE, FOR NEGLIGENCE,
AND FOR ANY OTHER PECUNIARY OR OTHER LOSS WHATSOEVER) ARISING OUT OF OR IN
ANY WAY RELATED TO THE USE OF OR INABILITY TO USE THE PRODUCT OR ANY PART OR
COMPONENT THEREOF OR RELATED SERVICE OR ANY THIRD PARTY SERVICES, OR
OTHERWISE UNDER OR IN CONNECTION WITH ANY PROVISION OF THE EULA, EVEN IN THE
EVENT OF THE FAULT, TORT (INCLUDING NEGLIGENCE), MISREPRESENTATION, STRICT
LIABILITY, BREACH OF CONTRACT, OR BREACH OF WARRANTY OF SEAGATE OR ITS
LICENSORS OR SUPPLIERS, AND EVEN IF SEAGATE OR ITS LICENSOR OR SUPPLIER HAS
BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND NOTWITHSTANDING ANY
FAILURE OF THE ESSENTIAL PURPOSE OF THIS AGREEMENT OR ANY REMEDY.

7.  LIMITATION OF LIABILITY.  NOTWITHSTANDING ANY DAMAGES THAT YOU MIGHT
INCUR FOR ANY REASON WHATSOEVER, THE ENTIRE LIABILITY OF SEAGATE UNDER ANY
PROVISION OF THIS EULA AND YOUR EXCLUSIVE REMEDY HEREUNDER SHALL BE LIMITED
TO, AND IN NO EVENT WILL SEAGATE'S TOTAL CUMULATIVE DAMAGES EXCEED, THE FEES
PAID BY THE LICENSEE TO SEAGATE FOR THE PRODUCT.  ADDITIONALLY, IN NO EVENT
SHALL SEAGATE'S LICENSORS OR SUPPLIERS BE LIABLE FOR ANY DAMAGES OF ANY KIND.

8.  Privacy.  Seagate’s collection, use and disclosure of personally
identifiable information in connection with your use of the Product is
governed by Seagate’s Privacy Policy which is located at
http://www.seagate.com/legal-privacy/privacy-policy/As further described in
Seagate’s Privacy Policy, certain Products may include a Product dashboard
which allows users to manage Product settings, including but not limited to
use of anonymous statistical usage data in connection with personally
identifiable information. You agree to Seagate’s collection, use, and
disclosure of your data in accordance with the Product dashboard settings
selected by you for the Product, or in the case of transfer as described in
Section 11, you agree to the settings selected by the prior licensee unless
or until you make changes to the settings.

9.  Indemnification.  By accepting the EULA, you agree to indemnify and
otherwise hold harmless Seagate, its officers, employees, agents,
subsidiaries, affiliates, and other partners from any direct, indirect,
incidental, special, consequential or exemplary damages arising out of,
relating to, or resulting from your use of the Product or any other matter
relating to the Product, including, without limitation, use of any of the
Third Party Services.

10.  International Trade Compliance.  The Software and any related technical
data made available for download under this EULA are subject to the customs
and export control laws and regulations of the United States ("U.S.") and may
also be subject to the customs and export laws and regulations of the country
in which the download is contemplated.  Further, under U.S. law, the Software
and any related technical data made available for download under this EULA
may not be sold, leased or otherwise transferred to restricted countries, or
used by a restricted end-user (as determined on any one of the U.S.
government restricted parties lists, found at
http://www.bis.doc.gov/complianceandenforcement/liststocheck.htm) or an
end-user engaged in activities related to weapons of mass destruction
including, without limitation, activities related to designing, developing,
producing or using nuclear weapons, materials, or facilities, missiles or
supporting missile projects, or chemical or biological weapons.  You
acknowledge that you are not a citizen, national, or resident of, and are not
under control of the governments of Cuba, Iran, North Korea, Sudan or Syria;
are not otherwise a restricted end-user as defined by U.S. export control
laws; and are not engaged in proliferation activities.  Further, you
acknowledge that you will not download or otherwise export or re-export the
Software or any related technical data directly or indirectly to the
above-mentioned countries or to citizens, nationals, or residents of those
countries, or to any other restricted end user or for any restricted end-use.

11.  General.  This EULA between Licensee and Seagate is governed by and
construed in accordance with the laws of the State of California without
regard to conflict of laws principles.  The EULA constitutes the entire
agreement between Seagate and you relating to the Product and governs your
use of the Product, superseding any prior agreement between you and Seagate
relating to the subject matter hereof.  If any provision of this EULA is held
by a court of competent jurisdiction to be contrary to law, such provision
will be changed and interpreted so as to best accomplish the objectives of
the original provision to the fullest extent allowed by law and the remaining
provisions of the EULA will remain in force and effect.  The Product and any
related technical data are provided with restricted rights.  Use,
duplication, or disclosure by the U.S. government is subject to the
restrictions as set forth in subparagraph (c)(1)(iii) of DFARS 252.227-7013
(The Rights in Technical Data and Computer Product) or subparagraphs (c)(1)
and (2) of 48 CFR 52.227-19 (Commercial Computer Product - Restricted
Rights), as applicable.  The manufacturer is Seagate.  You may not transfer
or assign this EULA or any rights under this EULA, except that you may make a
one-time, permanent transfer of this EULA and the Software to another end
user, provided that (i) you do not retain any copies of the Software, the
Hardware, the media and printed materials, Upgrades (if any), and this EULA,
and (ii) prior to the transfer, the end user receiving this EULA and the
Software agrees to all the EULA terms.  Any attempted assignment in violation
of this Section is void.  Seagate, the Seagate logo, and other Seagate names
and logos are the trademarks of Seagate.

5.4.2016

===========================================================================

GNU LESSER GENERAL PUBLIC LICENSE

Version 3, 29 June 2007

Copyright (c) 2007 Free Software Foundation, Inc. <http://fsf.org/>

Everyone is permitted to copy and distribute verbatim copies of this license
document, but changing it is not allowed.

This version of the GNU Lesser General Public License incorporates the terms
and conditions of version 3 of the GNU General Public License, supplemented
by the additional permissions listed below.

0. Additional Definitions.

As used herein, "this License" refers to version 3 of the GNU Lesser General
Public License, and the "GNU GPL" refers to version 3 of the GNU General
Public License.

"The Library" refers to a covered work governed by this License, other than
an Application or a Combined Work as defined below.

An "Application" is any work that makes use of an interface provided by the
Library, but which is not otherwise based on the Library. Defining a subclass
of a class defined by the Library is deemed a mode of using an interface
provided by the Library.

A "Combined Work" is a work produced by combining or linking an Application
with the Library. The particular version of the Library with which the
Combined Work was made is also called the "Linked Version".

The "Minimal Corresponding Source" for a Combined Work means the
Corresponding Source for the Combined Work, excluding any source code for
portions of the Combined Work that, considered in isolation, are based on the
Application, and not on the Linked Version.

The "Corresponding Application Code" for a Combined Work means the object
code and/or source code for the Application, including any data and utility
programs needed for reproducing the Combined Work from the Application, but
excluding the System Libraries of the Combined Work.

1. Exception to Section 3 of the GNU GPL.

You may convey a covered work under sections 3 and 4 of this License without
being bound by section 3 of the GNU GPL.

2. Conveying Modified Versions.

If you modify a copy of the Library, and, in your modifications, a facility
refers to a function or data to be supplied by an Application that uses the
facility (other than as an argument passed when the facility is invoked),
then you may convey a copy of the modified version:

* a) under this License, provided that you make a good faith effort to ensure
that, in the event an Application does not supply the function or data, the
facility still operates, and performs whatever part of its purpose remains
meaningful, or

* b) under the GNU GPL, with none of the additional permissions of this
License applicable to that copy.

3. Object Code Incorporating Material from Library Header Files.

The object code form of an Application may incorporate material from a header
file that is part of the Library. You may convey such object code under terms
of your choice, provided that, if the incorporated material is not limited to
numerical parameters, data structure layouts and accessors, or small macros,
inline functions and templates (ten or fewer lines in length), you do both of
the following:

* a) Give prominent notice with each copy of the object code that the Library
is used in it and that the Library and its use are covered by this License.

* b) Accompany the object code with a copy of the GNU GPL and this license
document.

4. Combined Works.

You may convey a Combined Work under terms of your choice that, taken
together, effectively do not restrict modification of the portions of the
Library contained in the Combined Work and reverse engineering for debugging
such modifications, if you also do each of the following:

* a) Give prominent notice with each copy of the Combined Work that the
Library is used in it and that the Library and its use are covered by this
License.

* b) Accompany the Combined Work with a copy of the GNU GPL and this license
document.

* c) For a Combined Work that displays copyright notices during execution,
include the copyright notice for the Library among these notices, as well as
a reference directing the user to the copies of the GNU GPL and this license
document.

* d) Do one of the following:
  o 0) Convey the Minimal Corresponding Source under the terms of this
License, and the Corresponding Application Code in a form suitable for, and
under terms that permit, the user to recombine or relink the Application
with a modified version of the Linked Version to produce a modified
Combined Work, in the manner specified by section 6 of the GNU GPL for
conveying Corresponding Source.
  o 1) Use a suitable shared library mechanism for linking with the Library.
A suitable mechanism is one that (a) uses at run time a copy of the Library
already present on the user's computer system, and (b) will operate
properly with a modified version of the Library that is
interface-compatible with the Linked Version.

* e) Provide Installation Information, but only if you would otherwise be
required to provide such information under section 6 of the GNU GPL, and only
to the extent that such information is necessary to install and execute a
modified version of the Combined Work produced by recombining or relinking
the Application with a modified version of the Linked Version. (If you use
option 4d0, the Installation Information must accompany the Minimal
Corresponding Source and Corresponding Application Code. If you use option
4d1, you must provide the Installation Information in the manner specified by
section 6 of the GNU GPL for conveying Corresponding Source.)

5. Combined Libraries.

You may place library facilities that are a work based on the Library side by
side in a single library together with other library facilities that are not
Applications and are not covered by this License, and convey such a combined
library under terms of your choice, if you do both of the following:

* a) Accompany the combined library with a copy of the same work based on the
Library, uncombined with any other library facilities, conveyed under the
terms of this License.

* b) Give prominent notice with the combined library that part of it is a
work based on the Library, and explaining where to find the accompanying
uncombined form of the same work.

6. Revised Versions of the GNU Lesser General Public License.

The Free Software Foundation may publish revised and/or new versions of the
GNU Lesser General Public License from time to time. Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

Each version is given a distinguishing version number. If the Library as you
received it specifies that a certain numbered version of the GNU Lesser
General Public License "or any later version" applies to it, you have the
option of following the terms and conditions either of that published version
or of any later version published by the Free Software Foundation. If the
Library as you received it does not specify a version number of the GNU
Lesser General Public License, you may choose any version of the GNU Lesser
General Public License ever published by the Free Software Foundation.

If the Library as you received it specifies that a proxy can decide whether
future versions of the GNU Lesser General Public License shall apply, that
proxy's public statement of acceptance of any version is permanent
authorization for you to choose that version for the Library.

===========================================================================
mbedtls - An open source, portable, easy to use, readable and flexible SSL
library https://tls.mbed.org

Modifications: -added DES & 3DES CFB cipher encryption and decryption support

         Apache License
   Version 2.0, January 2004
http://www.apache.org/licenses/

TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

1. Definitions.

"License" shall mean the terms and conditions for use, reproduction, and
distribution as defined by Sections 1 through 9 of this document.

"Licensor" shall mean the copyright owner or entity authorized by the copyright
owner that is granting the License.

"Legal Entity" shall mean the union of the acting entity and all other entities
that control, are controlled by, or are under common control with that entity.
For the purposes of this definition, "control" means (i) the power, direct or
indirect, to cause the direction or management of such entity, whether by
contract or otherwise, or (ii) ownership of fifty percent (50) or more of the
outstanding shares, or (iii) beneficial ownership of such entity.

"You" (or "Your") shall mean an individual or Legal Entity exercising
permissions granted by this License.

"Source" form shall mean the preferred form for making modifications, including
but not limited to software source code, documentation source,and configuration
files.

"Object" form shall mean any form resulting from mechanical transformation or
translation of a Source form, including but not limited to compiled object
code, generated documentation, and conversions to other media types.

"Work" shall mean the work of authorship, whether in Source or Object form,
made available under the License, as indicated by a copyright notice that is
included in or attached to the work (an example is provided in the Appendix
below).

"Derivative Works" shall mean any work, whether in Source or Object form, that
is based on (or derived from) the Work and for which the editorial revisions,
annotations, elaborations, or other modifications represent, as a whole, an
original work of authorship. For the purposes of this License, Derivative Works
shall not include works that remain separable from, or merely link (or bind by
name) to the interfaces of, the Work and Derivative Works thereof.

"Contribution" shall mean any work of authorship, including the original
version of the Work and any modifications or additions to that Work or
Derivative Works thereof, that is intentionally submitted to Licensor for
inclusion in the Work by the copyright owner or by an individual or Legal
Entity authorized to submit on behalf of the copyright owner. For the purposes
of this definition, "submitted" means any form of electronic, verbal, or
written communication sent to the Licensor or its representatives, including
but not limited to communication on electronic mailing lists, source code
control systems, and issue tracking systems that are managed by, or on behalf
of, the Licensor for the purpose of discussing and improving the Work, but
excluding communication that is conspicuously marked or otherwise designated in
writing by the copyright owner as "Not a Contribution."

"Contributor" shall mean Licensor and any individual or Legal Entity on behalf
of whom a Contribution has been received by Licensor and subsequently
incorporated within the Work.

2. Grant of Copyright License. Subject to the terms and conditions of this
License, each Contributor hereby grants to You a perpetual, worldwide,
non-exclusive, no-charge, royalty-free, irrevocable copyright license to
reproduce, prepare Derivative Works of, publicly display, publicly perform,
sublicense, and distribute the Work and such Derivative Works in Source or
Object form.

3. Grant of Patent License. Subject to the terms and conditions of this
License, each Contributor hereby grants to You a perpetual, worldwide,
non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this
section) patent license to make, have made, use, offer to sell, sell, import,
and otherwise transfer the Work, where such license applies only to those
patent claims licensable by such Contributor that are necessarily infringed by
their Contribution(s) alone or by combination of their Contribution(s) with the
Work to which such Contribution(s) was submitted. If You institute patent
litigation against any entity (including a cross-claim or counterclaim in a
lawsuit) alleging that the Work or a Contribution incorporated within the Work
constitutes direct or contributory patent infringement, then any patent
licenses granted to You under this License for that Work shall terminate as of
the date such litigation is filed.

4. Redistribution. You may reproduce and distribute copies of the Work or
Derivative Works thereof in any medium, with or without modifications, and in
Source or Object form, provided that You meet the following conditions:

(a) You must give any other recipients of the Work or Derivative Works a copy
of this License; and

(b) You must cause any modified files to carry prominent notices stating that
You changed the files; and

(c) You must retain, in the Source form of any Derivative Works that You
distribute, all copyright, patent, trademark, and attribution notices from the
Source form of the Work, excluding those notices that do not pertain to any
part of the Derivative Works; and

(d) If the Work includes a "NOTICE" text file as part of its distribution, then
any Derivative Works that You distribute must include a readable copy of the
attribution notices contained within such NOTICE file, excluding those notices
that do not pertain to any part of the Derivative Works, in at least one of the
following places: within a NOTICE text file distributed as part of the
Derivative Works; within the Source form or documentation, if provided along
with the Derivative Works; or, within a display generated by the Derivative
Works, if and wherever such third-party notices normally appear. The contents
of the NOTICE file are for informational purposes only and do not modify the
License. You may add Your own attribution notices within Derivative Works that
You distribute, alongside or as an addendum to the NOTICE text from the Work,
provided that such additional attribution notices cannot be construed as
modifying the License.

You may add Your own copyright statement to Your modifications and may provide
additional or different license terms and conditions for use, reproduction, or
distribution of Your modifications, or for any such Derivative Works as a
whole, provided Your use, reproduction, and distribution of the Work otherwise
complies with the conditions stated in this License.

5. Submission of Contributions. Unless You explicitly state otherwise, any
Contribution intentionally submitted for inclusion in the Work by You to the
Licensor shall be under the terms and conditions of this License, without any
additional terms or conditions. Notwithstanding the above, nothing herein shall
supersede or modify the terms of any separate license agreement you may have
executed with Licensor regarding such Contributions.

6. Trademarks. This License does not grant permission to use the trade names,
trademarks, service marks, or product names of the Licensor, except as required
for reasonable and customary use in describing the origin of the Work and
reproducing the content of the NOTICE file.

7. Disclaimer of Warranty. Unless required by applicable law or agreed to in
writing, Licensor provides the Work (and each Contributor provides its
Contributions) on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied, including, without limitation, any warranties
or conditions of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
PARTICULAR PURPOSE. You are solely responsible for determining the
appropriateness of using or redistributing the Work and assume any risks
associated with Your exercise of permissions under this License.

8. Limitation of Liability. In no event and under no legal theory, whether in
tort (including negligence), contract, or otherwise, unless required by
applicable law (such as deliberate and grossly negligent acts) or agreed to in
writing, shall any Contributor be liable to You for damages, including any
direct, indirect, special, incidental, or consequential damages of any
character arising as a result of this License or out of the use or inability to
use the Work (including but not limited to damages for loss of goodwill, work
stoppage, computer failure or malfunction, or any and all other commercial
damages or losses), even if such Contributor has been advised of the
possibility of such damages.

9. Accepting Warranty or Additional Liability. While redistributing the Work or
Derivative Works thereof, You may choose to offer, and charge a fee for,
acceptance of support, warranty, indemnity, or other liability obligations
and/or rights consistent with this License. However, in accepting such
obligations, You may act only on Your own behalf and on Your sole
responsibility, not on behalf of any other Contributor, and only if You agree
to indemnify, defend, and hold each Contributor harmless for any liability
incurred by, or claims asserted against, such Contributor by reason of your
accepting any such warranty or additional liability.

END OF TERMS AND CONDITIONS

APPENDIX: How to apply the Apache License to your work.

To apply the Apache License to your work, attach the following boilerplate
notice, with the fields enclosed by brackets "[]" replaced with your own
identifying information. (Don't include the brackets!) The text should be
enclosed in the appropriate comment syntax for the file format. We also
recommend that a file or class name and description of purpose be included on
the same "printed page" as the copyright notice for easier identification
within third-party archives.

Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

===========================================================================

zlib.h -- interface of the 'zlib' general purpose compression library version
1.2.8, April 28th, 2013

Copyright (C) 1995-2013 Jean-loup Gailly and Mark Adler

This software is provided 'as-is', without any express or implied warranty. In
no event will the authors be held liable for any damages arising from the use
of this software.

Permission is granted to anyone to use this software for any purpose, including
commercial applications, and to alter it and redistribute it freely, subject to
the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim
that you wrote the original software. If you use this software in a product, an
acknowledgment in the product documentation would be appreciated but is not
required.

2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.

Jean-loup Gailly        Mark Adler jloup@gzip.org
madler@alumni.caltech.edu
