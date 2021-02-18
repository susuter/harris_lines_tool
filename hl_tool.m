function varargout = hl_tool(varargin)
% HL_TOOL M-file for hl_tool.fig
%      HL_TOOL, by itself, creates a new HL_TOOL or raises the existing
%      singleton*.
%
%      H = HL_TOOL returns the handle to a new HL_TOOL or the handle to
%      the existing singleton*.
%
%      HL_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HL_TOOL.M with the given input arguments.
%
%      HL_TOOL('Property','Value',...) creates a new HL_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hl_tool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hl_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

%Copyright (c) 2021 University of Zurich, Institute of Evolutionary Medicine


% Edit the above text to modify the response to help hl_tool

% Last Modified by GUIDE v2.5 17-Jun-2009 09:02:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hl_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @hl_tool_OutputFcn, ...
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



% --- Executes just before hl_tool is made visible.
function hl_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hl_tool (see VARARGIN)

% Choose default command line output for hl_tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hl_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global IM_BONE LINES IM_SHAPE IM_SHAPE_0 RESULTS RAW_LINES SELECTED_LINES IND_NAME LEFT_SIDE STATURE TOT_LENGTH SITE GRAVE DATE;
global SHRINK SIGMA DE PE PHL DHL THRESH_OFFSET THRESH FEMALE AGE PRIM_OSS_CENTER LENGTH_TOLERANCE ORIENTATION_TOLERANCE ECCENTRICITY_TOLERANCE;
global DCM_INFO IM_DCM RESOLUTION INVERT XLS_OUT AGE_GROUP SEX MIN_LENGTH HL_LENGTH PEF_LINE DEF_LINE LINES_CUT;
global EXPORTFILE;
SHRINK = 20;
SIGMA = 0.834;
PHL = 0.3; %ratio of bone for proximal harris lines
DHL = 1 - 0.35; % ratio for proximal harris lines
DE = 1-0.06; %distal epiphyses  
PE = 0.06; % proximal ephyses
THRESH_OFFSET = 0.006; % default: 0.00425; %0.006 for images: 433, 478, 486, 655;
HL_LENGTH = 35;
RESOLUTION = 200;
FEMALE = true;
PRIM_OSS_CENTER = 1 - 0.43; % ratio for proximal harris lines poximal part is on top
ORIENTATION_TOLERANCE=6;
ECCENTRICITY_TOLERANCE=0.995;
LENGTH_TOLERANCE = 35;
RESULTS = 0;
IND_NAME = 'unknown';
LEFT_SIDE = true;
STATURE = 'unknown';
DATE = 'unknown';
SITE = 'unknown';
GRAVE = 'unknown';
SEX = 'female';
FEMALE = true;
TOT_LENGTH = 0;
INVERT = true;
XLS_OUT = {'Name', 'Grave', 'Archeological Site', 'Date', 'Age', 'Sex', 'Side', 'Stature', 'Tibia lenght', 'Distance from epiphysis', 'Orientation', 'Byers, 1991', 'Maat, 1984', 'Clarke, 1982', 'Hummert and Van Gerven, 1985'};
MIN_LENGTH = 1/5;
% --- Outputs from this function are returned to the command line.
function varargout = hl_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_dcm_Callback(hObject, eventdata, handles)
% hObject    handle to open_dcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global THRESH THRESH_OFFSET IM_DCM;
open_dcm(handles);
reset(handles);
THRESH = graythresh(IM_DCM);
set(handles.thresholdInput, 'String', THRESH);
set(handles.offsetInput, 'String', THRESH_OFFSET);
set(handles.buttonDetectBone, 'Enable', 'on');
set(handles.buttonDetectHLraw, 'Enable', 'off');
set(handles.status, 'String', 'Dicom image loaded.');



% --- Executes on button press in buttonDetectBone.
function buttonDetectBone_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDetectBone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_BONE IM_DCM IM_SHAPE IM_SHAPE_0 TOT_LENGTH RESOLUTION THRESH THRESH_OFFSET;
reset(handles);
%THRESH = str2double(get(handles.thresholdInput, 'String'));
%THRESH_OFFSET = str2double(get(handles.offsetInput, 'String'));
detect_one_bone();

