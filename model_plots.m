%Plot AutoExpansion Data

%Written by MK Salcedo Jan-April 2023

%Purpose of this code is to calulate Beta as part of the model described in
%the Autoexpansion paper.

%Experiment: Wings from Schistocerca americana, the American bird
%grasshopper, were removed at different points throughout wing expansion to
%investigate a phenomenon called "autonomous wing inflation" that is here
%termed as "autoexpansion." Wings were observed expanding under normal wing
%expansion (wings attached, intact to the insect) but also dissected at 5, 10, 15, and 20 min:

%Gravity treatment: dissected, glued, and hung from a glass slide
%Deionized water treatment: dissected, glued and layed on a bed of deionnized water in a petri dish 
%Buffer treatment: dissected, glued and layed on a bed of potassium phosphate buffer in a petri dish 
%Mineral oil: dissected, glued and layed on a bed of mineral oil in a petri dish 

%Solving model:
%Reminder: log(x) in matlab is natural log of x

%Recall variables Lfinal_FW, LfinalHW, Afinal_FW, and Afinal_HW 
% Following equation from notes with Dr. Jung: 
% L = Lfinal - (1-e^(-Beta*t))
% e^(-Beta*t) = 1 - L(t)/Lfinal)
% -Beta*t = ln(1-(L(t)/Lfinal))

%Model is viscoelastic representation of the wing. This code also used the
%"Curve Fitting" app in Matlab to deal with the numerous NaN's in the data
%(which made plotting tricky).


%% FIRST RUN THIS TO CHOOSE .CSV 
%This sets the working folder
clc; close all;

%Navigate to folders
% Define a starting folder.
start_path = fullfile(matlabroot, '\toolbox');
if ~exist(start_path, 'dir')
	start_path = matlabroot;
end
% Ask user to confirm the folder, or change it.
uiwait(msgbox('Pick a starting folder on the next window that will come up.'));
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
fprintf('The top level folder is "%s".\n', topLevelFolder);
%% Read in files

