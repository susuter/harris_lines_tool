function age = byers_age_lookup_female(hl)
%hl = percentage of occurence of harris line in distal adult diaphyses


table = [31.5, 1; 40.1,2; 46.6, 3; 52.4, 4; 58.6, 5; 63.9, 6; 69.0, 7; ...
    74.3, 8; 79.4, 9; 83.9, 10; 88.8, 11; 93.0, 12; 96.5, 13; 98.3, 14; ...
    99.1, 15; 100, 16];
age = byers_age_lookup(hl, table);