subplot(1,2,1), subimage(IM_BONE);
imshow(IM_BONE, []);
subplot(1,2,2), subimage(IM_SHAPE_0);
imshow(IM_SHAPE_0, []);

numpix = size(IM_BONE, 1);
if (size(IM_BONE, 2) > numpix)
   numpix = size(IM_BONE, 2);
end
TOT_LENGTH = pixel2cm(numpix, RESOLUTION);

set(handles.buttonDetectHLraw, 'Enable', 'on');
set(handles.checkboxHasEpiphyses, 'value', 1);
set(handles.loadHL, 'Enable', 'on');
set(handles.status, 'String', 'Detected one bone.');

% --- Executes on button press in buttonShowHLraw.
function buttonShowHLraw_Callback(hObject, eventdata, handles)
% hObject    handle to buttonShowHLraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global LINES RAW_LINES SELECTED_LINES IM_SHAPE;
repaintHLImage(handles);
LINES = consolidateLines(RAW_LINES);
DCMsamplesSELECTED_LINES = RAW_LINES;
harris_plot(handles.figure1, RAW_LINES);
set(handles.status, 'String', 'Displayed automatically detected Harris lines.');


% --- Executes on button press in buttonDetectHLraw.
function buttonDetectHLraw_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDetectHLraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global LINES RAW_LINES IM_SHAPE IM_BONE SELECTED_LINES;
set(handles.status, 'String', 'Started to detected Harris lines. Calculating...');
setEpiphyses(handles);

lines = harris_high();
RAW_LINES = lines;

RAW_LINES = removeCurlyLines(RAW_LINES);
RAW_LINES = removeNonHorizontal(RAW_LINES);
SELECTED_LINES = RAW_LINES;

LINES = consolidateLines(lines);
repaintHLImage(handles);

harris_plot(handles.figure1, SELECTED_LINES);

setAgeComputationMethods(handles);
setShowHLResults(handles, 'on');
set(handles.buttonClearHL, 'Enable', 'on');
set(handles.buttonSaveHL, 'Enable', 'on');
set(handles.status, 'String', 'Detected and displayed Harris lines.');

%%helper function
function setShowHLResults(handles, value)
set(handles.removeEccentricity, 'Enable', value);
set(handles.removeOrientation, 'Enable', value);
set(handles.removeShortLines, 'Enable', value);
set(handles.buttonShowHLraw, 'Enable', value);
set(handles.minLength, 'Enable', value);

%%%helper function
function isHasEpiphyses =  hasEpiphyses(handles)
isHasEpiphyses = get(handles.checkboxHasEpiphyses, 'value');


%%%helpfer fucntion
function setEpiphyses(handles)
global PE DE PEF_LINE DEF_LINE;




if (hasEpiphyses(handles))
    [DEF_LINE, PEF_LINE] = detectEF(handles.figure1);
    
    %set proximal epiphyseal line
    if (get(handles.setProximalEFLine, 'value'))
        PE = str2double(get(handles.setPE, 'String')); %set distal epiphyseal line
        PEF_LINE = PE + 0.028;
    else
        PE = PEF_LINE + 0.028;
        if(PE > 0.15)
            PEF_LINE = 0.055;
            PE = 0.06; %set distal epiphyseal line
        end
    end
    %set distal epiphyseal line
    if (get(handles.setDistalEFLine, 'value'))
        manDEF = str2double(get(handles.setDE, 'String')); %set distal epiphyseal line
        DE = 1- manDEF;
        DEF_LINE = manDEF - 0.028;
    else
        DE = 1 - DEF_LINE - 0.028;
        if(DE < 0.85)
            DEF_LINE = 0.055;
            DE = 1 - 0.06; %set distal epiphyseal line
        end
    end
else
    PE = 0;
    DE = 1;
end

