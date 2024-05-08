function lines = removeNonHorizontal(lines0)

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine

global ORIENTATION_TOLERANCE;

[lines3, num_labels] = bwlabel(lines0, 8);
lines_stats = regionprops(lines3, 'Orientation', 'BoundingBox');

lines4 = lines0;
for i = 1:num_labels
    orientation = lines_stats(i).Orientation;
    if (orientation < -ORIENTATION_TOLERANCE || orientation > ORIENTATION_TOLERANCE)
        bb = floor(lines_stats(i).BoundingBox);
        x3 = floor(bb(1,1));
        y3 = floor(bb(1,2));
        lines4(y3:y3+bb(1,4), x3:x3+bb(1,3)) = zeros();
    end
end
lines = bwmorph(lines4, 'clean');
