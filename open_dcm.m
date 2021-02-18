function  open_dcm(handles)


%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine

global IM_DCM DCM_INFO RESOLUTION INVERT;
[filename, pathname, filterindex] = uigetfile('*.dcm','Dicom images');

IM_DCM = dicomread(fullfile(pathname, filename)); 
DCM_INFO = dicominfo(fullfile(pathname, filename)); 

hpanel = handles.uipanel1;
set(hpanel, 'Title', filename);


subplot(1,2,1), subimage(IM_DCM);
himl = imshow(IM_DCM, []);
subplot(1,2,2), subimage(IM_DCM);
himl2 = imshow(IM_DCM, []);
