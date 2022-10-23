clear all
close all
clc

mother_drive = 'D:\VR_Headfix_Data_Ephys';

addpath(genpath([mother_drive '\program\MClust-3.5']));
addpath([mother_drive '\program']);
motherROOT = [mother_drive '\raw'];

cd(motherROOT);
inputCSV = fopen('sessionID_fogPupil.csv', 'r');
inputLOAD = fscanf(inputCSV, '%c');
inputNewline = find(inputLOAD == sprintf('\n'));

dataP = [mother_drive '\raw\PupilDetection'];
cd(dataP);


for sessionRUN = 1:length(session);
    if sessionRUN == 1
        
        sessionID = inputLOAD(1, 1:inputNewline(session(sessionRUN)) - 2);
    else
        sessionID = inputLOAD(1, 1 + inputNewline(session(sessionRUN) - 1):inputNewline(session(sessionRUN)) - 2);
    end
    findHYPHEN = find(sessionID == '-');
    
    thisRID = (sessionID(1, 1:findHYPHEN(1) - 1));
    thisSID = (sessionID(1, findHYPHEN(1)+1:findHYPHEN(1)+2));
    filename = [ thisRID '-' thisSID];
    
    
    load([filename '.mat']);
    fogTr = min([amb0Trial amb1Trial amb2Trial]);
    rTr = fogTr-6;
    
    
    for p = 1:length(ScenePupilCell)
        ScenePupilCell{1,p} = normalize(smoothdata((ScenePupilCell{1,p}),'gaussian',5));
    end
    
    for i = fogTr-5:1:fogTr-1
        for j = 1: 300
            preFOG(i-rTr,j) = nanmean((ScenePupilCell{1,i}([find(ScenePupilPosition{2,i} < j*5/3 & ScenePupilPosition{2,i} >= (j-1)*5/3)])));
        end
    end
    
    i = [];
    j = [];
    for i= 1:300
        preFOGmean(i) = nanmean([preFOG(:,i)]);
    end
    
    
    
    for i = 1:5
        for j = 1: 300
            postFOG0(i,j) = nanmean(ScenePupilCell{1,amb0Trial(i)}([find(ScenePupilPosition{2,amb0Trial(i)} < j*5/3 & ScenePupilPosition{2,amb0Trial(i)} >= (j-1)*5/3)]));
            postFOG1(i,j) = nanmean(ScenePupilCell{1,amb1Trial(i)}([find(ScenePupilPosition{2,amb1Trial(i)} < j*5/3 & ScenePupilPosition{2,amb1Trial(i)} >= (j-1)*5/3)]));
            postFOG2(i,j) = nanmean(ScenePupilCell{1,amb2Trial(i)}([find(ScenePupilPosition{2,amb2Trial(i)} < j*5/3 & ScenePupilPosition{2,amb2Trial(i)} >= (j-1)*5/3)]));
            
        end
    end
    
    i = [];
    j = [];
    for i= 1:300
        postFOGmean0(i) = nanmean([postFOG0(:,i)]);
        postFOGmean1(i) = nanmean([postFOG1(:,i)]);
        postFOGmean2(i) = nanmean([postFOG2(:,i)]);
        
    end
    
    
    Mpre(:,sessionRUN) =smoothdata(preFOGmean', 'gaussian', 5);
    Mpost0(:,sessionRUN) =smoothdata(postFOGmean0', 'gaussian', 5);
    Mpost1(:,sessionRUN) =smoothdata(postFOGmean1', 'gaussian', 5);
    Mpost2(:,sessionRUN) =smoothdata(postFOGmean2', 'gaussian', 5);
    
    for i=1:300
        Mprea(i) = nanmean(Mpre(i,:));
        Mposta0(i) = nanmean(Mpost0(i,:));
        Mposta1(i) = nanmean(Mpost1(i,:));
        Mposta2(i) = nanmean(Mpost2(i,:));
        
    end
    
    Mdiff0(:,sessionRUN) = Mpost0(:,sessionRUN)-Mpre(:,sessionRUN);
    Mdiff1(:,sessionRUN) = Mpost1(:,sessionRUN)-Mpre(:,sessionRUN);
    Mdiff2(:,sessionRUN) = Mpost2(:,sessionRUN)-Mpre(:,sessionRUN);
    
    Rdiff1 = Mdiff1 - Mdiff0;
    Rdiff2 = Mdiff2 - Mdiff0;
    
end


%%
rg = 80;
PRange = 0;

subplot(4,3,1)
for i = 1:rg
    for j = 1:length(d1)
        
        D1Fog0Pair(i,j) = Mpost0(i+PRange,d1(j));
        
        
        D1diff0(i,j) =    D1Fog0Pair(i,j) - Mpre(i+PRange, d1(j));
        
        if Mpre(i+PRange,d1(j)) < Mpost0(i+PRange,d1(j))
            scatter(Mpre(i+PRange,d1(j)),Mpost0(i+PRange,d1(j)),'r.')
            D1Mposta0I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d1(j)), Mpost0(i+PRange,d1(j)),'k.')
            D1Mposta0I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])



