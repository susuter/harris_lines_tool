function age = clarke_age_lookup_male(hl)
%hl = percentage of occurence of harris line in distal adult diaphyses

table = [0.423, 0; 0.347, 1; 0.296, 2; 0.265, 3;0.240, 4; 0.219, 5; ...
    0.200, 6; 0.178, 7; 0.160, 8; 0.141, 9; 0.120, 10; 0.101, 11; ...
    0.084, 12; 0.068, 13; 0.046, 14; 0.032, 15; 0.016, 16];
age = clarke_age_lookup(hl, table);

