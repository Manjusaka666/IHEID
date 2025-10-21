OVERVIEW
-----------------------------------------------------------------------
This file is a hand-coded crosswalk between WHO GBD disease codes and NIH institutes or centers. 
The goal in creating this crosswalk was to map diseases to the NIH institute or center that is 
likely to fund research pertaining to the disease.


SOURCE
-------------------------------------------------------------------------
NIH Institutes
/Data/Raw/NIH_grants

WHO GBD (Global burden of disease codes):
/Data/Raw/WHO_GBD

DESCRIPTION
----------------------------------------------------------------------------

The directory has the following format

	ctry_xwalk.dta ----This is the final crosswalk between the different name formats

	README.txt    -----what you are reading right now!


NOTES
---------------------------------------------------------------------------------
Linking these two data sources is complicated by the fact that GBD codes and NIH institutes 
or centers do not map together in a one-to-one manner. In general, the NIH data identifies 
disease categories at a more aggregated level. 
We hand match each of the 58 GBD codes available for the United States in 2012 to the 
appropriate NIH institute. We attempt to assign each GBD code to one institute. We succeed 
in doing so for 55 GBD codes: all except the codes for Maternal conditions, Abortion, and Poisonings.
Note that a number of these choices are subjective and many diseases could have been assigned 
to more than one institute. For example Iron-deficiency anaemia could be linked to 
“National Institute of Diabetes, Digestive and Kidney Diseases” or the 
“National Heart Lung and Blood Institute”. 
This crosswalk mapped the 55 GBD codes that we can match to 11 NIH institutes. We could not 
match “National Institute on Deafness and Other Communication Disorders”, 
“National Institute of Biomedical Imaging and Bioengineering”, 
“National Institute of Environmental Health Sciences” “National Eye Institute” 
“National Institute for General Medical Services”, or “National Human Genome Research Institute” 
to any GBD codes.

The table below lists the abbreviation for the NIH institutes and centers that GBD codes were mapped to.


Abbreviation	NIH institute or center
AA		National Institute of Alcohol Abuse and Alcoholism	
AG 		National Institute on Aging	
AI 		National Institute of Allergy and Infectious Diseases Extramural Activities	
AR 		National Institute of Arthritis and Musculoskeletal and Skin Diseases	
CA 		National Cancer Institute	 
DA 		National Institute on Drug Abuse	
DE 		National Institute on Dental and Craniofacial research	
DK 		National Institute of Diabetes and Digestive and Kidney Diseases	
HL 		National Heart, Lung and Blood Institute	
MH 		National Institute of Mental Health	
NS 		National Institute of Neurological Disorders and Stroke
