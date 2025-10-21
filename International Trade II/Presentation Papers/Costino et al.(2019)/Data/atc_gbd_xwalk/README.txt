This folder contains the crosswalk that allows us to link WHO GBD codes (2012)
to the Anatomic Therapeutic Classes (ATC4)

OVERVIEW
-----------------------------------------------------------------------
This directory contains the hand coded crosswalk between ATC 4 codes as found in the IMS MIDAS and
the WHO GBD codes as found in the WHO disease burden data.


SOURCE
-------------------------------------------------------------------------
The source of the ATC (Anatomic Therapeutic Class) codes is IMS MIDAS:
/Data/Raw/MIDAS_2000-2013

The source of the WHO GBD (Global burden of disease codes):
/Data/Raw/WHO_GBD


DESCRIPTION
----------------------------------------------------------------------------

The directory has the following format

	atc_gbd_xwalk.dta ----This is the final crosswalk between ATC4 codes and GBD codes

	README.txt    -----what you are reading right now!


NOTES
---------------------------------------------------------------------------------
1) This file matches root codes from the WHO GBD to ATC codes. Root codes are at the lowest level of hierarchy when counting disease burdens.
The following example will be illustrative:
The WHO GBD has the following categories
	Childhood Cluster Diseases   	xxx
		Whooping cough		yyy
		Pertussis		zzz
where xxx, yyy and zzz are disease burdens (in terms of death or disability adjusted life years (DALY))
Whooping Cough and Pertussis are subsidiaries of Childhood cluster diseases and there is no further division after whooping cough and pertussis.
As a result whooping cough and pertussis are root codes which can be matched to ATC codes under this system.
"Childhood cluster diseases" is not matched to ATC codes since it a non-root GBD code

2) There were instances of codes which were root codes in the WHO GBD data but not in external documentation relating to the GBD classification
(http://www.who.int/healthinfo/statistics/gbdestimatescauselist.pdf)
For example
The external documentation has the following
	Oral Conditions
		Dental Caries
		Other oral conditions
but the WHO GBD dataset only has disease burdens for oral conditions as a whole. 
As a result we consolidated U147 (Other oral conditions) and U144 (Dental Caries) into U143.
We also consolidated U043 and U048 into U042 and U099, U100 and U103 into U098.

3) We aggregated GBD codes U036 with U037 in our crosswalk because disease burdens in the WHO data correspond to 2014 GBD codes which aggregate 
U036 and U037 together.

