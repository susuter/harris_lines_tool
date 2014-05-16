function [def, pef] = detectEF(hfig)
% detects the distal and proximal epiphyseal fusion (def, pef)

global IM_BONE IM_SHAPE_0;

%distal epiphyeseal fusion
[y,x] = size(IM_BONE);
startY = floor(y*6/7);
distal = IM_BONE(startY:y-1, :);
distal_shape = IM_SHAPE_0(startY:y-1, :);
m = size(distal, 1);
n = size(distal, 2);
%remove noise outside of bone
for i = 1:m
    for j = 1:n
        inside = distal_shape(i,j);
        if (~inside)
            distal(i,j) = 0;
        end
    end
end

%figure, imshow(distal, []);

%find highest pixel intensity; set threshold accordingly and label the
%connected components; choose largest connected component -> should ideally
%see the epiphyses
L = bwlabel(distal, 8);
stats = regionprops(L, distal, 'MaxIntensity');
level = double(stats.MaxIntensity) / 65536 - 0.002;
def = im2bw(distal, level);
[L2, num_labels] = bwlabel(def, 8);
stats2 = regionprops(L2, 'Area', 'BoundingBox', 'Image');

max_label = 0;
max_label_size = 0;
for i = 1:num_labels
    label_size = stats2(i).Area;
    if (label_size > max_label_size)
        max_label_size = label_size;
        max_label = i;
    end
end


def2 = def;
for i = 1:m
    for j = 1:n
        val = L2(i,j);
        if (val==max_label)
            def2(i,j) = 1;
        else
            def2(i,j) = 0;
        end
    end
end


%figure, imshow(def, []);

def2_height = size(def2, 1);
max_line = 0;
max_idx = 0;
for i = 1:def2_height
    num_px = sum(def2(i, :));
    if (num_px > max_line)
        max_line = num_px;
        max_idx = i;
    end
end

def_line = def2_height - max_idx;

%for testing
figure(hfig); hold on;
for p = 1:size(def2,2)
   plot(p, y-def_line,'LineWidth',1,'Color','red');
end

figure(hfig); hold off;

def = def_line / y;

if(def > 0.15)
    def = 0.005;
end


%proximal epiphyseal fusion
[y,x] = size(IM_BONE);
stopY = floor(y*1/7);
proximal = IM_BONE(1:stopY, :);
proximal_shape = IM_SHAPE_0(1:stopY, :);
m = size(proximal, 1);
n = size(proximal, 2);
%remove noise outside of bone
for i = 1:m
    for j = 1:n
        inside = proximal_shape(i,j);
        if (~inside)
            proximal(i,j) = 0;
        end
    end
end

%figure, imshow(proximal, []);

%find highest pixel intensity; set threshold accordingly and label the
%connected components; choose largest connected component -> should ideally
%see the epiphyses
L_p = bwlabel(proximal, 8);
stats_p = regionprops(L_p, proximal, 'MaxIntensity');
level_p = double(stats_p.MaxIntensity) / 65536 - 0.002;
pef = im2bw(proximal, level_p);
[L2_p, num_labels_p] = bwlabel(pef, 8);
stats2_p = regionprops(L2_p, 'Area', 'BoundingBox', 'Image');

% max_label = 0;
% max_label_size = 0;
% for i = 1:num_labels_p
%     label_size = stats2_p(i).Area;
%     if (label_size > max_label_size)
%         max_label_size = label_size;
%         max_label = i;
%     end
% end


% pef2 = pef;
% for i = 1:m
%     for j = 1:n
%         val = L2_p(i,j);
%         if (val==max_label)
%             pef2(i,j) = 1;
%         else
%             pef2(i,j) = 0;
%         end
%     end
% end


%figure, imshow(pef, []);

pef_line = 1;
pef_height = size(pef, 1);
for i = 1:pef_height
    num_px = sum(pef(i, :));
    if (num_px > 2)
        pef_line = i;
    end
end


%for testing
figure(hfig); hold on;
for p = 1:size(pef,2)
   plot(p, pef_line,'LineWidth',1,'Color','red');
end

figure(hfig); hold off;

pef = pef_line / y;

if(pef > 0.2)
    pef = 0.005;
end

