
% plots the track data after gauss fits
% change R(n) and color based on the number of tracks
close all
figure
for ki = 1:nFrames
    R1=Res{1,ki};
    scatter(R1(1,1),R1(1,2),'*','r')
    hold on
    R2=Res{2,ki};
    scatter(R2(1,1),R2(1,2),'*','k')
    R3=Res{3,ki};
    scatter(R3(1,1),R3(1,2),'*','b')
    R4=Res{4,ki};
    scatter(R4(1,1),R4(1,2),'*','m')
    R5=Res{5,ki};
    scatter(R5(1,1),R5(1,2),'*','g')
end