%%%helpder function
function setAgeComputationMethods(handles)
if (hasEpiphyses(handles))
    %value must be either 'on' or 'off'
    set(handles.buttonComputeMaat, 'Enable', 'on');
    set(handles.buttonComputeClarke, 'Enable', 'on');
    set(handles.buttonComputeByers, 'Enable', 'on');
    set(handles.buttonComputeJuvenilesHVG, 'Enable', 'off');
    set(handles.popupChooseAge, 'Enable', 'off');
else
    set(handles.buttonComputeMaat, 'Enable', 'off');
    set(handles.buttonComputeClarke, 'Enable', 'off');
    set(handles.buttonComputeByers, 'Enable', 'off');
    set(handles.buttonComputeJuvenilesHVG, 'Enable', 'on');
    set(handles.popupChooseAge, 'Enable', 'on');
end


%%%helper function%%%
function repaintHLImage(handles)
global IM_BONE SELECTED_LINES;

subplot(1,2,2), subimage(IM_BONE);
imshow(IM_BONE, []);

harris_plot(handles.figure1, SELECTED_LINES);
set(handles.status, 'String', 'Reloaded Harris lines.');

% --- Executes on button press in buttonComputeMaat.
function buttonComputeMaat_Callback(hObject, eventdata, handles)
% hObject    handle to buttonComputeMaat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
repaintHLImage(handles);
computeMaat(handles.figure1);
plotAges(false);
set(handles.status, 'String', 'Computed age-at-formation of the Harris lines after Maat. Method for Adults');

% --- Executes on button press in buttonComputeByers.
function buttonComputeByers_Callback(hObject, eventdata, handles)
% hObject    handle to buttonComputeByers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
repaintHLImage(handles);
computeByers();
plotAges(true);
set(handles.status, 'String', 'Computed age-at-formation of the Harris lines after Byers. Method for Adults. Proximal and distal lines.');

% --- Executes on button press in buttonComputeClarke.
function buttonComputeClarke_Callback(hObject, eventdata, handles)
% hObject    handle to buttonComputeClarke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

repaintHLImage(handles);
computeClarke();
plotAges(false);
set(handles.status, 'String', 'Computed age-at-formation of the Harris lines after Clarke. Method for Adults.');


% --- Executes on button press in buttonComputeJuvenilesHVG.
function buttonComputeJuvenilesHVG_Callback(hObject, eventdata, handles)
% hObject    handle to buttonComputeJuvenilesHVG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

repaintHLImage(handles);
computeHvgJuveniles();
plotAges(false);
set(handles.status, 'String', 'Computed age-at-formation of the Harris lines after Hummert and v. Gerven. Method for Juveniles.');



% --- Executes on button press in checkboxHasEpiphyses.
function checkboxHasEpiphyses_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxHasEpiphyses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxHasEpiphyses
setShowHLResults(handles, 'off');
disableComputationMethods(handles);

%%%helper function
function disableComputationMethods(handles)
set(handles.buttonComputeMaat, 'Enable', 'off');
set(handles.buttonComputeClarke, 'Enable', 'off');
set(handles.buttonComputeByers, 'Enable', 'off');
set(handles.buttonComputeJuvenilesHVG, 'Enable', 'off');
set(handles.popupChooseAge, 'Enable', 'off');



% --- Executes on selection change in popupChooseAge.
function popupChooseAge_Callback(hObject, eventdata, handles)
% hObject    handle to popupChooseAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupChooseAge contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupChooseAge
global AGE_GROUP;

item = get(handles.popupChooseAge, 'Value');
token = strtok(get(handles.popupChooseAge, 'String'), '|');
if (item == 0)
   AGE_GROUP = 0;
else
    AGE_GROUP = token(item);
end



% --- Executes during object creation, after setting all properties.
function popupChooseAge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupChooseAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonClearHL.
function buttonClearHL_Callback(hObject, eventdata, handles)
% hObject    handle to buttonClearHL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_BONE;

reset(handles)
subplot(1,2,2), subimage(IM_BONE);
imshow(IM_BONE, []);
set(handles.status, 'String', 'Cleared all displayed Harris lines.');

%%helper function new line
function reset(handles)

