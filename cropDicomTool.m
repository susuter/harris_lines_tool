function varargout = cropDicomTool(varargin)
% CROPDICOMTOOL M-file for cropDicomTool.fig
%      CROPDICOMTOOL, by itself, creates a new CROPDICOMTOOL or raises the existing
%      singleton*.
%
%      H = CROPDICOMTOOL returns the handle to a new CROPDICOMTOOL or the handle to
%      the existing singleton*.
%
%      CROPDICOMTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CROPDICOMTOOL.M with the given input arguments.
%
%      CROPDICOMTOOL('Property','Value',...) creates a new CROPDICOMTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cropDicomTool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cropDicomTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


% Edit the above text to modify the response to help cropDicomTool

% Last Modified by GUIDE v2.5 05-Jun-2009 15:53:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cropDicomTool_OpeningFcn, ...
                   'gui_OutputFcn',  @cropDicomTool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cropDicomTool is made visible.
function cropDicomTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cropDicomTool (see VARARGIN)

% Choose default command line output for cropDicomTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cropDicomTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global IM_DCM_IN INFO_DCM_IN THRESH IM_BW MIN_AREA_SIZE STATS SELECTED_LABELS THRESH_OFFSET;
MIN_AREA_SIZE = 250000;
THRESH_OFFSET = 0.0;
% --- Outputs from this function are returned to the command line.
function varargout = cropDicomTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------

function thresholdInput_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdInput as text
%        str2double(get(hObject,'String')) returns contents of thresholdInput as a double
global THRESH;
THRESH = str2double(get(handles.thresholdInput, 'String'));


% --- Executes during object creation, after setting all properties.
function thresholdInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonApplyThreshold.
function buttonApplyThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to buttonApplyThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IM_DCM_IN THRESH THRESH_OFFSET IM_BW MIN_AREA_SIZE;

level = THRESH + THRESH_OFFSET;
IM_BW = im2bw(IM_DCM_IN, level);
subplot(1,2,2), subimage(IM_BW);
himl2 = imshow(IM_BW, []);
set(handles.editMinAreaSize, 'String', MIN_AREA_SIZE);

% --- Executes on button press in isInvert.
function isInvert_Callback(hObject, eventdata, handles)
% hObject    handle to isInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isInvert
global IM_DCM_IN THRESH;
IM_DCM_IN = invertIm(IM_DCM_IN, []);
subplot(1,2,1), subimage(IM_DCM_IN);
himl = imshow(IM_DCM_IN, []);
subplot(1,2,2), subimage(IM_DCM_IN);
himl2 = imshow(IM_DCM_IN, []);
THRESH = graythresh(IM_DCM_IN);
set(handles.thresholdInput, 'String', THRESH);


% --- Executes on button press in computeThreshold.
function computeThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to computeThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_DCM_IN THRESH;
THRESH = graythresh(IM_DCM_IN);
set(handles.thresholdInput, 'String', THRESH );



% --- Executes on button press in doLabeling.
function doLabeling_Callback(hObject, eventdata, handles)
% hObject    handle to doLabeling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_BW MIN_AREA_SIZE STATS SELECTED_LABELS;
[labels, numL] = bwlabel(IM_BW, 8);
STATS = regionprops(labels, 'BoundingBox', 'MajorAxisLength', 'FilledImage', 'Orientation', 'Area');

SELECTED_LABELS = find([STATS.Area] > MIN_AREA_SIZE);
bw2 = ismember(labels, SELECTED_LABELS);

[labels2, numL2] = bwlabel(bw2, 8);
RGB = label2rgb(labels2);
subplot(1,2,2), subimage(RGB);
himl2 = imshow(RGB, []);



function editMinAreaSize_Callback(hObject, eventdata, handles)
% hObject    handle to editMinAreaSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinAreaSize as text
%        str2double(get(hObject,'String')) returns contents of editMinAreaSize as a double
global MIN_AREA_SIZE;
MIN_AREA_SIZE = str2double(get(handles.editMinAreaSize, 'String'));

