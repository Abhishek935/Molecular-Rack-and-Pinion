% readme
% Works best with MATLAB 2016B. You need the function C2 present in the
% same folder as this code
% This code does the following
% 1) Loads the approximate position track data file from ImageJ 'Trackmate' 
% 2) Loads the .avi TIRF image video file of a rotating cell 
% 3) crops an area around the approximate position of a foci 
% 4) Fits a 3D gaussian to provide the sub pixel average position of the foci
% 
%  Use the following example files provided with this code to test:
% 1) TrackMate data file: C1_313_example_tracks.mat
% 2) Avi file: 313_SIF_sorted_select_bright copy_20.avi
%%
close all
clearvars -except  tracks;

filename=input('What is the file name');  %input the video file name in quotes with .avi extension
xyloObj = VideoReader(filename);            
nFrames = xyloObj.NumberOfFrames;           % No of frames
fps=xyloObj.FrameRate;
height_vid = xyloObj.Height;
width_vid = xyloObj.Width;
video_frame=read(xyloObj,1);% size(video_frame)
Crop.frames = zeros(1, nFrames);
nn = length(tracks);
xx=zeros(nn,1);
yy=zeros(nn,1);
CC = zeros(nn,2);
DD3=zeros(nn,2);
M = cell(nn, 1) ;  % creates a cell with zeros
Res = cell(nn, nFrames);
GOF_all = cell(nn, nFrames);
crop = 7; 
for ii =1:nFrames
    AA=read(xyloObj,ii);
B=im2double(AA);
  
for tz=1:nn   
    tr=tracks{tz,1};
    tr2=tr(ii,2:3);
    xx(tz)=tr2(1,1);
    yy(tz)=tr2(1,2);
end
 for p = 1:nn
       CC1 = [xx(p), yy(p)];
       CC(p,:)=CC1; 
 end
 %% This part crops the area around the foci in a square matrix
  for e = 1:nn  
   DD = [(CC(e,1)-crop), (CC(e,2)-crop), 15, 15]; % DD =  [xmin ymin width height]
   DD2=DD(1,1:2);
   DD3(e,:)=DD2;
   EE1 = imcrop(B,DD);
   M{e,ii} = EE1; % stacks cropped image matrices in a cell
  end 
  
  %% This part fits a gaussian
  coord_xy1= zeros(nn,2);
for gg = 1:nn
    MM = cell2mat(M(gg,ii));
[xx,yy]=meshgrid(1:16,1:16); % if we get a 16 by 16 matrix
xx1=xx(:);
yy1=yy(:);
z=M{gg,ii};
z=rgb2gray(z);
zz=z(:);
[value, location] = max(MM(:));
[row, column] = ind2sub(size(MM), location);
max_value=[column,row];
pp=max_value(1);
qq = max_value(2);
[fitresult, gof] = C2(xx1, yy1, zz, pp, qq);
coeffnames(fitresult)
Result = coeffvalues(fitresult);
coord_xy=[Result(1,4),Result(1,5)];

coord_xy2=DD3(gg,:)+coord_xy; %  bringing data back to original coordinates

Res{gg,ii} =coord_xy2; % stacks 'coordinates'  in a cell 
GOF_all{gg,ii}=gof; %  GOF of all foci from each frame

end

end


%% use C3 to plot tracks

