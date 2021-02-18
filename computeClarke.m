function ages = computeClarke()
%computes age of harris lines occurrence according to maat, 1984
%only distal 43% are used
%lines: input image, 1d, line or not, size of total original input image
%sex: 'm' for male, 'f' for female

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


global PRIM_OSS_CENTER FEMALE LINES LINES_CUT RESULTS DEF_LINE;

LINES_CUT = LINES(1:floor(size(LINES,1) * (1-DEF_LINE)), :);

distal43_lines = LINES_CUT(1:floor(size(LINES_CUT, 1)), :);
distal43_lines(1:ceil(PRIM_OSS_CENTER * size(LINES_CUT, 1)), :) = 0;
norm_lines = normalizeLines(distal43_lines);

ages = [];
num_hls = size(norm_lines, 1);
if (FEMALE) 
    for hl = 1:num_hls
        ages =  [ages, clarke_age_lookup_female(1-norm_lines(hl))];
    end
else
    for hl = 1:num_hls
        ages =  [ages, clarke_age_lookup_male(1-norm_lines(hl))];
    end    
end

RESULTS = ages;
