function addHarrisLines()
%user may manually add harris lines by clicking on left subplot. the
%result is schon on the right subplot image.



user_data =  get(gcf, 'UserData');

pt_list = get(gca, 'CurrentPoint');
