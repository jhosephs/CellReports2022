% visual display

sheet = figure;
sheetPOS = [25 0.01 29.7 21.0 ];
set(gcf,'units','centimeters','position',sheetPOS,'Color', [1 1 1]);

szFONT = 10;
txtFONT = 14;

%% SessionID & printed date
subplot(4,6,1:6);
set(gca,'units','normalized','position',[0.03 0.97 0.94 0.02]); axis off;
text(0.02, 0.5, ['Rat' thisRID '-S' thisSID '-Standard session' ],'FontSize',txtFONT);
text(0.8, 0.5, ['printed on ' date],'FontSize',szFONT);


%% Elapsed time / occupancy map

subplot(4,6,7);
set(gca,'units','pixels','position',[50 580 240 150]);

bar(elapsedTime)
xlabel(['Trial #'],'FontWeight','bold');
ylabel(['Elapsed time (s)'],'FontWeight','bold');
title({'Trial-by-trial latency'},'FontWeight','bold');

hold on
bar(POCI, elapsedTime(POCI))
axis([0 length(ITIEndIndex)+1 0 nanmax(elapsedTime)*1.1]);

subplot(4,6,8);
set(gca,'units','pixels','position',[350 580 200 150]);
set(gca,'xtick',[],'ytick',[]); axis off;

