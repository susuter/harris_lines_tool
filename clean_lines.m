function lines = clean_lines(lines0)


%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine

global ORIENTATION_TOLERANCE ECCENTRICITY_TOLERANCE LENGTH_TOLERANCE;

[lines3, num_labels] = bwlabel(lines0, 8);
lines_stats = regionprops(lines3, 'Orientation', 'BoundingBox', 'Eccentricity', 'MinorAxisLength', 'MajorAxisLength');

lines4 = lines0;
for i = 1:num_labels
    orientation = lines_stats(i).Orientation;
    eccentricity= lines_stats(i).Eccentricity;
    hl_malength = lines_stats(i).MajorAxisLength;
    if (hl_malength < LENGTH_TOLERANCE || orientation < -ORIENTATION_TOLERANCE || orientation > ORIENTATION_TOLERANCE || eccentricity < ECCENTRICITY_TOLERANCE)
        bb = floor(lines_stats(i).BoundingBox);
        x3 = floor(bb(1,1));
        y3 = floor(bb(1,2));
        lines4(y3:y3+bb(1,4), x3:x3+bb(1,3)) = zeros();
    end
end
lines = bwmorph(lines4, 'clean');