subplot(4,3,2)
for i = 1:rg
    for j = 1:length(d1)
        
        D1Fog1Pair(i,j) = Mpost1(i+PRange,d1(j));
        D1diff1(i,j) =       D1Fog1Pair(i,j) - Mpre(i+PRange, d1(j));
        
        if Mpre(i+PRange,d1(j)) < Mpost1(i+PRange,d1(j))
            scatter(Mpre(i+PRange,d1(j)),Mpost1(i+PRange,d1(j)),'r.')
            D1Mposta1I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d1(j)), Mpost1(i+PRange,d1(j)),'k.')
            D1Mposta1I(i,j) = 0;
        end
    end
end




xlim([-3 3])
ylim([-3 3])


subplot(4,3,3)
for i = 1:rg
    for j = 1:length(d1)
        
        D1Fog2Pair(i,j) = Mpost2(i+PRange,d1(j));
        D1diff2(i,j) =       D1Fog2Pair(i,j) - Mpre(i+PRange, d1(j));
        
        
        if Mpre(i+PRange,d1(j)) < Mpost2(i+PRange,d1(j))
            scatter(Mpre(i+PRange,d1(j)),Mpost2(i+PRange,d1(j)),'r.')
            D1Mposta2I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d1(j)), Mpost2(i+PRange,d1(j)),'k.')
            D1Mposta2I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])


subplot(4,3,4)
for i = 1:rg
    for j = 1:length(d2)
        
        D2Fog0Pair(i,j) = Mpost0(i+PRange,d2(j));
        D2diff0(i,j) =    D2Fog0Pair(i,j) - Mpre(i+PRange, d2(j));
        
        if Mpre(i+PRange,d2(j)) < Mpost0(i+PRange,d2(j))
            scatter(Mpre(i+PRange,d2(j)),Mpost0(i+PRange,d2(j)),'r.')
            D2Mposta0I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d2(j)), Mpost0(i+PRange,d2(j)),'k.')
            D2Mposta0I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])


subplot(4,3,5)
for i = 1:rg
    for j = 1:length(d2)
        
        D2Fog1Pair(i,j) = Mpost1(i+PRange,d2(j));
        D2diff1(i,j) =    D2Fog1Pair(i,j) - Mpre(i+PRange, d2(j));
        
        if Mpre(i+PRange,d2(j)) < Mpost1(i+PRange,d2(j))
            scatter(Mpre(i+PRange,d2(j)),Mpost1(i+PRange,d2(j)),'r.')
            D2Mposta1I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d2(j)), Mpost1(i+PRange,d2(j)),'k.')
            D2Mposta1I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])



subplot(4,3,6)
for i = 1:rg
    for j = 1:length(d2)
        
        D2Fog2Pair(i,j) = Mpost2(i+PRange,d2(j));
        D2diff2(i,j) =    D2Fog2Pair(i,j) - Mpre(i+PRange, d2(j));
        
        if Mpre(i+PRange,d2(j)) < Mpost2(i+PRange,d2(j))
            scatter(Mpre(i+PRange,d2(j)),Mpost2(i+PRange,d2(j)),'r.')
            D2Mposta2I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d2(j)), Mpost2(i+PRange,d2(j)),'k.')
            D2Mposta2I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])




