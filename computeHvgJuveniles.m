function hl_occurrences = computeHvgJuveniles()
%computes ages of harris line occurence according to hummert and van gerven
%, 1985
%TODO: implementation for adults
%no separation in sex
%input params:
%lines: input image, 1d, line or not, size of total original input image
%sex: 'm' for male, 'f' for female

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


global PRIM_OSS_CENTER AGE_GROUP LINES LINES_CUT RESULTS;
LINES_CUT = LINES;

distal43_lines = LINES(ceil(PRIM_OSS_CENTER * size(LINES, 1)):size(LINES, 1), :);
norm_lines = normalizeLines(distal43_lines);

%if (age)
    %warning('no age defined for this individual! computation for juveniles cannot be done without information of age group.');
%end
num_hls = size(norm_lines, 1);
hl_occurrences = [];

for hl = 1:num_hls
    hl_occurrences(1,hl) = hvg_lookup(AGE_GROUP, norm_lines(hl)*100);
end

RESULTS =hl_occurrences;