global LINES RAW_LINES SELECTED_LINES RESULTS;
disableComputationMethods(handles);
%set(handles.checkboxHasEpiphyses, 'value', 1);
setShowHLResults(handles, 'off');
LINES = [];
RAW_LINES = [];
SELECTED_LINES = [];
set(handles.buttonClearHL, 'Enable', 'off');
RESULTS = 0;
plotAges(true);


% --------------------------------------------------------------------
function loadHL_Callback(hObject, eventdata, handles)
% hObject    handle to loadHL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SELECTED_LINES LINES;
[filename, pathname] = uigetfile('*.hl','Harris lines File');

if isequal(filename,0) || isequal(pathname,0)
   f = [];
else
   f = dlmread(fullfile(pathname, filename));
end
SELECTED_LINES = f;
LINES = consolidateLines(SELECTED_LINES);
harris_plot(handles.figure1, SELECTED_LINES);
setAgeComputationMethods(handles);
set(handles.buttonClearHL, 'Enable', 'on');
set(handles.buttonSaveHL, 'Enable', 'on');
set(handles.status, 'String', 'Loaded Harris lines from a file.');


% --- Executes on button press in buttonSaveHL.
function buttonSaveHL_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSaveHL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SELECTED_LINES;
[filename, pathname] = uiputfile('*.hl','Harris lines File');

dlmwrite(fullfile(pathname, filename), SELECTED_LINES);
set(handles.status, 'String', 'Saved current set of Harris lines to a file.');

% --------------------------------------------------------------------
function xlsExport_Callback(hObject, eventdata, handles)
% hObject    handle to xlsExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PE DE XLS_OUT EXPORTFILE;

[filename, pathname] = uiputfile('*.xls','Harris lines data');
EXPORTFILE = fullfile(pathname, filename);
xlswrite(EXPORTFILE, XLS_OUT);
set(handles.status, 'String', 'Exported the Harris lines meta data to an XLS file.');

% --- Executes on button press in listSex.
function listSex_Callback(hObject, eventdata, handles)
% hObject    handle to listSex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listSex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listSex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in editSex.
function editSex_Callback(hObject, eventdata, handles)
% hObject    handle to editSex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns editSex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from editSex
global FEMALE SEX;

item = get(handles.editSex, 'Value');
token = strtok(get(handles.editSex, 'String'), '|');
if (item == 0)
   SEX = 'female';
else
   value = token(item);
   SEX = value{1,1};
end

if (strcmp(SEX, 'male') || strcmp(SEX, 'probably male'))
    FEMALE = false;
else
    FEMALE = true;
end



% --- Executes during object creation, after setting all properties.
function editSex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editIndName_Callback(hObject, eventdata, handles)
% hObject    handle to editIndName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIndName as text
%        str2double(get(hObject,'String')) returns contents of editIndName as a double
global IND_NAME;
IND_NAME = get(handles.editIndName, 'String');


% --- Executes during object creation, after setting all properties.
function editIndName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIndName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAge_Callback(hObject, eventdata, handles)
% hObject    handle to editAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAge as text
%        str2double(get(hObject,'String')) returns contents of editAge as a double
global AGE;
AGE = str2double(get(handles.editAge, 'String'));

% --- Executes during object creation, after setting all properties.
function editAge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in editSide.
function editSide_Callback(hObject, eventdata, handles)
% hObject    handle to editSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns editSide contents as cell array
%        contents{get(hObject,'Value')} returns selected item from editSide
global LEFT_SIDE;
item = get(handles.editSide, 'Value');
if (item == 2)
   LEFT_SIDE = false;
end


% --- Executes during object creation, after setting all properties.
function editSide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editStature_Callback(hObject, eventdata, handles)
% hObject    handle to editStature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStature as text
%        str2double(get(hObject,'String')) returns contents of editStature as a double

global STATURE;
STATURE = get(handles.editStature, 'String');

% --- Executes during object creation, after setting all properties.
function editStature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in appendXLSOut.
function appendXLSOut_Callback(hObject, eventdata, handles)
% hObject    handle to appendXLSOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global PE DE;

if (PE==0 && DE==1)
    append2XLSOutput(false); 
else
    append2XLSOutput(true);
