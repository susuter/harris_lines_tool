function lines = removeShortLines(linesIn)

global MIN_LENGTH IM_SHAPE_0;


[labeledLines, num_labels] = bwlabel(linesIn, 8);
lines_stats = regionprops(labeledLines, 'Orientation', 'BoundingBox', 'MajorAxisLength');

linesOut = linesIn;
for i = 1:num_labels
    bb = floor(lines_stats(i).BoundingBox);
    x = floor(bb(1,1));
    y = floor(bb(1,2));
    %max_width_line = IM_SHAPE_0(y, :);
    %[max_width_line, num_labels2] = bwlabel(max_width_line, 8);
    %Be sure that there are no white pixels outside shape_0
    %if (num_labels > 1)
    %end
    max_width = sum(IM_SHAPE_0(y, :));
    rel_width = lines_stats(i).MajorAxisLength / max_width;
    if (rel_width < MIN_LENGTH)
        linesOut(y:y+bb(1,4), x:x+bb(1,3)) = zeros();
    end    
end
lines = bwmorph(linesOut, 'clean');
