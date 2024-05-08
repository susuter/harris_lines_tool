function lines = consolidateLines(linesIn)

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


global LINES IM_SHAPE PHL DHL DE PE;
[c, num_labels] = bwlabel(linesIn, 8);
stats = regionprops(c, 'PixelList', 'Image');

length = size(linesIn, 1);
lines(length, 1) = 0;

for l = 1:num_labels
    im = stats(l).Image;
    line_width = size(im, 1);
    max_line = 0;
    max_idx = 0;
    for i = 1:line_width
       num_px = sum(im(i, :));
       if (num_px > max_line)
           max_line = num_px;
           max_idx = i;
       end
    end
    pxlist = stats(l).PixelList;
    y_hl = pxlist(max_idx, 2);
    x_hl = pxlist(max_idx, 1);
    if (y_hl > floor(length*PE)+10 && y_hl < floor(length*DE)-10)
        if (y_hl < ceil(length*PHL)-10 || y_hl > floor(length*DHL)+10)
            lines(y_hl, 1) = 1;
        end
    end
end


for y = 1:length
   if (lines(y, 1))
       startline = y;
       endline = y;
       while(lines(endline+1,1))
           endline = endline +1;
       end
       c = ceil((startline + endline) / 2);
       for n = c-8:c+8
           if (lines(n,1) && n ~= c)
               lines(n,1) = 0;
           end
       end
   end    
end

LINES = lines;
