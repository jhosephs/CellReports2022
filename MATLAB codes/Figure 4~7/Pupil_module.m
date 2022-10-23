clear all; clc; close all; fclose all;

% add path

mother_drive = 'D:\VR_Headfix_Data_Ephys';

addpath(genpath([mother_drive '\program\MClust-3.5']));
addpath([mother_drive '\program']);
motherROOT = [mother_drive '\raw'];

if ~exist(motherROOT, 'dir') mkdir (motherROOT); end
saveROOT = [motherROOT '\PupilDetection']; 

if ~exist(saveROOT) mkdir(saveROOT); end

thisRat = ['551']; %rat #
thisSession = ['07']; %session # 
      
obj = VideoReader([motherROOT '\Rat' thisRat '\Rat' thisRat '_' thisSession    '\Rat' thisRat '_' thisSession '.avi']);
NumberOfFrames = obj.NumberOfFrames;
threshold = 0.838; % Lesser the value, more strict boundary

for cnt = 1:NumberOfFrames 
     
 [pupilArea(cnt), cenx(cnt), ceny(cnt)] = DetectPupil(obj, NumberOfFrames, cnt, threshold);

end

cd(saveROOT);
fileName = [ thisRat '_' thisSession '_pupil.mat'];
save(fileName, 'pupilArea', 'cenx', 'ceny', 'cenx2', 'ceny2' )

