function   [ttrawMat, ttsmoothedMat] = GetFogTrialbyTrialMats(clusterID, motherROOT, saveROOT, thisRegionSite, thisconfigType);

%Field property calculation (Fog session)

motherROOT = 'D:\VR_Headfix_Data_Ephys\raw';

%Basic parameter

XsizeOfVideo = 600;
YsizeOfVideo = 200;
samplingRate = 30;
scaleForRateMap = 5;

binXForRateMap = XsizeOfVideo / scaleForRateMap;
binYForRateMap = YsizeOfVideo / scaleForRateMap;

close all;

%Parse clusterID
findHYPHEN = find(clusterID == '-');
thisRID = clusterID(1, 1:findHYPHEN(1) - 1);
thisSID = clusterID(1, findHYPHEN(1) + 1:findHYPHEN(2) - 1);
thisTTID = clusterID(1, findHYPHEN(2) + 1:findHYPHEN(3) - 1);
thisCLID = clusterID(1, findHYPHEN(3) + 1:end);

if str2double(thisCLID) < 10
    zero_filter = nonzeros(thisCLID);
    thisCLID = zero_filter(2);
end

%Import cluster data

WinClusterID =([motherROOT '\rat' thisRID '\rat' thisRID '_' thisSID '\TT' thisTTID '\T' thisTTID '.' thisCLID]);
delimiter = ',';
startRow = 14;
formatSpec = '%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%[^\n\r]';
fileID = fopen(WinClusterID,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
SpikeIndex = dataArray{:, 1};
SpikeTime = dataArray{:, 2};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Import TTL_Events

UEtoNlxEvent = ([motherROOT '\Rat' thisRID '\Rat' thisRID '_' thisSID '\Events.csv']);
filename = [UEtoNlxEvent];
delimiter = ',';
startRow = 2;
formatSpec = '%*s%*s%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

fclose(fileID);

Events = table(dataArray{1:end-1}, 'VariableNames', {'Timestamp','Event'});
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

Timestamp = Events{:, 1};
Event = Events{:, 2};

str1 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0010).';
str2 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0040).';
str3 = 'TTL Input on AcqSystem1_0 board 0 port 3 value (0x0004).';
str4 = 'TTL Input on AcqSystem1_0 board 0 port 3 value (0x0008).';
str5 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0050).';

TTL1 = find(strcmp(Event, str1));
TTL2 = find(strcmp(Event, str2));
TTL3 = find(strcmp(Event, str3));
TTL4 = find(strcmp(Event, str4));
TTL5 = find(strcmp(Event, str5));

TTL1Time = Timestamp(TTL1);
TTL2Time = Timestamp(TTL2);
TTL3Time = Timestamp(TTL3);
TTL4Time = Timestamp(TTL4);
TTL5Time = Timestamp(TTL5);

TTL1TimeT = (((TTL1Time-min(TTL1Time)))./1000000);

% Import UE event file

