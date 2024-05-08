function lines = removeShortLines(linesIn)

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


global MIN_LENGTH IM_SHAPE_0;


[labeledLines, num_labels] = bwlabel(linesIn, 8);
lines_stats = regionprops(labeledLines, 'Orientation', 'BoundingBox', 'MajorAxisLength');

linesOut = linesIn;
for i = 1:num_labels
    bb = floor(lines_stats(i).BoundingBox);
    x = floor(bb(1,1));
    y = floor(bb(1,2));
    max_width = sum(IM_SHAPE_0(y, :));
    rel_width = lines_stats(i).MajorAxisLength / max_width;
    if (rel_width < MIN_LENGTH)
        linesOut(y:y+bb(1,4), x:x+bb(1,3)) = zeros();
    end    
end
lines = bwmorph(linesOut, 'clean');
