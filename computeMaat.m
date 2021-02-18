function ages = computeMaat(hfig)
%computes age of harris lines occurrence according to maat, 1984
%only distal 43% are used
%lines: input image, 1d, line or not, size of total original input image
%sex: 'm' for male, 'f' for female

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine

global PRIM_OSS_CENTER FEMALE LINES RESULTS DEF_LINE LINES_CUT;

lines_def_top = LINES(1:floor(size(LINES,1) * (1-DEF_LINE)), :);
LINES_CUT = lines_def_top;

distal43_lines = LINES(ceil(PRIM_OSS_CENTER * size(lines_def_top, 1)):floor(size(lines_def_top, 1)), :);
norm_lines = normalizeLines(distal43_lines);
ages = [];
num_hls = size(norm_lines, 1);
if (FEMALE) 
    for hl = 1:num_hls
        ages(hl) =  maat_age_lookup_female(norm_lines(hl)*100);
    end
else
    for hl = 1:num_hls
        ages(hl) =  maat_age_lookup_male(norm_lines(hl)*100);
    end    
end

RESULTS = ages;
