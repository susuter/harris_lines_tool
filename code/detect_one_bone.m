function [I_cropped, shape_shrinked, shape] = detect_one_bone()

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine

%define global variables
global DE PE PHL DHL THRESH THRESH_OFFSET IM_DCM IM_BONE IM_SHAPE IM_SHAPE_0;

level = THRESH + THRESH_OFFSET;
b = im2bw(IM_DCM, level);
%figure('Name', 'threshold'); imshow(b);

[c, num_labels] = bwlabel(b, 8);
stats = regionprops(c, 'BoundingBox', 'MajorAxisLength', 'FilledImage', 'Orientation', 'Area');

max_label = 0;
max_label_size = 0;
for i = 1:num_labels
    label_size = stats(i).Area;
    if (label_size > max_label_size)
        max_label_size = label_size;
        max_label = i;
    end
end

%total_bone_length = stats(max_label).MajorAxisLength;
max_bounding_box = stats(max_label).BoundingBox;
%orientation = stats(max_label).Orientation;
I_shape = stats(max_label).FilledImage;
[y, x] = size(I_shape);
shape = I_shape;
IM_SHAPE_0 = shape;
shape_shrinked = I_shape;
shape_shrinked(1:floor(y*PE)+10, :) = 0;
shape_shrinked(floor(y*DE)-10:(y-1), :) = 0;
shape_shrinked(ceil(y*PHL)-10:floor(y*DHL)+10, :) = 0;

IM_SHAPE = shape_shrinked;

I_cropped = imcrop(IM_DCM, [max_bounding_box(1,1) max_bounding_box(1,2) x-1 y-1]);
IM_BONE = I_cropped;