% --- Executes during object creation, after setting all properties.
function editMinAreaSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinAreaSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in saveDicom.
function saveDicom_Callback(hObject, eventdata, handles)
% hObject    handle to saveDicom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global INFO_DCM_IN IM_DCM_IN STATS SELECTED_LABELS;

numImages = size(SELECTED_LABELS, 2);
for l=1:numImages
    idx = SELECTED_LABELS(l);
    bb = STATS(idx).BoundingBox;
    dcm_cropped = imcrop(IM_DCM_IN, bb);
    figure, imshow(dcm_cropped, []);
    [filename, pathname] = uiputfile('*.dcm','Dicom image');
    dicomwrite(dcm_cropped, fullfile(pathname, filename), INFO_DCM_IN ,'CreateMode', 'Copy');
end


% --- Executes on button press in openDicom.
function openDicom_Callback(hObject, eventdata, handles)
% hObject    handle to openDicom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_DCM_IN INFO_DCM_IN;

[filename, pathname, filterindex] = uigetfile('*.dcm','Dicom images');

%if isequal(filename,0) || isequal(pathname,0)

IM_DCM_IN = dicomread(fullfile(pathname, filename)); %a = imread(fullfile(pathname, filename));
INFO_DCM_IN = dicominfo(fullfile(pathname, filename)); %a = imread(fullfile(pathname, filename));

hpanel = handles.uipanel1;
set(hpanel, 'Title', filename);

subplot(1,2,1), subimage(IM_DCM_IN);
himl = imshow(IM_DCM_IN, []);
subplot(1,2,2), subimage(IM_DCM_IN);
himl2 = imshow(IM_DCM_IN, []);

set(handles.thresholdInput, 'String', graythresh(IM_DCM_IN));




% --- Executes on button press in doInvert.
function doInvert_Callback(hObject, eventdata, handles)
% hObject    handle to doInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_DCM_IN THRESH THRESH_OFFSET;
IM_DCM_IN = invertIm(IM_DCM_IN, []);
subplot(1,2,1), subimage(IM_DCM_IN);
himl = imshow(IM_DCM_IN, []);
subplot(1,2,2), subimage(IM_DCM_IN);
himl2 = imshow(IM_DCM_IN, []);
THRESH = graythresh(IM_DCM_IN);
set(handles.thresholdInput, 'String', THRESH);
set(handles.offsetInput, 'String', THRESH_OFFSET);




function offsetInput_Callback(hObject, eventdata, handles)
% hObject    handle to offsetInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offsetInput as text
%        str2double(get(hObject,'String')) returns contents of offsetInput as a double
global THRESH_OFFSET;
value = get(handles.offsetInput, 'String');
if (isempty(value))
    THRESH_OFFSET = 0.0;
else
    THRESH_OFFSET = str2double(value);
end


% --- Executes during object creation, after setting all properties.
function offsetInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offsetInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openTiff_Callback(hObject, eventdata, handles)
% hObject    handle to openTiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_DCM_IN;

[filename, pathname, filterindex] = uigetfile('*.tif','TIFF images');

%if isequal(filename,0) || isequal(pathname,0)

IM_DCM_IN = imread(fullfile(pathname, filename)); %a = imread(fullfile(pathname, filename));

hpanel = handles.uipanel1;
set(hpanel, 'Title', filename);

subplot(1,2,1), subimage(IM_DCM_IN);
himl = imshow(IM_DCM_IN, []);
subplot(1,2,2), subimage(IM_DCM_IN);
himl2 = imshow(IM_DCM_IN, []);

set(handles.thresholdInput, 'String', graythresh(IM_DCM_IN));




% --- Executes on button press in zoomOriginal.
function zoomOriginal_Callback(hObject, eventdata, handles)
% hObject    handle to zoomOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_DCM_IN;

figure, imshow(IM_DCM_IN, []);


