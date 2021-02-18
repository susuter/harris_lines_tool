function age = maat_age_lookup_male(hl)
%hl = percentage of occurence of harris line in distal adult diaphyses

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


table = [17.15, 2/12; 20.99, 4/12; 23.44, 6/12; 25.60, 1; 33.02, 1.5; ...
    36.75, 2; 40.04, 2.5; 42.94, 3; 45.65, 3.5; 48.22, 4; 50.72, 4.5; ...
    53.09, 5; 55.41, 5.5; 57.67, 6; 59.85, 6.5; 62.01, 7; 64.17, 7.5; ...
    66.3, 8; 68.43, 8.5; 70.51, 9; 72.58, 9.5; 74.64, 10; 76.66, 10.5; ...
    78.66, 11; 80.66, 11.5; 82.66, 12; 85.36, 12.5; 87.85, 13; 90.63, 13.5; ...
    92.84, 14; 94.82, 14.5; 96.44, 15; 97.84, 15.5; 98.77, 16; 99.35, 16.5; ...
    99.7, 17; 99.88, 17.5; 100, 18];

num_ages = size(table, 1);

for i = 1:num_ages
   if (hl <= table(i, 1))
       age = table(i, 2);
       break;
   end
end