plot((FilteredPosition./5*3),(FilteredTime),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(gca,'YDir','reverse');

xlabel('Position (cm)','FontWeight','bold','FontSize',10);
ylabel('Time (s)','FontWeight','bold','FontSize',10);

set(gca,'YDir','reverse');
axis([0 647 0 (FilteredTime(end)*1.05)]);
title({'Raw trajectory'},'FontWeight','bold');

subplot(4,6,9);
set(gca,'units','pixels','position',[610 580 200 150]);

plot(FpositionV(slow_vFI)*3/5, filteredPupilArea(slow_vFI),'.', 'Color',[0.929411764705882 0.694117647058824 0.125490196078431])
axis([0 348 0 15000]);

xline(282,'--k', 'LineWidth', 2);
ylabel('Pupil size (# pixel)','FontWeight','bold');
xlabel('Position (cm)','FontWeight','bold');
title({'Forest (slow)'},'FontWeight','bold');

subplot(4,6,10);
set(gca,'units','pixels','position',[870 580 200 150]);

plot((FilteredPosition(slow_vCI)-500)*3/5, filteredPupilArea(slow_vCI),'.', 'Color',[0.929411764705882 0.694117647058824 0.125490196078431])
axis([0 348 0 15000]);

xline(282,'--k', 'LineWidth', 2);
ylabel('Pupil size (# pixel)','FontWeight','bold');
xlabel('Position (cm)','FontWeight','bold');
title({'City (slow)'},'FontWeight','bold');

%% pupil by velocity

subplot(4,6,13);

set(gca,'units','pixels','position',[65 350 200 150]);

imagesc(sFTDuration_norm)
colormap hot

xlabel('Position (1bin = 12cm)','FontWeight','bold','FontSize',10);
ylabel('Trial #','FontWeight','bold','FontSize',10);
title({'Occupancy map (Forest)'},'FontWeight','bold');
xline(23.5,'--w', 'LineWidth', 2);



subplot(4,6,14);

set(gca,'units','pixels','position',[345 350 200 150]);

imagesc(sCTDuration_norm)
colormap hot

xlabel('Position (1bin = 12cm)','FontWeight','bold','FontSize',10);
ylabel('Trial #','FontWeight','bold','FontSize',10);
title({'Occupancy map (City)'},'FontWeight','bold');
xline(23.5,'--w', 'LineWidth', 2);

subplot(4,6,19);

set(gca,'units','pixels','position',[65 100 200 150]);

plot(FpositionV(firsthalfFindex)*3/5, filteredPupilArea(firsthalfFindex),'.','Color',[0.466666666666667 0.674509803921569 0.188235294117647] )
axis([0 348 0 15000]);

xline(282,'--k', 'LineWidth', 2);
ylabel('Pupil size (# pixel)','FontWeight','bold');
xlabel('Position (cm)','FontWeight','bold');

hold on

plot(FpositionV(secondhalfFindex)*3/5, filteredPupilArea(secondhalfFindex),'.', 'Color',[0.717647058823529 0.274509803921569 1])

title({'1st 5 trials vs last 5 trials (Forest)'},'FontWeight','bold');


subplot(4,6,20);

set(gca,'units','pixels','position',[345 100 200 150]);


plot(((FilteredPosition(firsthalfCindex)-500)*3/5), filteredPupilArea(firsthalfCindex),'.', 'Color',[0.466666666666667 0.674509803921569 0.188235294117647])
axis([0 348 0 15000]);

xline(282,'--k', 'LineWidth', 2);
xlabel('Position (cm)','FontWeight','bold');

hold on

plot(((FilteredPosition(secondhalfCindex)-500)*3/5), filteredPupilArea(secondhalfCindex),'.', 'Color',[0.717647058823529 0.274509803921569 1])

title({'1st 5 trials vs last 5 trials (City)'},'FontWeight','bold');
text(0, -0.45, sprintf(['Stopped time = ' jjnum2str(length(rest_vI)/30) 's']), 'units', 'normalized', 'FontWeight','bold')

%% pupil sizes by trial block


subplot(4,6,16);
set(gca,'units','pixels','position',[610 350 200 150]);

plot(FpositionV(fast_vFI)*3/5, filteredPupilArea(fast_vFI),'.', 'Color',[0.466666666666667 0.674509803921569 0.188235294117647])
axis([0 348 0 15000]);

xline(282,'--k', 'LineWidth', 2);
ylabel('Pupil size (# pixel)','FontWeight','bold');
xlabel('Position (cm)','FontWeight','bold');


title({'Forest (fast)'},'FontWeight','bold');


subplot(4,6,18);
set(gca,'units','pixels','position',[870 350 200 150]);

plot((FilteredPosition(fast_vCI)-500)*3/5, filteredPupilArea(fast_vCI),'.', 'Color',[0.466666666666667 0.674509803921569 0.188235294117647])
axis([0 348 0 15000]);

xline(282,'--k', 'LineWidth', 2);
ylabel('Pupil size (# pixel)','FontWeight','bold');
xlabel('Position (cm)','FontWeight','bold');

hold on

title({'City (fast)'},'FontWeight','bold');

subplot(4,6,23);
xlabel('Trial #','FontWeight','bold');
set(gca,'units','pixels','position',[610 100 200 150]);
yyaxis left
plot(FspupilAvArea, 'o')
axis([0 length(ForestStartIndex)+1 2000 12000]);
hold on
yyaxis right
plot(fVelocity, '*', 'Color',[0.501960784313725 0.501960784313725 0.501960784313725])

title({'Forest (Pupil size vs Velocity)'},'FontWeight','bold');
title({'City (Pupil size vs Velocity)'},'FontWeight','bold');

text(0, -0.185, sprintf(['r = ' jjnum2str(forestR)]), 'units', 'normalized', 'FontWeight','bold')
text(0, -0.3, sprintf(['p = ' jjnum2str(forestP)]), 'units', 'normalized', 'FontWeight','bold')

subplot(4,6,24);

set(gca,'units','pixels','position',[870 100 200 150]);
yyaxis left
plot(CspupilAvArea, 'o')
axis([0 length(CityStartIndex)+1  2000 12000]);
hold on
yyaxis right
fig = plot(cVelocity,'*', 'Color',[0.501960784313725 0.501960784313725 0.501960784313725]);
left_color = [.5 .5 0];
right_color = [0.501960784313725 0.501960784313725 0.501960784313725];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

xlabel('Trial #','FontWeight','bold');
title({'City (Pupil size vs Velocity)'},'FontWeight','bold');

text(0, -0.185, sprintf(['r = ' jjnum2str(cityR)]), 'units', 'normalized', 'FontWeight','bold')
text(0, -0.3, sprintf(['p = ' jjnum2str(cityP)]), 'units', 'normalized', 'FontWeight','bold')


%% save image

graphicalResultFolder = [motherROOT '\Behavior_graphics'];

if ~exist(graphicalResultFolder, 'dir')
    mkdir(graphicalResultFolder);
end

cd([motherROOT '\Behavior_graphics']);
saveas(gcf, [graphicalResultFolder '\Rat' thisRID '-' thisSID '_Behavior.jpeg']);

save([graphicalResultFolder '\Rat' thisRID '-' thisSID '.mat'], 'forestSV', 'citySV');
close all

