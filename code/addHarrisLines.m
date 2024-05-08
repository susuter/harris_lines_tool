function addHarrisLines()
%user may manually add harris lines by clicking on left subplot. the
%result is schon on the right subplot image.

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine

user_data =  get(gcf, 'UserData');

pt_list = get(gca, 'CurrentPoint');
