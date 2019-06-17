# Molecular-Rack-and-Pinion
These codes are used for image analysis
Works best with MATLAB 2016B. You need the function C2 present in the
% same folder as this code
% C1-C3 codes do the following
% 1) Loads the approximate position track data file from ImageJ 'Trackmate' 
% 2) Loads the .avi TIRF image video file of a rotating cell 
% 3) crops an area around the approximate position of a foci 
% 4) Fits a 3D gaussian to provide the sub pixel average position of the foci
% 
%  Use the following example files provided with this code to test:
% 1) TrackMate data file: C1_313_example_tracks.mat
% 2) Avi file: 313_copy_20.avi
%%
% C4: Adds successive images of an image stack of a rotating cell abnd cretaes a new image matrix
