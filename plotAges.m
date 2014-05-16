function plotAges(display_proximal)
%display rseutls of hl computation: ages of hl occurences
global RESULTS LINES_CUT DHL;
y_length = size(LINES_CUT, 1);
num_results = size(RESULTS, 2);
count_results = 1;
if (display_proximal)
    start = 1;
else
    start = ceil(DHL *y_length); 
end
last_y = 0;
last_tabbed = false;
for y = start:y_length
    if (count_results <= num_results)
        value = LINES_CUT(y, 1);
        if (value)
            if ((y - last_y) < 60 && ~last_tabbed)
                x = 70;
                last_tabbed = true;
            else
                x = 10;
                last_tabbed = false;
            end
            
            age = RESULTS(1, count_results);
            text(x,y,num2str(age), 'HorizontalAlignment','left', 'Color', 'white');
            count_results = count_results + 1;
            last_y = y;
        end
    else
        break;
    end
end

%set(handles.textMethod, 'String', method);
