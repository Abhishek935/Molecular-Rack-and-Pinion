
clear all
close all

filename=input('What is the file name');   %input the video name
xyloObj = VideoReader(filename);           
nFrames = xyloObj.NumberOfFrames;           % No of frames
fps=xyloObj.FrameRate;
height_vid = xyloObj.Height;
width_vid = xyloObj.Width;
video_frame=read(xyloObj,10);
counter = 0;
M = cell(nFrames, 1) ;
%%find threshold
AA=read(xyloObj,6);
AA=im2double(AA);
AA=rgb2gray(AA);
imtool(AA) %find threshold here
t = input('what is threshold')
ind_below = (AA < t);
% find values above
ind_above = (AA >= t);
% set values below to black
AA(ind_below) = 255;
% set values above to white
AA(ind_above) = 0;
imshow(AA)
Happy = input('if happy with threshold input 1 if not input 0')
if Happy ==1
    
for  ii=1:nFrames;
    A=read(xyloObj,ii);  %A=read(xyloObj,ii);
A=im2double(A);
A=rgb2gray(A);
ind_below = (A < t);
ind_above = (A >= t);
% set values below to black
A(ind_below) = 255;
% set values above to white
A(ind_above) = 0;
M{ii}=A;
end

StackSummImage = zeros(size(M{1}));
for kk = 1:nFrames
     StackSummImage = StackSummImage + M{kk};
end
SS =StackSummImage;  % This is the average
imshow(SS)
end

%% apply a 3D gaussian fit as shown in code C1
