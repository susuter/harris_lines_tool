function age = byers_age_lookup_male(hl)
%hl = percentage of occurence of harris line in distal adult diaphyses

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


table = [28.8, 1; 36.5,2; 42.4, 3; 47.6, 4; 53.5, 5; 57.9, 6; 62.3, 7; ...
    67.5, 8; 71.6, 9; 75.7, 10; 79.6, 11; 83.7, 12; 88.5, 13; 93.0, 14; ...
    96.7, 15; 99.0, 16; 100, 17];
age = byers_age_lookup(hl, table);