end
set(handles.status, 'String', 'Appended the data of the current individual to a temporary table. NOTE: this data is not yet saved! In order to save the data, you need to export it to a XLS file.');


function editGrave_Callback(hObject, eventdata, handles)
% hObject    handle to editGrave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGrave as text
%        str2double(get(hObject,'String')) returns contents of editGrave as a double
global GRAVE;
GRAVE = get(handles.editGrave, 'String');


% --- Executes during object creation, after setting all properties.
function editGrave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGrave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSite_Callback(hObject, eventdata, handles)
% hObject    handle to editSite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSite as text
%        str2double(get(hObject,'String')) returns contents of editSite as a double
global SITE;
SITE = get(handles.editSite, 'String');


% --- Executes during object creation, after setting all properties.
function editSite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDate_Callback(hObject, eventdata, handles)
% hObject    handle to editDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDate as text
%        str2double(get(hObject,'String')) returns contents of editDate as a double
global DATE;
DATE = get(handles.editDate, 'String');


% --- Executes during object creation, after setting all properties.
function editDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clearXLSOut.
function clearXLSOut_Callback(hObject, eventdata, handles)
% hObject    handle to clearXLSOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global XLS_OUT;

XLS_OUT = {'Name', 'Grave', 'Archeological Site', 'Date', 'Age', 'Sex', 'Side', 'Stature', 'Tibia lenght', 'Distance from epiphysis', 'Orientation', 'Byers, 1991', 'Maat, 1984', 'Clarke, 1982', 'Hummert and Van Gerven, 1985'};
set(handles.status, 'String', 'All temporary data has been deleted.');

% --- Executes on button press in doInvert.
function doInvert_Callback(hObject, eventdata, handles)
% hObject    handle to doInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_DCM THRESH THRESH_OFFSET;

IM_DCM = invertIm(IM_DCM, []);
subplot(1,2,1), subimage(IM_DCM);
himl = imshow(IM_DCM, []);
subplot(1,2,2), subimage(IM_DCM);
himl2 = imshow(IM_DCM, []);
THRESH = graythresh(IM_DCM);
set(handles.thresholdInput, 'String', THRESH);
set(handles.offsetInput, 'String', THRESH_OFFSET);
set(handles.status, 'String', 'Image has been inverted.');

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


% --- Executes on button press in minLengthHalf.
function minLengthHalf_Callback(hObject, eventdata, handles)
% hObject    handle to minLengthHalf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of minLengthHalf
global MIN_LENGTH;
MIN_LENGTH = 0.5;

