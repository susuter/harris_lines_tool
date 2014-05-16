function harris_plot(hfig, lines)

global DE PE PHL DHL IM_SHAPE;


[length_y, length_x] = size(lines);
figure(hfig); hold on;

for y = floor(length_y*PE)+10:ceil(length_y*PHL)-10
    for x = 1:length_x
        hl = lines(y, x);
        if (hl)
            inside_bone = IM_SHAPE(y, x);
            %if (inside_bone)
                plot(x ,y ,'LineWidth',1,'Color','white');
            %end
        end
    end
end
for y2 =  floor(length_y*DHL)+10:floor(length_y*DE)-10
    for x2 = 1:length_x
        hl = lines(y2, x2);
        if (hl)
            plot(x2, y2 ,'LineWidth',1,'Color','white');
        end
    end
end


for x3 = 1:length_x
   plot(x3, floor(length_y*PHL)-10,'LineWidth',1,'Color','yellow');
   plot(x3, floor(length_y*PE)+10,'LineWidth',1,'Color','yellow');
   plot(x3, ceil(length_y*DHL)+10,'LineWidth',1,'Color','yellow');
   plot(x3, floor(length_y*DE)-10,'LineWidth',1,'Color','yellow');
end

figure(hfig); hold off;

