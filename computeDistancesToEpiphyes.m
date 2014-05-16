function d = computeDistancesToEpiphyes()

global LINES PHL DHL RESOLUTION;

d = [];

tibial_length = size(LINES, 1);
proximal_lines = LINES(1:floor(tibial_length*PHL), :);
distal_lines = LINES(ceil(tibial_length*DHL):tibial_length, :);

proximal_size = size(proximal_lines, 1);
distal_size = size(distal_lines, 1);

for phl = 1:proximal_size
    line = proximal_lines(phl);
    if (line)
        d =  [d, pixel2cm(phl, RESOLUTION)];
    end
end
for dhl = 1:distal_size
    line = distal_lines(dhl);
    if (line)
        d =  [d, pixel2cm(distal_size-dhl, RESOLUTION)];
    end
end

d = d';
