# Codebook data2018
This dataset compiles data from the monitoring efforts and water sampling events that occurred as part of the Penobscot Nation’s Water Resource Program in 2018. Water samples were collected from a total of 15 different runs and 106 different sites and were processed and analyzed in the lab. This dataset includes variables relevant to the creation of internal field and lab reports. The following codebook includes a description of each variable and some of their specific values in parentheses. It also specifies weather a variable should be associated to the field or lab reports and to a specific table within these reports. 

A data frame with 7,362 rows and 57 columns
| Variable Name    | Description                          | Associated Report | Associated Table |
|------------------|--------------------------------------|-------------------|------------------|
|SiteVisitID | Links the Site Visit information to the Sample Information - one to many relationship - and probably don't need for any reports
|RunCode |Code attributed to the run |Field | Site Visit Information
|RunDate |Date of run sampling |Field | Site Visit Information
|WaterBody |Type of water body sampled (lakes, river and tributary)
|SiteCode |Code attributed to the site |Field | Site Visit Information
|SiteVisitStartTime | Date and time that a sample was collected 
|Collectors |Initials of all staff on the run, delimited by a semi-colon. The first set of initials is the primary collector and should be used as one of the grouping variables in the field summary reports. | Field | Site Visit Information
|SiteDepth | Depth of water at which a sample was collected in meters | Field | Site Visit Information
|SiteDepthMethod |Method used to measure site depth | Field | Site Visit Information
|SamplingAirTemp | Air temperature at sampling site and time| Field |Site Visit Information
|Weather |General weather condition at sampling site and time (Partly Sunny, Sunny, Overcast, Precipitation) |Field |Site Visit Information
|RivCond | River conditions at sampling site and time (Calm, Ripples, Choppy, Whitecaps)| Field | Site Visit Information
|WaterLevel |Water level at sampling site and time (Very low, Low, Normal, High) |Field | Site Visit Information
|FoamRank |Foam presnce at sampling site and time (No Foam Present, Few Bubbles Present, Dispersed Foam Clumps) | Field| Site Visit Information
|FoamSource |Foam source at sampling saite and time (Unknown, Wave Action, Natural Causes, Municipal, industrial)  |Field |Site Visit Information
|SiteVisitComment |Comments made at time on sampling about conditions, errors or equipment problems. Should be included in the field summary report as "Site Visit Notes" |Field |Site Visit Information
|SampleID |Unique ID for each sample.  When it is a measurement it links to the associated records in the results table.
|ProjectCode |A way to distinguish different projects.  Not needed for the reports 
|SampleDatetime |Date and time of the sampling at site
|Agency_ID |Unique ID of the Agency associated with the sample. Is linked to another table in the database that has more information about each agency.
|Collector |Initials of staff who collected a sample bottle. Not needed for the field summary reports
|AgencySampleNumber |When another agency gives a sample another sample number
|SampleDepth |Depth of water sample collected in meters | Field| Sample
|SampleName |Unique name of each sample and should be included in the field summary report in the sample name column |Field |Sample
|CollMethod |Method of water sample collection. CO-E = Integrated core sample which should never have an associated depth of 0; GS = grab sample which should always have an associated depth of 0; Msmt = measurement and anytime you see this will have field results associated with it.  These are used to populate the Result table section of the Field Data summaries. |Field |Sample and Result
|Equip |Equipment used for the sample collection (Msmt, Vinyl Tube, Water Bottle) 
|CntrType |Container type for the water sample (BOD Bottle, Msmt, Plastic Bottle) |Field |Sample 
|CntrColor |Container color for the water sample (Amber, Black, Clear, Mnmt). Not necessary to include in the summary 
|CntrVol |Container volume for water sample in milliliters.(0,120,125,250,399,500,1000,2000) Not necessary to include in the summary 
|QCType |Quality Control type for water sample (00 Blank, Duplicate, Regular, Split)  Regular is just a typical sample.  Duplicate is a sample collected in the field at nearly the same time as the regular and meant to assess field methods.  Split is a sample bottle collected in the field at nearly the same time as the regular or duplicate and meant to assess laboratory methods.  This information will be displayed in two sections of the field summaries.  If a sample bottle is a duplicate the sample name should include the prefix "DUP-" in it. |Field |Sample and Result
|ChemPreserv |Chemical preservative used for the water sample (Msmt, Na2S2O3, None) 
|ThermPreserv  |Thermal preservative used for the water sample (Frozen (0 deg C), Msmt, Wet Ice (4 deg C)) 
|SampleFilterMethod |Filter method used for water sample (Msmt, None, Vacuum pump) 
|FieldMethod | Describes the process for collecting a sample or taking a measurement.  (Field Msr/Obs, Sample-Integrated Vertical Profile, Sample-Routine)  Field Msr/Obs = a field measurement or observation.  Sample-Integrated Vertical Profile = collecting water from many different depths by using a long vinyl tube sent straight down, like a straw in a drink.  Sample-Routine is what we typically call a grab sample and represents a sample bottle used to collect water at the surface. 
|LabAbbrev |Indicates at which lab a sample will be analyzed or is set to Msmt when it is a field measurement.  HETL is the Maine Health and Environmental Testing Laboratory to whom is sent theTotal Phosphorus and chlorophyll a samples.  PIN is the Penobscot Nation internal laboratory. |Field | Sample 
|Constituents |Indicates which constituents will be analyzed from the water in the bottle.  Alk = Alkalinity.  Cond = Conductivity. Turb = Turbidity. BOD = biochemical oxygen demand. Chla = chlorophyll a.  ColA = Apparent color.  ColiformIQT = total coliform using IDEXX Quanti-tray. EcoliIQT = E. coli using IDEXX Quanti-tray. TSS = total suspended solids. TotP = Total phosphorus.  These are preset in the field using code. 
|ContainerCode |Code used by the database developer for dealing with data back at the office. Not necessary for any reports 
|ContainerAbbrev |Container abbreviation. Should give abbreviations like BP(1) that stands for Brown Plastic 1 Liter. |Field |Sample
|FieldMethodProduct |Product of field method (Bollte, Filter, Recorded data)
|Bottle_ID |Four or more numbers for the bottle ID 
|ProcessDateTime |Date and time samples were pre-processed in the lab.  Currently this only applies to bacteria samples. | Lab 
|IncubationLength |This designates how many hours the coliform/e coli bacteria samples should have been in the incubator.  See Quality control flags document for more information. (0, 18, 24, NA) |Lab
|ProfileDepth |Depth in the water at which the measurement was taken, in meters.  This should be used to create the grids of temperature and dissolved oxygen (and any others in the future) to show how the numbers change as depth increases.  It should also be used to show the depth at which a water sample was collected. (0,1,2,3,4,5,6,7,8,9) |Field |Sample and Result
|FilterName |These are generated by running water from the BP(1) bottle through a membrane filter and saving it to send to HETL for chlorophyll a analysis. |Field |Filter
|ResultDateTime |Date and time a measurement was taken in the field 
|Analyst |Initials of water sample analyst
|Meter
|Const |Constituent being measured. This will have field results associated with it. (dissolved oxygen (DO), Secchi, pH and water temperature) |Field |Result
|Result |When CollMethod = Msmt, This will have field results associated with it.  |Field |Result
|Unit_ID |Unique ID that is linked to another table in the database that has more information about the units of measurement. (5, 19, 20, 26, 31, 35, 37, 39, 40)
|ResultFlag_ID |Number of flags detected
|ResultComment |Comments on results
|Constituent_ID |Unique ID that is linked to another table in the db that has more information about the consitutent. |Lab
|LabAnalysisDatetime |Date and time of lab analysis of results
|LabAnalysisStaff |Initials of person who performed the lab analysis 
|ResultValue |When CollMethod does not = Msmt, This will have lab results associated with it.  It is different from Results because it does not contain field results.  |Lab 
|AnalyticalMethod_ID |A unique ID associated with the analytical method that has a linked table in the database with more info about each.  Not necessary for the lab summary report. (5,6,7,8,10,11,14, NA)
