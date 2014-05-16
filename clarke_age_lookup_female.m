function age = clarke_age_lookup_female(hl)
%hl = percentage of occurence of harris line in distal adult diaphyses

table = [0.429, 0; 0.346, 1; 0.292, 2; 0.255, 3;0.227, 4; 0.202, 5; ...
    0.18, 6; 0.159, 7; 0.137, 8; 0.114, 9; 0.089, 10; 0.069, 11; ...
    0.051, 12; 0.037, 13; 0.025, 14; 0.017, 15; 0.011, 16];

age = clarke_age_lookup(hl, table);