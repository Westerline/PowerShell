:: Used to Turn Windows Features On or Off, the /All parameter is used to also enable/disable any dependencies 

DISM /Online /Enable-Feature /FeatureName:FEATURENAME /All 
DISM /Online /Disable-Feature /FeatureName:FEATURENAME /All 