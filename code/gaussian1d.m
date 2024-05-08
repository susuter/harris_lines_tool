function   dG = gaussian1d(sigma)
%1d rootdetection: gaussian filter adjusted for sigma

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


%first derivative of gaussian

std = sigma;
%filter size is defined by
flength = (floor(4*std)+1);
%flength = 15;
%filter matrix is generated, according to size (see above)
[x,y] = meshgrid(-5*std:5*std,1); 

%the gaussian 
arg = (-0.5.*(x/std).*(x/std));
a = x.*(1/(std^2));
dG = a .* exp(arg); %G'(x)*sigma
dG = dG';

