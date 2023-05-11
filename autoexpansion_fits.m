%Autoexpansion fit lines

%Written by MK Salcedo Jan-April 2023

%Purpose of this code: plot intact, gravity, and water with trendlines in the 5,10,15,
% 20 min increments

%Experiment: Wings from Schistocerca americana, the American bird
%grasshopper, were removed at different points throughout wing expansion to
%investigate a phenomenon called "autonomous wing inflation" that is here
%termed as "autoexpansion." Wings were observed expanding under normal wing
%expansion (wings attached, intact to the insect) but also dissected at 5, 10, 15, and 20 min:

%Gravity treatment: dissected, glued, and hung from a glass slide
%Deionized water treatment: dissected, glued and layed on a bed of deionnized water in a petri dish 
%Buffer treatment: dissected, glued and layed on a bed of potassium phosphate buffer in a petri dish 
%Mineral oil: dissected, glued and layed on a bed of mineral oil in a petri dish 


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

%Each of these files is separated into their dissection treatment

fileParams = dir(fullfile(topLevelFolder, '*grav5.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
G5 = readtable(wingParams); %read table
G5 = sortrows(G5,5);  %sort rows by time in minutes

fileParams = dir(fullfile(topLevelFolder, '*grav10.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
G10 = readtable(wingParams); %read table
G10 = sortrows(G10,5);  %sort rows by time in minutes

fileParams = dir(fullfile(topLevelFolder, '*grav15.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
G15 = readtable(wingParams); %read table
G15 = sortrows(G15,5);  %sort rows by time in minutes

fileParams = dir(fullfile(topLevelFolder, '*grav20.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
G20 = readtable(wingParams); %read table
G20 = sortrows(G20,5);  %sort rows by time in minutes

fileParams = dir(fullfile(topLevelFolder, '*water5.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
W5 = readtable(wingParams); %read table
W5 = sortrows(W5,7);  %sort rows by time in minutes

fileParams = dir(fullfile(topLevelFolder, '*water10.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
W10 = readtable(wingParams); %read table
W10 = sortrows(W10,7);  %sort rows by time in minutes

fileParams = dir(fullfile(topLevelFolder, '*water15.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
W15 = readtable(wingParams); %read table
W15 = sortrows(W15,7);  %sort rows by time in minutes

fileParams = dir(fullfile(topLevelFolder, '*water20.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
W20 = readtable(wingParams); %read table
W20 = sortrows(W20,7);  %sort rows by time in minutes

%Intact (no treatment)
fileParams6 = dir(fullfile(topLevelFolder, '*intact_schisto.csv')); %get file of mineral oil trial wing lengths
wingParams6 = fullfile(topLevelFolder,fileParams6.name); %set pathway to name
schisto = readtable(wingParams6); %read table of gravity trial wing lengths
S2 = sortrows(schisto,4);  %sort rows by time2

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

%% Calculate average fore-/hindwing lengths using table S2, rows 93-109 (40 min-62) min 

Lfinal_FW = mean(S2.fwLength_mm_(93:109),'omitnan'); %length
Lfinal_HW = mean(S2.hwLength_mm_(93:109),'omitnan');

Afinal_FW = mean(S2.fwArea(93:109),'omitnan'); %area
Afinal_HW = mean(S2.hwArea(93:109),'omitnan');

%% Trendlines over each time point - LENGTH (next plot below is area)

close all

%intact_schisto_v2.csv info. This insect was just observed, no treatments or cutting
timeSV2 = S2.time2; %rename column
fwLS = S2.fwLength_mm_; %rename fw length
hwLS = S2.hwLength_mm_; %rename hw length

X1 = timeSV2;
X2 = timeSV2;
Y1 = fwLS;
Y2 = hwLS;


%PLOT intact schistos - don't have area
figure
subplot(2,5,1)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(timeSV2, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(timeSV2, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Intact ','FontSize',20)
ylabel('Wing Length','FontSize',20)
xlabel('Time (min)','FontSize',20)


%Plot gravity
k = 25; %smoothing factor
time = G5.timeInMin + 5; %this column sorts by time
fwLS = G5.fwLength_mm_; %rename fw length
hwLS = G5.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,2)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Gravity at 10 min
time = G10.timeInMin + 10; %this column sorts by time
fwLS = G10.fwLength_mm_; %rename fw length
hwLS = G10.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,3)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

%Gravity at 15 min
time = G15.timeInMin + 15; %this column sorts by time
fwLS = G15.fwLength_mm_; %rename fw length
hwLS = G15.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,4)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

%Gravity at 20 min
k = 20;
time = G20.timeInMin + 20; %this column sorts by time
fwLS = G20.fwLength_mm_; %rename fw length
hwLS = G20.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,5)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

%Plot water
k = 25; %smoothing factor
time = W5.timeInMin; %this column sorts by time
fwLS = W5.fwLength_mm_; %rename fw length
hwLS = W5.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,7)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('WATER at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Water at 10 min
time = W10.timeInMin; %this column sorts by time
fwLS = W10.fwLength_mm_; %rename fw length
hwLS = W10.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,8)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('WATER at 10 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Water at 15 min
time = W15.timeInMin; %this column sorts by time
fwLS = W15.fwLength_mm_; %rename fw length
hwLS = W15.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,9)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('WATER at 15 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Water at 20 min
time = W20.timeInMin; %this column sorts by time
fwLS = W20.fwLength_mm_; %rename fw length
hwLS = W20.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,10)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('WATER at 20 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

%% Trendlines over each time point - AREA

close all

%intact_schisto_v2.csv info. This insect was just observed, no treatments or cutting
timeSV2 = S2.time2; %rename column
fwLS = S2.fwArea; %rename fw length
hwLS = S2.hwArea; %rename hw length

X1 = timeSV2;
X2 = timeSV2;
Y1 = fwLS;
Y2 = hwLS;


%PLOT intact schistos - don't have area
figure
subplot(2,5,1)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(timeSV2, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(timeSV2, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Intact ','FontSize',20)
ylabel('Wing Area','FontSize',20)
xlabel('Time (min)','FontSize',20)


%Plot gravity
k = 25; %smoothing factor
time = G5.timeInMin + 5; %this column sorts by time
fwLS = G5.fwArea; %rename fw length
hwLS = G5.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,2)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Gravity at 10 min
time = G10.timeInMin + 10; %this column sorts by time
fwLS = G10.fwArea; %rename fw length
hwLS = G10.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,3)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

%Gravity at 15 min
time = G15.timeInMin + 15; %this column sorts by time
fwLS = G15.fwArea; %rename fw length
hwLS = G15.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,4)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

%Gravity at 20 min
k = 20;
time = G20.timeInMin + 20; %this column sorts by time
fwLS = G20.fwArea; %rename fw length
hwLS = G20.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,5)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

%Plot water
k = 25; %smoothing factor
time = W5.timeInMin; %this column sorts by time
fwLS = W5.fwArea; %rename fw length
hwLS = W5.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,7)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('WATER at 5 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Water at 10 min
time = W10.timeInMin; %this column sorts by time
fwLS = W10.fwArea; %rename fw length
hwLS = W10.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,8)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('WATER at 10 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Water at 15 min
time = W15.timeInMin; %this column sorts by time
fwLS = W15.fwArea; %rename fw length
hwLS = W15.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,9)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('WATER at 15 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Water at 20 min
time = W20.timeInMin; %this column sorts by time
fwLS = W20.fwArea; %rename fw length
hwLS = W20.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(2,5,10)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan'); %forewing
plot(time, M1,'-','Color',pink,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan'); %hindwing
plot(time, M2,'-','Color',purple,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('WATER at 20 min ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%% Percent expansion

%Intact values for final wing length and area
Lfinal_FW = mean(S2.fwLength_mm_(80:109),'omitnan'); %length
Lfinal_HW = mean(S2.hwLength_mm_(80:109),'omitnan');

Afinal_FW = mean(S2.fwArea(84:109),'omitnan'); %area
Afinal_HW = mean(S2.hwArea(84:93),'omitnan'); %hindwing folds

%intact percent expansion of starting length to ending length
startInFWL = mean(S2.fwLength_mm_(1:15),'omitnan');
startInHWL = mean(S2.hwLength_mm_(1:15),'omitnan');

fwInL = ((Lfinal_FW - startInFWL)/startInFWL)*100 %fw percent exp
hwInL = ((Lfinal_HW - startInHWL)/startInHWL)*100 %hw

startInFWA = mean(S2.fwArea(1:15),'omitnan');
startInHWA = mean(S2.hwArea(1:15),'omitnan');

fwInA = ((Afinal_FW - startInFWA)/startInFWA)*100 %fw percent exp
hwInA = ((Afinal_HW - startInHWA)/startInHWA)*100 %hw

%% Intact 5 min
% I used this code to just adjust the numbers in the length and area in
% each of the 5 min intervals
clc;

%intact percent expansion of starting length to ending length
startInFWL = mean(S2.fwLength_mm_(51:67),'omitnan');
startInHWL = mean(S2.hwLength_mm_(51:67),'omitnan');

fwInL = ((Lfinal_FW - startInFWL)/startInFWL)*100 %fw percent exp
hwInL = ((Lfinal_HW - startInHWL)/startInHWL)*100 %hw

startInFWA = mean(S2.fwArea(51:67),'omitnan');
startInHWA = mean(S2.hwArea(51:67),'omitnan');

fwInA = ((Afinal_FW - startInFWA)/startInFWA)*100 %fw percent exp
hwInA = ((Afinal_HW - startInHWA)/startInHWA)*100 %hw



%% gravity percent expansion for length - 5 min

clc;

startFWL = mean(G5.fwLength_mm_(1:13),'omitnan');
startHWL = mean(G5.hwLength_mm_(1:13),'omitnan');

finalFWL = mean(G5.fwLength_mm_(53:81),'omitnan');
finalHWL = mean(G5.hwLength_mm_(53:81),'omitnan');

fwGL = ((finalFWL - startFWL)/startFWL)*100 %fw percent exp
hwGL = ((finalHWL - startHWL)/startHWL)*100 %hw

startFWA = mean(G5.fwArea(1:13),'omitnan');
startHWA = mean(G5.hwArea(1:13),'omitnan');

finalFWA = mean(G5.fwArea(48:56),'omitnan');
finalHWA = mean(G5.hwArea(48:56),'omitnan');

fwGA = ((finalFWA- startFWA)/startFWA)*100 %fw percent exp
hwGA = ((finalHWA - startHWA)/startHWA)*100 %hw

%% gravity percent expansion for length - 10 min

clc;

startFWL = mean(G10.fwLength_mm_(1:6),'omitnan');
startHWL = mean(G10.hwLength_mm_(1:6),'omitnan');

finalFWL = mean(G10.fwLength_mm_(31:50),'omitnan');
finalHWL = mean(G10.hwLength_mm_(31:50),'omitnan');

fwGL = ((finalFWL - startFWL)/startFWL)*100 %fw percent exp
hwGL = ((finalHWL - startHWL)/startHWL)*100 %hw

startFWA = mean(G10.fwArea(1:6),'omitnan');
startHWA = mean(G10.hwArea(1:6),'omitnan');

finalFWA = mean(G10.fwArea(24:30),'omitnan');
finalHWA = mean(G10.hwArea(24:30),'omitnan');

fwGA = ((finalFWA- startFWA)/startFWA)*100 %fw percent exp
hwGA = ((finalHWA - startHWA)/startHWA)*100 %hw

%% gravity percent 15 min

clc;

startFWL = mean(G15.fwLength_mm_(1:6),'omitnan');
startHWL = mean(G15.hwLength_mm_(1:6),'omitnan');

finalFWL = mean(G15.fwLength_mm_(18:24),'omitnan');
finalHWL = mean(G15.hwLength_mm_(18:24),'omitnan');

fwGL = ((finalFWL - startFWL)/startFWL)*100 %fw percent exp
hwGL = ((finalHWL - startHWL)/startHWL)*100 %hw

startFWA = mean(G15.fwArea(1:6),'omitnan');
startHWA = mean(G15.hwArea(1:6),'omitnan');

finalFWA = mean(G15.fwArea(18:24),'omitnan');
finalHWA = mean(G15.hwArea(18:24),'omitnan');

fwGA = ((finalFWA- startFWA)/startFWA)*100 %fw percent exp
hwGA = ((finalHWA - startHWA)/startHWA)*100 %hw

%% gravity percent 20 min

clc;

startFWL = mean(G20.fwLength_mm_(1:5),'omitnan');
startHWL = mean(G20.hwLength_mm_(1:5),'omitnan');

finalFWL = mean(G20.fwLength_mm_(12:15),'omitnan');
finalHWL = mean(G20.hwLength_mm_(12:15),'omitnan');

fwGL = ((finalFWL - startFWL)/startFWL)*100 %fw percent exp
hwGL = ((finalHWL - startHWL)/startHWL)*100 %hw

startFWA = mean(G20.fwArea(1:5),'omitnan');
startHWA = mean(G20.hwArea(1:5),'omitnan');

finalFWA = mean(G20.fwArea(12:15),'omitnan');
finalHWA = mean(G20.hwArea(12:15),'omitnan');

fwGA = ((finalFWA- startFWA)/startFWA)*100 %fw percent exp
hwGA = ((finalHWA - startHWA)/startHWA)*100 %hw


%% water percent expansion for length - 5 min

clc;

startFWL = mean(W5.fwLength_mm_(1:6),'omitnan');
startHWL = mean(W5.hwLength_mm_(1:6),'omitnan');

finalFWL = mean(W5.fwLength_mm_(29:45),'omitnan');
finalHWL = mean(W5.hwLength_mm_(29:45),'omitnan');

fwGL = ((finalFWL - startFWL)/startFWL)*100 %fw percent exp
hwGL = ((finalHWL - startHWL)/startHWL)*100 %hw

startFWA = mean(W5.fwArea(1:6),'omitnan');
startHWA = mean(W5.hwArea(1:6),'omitnan');

finalFWA = mean(W5.fwArea(24:30),'omitnan');
finalHWA = mean(W5.hwArea(24:30),'omitnan');

fwGA = ((finalFWA- startFWA)/startFWA)*100 %fw percent exp
hwGA = ((finalHWA - startHWA)/startHWA)*100 %hw

%% water percent expansion for length - 10 min

clc;

startFWL = mean(W10.fwLength_mm_(1:6),'omitnan');
startHWL = mean(W10.hwLength_mm_(1:6),'omitnan');

finalFWL = mean(W10.fwLength_mm_(24:34),'omitnan');
finalHWL = mean(W10.hwLength_mm_(24:34),'omitnan');

fwGL = ((finalFWL - startFWL)/startFWL)*100 %fw percent exp
hwGL = ((finalHWL - startHWL)/startHWL)*100 %hw

startFWA = mean(W10.fwArea(1:6),'omitnan');
startHWA = mean(W10.hwArea(1:6),'omitnan');

finalFWA = mean(W10.fwArea(10:18),'omitnan');
finalHWA = mean(W10.hwArea(10:18),'omitnan');

fwGA = ((finalFWA- startFWA)/startFWA)*100 %fw percent exp
hwGA = ((finalHWA - startHWA)/startHWA)*100 %hw

%% water percent expansion for length - 15 min

clc;

startFWL = mean(W15.fwLength_mm_(1:5),'omitnan');
startHWL = mean(W15.hwLength_mm_(1:5),'omitnan');

finalFWL = mean(W15.fwLength_mm_(21:32),'omitnan');
finalHWL = mean(W15.hwLength_mm_(21:32),'omitnan');

fwGL = ((finalFWL - startFWL)/startFWL)*100 %fw percent exp
hwGL = ((finalHWL - startHWL)/startHWL)*100 %hw

startFWA = mean(W15.fwArea(1:5),'omitnan');
startHWA = mean(W15.hwArea(1:5),'omitnan');

finalFWA = mean(W15.fwArea(6:10),'omitnan');
finalHWA = mean(W15.hwArea(6:10),'omitnan');

fwGA = ((finalFWA- startFWA)/startFWA)*100 %fw percent exp
hwGA = ((finalHWA - startHWA)/startHWA)*100 %hw

%% water percent expansion for length - 20 min

clc;

startFWL = mean(W20.fwLength_mm_(1:6),'omitnan');
startHWL = mean(W20.hwLength_mm_(1:6),'omitnan');

finalFWL = mean(W20.fwLength_mm_(19:25),'omitnan');
finalHWL = mean(W20.hwLength_mm_(19:25),'omitnan');

fwGL = ((finalFWL - startFWL)/startFWL)*100 %fw percent exp
hwGL = ((finalHWL - startHWL)/startHWL)*100 %hw

startFWA = mean(W20.fwArea(1:6),'omitnan');
startHWA = mean(W20.hwArea(1:6),'omitnan');

finalFWA = mean(W20.fwArea(4:9),'omitnan');
finalHWA = mean(W20.hwArea(4:9),'omitnan');

fwGA = ((finalFWA- startFWA)/startFWA)*100 %fw percent exp
hwGA = ((finalHWA - startHWA)/startHWA)*100 %hw

