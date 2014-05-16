function lines = removeCurlyLines(lines0)

global ECCENTRICITY_TOLERANCE;

[lines3, num_labels] = bwlabel(lines0, 8);
lines_stats = regionprops(lines3, 'BoundingBox', 'Eccentricity');

lines4 = lines0;
for i = 1:num_labels
    eccentricity= lines_stats(i).Eccentricity;
    if (eccentricity < ECCENTRICITY_TOLERANCE)
        bb = floor(lines_stats(i).BoundingBox);
        x3 = floor(bb(1,1));
        y3 = floor(bb(1,2));
        lines4(y3:y3+bb(1,4), x3:x3+bb(1,3)) = zeros();
    end
end
lines = bwmorph(lines4, 'clean');
