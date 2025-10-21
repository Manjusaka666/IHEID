%% loading the data from file
[dataQ,datadate,raw] = xlsread('SW_Data4HW2025.xlsx','Sheet10'); %% NB: Your data may be in a Sheet with a different name !!
% CK08-US data  in logged per capita terms   : c i y h pi rw r
timeline=(1965.0:0.25:2024.75)'; %% Data are from 1965Q1 until 2024Q4
lambda = 1600;              % HP smoothing parameter for quarterly data	 
	cobs = (dataQ(:,1))-one_sided_hp_filter(dataQ(:,1), lambda);  
	iobs = (dataQ(:,2))-one_sided_hp_filter(dataQ(:,2), lambda);
	yobs = (dataQ(:,3))-one_sided_hp_filter(dataQ(:,3), lambda); 	
	labobs = (dataQ(:,4))-one_sided_hp_filter(dataQ(:,4), lambda); 
	piobs=demean(dataQ(:,5));
	rwobs = (dataQ(:,6))-one_sided_hp_filter(dataQ(:,6), lambda);  
	robs=demean(dataQ(:,7));
	

	