UnrealFile =([motherROOT '\Rat' thisRID '\Rat' thisRID '_' thisSID '\Rat' thisRID '_' thisSID '.csv']);
delimiter = ',';
formatSpec = '%s%f%*s%f%[^\n\r]';
fileID = fopen(UnrealFile,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

X = dataArray{:, 1};
Time = dataArray{:, 2};
Position = dataArray{:, 3};
RewardEvent = 'Reward';
Position([1:end])=((Position(1:end))./20);

clearvars UnrealFile delimiter formatSpec fileID dataArray ans;

Position(Position<0) = 0;
Filtered = ~isnan(Position);
FilteredPositionIndex = find(Filtered==1);
FilteredTime = Time(FilteredPositionIndex);
FilteredPosition = Position(FilteredPositionIndex);

for n=1:(length(FilteredPosition)-1)
    
    Teleport(n) = (FilteredPosition(n)-FilteredPosition(n+1))>50;
    Reset(n+1) = (FilteredPosition(n)-FilteredPosition(n+1))>25;
    ttt(n+1) =     abs(FilteredPosition(n)-FilteredPosition(n+1))>150;
end

Teleport = find(Teleport==1);
Reset = find(Reset==1);
ttt = find(ttt==1);

%Cumulative distance

ForestAnimalIndices = find(FilteredPosition<500);
CityAnimalIndices = find(FilteredPosition>500 & FilteredPosition<1000);

for i=2:length(ForestAnimalIndices)
    ForestIndiceDifference(i) = (ForestAnimalIndices(i)) - (ForestAnimalIndices(i-1));
end

for i=2:length(CityAnimalIndices)
    CityIndiceDifference(i) = (CityAnimalIndices(i)) - (CityAnimalIndices(i-1));
end

if isempty(ForestAnimalIndices)
    ForestTrialEndIndiceMarker = 0;
    ForestIndiceDifference = nan;
        ForestStartIndex = nan;

else
    ForestTrialEndIndiceMarker = (find(ForestIndiceDifference > 1)-1);
    ForestTrialEndIndiceMarker = ForestAnimalIndices(ForestTrialEndIndiceMarker);
    ForestTrialEndIndiceMarker = [(ForestTrialEndIndiceMarker)'  ForestAnimalIndices(end)];
end

if isempty(CityAnimalIndices)
    CityTrialEndIndiceMarker = 0;
    CityIndiceDifference = nan;
    CityStartIndex = nan;
else
    CityTrialEndIndiceMarker = (find(CityIndiceDifference > 1)-1);
    CityTrialEndIndiceMarker = CityAnimalIndices(CityTrialEndIndiceMarker);
    CityTrialEndIndiceMarker = [(CityTrialEndIndiceMarker)'  CityAnimalIndices(end)];
end


for k=2:length(FilteredPosition);
    Distance(k)= abs(FilteredPosition(k)-FilteredPosition(k-1));
end

Reset = Reset(2:length(Reset));

for n=1:length(Reset);
if (FilteredPosition(Reset(n))>450);
    CityStartIndex(n) = Reset(n);
else 
    ForestStartIndex(n) = Reset(n);
end
end

Distance = Distance(2:end);
Distance(abs(Distance)>70) = 0;
Distance(CityTrialEndIndiceMarker+1) = 0;


Cycle= find(Teleport==1);
ResetIndices = find(Reset==1);
CycleTime=Time(Cycle); 


ForestStartIndex(ForestStartIndex==0)=[];
CityStartIndex(CityStartIndex==0)=[];


ITIEndIndex = [Teleport(1:length(Teleport)) ttt(length(ttt))-1];
ITIStartIndex = sort([ForestTrialEndIndiceMarker CityTrialEndIndiceMarker]);
ITIStartIndex = [(ITIStartIndex(1:length(ITIStartIndex)-1))+1 ttt(length(ttt)-1)];


for k=1:length(Distance);
    CumulativeDistance(k) = sum(Distance(1:k));
end

CumulativeDistance = [0 , CumulativeDistance];

for n=2:length(CumulativeDistance);
    Instantenous_velocity(n-1) = (((CumulativeDistance(n) - CumulativeDistance(n-1)))) ;
end

Instantenous_velocity = [ 0 Instantenous_velocity ];
Moving_window = 15;
Smoothed_velocity = movmean(Instantenous_velocity,Moving_window);
Smoothed_velocity = Smoothed_velocity.*30;

Velocity_FilterIndex = find(Smoothed_velocity>=5);
Rest_FilterIndex = find(Smoothed_velocity<5);

FSpikeTime = interp1(TTL1Time, TTL1Time, SpikeTime, 'nearest');

if CityTrialEndIndiceMarker == 0 
    for i = 1:length(FilteredPosition)
    if  FilteredPosition(i) > 999
    FilteredPosition (i) = FilteredPosition (i) - 500;
else
    FilteredPosition(i) = FilteredPosition (i);
    end
    end
end
    
if ForestTrialEndIndiceMarker == 0 
FilteredPosition = FilteredPosition - 500;
end
    
% Filtering

Filtered_TTL1Time = TTL1Time(Velocity_FilterIndex);
[SpikeTime,pos]=intersect(FSpikeTime,Filtered_TTL1Time);

% Spike-Position parsing

FilteredPosition(Rest_FilterIndex) = nan;
TTL1TimeT(Rest_FilterIndex) = nan;
AFilteredPosition = FilteredPosition;

csFilteredTime(Rest_FilterIndex) = nan;
csFilteredTime(isnan(csFilteredTime)) = [];

[NaNIndex, col] = find(isnan(AFilteredPosition));
AFilteredPosition = AFilteredPosition(~isnan(AFilteredPosition));

SpikePosition = interp1(Filtered_TTL1Time, AFilteredPosition, SpikeTime, 'nearest');
SpikeTimeT = (((SpikeTime-min(TTL1Time)))./1000000);
Frequency = length(SpikeTime)/max(TTL1TimeT);
SpikeData = [SpikeTime, SpikePosition];

SpikeCell = cell(2,length(ITIEndIndex)-1);
UnrealCell = cell(2,length(ITIEndIndex)-1);

for n=1:length(ITIEndIndex)-1
    
    SpikeFilter = (TTL1TimeT(ITIEndIndex(n)+1)<SpikeTimeT & TTL1TimeT(ITIEndIndex(n+1))>SpikeTimeT);
    SpikeFilter = find(SpikeFilter==1); 
    
SpikeCell{1,n} = SpikeTimeT(SpikeFilter);
SpikeCell{2,n} = SpikePosition(SpikeFilter);

UnrealCell{2,n} = FilteredPosition((ITIEndIndex(n)+1):ITIEndIndex(n+1));
UnrealCell{1,n} = FilteredTime((ITIEndIndex(n)+1):ITIEndIndex(n+1));

end

stdTrialTime = vertcat(UnrealCell{1, stdTrial});
stdTrialPosition = vertcat(UnrealCell{2, stdTrial});

stdTrialSpikeTime = vertcat(SpikeCell{1, stdTrial});
stdTrialSpikePosition = vertcat(SpikeCell{2, stdTrial});

amb0TrialTime = vertcat(UnrealCell{1, amb0Trial});
amb0TrialPosition = vertcat(UnrealCell{2, amb0Trial});

amb0TrialSpikeTime = vertcat(SpikeCell{1, amb0Trial});
amb0TrialSpikePosition = vertcat(SpikeCell{2, amb0Trial});

amb1TrialTime = vertcat(UnrealCell{1, amb1Trial});
amb1TrialPosition = vertcat(UnrealCell{2, amb1Trial});

amb1TrialSpikeTime = vertcat(SpikeCell{1, amb1Trial});
amb1TrialSpikePosition = vertcat(SpikeCell{2, amb1Trial});

amb2TrialTime = vertcat(UnrealCell{1, amb2Trial});
amb2TrialPosition = vertcat(UnrealCell{2, amb2Trial});

amb2TrialSpikeTime = vertcat(SpikeCell{1, amb2Trial});
amb2TrialSpikePosition = vertcat(SpikeCell{2, amb2Trial});


mod = 3; % Bin size

% trial- bin-by-bin

for i = 1:length(ITIEndIndex)-1
    totalTime = vertcat(UnrealCell{1, i});
    totalPosition = vertcat(UnrealCell{2, i});
    
    totalSpikeTime = vertcat(SpikeCell{1, i});
    totalSpikePosition = vertcat(SpikeCell{2, i});
    
    SpikePositionY = ones(length(totalSpikePosition),1);
    FilteredPositionY = ones(length(totalPosition), 1);
    
    if isempty(totalSpikePosition)
        ttoccMat(1:40, 1:115) = 0;
        ttspkMat(1:40, 1:115) = 0;
        ttrMat(1:40, 1:115) = 0;
        ttskaggsrateMat(1:40, 1:115) = 0;
        ttSpaInfoScore = 0;
        ttMaxFR = 0;
        ttAvgFR(i) = 0;
        ttnumOfSpk = 0;
        RawttAvFR(i) = 0;
        RawITIttAvFR(i) = 0;
        ttrawMat(i, 1:115) = zeros(1,115);
        ttsmoothedMat(i, 1:115) = zeros(1,115);
    else
        [ttoccMat, ttspkMat,  ttrMat, ttskaggsrateMat] = abmFiringRateMap( ...
            [totalSpikeTime, totalSpikePosition, SpikePositionY],...
            [totalTime, totalPosition, FilteredPositionY],...
            binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
        ttSpaInfoScore = GetSpaInfo(ttoccMat, ttskaggsrateMat);
        ttMaxFR = nanmax(nanmax(ttskaggsrateMat));
        ttAvgFR = nanmean(nanmean(ttskaggsrateMat));
        ttnumOfSpk = length(totalSpikeTime);
        
        ttrawMat(i, 1:115) = ttrMat(1, 1:115);
        ttsmoothedMat(i, 1:115) = ttskaggsrateMat(1,1:115);
    end
    
    SpikePositionY = [];
    FilteredPositionY = [];
    
end


graphicalResultFolder = [motherROOT  '\FogLap_by_Lap_20220608(mat)'];

if ~exist(graphicalResultFolder, 'dir')
    mkdir(graphicalResultFolder);
end

cd([motherROOT  '\FogLap_by_Lap (mat)']);
save([graphicalResultFolder '\' clusterID '.mat'], 'ttrawMat', 'ttsmoothedMat', 'stdTrial', 'amb0Trial', 'amb1Trial', 'amb2Trial');

clear ttskaggsrateMat ttrawMat;
end
