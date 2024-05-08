function   g=gaussian2dRD(sigma)
%gaussian for 2d rootdetection

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine

%dettwiler, p.34
%filter adapted from matlab function fspecial('gaussian')

std=sigma; 

%filter size is defined by
flength=(floor(4*std)+1);
fsiz=([flength flength]-1)/2; 

%filter matrix is generated, according to filter size (see above:fsiz)
[x,y] = meshgrid(-fsiz(2):fsiz(2),-fsiz(1):fsiz(1)); 

%Gaussfunction applied to filter matrix
arg   = -(x.*x + y.*y)/(2*std*std);
g=exp(arg); %G(x,y)
%@keine Multiplikation mit sigma? f?r normierung im scalespace


%to normalize the gaussian to values between 0 and 1
%due to image intensity values are to be kept between 0 and 1

g(g<eps*max(g(:))) = 0;

sumg = sum(g(:));
if sumg ~= 0,
g  = g/sumg;
end;