% --- Executes on button press in minLengthThird.
function minLengthThird_Callback(hObject, eventdata, handles)
% hObject    handle to minLengthThird (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of minLengthThird
global MIN_LENGTH;
MIN_LENGTH = 1/3;



% --- Executes on button press in removeShortLines.
function removeShortLines_Callback(hObject, eventdata, handles)
% hObject    handle to removeShortLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SELECTED_LINES LINES IM_BONE MIN_LENGTH RAW_LINES;

lines = removeShortLines(RAW_LINES);
SELECTED_LINES = lines;
LINES = consolidateLines(SELECTED_LINES);

subplot(1,2,2), subimage(IM_BONE);
imshow(IM_BONE, []);
harris_plot(handles.figure1, SELECTED_LINES);
set(handles.status, 'String', 'Short Harris lines have been removed.');

function minLength_Callback(hObject, eventdata, handles)
% hObject    handle to minLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minLength as text
%        str2double(get(hObject,'String')) returns contents of minLength as a double
global MIN_LENGTH;
value = get(handles.minLength, 'String');
if (isempty(value))
    MIN_LENGTH = 0.0;
else
    MIN_LENGTH = str2double(value);
end


% --- Executes during object creation, after setting all properties.
function minLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in removeOrientation.
function removeOrientation_Callback(hObject, eventdata, handles)
% hObject    handle to removeOrientation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global LINES SELECTED_LINES IM_BONE;

subplot(1,2,2), subimage(IM_BONE);
imshow(IM_BONE, []);

lines = removeNonHorizontal(SELECTED_LINES);
SELECTED_LINES = lines;

LINES = consolidateLines(SELECTED_LINES);
harris_plot(handles.figure1, SELECTED_LINES);
set(handles.status, 'String', 'Non-horizontal Harris lines have been removed..');


% --- Executes on button press in removeEccentricity.
function removeEccentricity_Callback(hObject, eventdata, handles)
% hObject    handle to removeEccentricity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global LINES SELECTED_LINES IM_BONE;

subplot(1,2,2), subimage(IM_BONE);
imshow(IM_BONE, []);

lines = removeCurlyLines(SELECTED_LINES);
SELECTED_LINES = lines;

LINES = consolidateLines(SELECTED_LINES);
harris_plot(handles.figure1, SELECTED_LINES);
set(handles.status, 'String', 'Curly Harris lines have been removed.');


% --- Executes on button press in rotate90CCW.
function rotate90CCW_Callback(hObject, eventdata, handles)
% hObject    handle to rotate90CCW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IM_DCM;

IM_DCM = imrotate(IM_DCM, 90);
subplot(1,2,1), subimage(IM_DCM);
imshow(IM_DCM, []);
subplot(1,2,2), subimage(IM_DCM);
imshow(IM_DCM, []);



function setDE_Callback(hObject, eventdata, handles)
% hObject    handle to setDE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setDE as text
%        str2double(get(hObject,'String')) returns contents of setDE as a double
global DE;

DE = 1 - str2double(get(handles.setDE, 'String')); %set distal epiphyseal line




% --- Executes during object creation, after setting all properties.
function setDE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setDE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in detectEF.
function detectEF_Callback(hObject, eventdata, handles)
% hObject    handle to detectEF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_BONE DEF_LINE PEF_LINE;

repaintHLImage(handles);
[DEF_LINE, PEF_LINE] = detectEF(handles.figure1);


% --- Executes on button press in zoomOriginal.
function zoomOriginal_Callback(hObject, eventdata, handles)
% hObject    handle to zoomOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global IM_BONE;
figure, imshow(IM_BONE, []);


% --- Executes on button press in repaint.
function repaint_Callback(hObject, eventdata, handles)
% hObject    handle to repaint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
repaintHLImage(handles);


% --- Executes on button press in setDistalEFLine.
function setDistalEFLine_Callback(hObject, eventdata, handles)
% hObject    handle to setDistalEFLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setDistalEFLine



function setPE_Callback(hObject, eventdata, handles)
% hObject    handle to setPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setPE as text
%        str2double(get(hObject,'String')) returns contents of setPE as a double


% --- Executes during object creation, after setting all properties.
function setPE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setProximalEFLine.
function setProximalEFLine_Callback(hObject, eventdata, handles)
% hObject    handle to setProximalEFLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setProximalEFLine


% --- Executes on button press in saveXLS.
function saveXLS_Callback(hObject, eventdata, handles)
% hObject    handle to saveXLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PE DE XLS_OUT EXPORTFILE;

try
    if (isempty(EXPORTFILE))
        [filename, pathname] = uiputfile('*.xls','Harris lines data');
        EXPORTFILE = fullfile(pathname, filename);
        xlswrite(EXPORTFILE, XLS_OUT);
        set(handles.status, 'String', 'saved the Harris lines meta data.');
   else
        [num, txt] = xlsread(EXPORTFILE);
        num_rows = size(txt,1);
        num_entries = size(XLS_OUT,1);
        range = sprintf('A%i:O%i', num_rows+1, num_entries+num_rows-1);
        xlswrite(EXPORTFILE, XLS_OUT(2:num_entries, :), range);
        XLS_OUT = {'Name', 'Grave', 'Archeological Site', 'Date', 'Age', 'Sex', 'Side', 'Stature', 'Tibia lenght', 'Distance from epiphysis', 'Orientation', 'Byers, 1991', 'Maat, 1984', 'Clarke, 1982', 'Hummert and Van Gerven, 1985'};
        set(handles.status, 'String', 'saved the Harris lines meta data.');
    end

catch ME
   errordlg(ME.message); 
end




