%% Initializing

clear all; clc; close all; fclose all;

% add path

mother_drive = 'D:\VR_Headfix_Data_Ephys';

addpath(genpath([mother_drive '\program\MClust-3.5']));
addpath([mother_drive '\program']);
motherROOT = [mother_drive '\raw'];

if ~exist(motherROOT, 'dir') mkdir (motherROOT); end
saveROOT = [motherROOT '\Fog_FieldMatrix'];
if ~exist(saveROOT) mkdir(saveROOT); end

cd(saveROOT);

%Load basic param


cd(motherROOT);
inputCSV = fopen('ClusterID.csv', 'r');
inputLOAD = fscanf(inputCSV, '%c');
inputNewline = find(inputLOAD == sprintf('\n'));
load ('bootFog_Filtered.mat')

Indices = [];
Indices = vertcat([CA1' CA3']');

% Indices = idc;

regionStr = {'CA1', 'CA3a', 'CA3b', 'CA3c', 'DG', 'V1', 'V2', 'etc'};
sessionStr = {'standard_session', 'auditory_contextual_switch', 'fog_session', 'sensory_motor_gain_session'};

%Calc. starts

tic;
for i=1:length(Indices);
    cd(motherROOT);
    
    clusterID = cell2mat(Indices(i));
    findHYPHEN = find(clusterID == '-');
    
    thisRID = (clusterID(1, 1:findHYPHEN(1) - 1));
    thisSID = (clusterID(1, findHYPHEN(1) + 1:findHYPHEN(2) - 1));
    thisSession = ['rat' thisRID '-' thisSID];
    thisTTID = (clusterID(1, findHYPHEN(2) + 1:findHYPHEN(3) - 1));
    thisCLID = (clusterID(1, findHYPHEN(3) + 1:end));
    
    stIter = get_regionSite(thisRID, thisTTID);
    thisRegionSite = regionStr{stIter};
    
    stIter = get_sessionType(thisRID, thisSID);
    thisSessionType = sessionStr{stIter};
    
    
    stIter = get_config_type(thisRID, thisSID);
    thisconfigType = configStr{stIter};
    
    
    GetFogTrialbyTrialMats(clusterID, motherROOT, saveROOT, thisRegionSite, thisconfigType);
    clear clusterID  stdoccMat TTL1 TTL1Time TT1TimeT ttMat ttoccMat ttrawMat ttskaggsrateMat ttspkMat ttt UnrealCell X stdTrialTime stdTrialSpikeTime stdTrialSpikePosition stdTrialPosition stdTrial stdspkMat thisSessionType thisRID thisSID thisTTID thisCLID thisRegionSite stdAvgFR amb0AvgFR stdSpaInfoScore amb0SpaInfoScore stdmaxField stdminField amb0maxField amb0minField stdpeakFrBin amb0peakFrBin stdcent amb0cent stdfieldSize amb0fieldSize
    
end
cd(motherROOT); toc;