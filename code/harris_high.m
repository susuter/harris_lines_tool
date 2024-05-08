function lines = harris_high()

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


global SHRINK SIGMA DE PE PHL DHL HL_LENGTH IM_BONE;

[y, x] = size(IM_BONE);

I_line_response(y,x) = 0; % assure that respones has same size as input

I_proximal = IM_BONE(floor(y*PE)+1:floor(y*PHL), :); 
I_distal = IM_BONE(ceil(y*DHL):floor(y*DE), :);

I_line_response(floor(y*PE)+1:floor(y*PHL), :) = line_detection1d(I_proximal, SIGMA, SHRINK);
I_line_response(ceil(y*DHL):floor(y*DE), :) = line_detection1d(I_distal, SIGMA, SHRINK);

I_line_r2 = bwmorph(I_line_response, 'clean');
I_line_r3 = bwmorph(I_line_r2, 'hbreak');
I_line_r4 = bwmorph(I_line_r3, 'close');
I_line_r5 = bwmorph(I_line_r4, 'skel', Inf);
lines = bwareaopen(I_line_r5, HL_LENGTH);

