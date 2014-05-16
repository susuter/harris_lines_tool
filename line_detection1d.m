function f = line_detection1d(I, sigm, shrink)
%EDGE Find edges in intensity image.

sigm = 1;
sigm = 0.834 * sigm;

I_adiff =  anisodiff(I, 20, 100, 0.25, 1);
%figure('Name', 'I_adiff'); imshow(I_adiff, []);

w  =  gaussian1d(sigm);
I2 = imfilter(I_adiff, w);
%I_shrinked_shape = shrinkShape(I_shape, shrink);
%I = I .* I_shrinked_shape; 
%figure('Name', 'input'); imshow(I2);

%shift to -sigma and +sigma *-1
%this shifts represent two gaussian filters, filter_left and
%filter_right. 
[y_length, x_length] = size(I2); %get size of convolution response (filter with w at scale j)
iN = y_length-ceil(sigm); %endpos for shift
i1 = 1 + shrink + ceil(sigm); %startpos for shift
q = sigm-floor(sigm);%quotient for linear interpolation
%linear interpolation is done to prevent that the response shift comes between two pixels
%linear interpolation: I(P) = I(P1) *(1-q)+I(P2) * q

%in case of multiscaling
%zeropadding is necessary because the filter-matrix-size differs for
%every scale. as the shifts are only defined within the pixel-row, at
%each end of the pixel row some pixels have undefined values. these
%pixels are replaced by zero values ( = zeropadding).
%doing so, consistant response-lengths are assured and no problems
%occur when combining the different scale-responses

combResponse = []; %combined response of one scale for every pixel

for x = 1:x_length
    response = []; 
    l = [];
    r = [];
    I_sub = I2(:,x);

    %zeropadding at beginning of a pixelrow
    for i=1:(i1-1)
        response = [response, 0];
        l = [l,0];
        r = [r,0];
    end;
    %for loop for shifts, including linear interpolation
    %for every pixel in the loaded image do...
    for i = i1:iN 
        %left shift incl. linear interpolation
        leftR = ((-1)*((I_sub(i+floor(sigm))*(1-q)) + (I_sub(i+ceil(sigm))*q)));
        %right shift incl. linear interpolation
        rightR = ((I_sub(i-floor(sigm))*(1-q)) + (I_sub(i-ceil(sigm))*q));
        %cut negative lobes of left and right response
        l = [l, leftR];
        r = [r, rightR];
        if(sign(leftR) == (-1))
            leftR = 0;  
        end;
        if (sign(rightR) == (-1))
            rightR = 0;
        end;
        %combine left and right response by selecting the minimum value
        combR = min(leftR, rightR);
        response = [response, (combR > sigm)];
    end; %end for every pixel

    %zeropadding at end of a pixelrow
    for i = (iN+1):y_length
        response = [response, 0];
        l = [l,0];
        r = [r,0];
    end;
    right(:, x) = r';
    left(:, x) = l';
    combResponse(:, x) = response';
end
%figure('Name', 'right response'); imshow(right, []);
%figure('Name', 'left response'); imshow(left, []);

f = combResponse;
%figure('Name', 'response'); imshow(f, []);

