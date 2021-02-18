function ages = computeByers()
%computes ages of harris lines occurence according to byers, 1991
%distal and proximal harris lines
%Proximal: pct = 1.15 ? (T ? 1.75P ) ? 100/T
%Distal: pct = 1.15 ? (T ? 2.33D) ? 100/T
%T: Total tibial length P: length of HL to proximal tibial end D: length of
%HL to disatl end
%input params:
%lines: input image, 1d, line or not, size of total original input image
%sex: 'm' for male, 'f' for female

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


global PHL DHL FEMALE LINES LINES_CUT RESULTS;

LINES_CUT = LINES;

tibial_length = size(LINES, 1);
proximal_lines = LINES(1:floor(tibial_length*PHL), :);
distal_lines = LINES(ceil(tibial_length*DHL):tibial_length, :);

proximal_size = size(proximal_lines, 1);
distal_size = size(distal_lines, 1);

%TODO: check if hls first need to be measured or if pixel values result in
%same output (because ratio, should be ok)
ages = [];
if (FEMALE)
    for phl = 1:proximal_size
        line = proximal_lines(phl);
        if (line)
            pct = 1.15 * (tibial_length - 1.75 * phl) * 100/tibial_length;
            ages =  [ages, byers_age_lookup_female(pct)];
        end
    end
    for dhl = 1:distal_size
        line = distal_lines(dhl);
        if (line)
            dhl_length = distal_size - dhl;
            pct = 1.15 * (tibial_length - 2.33 * dhl_length) * 100/tibial_length;
            ages =  [ages, byers_age_lookup_female(pct)];
        end
    end
else
    for phl = 1:proximal_size
        line = proximal_lines(phl);
        if (line)
            pct = 1.15 * (tibial_length - 1.75 * phl) * 100/tibial_length;
            ages =  [ages, byers_age_lookup_male(pct)];
        end
    end
    for dhl = 1:distal_size
        line = distal_lines(dhl);
        if (line)
            dhl_length = distal_size - dhl;
            pct = 1.15 * (tibial_length - 2.33 * dhl_length) * 100/tibial_length;
            ages =  [ages, byers_age_lookup_male(pct)];
        end
    end
end

RESULTS = ages;