subplot(4,3,7)
for i = 1:rg
    for j = 1:length(d3)
        
        D3Fog0Pair(i,j) = Mpost0(i+PRange,d3(j));
        D3diff0(i,j) =    D3Fog0Pair(i,j) - Mpre(i+PRange, d3(j));
        
        if Mpre(i+PRange,d3(j)) < Mpost0(i+PRange,d3(j))
            scatter(Mpre(i+PRange,d3(j)),Mpost0(i+PRange,d3(j)),'r.')
            D3Mposta0I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d3(j)), Mpost0(i+PRange,d3(j)),'k.')
            D3Mposta0I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])



subplot(4,3,8)
for i = 1:rg
    for j = 1:length(d3)
        
        D3Fog1Pair(i,j) = Mpost1(i+PRange,d3(j));
        D3diff1(i,j) =    D3Fog1Pair(i,j) - Mpre(i+PRange, d3(j));
        
        if Mpre(i+PRange,d3(j)) < Mpost1(i+PRange,d3(j))
            scatter(Mpre(i+PRange,d3(j)),Mpost1(i+PRange,d3(j)),'r.')
            D3Mposta1I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d3(j)), Mpost1(i+PRange,d3(j)),'k.')
            D3Mposta1I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])

subplot(4,3,9)
for i = 1:rg
    for j = 1:length(d3)
        
        D3Fog2Pair(i,j) = Mpost2(i+PRange,d3(j));
        D3diff2(i,j) =    D3Fog2Pair(i,j) - Mpre(i+PRange, d3(j));
        
        if Mpre(i+PRange,d3(j)) < Mpost2(i+PRange,d3(j))
            scatter(Mpre(i+PRange,d3(j)),Mpost2(i+PRange,d3(j)),'r.')
            D3Mposta2I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d3(j)), Mpost2(i+PRange,d3(j)),'k.')
            D3Mposta2I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])



subplot(4,3,10)
for i = 1:rg
    for j = 1:length(d4)
        
        D4Fog0Pair(i,j) = Mpost0(i+PRange,d4(j));
        D4diff0(i,j) =    D4Fog0Pair(i,j) - Mpre(i+PRange, d4(j));
        
        if Mpre(i+PRange,d4(j)) < Mpost0(i+PRange,d4(j))
            scatter(Mpre(i+PRange,d4(j)),Mpost0(i+PRange,d4(j)),'r.')
            D4Mposta0I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d4(j)), Mpost0(i+PRange,d4(j)),'k.')
            D4Mposta0I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])


subplot(4,3,11)
for i = 1:rg
    for j = 1:length(d4)
        
        D4Fog1Pair(i,j) = Mpost1(i+PRange,d4(j));
        D4diff1(i,j) =    D4Fog1Pair(i,j) - Mpre(i+PRange, d4(j));
        
        if Mpre(i+PRange,d4(j)) < Mpost1(i+PRange,d4(j))
            scatter(Mpre(i+PRange,d4(j)),Mpost1(i+PRange,d4(j)),'r.')
            D4Mposta1I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d4(j)), Mpost1(i+PRange,d4(j)),'k.')
            D4Mposta1I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])


subplot(4,3,12)
for i = 1:rg
    for j = 1:length(d4)
        
        D4Fog2Pair(i,j) = Mpost2(i+PRange,d4(j));
        D4diff2(i,j) =    D4Fog2Pair(i,j) - Mpre(i+PRange, d4(j));
        
        if Mpre(i+PRange,d4(j)) < Mpost2(i+PRange,d4(j))
            scatter(Mpre(i+PRange,d4(j)),Mpost2(i+PRange,d4(j)),'r.')
            D4Mposta2I(i,j) = 1;
            hold on
        else
            scatter(Mpre(i+PRange,d4(j)), Mpost2(i+PRange,d4(j)),'k.')
            D4Mposta2I(i,j) = 0;
        end
    end
end

xlim([-3 3])
ylim([-3 3])

%%%%%%%

figure();

A = [];
A = D1diff0';
A = A(:)';

B = [];
B = D1diff1';
B = B(:)';

C = [];
C = D1diff2';
C = C(:)';

D = [];
D(:,1) = A;
D(:,2) = B;
D(:,3) = C;


[f1,x] = ecdf([A B C]);
plot(x,f1,'LineWidth',1)

[f1,x] = ecdf([A B C]);
plot(x,f1,'LineWidth',1)

set(gca,'linewidth',1)

xlabel('postFog - preFog','FontWeight','bold','FontSize',10);
ylabel('Proportion','FontWeight','bold','FontSize',10);
xlim([-2 2])
xline(0,'k:')