%Gravity
fileParams = dir(fullfile(topLevelFolder, '*gravEDIT.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
G = readtable(wingParams); %read table

fileParams = dir(fullfile(topLevelFolder, '*grav_length.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
G2 = readtable(wingParams); %read table
G2 = sortrows(G2,4); %sort rows by time2

%Buffer treatment
fileParams3 = dir(fullfile(topLevelFolder, '*buffer.csv')); %get file of buffer trial wing lengths
wingParams3 = fullfile(topLevelFolder,fileParams3.name); %set pathway to name
buff = readtable(wingParams3); %read table of gravity trial wing lengths
buff2 = sortrows(buff,7); %sort rows by time2

%Deionized water treatment
fileParams4 = dir(fullfile(topLevelFolder, '*di_h2o.csv')); %get file of deionized water trial wing lengths
wingParams4 = fullfile(topLevelFolder,fileParams4.name); %set pathway to name
water = readtable(wingParams4); %read table of gravity trial wing lengths
water2 = sortrows(water,7); %sort rows by time2

%Mineral oil treatment
fileParams5 = dir(fullfile(topLevelFolder, '*mo.csv')); %get file of mineral oil trial wing lengths
wingParams5 = fullfile(topLevelFolder,fileParams5.name); %set pathway to name
mo = readtable(wingParams5); %read table of gravity trial wing lengths
mo2 = sortrows(mo,7); %sort rows by time2

%Intact (no treatment)
fileParams6 = dir(fullfile(topLevelFolder, '*intact_schisto.csv')); %get file of mineral oil trial wing lengths
wingParams6 = fullfile(topLevelFolder,fileParams6.name); %set pathway to name
schisto = readtable(wingParams6); %read table of gravity trial wing lengths
S2 = sortrows(schisto,4);  %sort rows by time2

%Calculate average fore-/hindwing lengths using table S2, rows 93-109 (40 min-62) min 
Lfinal_FW = mean(S2.fwLength_mm_(93:109),'omitnan');
Lfinal_HW = mean(S2.hwLength_mm_(93:109),'omitnan');

Afinal_FW = mean(S2.fwArea(93:109),'omitnan');
Afinal_HW = mean(S2.hwArea(93:109),'omitnan');

%% Colors and Variables for plotting
%Set up color variables for all plots that follow

%Colors 
red = [0.9375 0.3438 0.2891];
darkred = [0.4492 0.0469 0.0078]; %trend line
pink = [0.9805 0.6719 0.5352]; 
black = [0 0 0]; %black - marker edge color
white = [1 1 1]; %white
gray = [0.3438 0.3477 0.3477]; %dark gray
darkblue = [0.1680 0.3438 0.4648];
purple = [0.1562    0.1680    0.3633]; %trend line
lightblue = [0.1211 0.7773 0.7148]; 
lightgray = [0.6523    0.6602    0.6719];
yellow = [0.9290 0.6940 0.1250];


%variables used in each subplot
alpha = 0.75; %opacity of circles
alpha2 = 0.5; %opacity for wings plotted on top
k = 15; %window for movmean function
circleSize = 100;
circleLine = 0.1;
trendcolor1 = gray;
trendcolor2 = gray;
edgeColor = white; %circle edge color
widthLine = 4; %line width of the trendline

%% Calculated beta

close all;
%for these plots, I found the p-values through the curve-fitting app on
%matlab and I hardcoded them in. Otherwise the NaNs were messing with the
%calculation

%Plot Gravity
timeG = G2.time2(14:89); %rename column
fwGravA = G2.fwArea(14:89); %rename fw area
hwGravA = G2.hwArea(14:89); %rename hw area

fwGravL = G2.fwLength_mm_(14:89); %rename fw area
hwGravL = G2.hwLength_mm_(14:89); %rename hw area

%Plot Gravity treatments
%Calculate area
fwAgrav = log(1-(fwGravA/Afinal_FW)); %rename fw area
hwAgrav = log(1-(hwGravA/Afinal_HW)); %rename hw area

%Calculate length
fwLgrav = log(1-(fwGravL/Lfinal_FW)); %rename fw length
hwLgrav = log(1-(hwGravL/Lfinal_HW)); %rename hw length

%p1 = polyfit(timeG,fwAgrav,1);
%p1 = [-0.02486 -0.5141]; %hardcoded in - all data
p1 = [-0.05913 0.2132]; %10-30 min, R^2 = 0.198
X1 = linspace(0,90,1e2);
Y1 = polyval(p1, X1);

%p2 = polyfit(timeG,hwAgrav,1);
%p2 = [-0.0003 -1.059]; %hardcoded in - all data
p2 = [-0.04497 -0.1824]; %10-30 min, R^2 = 0.1036
X2 = linspace(0,90,1e2);
Y2 = polyval(p2, X2);


%p3 = polyfit(time3,fwLgrav(~isnan(fwLgrav)),1);
%p3 = [-0.01617 -0.9242];
p3 = [-0.04277 -0.2758]; %10-30 min, R^2 = 0.3634
X3 = linspace(0,90,1e2);
Y3 = polyval(p3, X3);

%p4 = polyfit(time4,hwLgrav(~isnan(hwLgrav)),1);
%p4 = [-0.01238 -0.6323];
p4 = [-0.04168 -0.004561]; %10-30 min, R^2 = 0.1615
X4 = linspace(0,90,1e2);
Y4 = polyval(p4, X4);

%PLOT GRAV schistos - AREA
%Model-Area
set(gcf,'color','w') %change whole figure background to white
subplot(2,5,7)
h1 = scatter(timeG, fwAgrav,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X1, Y1, 'k--', 'linewidth', 4); 
%text(80, -2.5,['p = ' num2str(p1(1))] , 'FontSize', 16); 

h2 = scatter(timeG, hwAgrav,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X2, Y2, 'b--', 'linewidth', 4); 
%text(60, -1, [ 'p = ' num2str(p2(1))] , 'FontSize', 16); 
          
%Axes labels and formatting
axis([0 35 -5 0])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity Area','FontSize',20)
% ylabel('Log of 1-L(t)/Lf - Area (mm^2)','FontSize',20)
% xlabel('Time (min)','FontSize',20)


%Model - Length
subplot(2,5,2)
h1 = scatter(timeG, fwLgrav,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X3, Y3, 'k--', 'linewidth', 4); 
%text(80, -2.5,['p = ' num2str(p3(1))] , 'FontSize', 16); 
hold on
h2 = scatter(timeG, hwLgrav,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X4, Y4, 'b--', 'linewidth', 4); 
%text(60, -1, [ 'p = ' num2str(p4(1))] , 'FontSize', 16); 
          
%Axes labels and formatting
axis([0 35 -5 0])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity Length','FontSize',20)
% ylabel('Log of 1-L(t)/Lf - Length (mm)','FontSize',20)
% xlabel('Time (min)','FontSize',20)

% legend('forewing','hindwing')
% lgd = legend;
% lgd.FontSize = 16;
% lgd.Title.String = 'Wings';

%Plot Intact
timeS2 = S2.time2(18:81); %rename column
fwIntactA = S2.fwArea(18:81); %rename fw area
hwIntactA = S2.hwArea(18:81); %rename hw area

fwIntactL = S2.fwLength_mm_(18:81); %rename fw area
hwIntactL = S2.hwLength_mm_(18:81); %rename hw area
%Calculate area
fwAIn = log(1-(fwIntactA/Afinal_FW)); %rename fw area
hwAIn = log(1-(hwIntactA/Afinal_HW)); %rename hw area

%Calculate length
fwLIn = log(1-(fwIntactL/Lfinal_FW)); %rename fw length
hwLIn = log(1-(hwIntactL/Lfinal_HW)); %rename hw length

%p1 = polyfit(timeS2,fwAIn,1);
p1 = [-0.1441 1.308]; %calculated with curve fitting tool, R^2 = 0.4124
X1 = linspace(0,90,1e2);
Y1 = polyval(p1, X1);

%p2 = polyfit(timeS2,hwAIn,1);
p2 = [-0.09274 0.3108]; %calculated in Curve Fitting tool, R^2 = 0.3338
X2 = linspace(0,90,1e2);
Y2 = polyval(p2, X2);

%FW Length
%p3 = polyfit(timeS2,fwLIn,1); 
p3 = [-0.07509 0.1515]; %calculated with curve fitting tool, R^2 = 0.7018
X3 = linspace(0,90,1e2);
Y3 = polyval(p3, X3);

%HW Length
%p4 = polyfit(timeS2,hwLIn,1);
p4 = [-0.06599 0.256]; %calculated with curve fitting tool, R^2 = 0.617
X4 = linspace(0,90,1e2);
Y4 = polyval(p4, X4);

%PLOT intact schistos - AREA
%This is not subsampled, but is the entire plot
set(gcf,'color','w') %change whole figure background to white
subplot(2,5,6)
h1 = scatter(timeS2, fwAIn,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X1, Y1, 'k--', 'linewidth', 4); 
%text(20, -6,['p = ' num2str(p1(1))] , 'FontSize', 16); 

h2 = scatter(timeS2, hwAIn,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X2, Y2, 'b--', 'linewidth', 4); 
%text(20, -8, [ 'p = ' num2str(p2(1))] , 'FontSize', 16); 
          
%Axes labels and formatting
axis([0 35 -9 0])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Intact Area','FontSize',20)
ylabel('Log of 1-A(t)/Af - Area (mm^2)','FontSize',20)
xlabel('Time (min)','FontSize',20)

%This is not subsampled, but is the entire plot
subplot(2,5,1)
h1 = scatter(timeS2, fwLIn,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X3, Y3, 'k--', 'linewidth', 4); 
%text(20, -6,['p = ' num2str(p3(1))] , 'FontSize', 16); 
hold on
h2 = scatter(timeS2, hwLIn,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X4, Y4, 'b--', 'linewidth', 4); 
%text(20, -8, [ 'p = ' num2str(p4(1))] , 'FontSize', 16); 
          
%Axes labels and formatting
axis([0 35 -9 0])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Intact Length','FontSize',20)
ylabel('Log of 1-L(t)/Lf - Length (mm)','FontSize',20)
xlabel('Time (min)','FontSize',20)

%Water treatment fitting 
timewater2 = water2.time2(7:66); %rename column
fwWaterA = water2.fwArea(7:66); %rename fw area
hwWaterA = water2.hwArea(7:66); %rename hw area

fwWaterL = water2.fwLength_mm_(7:66); %rename fw area
hwWaterL = water2.hwLength_mm_(7:66); %rename hw area

%Calculate length
fwLWa = log(1-(fwWaterL/Lfinal_FW)); %rename fw length
hwLWa = log(1-(hwWaterL/Lfinal_HW)); %rename hw length

%Calculate area
fwAWa = log(1-(fwWaterA/Afinal_FW)); %rename fw area
hwAWa = log(1-(hwWaterA/Afinal_HW)); %rename hw area

%Area
%p1 = polyfit(timewater2,fwAWa,1); %
%p1 = [-0.01535 -0.6212]; %calculated with curve fitting tool
p1 = [-0.0447 -0.0313]; %10-30 min, R^2 = 0.1431
X1 = linspace(0,90,1e2);
Y1 = polyval(p1, X1);

%p2 = polyfit(timewater2,hwAWa,1);  %
%p2 = [-0.007392 -0.6308]; %calculated in Curve Fitting tool
p2 = [-0.0306 -0.2298]; %10-30 min, R^2 = 0.05549
X2 = linspace(0,90,1e2);
Y2 = polyval(p2, X2);

%FW Length
%p3 = polyfit(timewater2,fwLWa,1);  %p3 = [-0.0444 -0.3068]
%p3 = [-0.02914 -0.6595]; %calculated with curve fitting tool
p3 = [-0.0444 -0.3068]; %10-30 min, R^2 = 0.2355
X3 = linspace(0,90,1e2);
Y3 = polyval(p3, X3);

%HW Length
%p4 = polyfit(timewater2,hwLWa,1);  %p4 = [-0.0410 -0.0946]
%p4 = [-0.01159 -0.7391]; %calculated with curve fitting tool
p4 = [-0.0410 -0.0946]; %10-30 min, R^2 = 0.1586
X4 = linspace(0,90,1e2);
Y4 = polyval(p4, X4);

%PLOT water schistos - AREA
%This is not subsampled, but is the entire plot
set(gcf,'color','w') %change whole figure background to white
subplot(2,5,8)
h1 = scatter(timewater2, fwAWa,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X1, Y1, 'k--', 'linewidth', 4); 
%text(20, -6,['p = ' num2str(p1(1))] , 'FontSize', 16); 

h2 = scatter(timewater2, hwAWa,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X2, Y2, 'b--', 'linewidth', 4); 
%text(20, -8, [ 'p = ' num2str(p2(1))] , 'FontSize', 16); 
          
%Axes labels and formatting
axis([0 35 -5 0])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Water Area','FontSize',20)
%ylabel('Log of 1-L(t)/Lf - Area (mm^2)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%This is not subsampled, but is the entire plot
subplot(2,5,3)
h1 = scatter(timewater2, fwLWa,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X3, Y3, 'k--', 'linewidth', 4); 
%text(20, -6,['p = ' num2str(p3(1))] , 'FontSize', 16); 
hold on
h2 = scatter(timewater2, hwLWa,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on; plot(X4, Y4, 'b--', 'linewidth', 4); 
%text(20, -8, [ 'p = ' num2str(p4(1))] , 'FontSize', 16); 
          
%Axes labels and formatting
axis([0 35 -5 0])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Water Length','FontSize',20)
%ylabel('Log of 1-L(t)/Lf - Length (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

