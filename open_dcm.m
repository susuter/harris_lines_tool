function  open_dcm(handles)

global IM_DCM DCM_INFO RESOLUTION INVERT;
[filename, pathname, filterindex] = uigetfile('*.dcm','Dicom images');

%if isequal(filename,0) || isequal(pathname,0)
%   d = dicomread('/home/sutersu/images/tibiae_decompressed/tib_269.dcm'); %a = imread('images/set1/jpeg/tib_007.jpg');
%else
   IM_DCM = dicomread(fullfile(pathname, filename)); %a = imread(fullfile(pathname, filename));
   DCM_INFO = dicominfo(fullfile(pathname, filename)); %a = imread(fullfile(pathname, filename));
%end
%if (INVERT)
%    IM_DCM = invertIm(d, []);
%else
%    IM_DCM = d;
%end

hpanel = handles.uipanel1;
set(hpanel, 'Title', filename);
%haxes = handles.axes3;
%set(haxes, 'UserData', IM_DCM);
%haxes2 = handles.axes5;
%set(haxes2, 'UserData', IM_DCM);

%guidata(gca, handles.axes3);


subplot(1,2,1), subimage(IM_DCM);
himl = imshow(IM_DCM, []);
subplot(1,2,2), subimage(IM_DCM);
himl2 = imshow(IM_DCM, []);


%subplot(1,2,1);
%set(haxes, 'UserData', e);
%himl = imshow(e, []);
%set(himl, 'UserData');
%hiscp = imscrollpanel(hpanel, himl);
%guidata(hiscp, handles);

%api = iptgetapi(hiscp);
%mag = api.getMagnification();
%r = api.getVisibleImageRect();
%api.setMagnification(api.findFitMag());

%set(handles, 'scrollpanel', hiscp);
%imscrollpanel(handles.axes5, himl2);
%immagbox(hpanel, himl);
%immagbox(hpanel, himl2);

%apiL = iptgetapi(hSpL);
%apiR = iptgetapi(hSpR);

%subplot(1,2,2);
%himr = imshow(e, []);
%scrpl = imscrollpanel(hfig, himl);
%scrpr = imscrollpanel(hfig, himr);
%hMagBox = immagbox(hfig, himl);
%hMagBox.setMagnification(15);

%handles.uipanel_img = imshow(d, []);
%handles.uipanel_img = imshow(d, []);
