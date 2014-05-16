function out = normalizeLines(lines)
% normalize lines to inverval between 0 an 1, output contains only values
% of lines != size of lines
out = [];
y_length = size(lines, 1);
for l = 1:y_length
    line = lines(l);
    if (line)
        out = [out, l/y_length];
    end
end
out = out';