function age = maat_age_lookup_female(hl)
%hl = percentage of occurence of harris line in distal adult diaphyses

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


table = [20.18, 2/12; 23.15, 4/12; 25.57, 6/12; 31.05, 1; 35.67, 1.5; ...
    39.65, 2; 43.25, 2.5; 46.42, 3; 49.42, 3.5; 52.33, 4; 55.13, 4.5; ...
    57.84, 5; 60.43, 5.5; 62.94, 6; 65.45, 6.5; 67.93, 7; 70.38, 7.5; ...
    72.8, 8; 75.23, 8.5; 77.65, 9; 80.07, 9.5; 82.43, 10; 84.77, 10.5; ...
    87.25, 11; 89.9, 11.5; 92.78, 12; 93.67, 12.5; 95.34, 13; 96.61, 13.5; ...
    98.18, 14; 99.16, 14.5; 99.65, 15; 99.87, 15.5; 100, 16];

num_ages = size(table, 1);

for i = 1:num_ages
   if (hl <= table(i, 1))
       age = table(i, 2);
       break;
   end
end
