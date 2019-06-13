% works with MATLAB 2016B. Written by AS.
% Load the approximate position track data file from ImageJ 'Trackmate' to get approximate positions of foci
close all
% clear all
clearvars -except  tracks;

filename=input('What is the file name');  %input the video name
xyloObj = VideoReader(filename);            
nFrames = xyloObj.NumberOfFrames;           % No of frames
fps=xyloObj.FrameRate;
height_vid = xyloObj.Height;
width_vid = xyloObj.Width;
video_frame=read(xyloObj,1);% size(video_frame)

filename_no_extension=input('Input file name with no extension');
Crop.frames = zeros(1, nFrames);

AA=read(xyloObj,1);
B=im2double(AA);
%AA=rgb2gray(AA);
imagesc(B)
th=input('What is the threshold');
close
B(B<=th)=0;
imagesc(B)
fj=input('1 if happy with threshold');
if fj == 1
nn = length(tracks);
xx=zeros(nn,1);
yy=zeros(nn,1);
%% This part crops the area around the foci in a square matrix
for tz=1:nn
    tr=tracks{tz,1};
    tr2=tr(1,2:3);
    xx(tz)=tr2(1,1);
    yy(tz)=tr2(1,2);
end

LL = length(xx);
CC = zeros(nn,2);
M = cell(nn, 1) ;  % creates a cell with zeros
   Res = cell(nn, 1);
   GOF_all = cell(nn, 1);
  
  for p = 1:LL
       CC1 = [xx(p), yy(p)];
       CC(p,:)=CC1; % CC is the approximate position of foci in 1st frame
  end
    crop = 7;%input('by how many pixel should i crop?'); % always answer 7 to create a 16x16 matrix?
for ii =1:nFrames
    AA=read(xyloObj,ii);
B=im2double(AA);
     
  for e = 1:LL  
   DD = [(CC(e,1)-crop), (CC(e,2)-crop), 15, 15]; % DD =  [xmin ymin width height]
   EE1 = imcrop(B,DD);
   M{e,ii} = EE1; % stacks cropped image matrices in a cell
  end 
  % M is saved as a matlab cell
  %use MM = cell2mat(M(1,1)) to get the 1st cropped image from a cell;
 
%Crop.frames(ii) = M; % creates a structure that saves M from each frame

  
  %% This part fits a gaussian
  coord_xy1= zeros(nn,2);
for gg = 1:LL
    MM = cell2mat(M(gg,ii));
      %th = 0.08;
% 3d gauss fitting module
[xx,yy]=meshgrid(1:16,1:16); % if we get a 16 by 16 matrix
xx=xx(:);
yy=yy(:);
MM(MM<=th)=0;
z=M{gg,ii};
z=rgb2gray(z);
zz=z(:);
[value, location] = max(MM(:));
[row, column] = ind2sub(size(MM), location);
max_value=[column,row];
pp=max_value(1);
qq = max_value(2);
[fitresult, gof] = createFit1(xx, yy, zz, pp, qq);
coeffnames(fitresult)
Result = coeffvalues(fitresult);
coord_xy=[Result(1,4),Result(1,5)];
coord_xy1(gg,:) = coord_xy; % This calulates position of gaussian peak
ff=input('1 if happy with fit');
if ff == 1
    %saveas(gcs,sprintf('figure%d.fig',gg);
    %or
    saveas(gcf,strcat(filename_no_extension, num2str(gg)),'fig');
close
Res{gg,ii} = Result; % stacks position results in a cell in 
GOF_all{gg,ii}=gof;%GOF of all foci from each frame
else
    break
end

end

end
end


