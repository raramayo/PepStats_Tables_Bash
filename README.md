**[![DOI](https://zenodo.org/badge/778490844.svg)](https://zenodo.org/doi/10.5281/zenodo.10888521)**
# **PepStats_Tables_Bash**

## **Motivation**

```
This script was generated with the objective of constructing a table summarizing the main physical-chemical properties associated with each protein present in a given proteome.
The script uses PepStats, an EMBOSS program to extract and construct a table displaying the following protein properties:
    Protein_ID
	Molecular_weight
	No_Residues
	Average_Residue_Weight
	Isoelectric_Point
	Mole%_Tiny
	Mole%_Small
	Mole%_Aliphatic
	Mole%_Aromatic
	Mole%_Non-polar
	Mole%_Polar
	Mole%_Charged
	Mole%_Basic
	Mole%_Acidic
In theory, thie script could be easily modified to extract other protein properties calculated by PepStats, but not extracted by the current script
```

## Documentation

```
########################################################################################################################################################################################################
ARAMAYO_LAB

This program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not,
see <https://www.gnu.org/licenses/>.

SCRIPT_NAME:                       PepStats_Tables_v1.0.0.sh
SCRIPT_VERSION:                    1.0.0

USAGE: PepStats_Tables_v1.0.0.sh
       -p Homo_sapiens.GRCh38.pep.all.fa               # REQUIRED (Proteins File - Proteome)
       -r PepStats_Tables                              # OPTIONAL (Run Name)
       -z TMPDIR Location                              # OPTIONAL (default=0='TMPDIR Run')

TYPICAL COMMANDS:
                                   PepStats_Tables_v1.0.0.sh -p Homo_sapiens.GRCh38.pep.all.fa -r PepStats_Tables

INPUT01:          -p FLAG          REQUIRED - Protein File
INPUT01_FORMAT:                    Fasta Format
INPUT01_DEFAULT:                   No default

INPUT02:          -r FLAG          OPTIONAL - Run Name
INPUT02_FORMAT:                    Text
INPUT02_DEFAULT:                   PepStats_Tables

INPUT03:          -z FLAG          OPTIONAL input
INPUT03_FORMAT:                    Numeric: 0 == TMPDIR Run | 1 == Normal Run
INPUT03_DEFAULT:                   0 == TMPDIR Run
INPUT03_NOTES:                     0 Processes the data in the $TMPDIR directory of the computer used or of the node assigned by the SuperComputer scheduler
INPUT03_NOTES:                     Processing the data in the $TMPDIR directory of the node assigned by the SuperComputer scheduler reduces the possibility of file error generation due to network traffic
INPUT03_NOTES:                     1 Processes the data in the same directory where the script is being run

DEPENDENCIES:                      EMBOSS:        Required (see: http://emboss.open-bio.org/html/adm/ch01s01.html)

Author:                            Rodolfo Aramayo
WORK_EMAIL:                        raramayo@tamu.edu
PERSONAL_EMAIL:                    rodolfo@aramayo.org
########################################################################################################################################################################################################
```

## Development/Testing Environment:

```
Distributor ID:       Ubuntu
Description:	      Ubuntu 22.04.3 LTS
Release:	          22.04
Codename:	          jammy
```

```
Distributor ID:       Apple, Inc.
Description:          Apple M1 Max
Release:              14.4.1
Codename:             Sonoma
```

## Required Script Dependencies:
### EMBOSS (https://emboss.sourceforge.net/download/)
#### Version Number: 6.6.0.0
#### Credits: https://emboss.sourceforge.net/credits/
