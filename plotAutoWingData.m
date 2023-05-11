%Plot AutoExpansion Data

%Written by MK Salcedo Jan-Mar 2023

%Purpose of this code is to replot data from 2017-2018 as a part of Mary's
%thesis.

%Experiment: Wings from Schistocerca americana, the American bird
%grasshopper, were removed at different points throughout wing expansion to
%investigate a phenomenon called "autonomous wing inflation" that is here
%termed as "autoexpansion." Wings were observed expanding under normal wing
%expansion (wings attached, intact to the insect) but also dissected at 5, 10, 15, and 20 min:

%Gravity treatment: dissected, glued, and hung from a glass slide
%Deionized water treatment: dissected, glued and layed on a bed of deionnized water in a petri dish 
%Buffer treatment: dissected, glued and layed on a bed of potassium phosphate buffer in a petri dish 
%Mineral oil: dissected, glued and layed on a bed of mineral oil in a petri dish 


%Notes on wing treatments:

%autowingweights.csv
%Columns of data go as follows: 1-[Insect ID] 2-[time] 3-[treatment ID (buff, NaN, di, mo)]	
%	4-[Sex (m/f)] 5-[Whole weight] 6-[LFW (g)]	7-[LHW (g)]	8-[RFW (g)] 9-[RHW (g)]

%all other treatments have labeled columsn and are read in as tables.

%This code is for plotting!

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
%% SECOND RUN THIS TO Set up naming of folders
%Columns are read in normally and then also sorted by time for the large
%scatter plots that occur towards the back of this code 

%Wing mass (dissection treatment)
fileParams = dir(fullfile(topLevelFolder, '*wingweights.csv')); %get file of weight values
wingParams = fullfile(topLevelFolder,fileParams.name); %set pathway to name
%Only sort wing weights
C = readtable(wingParams); %read table
D = sortrows(C,2);   %sort entire table by  time - col2

%Gravity treatment
fileParams2 = dir(fullfile(topLevelFolder, '*grav_length.csv')); %get file of grav trial wing lengths
wingParams2 = fullfile(topLevelFolder,fileParams2.name); %set pathway to name
gL = readtable(wingParams2); %read table of gravity trial wing lengths
gL2 = sortrows(gL,4); %sort rows by time2

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

%% Establish wing mass variables
%Columns of data go as follows: 1-[Insect ID] 2-[time] 3-[treatment ID (buff, NaN, di, mo)]	
%	4-[Sex (m/f)] 5-[Whole weight] 6-[LFW (g)]	7-[LHW (g)]	8-[RFW (g)] 9-[RHW (g)]

time = D.time;  %time variables apply to both wing_metrics/wing_lengths

wholeWeight = D.body_weight_mg; %even tho it has an _mg label, it was measured in grams

%Left and right wings - weight
LFW = D.LFW_mg; LHW = D.LHW_mg;
RFW = D.RFW_mg; RHW = D.RHW_mg;

%from spreadsheet schistocerca adult wing lengths.csv
%these are hard-coded in from 6 different adults, 3 M, 3F

%average forewing length - might not be used
mFW = 43.1; %mm
fFW = 47.7; %mm;

%average hindwing length - might not be used
mHW = 39.3; %mm
fHW = 44.8; %mm

%Calculate average fore-/hindwing lengths using table S2, rows 93-109 (40 min-62) min 
Lfinal_FW = mean(S2.fwLength_mm_(93:109),'omitnan');
Lfinal_HW = mean(S2.hwLength_mm_(93:109),'omitnan');

Afinal_FW = mean(S2.fwArea(93:109),'omitnan');
Afinal_HW = mean(S2.hwArea(93:109),'omitnan');

%% WHOLE WEIGHT PLOT
%This plot shows the whole weight (entire mass) of the hopper before
%dissection

close all

set(gcf,'color','w') %change whole figure background to white
scatter(time, wholeWeight, 200,'filled', 'MarkerEdgeColor',[0.5 .5 .5],...
              'MarkerFaceColor',[0.9290 0.6940 0.1250],...
              'LineWidth',1.5')
          
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Whole body weight during wing autoexpansion','FontSize',20)
xlabel('Time (min) weighed from "wings-out" phase','FontSize',20)
ylabel('Whole body weight (g)','FontSize',20)
axis([0 30 0 1.4])

%% LEFT AND RIGHT WINGS
%This plots wing massses of Left and Right wings, separating forewing and
%hindwings

close all

%LEFT WING WEIGHTS
subplot(1,2,1)
set(gcf,'color','w') %change whole figure background to white
scatter(time, LFW, 150,'filled', 'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.9375 0.3438 0.2891],...
              'MarkerFaceAlpha',alpha,'LineWidth',0.5');
hold on
scatter(time, LHW, 150,'filled', 'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.9805 0.6719 0.5352],...
              'MarkerFaceAlpha',alpha,'LineWidth',0.5')    
axis([0 30 0 0.09])

ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Left','FontSize',20)
xlabel('Time (min)','FontSize',20)
ylabel('Left wing mass (g)','FontSize',20)

%RIGHT WING WEIGHTS
subplot(1,2,2)
set(gcf,'color','w') %change whole figure background to white
scatter(time, RFW, 150,'filled', 'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.1680 0.3438 0.4648],...
              'MarkerFaceAlpha',alpha,'LineWidth',0.5')
hold on
scatter(time, RHW, 150,'filled', 'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.1211 0.7773 0.7148],...
              'MarkerFaceAlpha',alpha,'LineWidth',0.5')
axis([0 30 0 0.09])

ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Right','FontSize',20)
xlabel('Time (min)','FontSize',20)
ylabel('Right wing mass (g)','FontSize',20)

%% PLOT WEIGHT AND SEX
%Run this code to plot whole body weight and wing weight by sex

sex = D.sex;
time = D.time;
body_weight = D.body_weight_mg;

Sex = categorical(sex); %create category
summary(Sex); %gives number of f/m

%Using this plotting framework -- replot using mulitple metrics
X1 = time(Sex == 'F');
Y1 = body_weight(Sex == 'F');

X2 = time(Sex == 'M');
Y2 = body_weight(Sex == 'M');

%PLOT:
figure
subplot(1,2,1)
circleSize = 250;
set(gcf,'color','w') %change whole figure background to white
%Sex category - female - is yellow
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',yellow,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
%Sex category - male - is gray
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha2,'LineWidth',circleLine);

%Axes labels and formatting
axis([0 20 0 1.4])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
%title('Whole body mass versus time','FontSize',20)
ylabel('Body mass  (g)','FontSize',20)
xlabel('Time (min)','FontSize',20)

legend('female','male')
lgd = legend;
lgd.FontSize = 16;
lgd.Title.String = 'Sex';

%Using this plotting framework -- replot using mulitple metrics
LFW = D.LFW_mg;
LHW = D.LHW_mg;

X1 = time(Sex == 'F');
Y1 = LFW(Sex == 'F');

X2 = time(Sex == 'M');
Y2 = LHW(Sex == 'M');

%PLOT:
subplot(1,2,2)
set(gcf,'color','w') %change whole figure background to white
%Sex category - female - is yellow
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',yellow,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
%Sex category - male - is gray
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha2,'LineWidth',circleLine);
hold on
RFW = D.RFW_mg;
RHW = D.RHW_mg;

X1 = time(Sex == 'F');
Y1 = RFW(Sex == 'F');

X2 = time(Sex == 'M');
Y2 = RHW(Sex == 'M');

h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',yellow,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
%Sex category - male - is gray
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha2,'LineWidth',circleLine);
         
%Axes labels and formatting
axis([0 20 0 0.08])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
%title('FW/HW at 5 min','FontSize',20)
ylabel('Wing mass (g)','FontSize',20)
xlabel('Time (min)','FontSize',20)


legend('female','male')
lgd = legend;
lgd.FontSize = 16;
lgd.Title.String = 'Sex';


%% BOXPLOTS OF Wing Weights at different time samples
%This plots wing mass of Left and Right and fore/hind wings at 
%5 min, 10 min, 15 min, and 20 min dissection times

close all
figure
subplot(1,4,1)
set(gcf,'color','w') %change whole figure background to white

labels = {'LFW','LHW','RFW','RHW'}; %labels for box plots

%5 min sampling
%Use of CategoricalScatter to plot the columns of my data
CategoricalScatterplot([LFW(1:10),LHW(1:10),RFW(1:10),RHW(1:10)],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
xlabel('Wing mass at 5 min post-extraction','FontSize',20)
axis([0 5 0 0.1])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

subplot(1,4,2)
labels = {'LFW','LHW','RFW','RHW'}; %labels for box plots

%10 min sampling
CategoricalScatterplot([LFW(11:18),LHW(11:18),RFW(11:18),RHW(11:18)],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 5 0 0.1])

subplot(1,4,3)
labels = {'LFW','LHW','RFW','RHW'}; %labels for box plots

%15 min sampling
CategoricalScatterplot([LFW(19:27),LHW(19:27),RFW(19:27),RHW(19:27)],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 5 0 0.1])


subplot(1,4,4)
labels = {'LFW','LHW','RFW','RHW'}; %labels for box plots

%20 min sampling
CategoricalScatterplot([LFW(28:30),LHW(28:30),RFW(28:30),RHW(28:30)],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 5 0 0.1])

%% wing mass
% BUFFER/DIWATER/MO/GRAVITY TRIALS
figure
set(gcf,'color','w') %change whole figure background to white

subplot(2,4,1)
set(gcf,'color','w') %change whole figure background to white

labels = {'5','f'}; %labels for box plots

FW = [LFW(1:10);RFW(1:10)];
FW2 = [LFW(11:18);RFW(11:18)];
FW3 = [LFW(19:27);RFW(19:27)];
FW4 = [LFW(28:30);RFW(28:30)];

%5 min sampling
%Use of CategoricalScatter to plot the columns of my data
CategoricalScatterplot([FW,FW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0.01 0.095])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('5 min', 'FontSize',20)

%10 min sampling
%Use of CategoricalScatter to plot the columns of my data
subplot(2,4,2)
labels = {'10','f'}; %labels for box plots
CategoricalScatterplot([FW2,FW2],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0.01 0.095])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('10 min', 'FontSize',20)

%15 min sampling
%Use of CategoricalScatter to plot the columns of my data
subplot(2,4,3)
labels = {'15','f'}; %labels for box plots
CategoricalScatterplot([FW3,FW3],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0.01 0.095])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('15 min', 'FontSize',20)

%20 min sampling
%Use of CategoricalScatter to plot the columns of my data
subplot(2,4,4)
labels = {'20','f'}; %labels for box plots
CategoricalScatterplot([FW4,FW4],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0.01 0.095])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('20 min', 'FontSize',20)

subplot(2,4,5)
HW = [LHW(1:10);RHW(1:10)];

%5 min sampling
%Use of CategoricalScatter to plot the columns of my data
labels = {'5','h'}; %labels for box plots
CategoricalScatterplot([HW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0.01 0.095])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('5 min', 'FontSize',20)

subplot(2,4,6)
HW2 = [LHW(11:18);RHW(11:18)];
%10 min sampling
%Use of CategoricalScatter to plot the columns of my data
labels = {'10','h'}; %labels for box plots
CategoricalScatterplot([HW2,HW2],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0.01 0.095])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('10 min', 'FontSize',20)

subplot(2,4,7)
HW3 = [LHW(19:27);RHW(19:27)];
%15 min sampling
%Use of CategoricalScatter to plot the columns of my data
labels = {'15','H'}; %labels for box plots
CategoricalScatterplot([HW3,HW3],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0.01 0.095])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('15 min', 'FontSize',20)

subplot(2,4,8)
HW4 = [LHW(28:30);RHW(28:30)];
%20 min sampling
%Use of CategoricalScatter to plot the columns of my data
labels = {'20','H'}; %labels for box plots
CategoricalScatterplot([HW4,HW4],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0.01 0.095])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('20 min', 'FontSize',20)


%% Plot all length treatments with mass
% This plot shows mass treatments at the top follows by Buffer, DI Water,
% Gravity, and then Mineral Oil. It plots it in columns which reflect the
% time at which the wing was dissected. The first column is 5 min, then 10
% min, 15 min, and 20 min.

% The rows reflect the entire treatment. The whole top row is mass, the
% whole second row is buffer.

% The last two plots in red/pink are not related to mineral oil they are
% the intact case plotted in two ways, in lines and in scatter plot

% BUFFER/DIWATER/MO/GRAVITY TRIALS
figure
set(gcf,'color','w') %change whole figure background to white

subplot(5,4,1)
set(gcf,'color','w') %change whole figure background to white

labels = {'FW','HW'}; %labels for box plots

FW = [LFW(1:10);RFW(1:10)];
HW = [LHW(1:10);RHW(1:10)];
%5 min sampling
%Use of CategoricalScatter to plot the columns of my data
CategoricalScatterplot([FW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0 0.1])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('5 min', 'FontSize',20)

subplot(5,4,2)
FW = [LFW(11:18);RFW(11:18)];
HW = [LHW(11:18);RHW(11:18)];

%10 min sampling
CategoricalScatterplot([FW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 3 0 0.1])
xlabel('10 min','FontSize',20)

subplot(5,4,3)
FW = [LFW(19:27);RFW(19:27)];
HW = [LHW(19:27);RHW(19:27)];

%15 min sampling
CategoricalScatterplot([FW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 3 0 0.1])
xlabel('15 min','FontSize',20)

subplot(5,4,4)
FW = [LFW(28:30);RFW(28:30)];
HW = [LHW(28:30);RHW(28:30)];

%20 min sampling
CategoricalScatterplot([FW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 3 0 0.1])
xlabel('20 min','FontSize',20)

%schisto.csv info. This insect was just observed, no treatments or cutting
timeS = schisto.time_min_; %rename column
fwLS = schisto.fwLength_mm_; %rename fw length
hwLS = schisto.hwLength_mm_; %rename hw length


% Plot BUFFER lengths
%In the buffer.csv, col6: time elapsed during experiment in minutes

[m,n] = size(buff); %get size for looping through all rows

%Establish variables
time = buff.time_min_; %rename column
frame = buff.frame; %number of frames
dtime = buff.dissection_time; %when the wings were removed
fwL = buff.fwLength_mm_; %rename fw length
hwL = buff.hwLength_mm_; %rename hw length


indx = find(frame == 1); %find when the time equals one, this is how we pick out trials

for i = 1:length(indx)
    
    if indx(i) < 77
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,13)
            x = time(first:last)+5;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on
            xlabel('Buffer 5 min', 'FontSize',20)
            
        elseif dtime(indx(i)) == 10
            subplot(5,4,14)
            x = time(first:last)+10;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)           
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        elseif dtime(indx(i)) == 15
            subplot(5,4,15)
            x = time(first:last)+15;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        elseif dtime(indx(i)) == 20
            subplot(5,4,16)
            x = time(first:last)+20;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 5 min treatment
        subplot(5,4,13)
        x = time(first:last)+15;
        y = fwL(first:last);
        y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on

    end

    hold on
end

hold on
% Plot DI WATER lengths
%In the di_h2o.csv, col6: time elapsed during experiment in minutes

[m,n] = size(water); %get size for looping through all rows

%Establish variables
time = water.time_min_; %rename column
frame = water.frame; %number of frames
dtime = water.dissection_time; %when the wings were removed
fwL = water.fwLength_mm_; %rename fw length
hwL = water.hwLength_mm_; %rename hw length


indx = find(frame == 1); %find when the time equals one, this is how we pick out trials

for i = 1:length(indx)
    
    if indx(i) < 128 %last trial of the file
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,9)
            x = time(first:last)+5;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on
            xlabel('DI Water 5 min', 'FontSize',20)
            
        elseif dtime(indx(i)) == 10
            subplot(5,4,10)
            x = time(first:last)+10;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        elseif dtime(indx(i)) == 15
            subplot(5,4,11)
            x = time(first:last)+15;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        elseif dtime(indx(i)) == 20
            subplot(5,4,12)
            x = time(first:last)+20;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 5 min treatment
        subplot(5,4,9)
        x = time(first:last)+5;
        y = fwL(first:last);
        y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on

    end

    hold on
end

% Plot MINERAL OIL lengths
%In the mo.csv, col6: time elapsed during experiment in minutes

[m,n] = size(mo); %get size for looping through all rows

%Establish variables
time = mo.time_min_; %rename column
frame = mo.frame; %number of frames
dtime = mo.dissection_time; %when the wings were removed
fwL = mo.fwLength_mm_; %rename fw length
hwL = mo.hwLength_mm_; %rename hw length


indx = find(frame == 1); %find when the time equals one, this is how we pick out trials

for i = 1:length(indx)
    
    if indx(i) < 40 %last entry
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,17)
            x = time(first:last)+5;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on
            xlabel('Mineral Oil 5 min', 'FontSize',20)
            
        elseif dtime(indx(i)) == 10
            subplot(5,4,18)
            x = time(first:last)+10;
            y = fwL(first:last);
            y2 = hwL(first:last);   
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)          
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        elseif dtime(indx(i)) == 15
            subplot(5,4,19)
            x = time(first:last)+15;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        elseif dtime(indx(i)) == 20
            subplot(5,4,20)
            x = time(first:last)+20;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on
        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 5 min treatment
        subplot(5,4,18)
        x = time(first:last)+10;
        y = fwL(first:last);
        y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on
        
    end

    hold on
end

% Plot gravity length
%In the grav_length.csv, col3: time elapsed during experiment in minutes

[m,n] = size(gL); %get size for looping through all rows

%Establish variables
time = gL.time_min_; %rename column
dtime = gL.dissection_time; %when the wings were removed
fwL = gL.fwLength_mm_; %rename fw length
hwL = gL.hwLength_mm_; %rename hw length


indx = find(time == 0); %find when the time equals zero

for i = 1:length(indx)
    
    if indx(i) < 184 %this is the last zero
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,5)
            x = time(first:last)+5;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on
            xlabel('Gravity 5 min', 'FontSize',20)
            
        elseif dtime(indx(i)) == 10
            subplot(5,4,6)
            x = time(first:last)+10;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        elseif dtime(indx(i)) == 15
            subplot(5,4,7)
            x = time(first:last)+15;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        elseif dtime(indx(i)) == 20
            subplot(5,4,8)
            x = time(first:last)+20;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on

        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 5 min treatment
        subplot(5,4,5)
        x = time(first:last)+5;
        y = fwL(first:last);
        y2 = hwL(first:last);
        plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
        plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on
    end

    hold on
end


%PLOT INTACT SCHISTOS: in the leftover mineral oil plots
indx = find(timeS == 0); %find when the time equals zero, this is how we pick out trials

%schisto.csv info. This insect was just observed, no treatments or cutting
timeS = schisto.time_min_; %rename column
fwLS = schisto.fwLength_mm_; %rename fw length
hwLS = schisto.hwLength_mm_; %rename hw length
dtime = schisto.timeOfMeasurement_min_;
circleSize = 50;
for i = 1:9
    
    if indx(i) < 71 %last zero
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,19)
            x = timeS(first:last)+5;
            y = fwLS(first:last);
            y2 = hwLS(first:last);
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            xlabel('Intact case', 'FontSize',20)
            hold on
            subplot(5,4,20)
            h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
            hold on
            h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
             xlabel('Intact case', 'FontSize',20)

            
        elseif dtime(indx(i)) == 10
            subplot(5,4,19)
            x = timeS(first:last)+10;
            y = fwLS(first:last);
            y2 = hwLS(first:last);
     
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)          
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
           axis([0 75 0 50])
            hold on
            subplot(5,4,20)
            h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
            hold on
            h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);

        elseif dtime(indx(i)) == 15
            subplot(5,4,19)
            x = timeS(first:last)+15;
            y = fwLS(first:last);
            y2 = hwLS(first:last);
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on
            subplot(5,4,20)
            h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
            hold on
            h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);

        elseif dtime(indx(i)) == 20
            subplot(5,4,19)
            x = timeS(first:last)+20;
            y = fwLS(first:last);
            y2 = hwLS(first:last);
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 75 0 50])
            hold on
            subplot(5,4,20)
            h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
            hold on
            h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 5 min treatment
        subplot(5,4,19)
            x = timeS(first:last);
            y = fwLS(first:last);
            y2 = hwLS(first:last);
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on
        subplot(5,4,20)
        h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
          'MarkerFaceColor',pink,...
          'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
        hold on
        h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
          'MarkerFaceColor',red,...
          'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
    end
    ax = gca; ax.FontSize = 14; %change axes numbers to larger font
    axis([0 75 0 50])
    hold on
end

%% Plot all AREA treatments with mass
% This plot shows mass treatments at the top follows by Buffer, DI Water,
% Gravity, and then Mineral Oil. It plots it in columns which reflect the
% time at which the wing was dissected. The first column is 5 min, then 10
% min, 15 min, and 20 min.

% The rows reflect the entire treatment. The whole top row is mass, the
% whole second row is buffer.

% The last two plots in red/pink are not related to mineral oil they are
% the intact case plotted in two ways, in lines and in scatter plot

% BUFFER/DIWATER/MO/GRAVITY TRIALS
figure
set(gcf,'color','w') %change whole figure background to white

subplot(5,4,1)

%Plot wing weights
labels = {'FW','HW'}; %labels for box plots

FW = [LFW(1:10);RFW(1:10)];
HW = [LHW(1:10);RHW(1:10)];
%5 min sampling
CategoricalScatterplot([FW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)

%Appropriate labels
ylabel('Weight','FontSize',20)
axis([0 3 0 0.1])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font

xlabel('5 min', 'FontSize',20)

subplot(5,4,2)
FW = [LFW(11:18);RFW(11:18)];
HW = [LHW(11:18);RHW(11:18)];

%10 min sampling
CategoricalScatterplot([FW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 3 0 0.1])
xlabel('10 min','FontSize',20)

subplot(5,4,3)
FW = [LFW(19:27);RFW(19:27)];
HW = [LHW(19:27);RHW(19:27)];

%15 min sampling
CategoricalScatterplot([FW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 3 0 0.1])
xlabel('15 min','FontSize',20)

subplot(5,4,4)
FW = [LFW(28:30);RFW(28:30)];
HW = [LHW(28:30);RHW(28:30)];

%20 min sampling
CategoricalScatterplot([FW,HW],...
    'MedianLineWidth', 6, 'MarkerSize',50, 'WhiskerLineWidth', 4,...
    'WhiskerColor', [0.3438 0.3477 0.3477],'MedianColor',[0.4492 0.0469 0.0078],...
    'BoxColor',[0.6523 0.6602 0.6719],'BoxAlpha',1,'Labels',labels)
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
axis([0 3 0 0.1])
xlabel('20 min','FontSize',20)

%schisto.csv info. This insect was just observed, no treatments or cutting
timeS = schisto.time_min_; %rename column
fwLS = schisto.fwArea; %rename fw area
hwLS = schisto.hwArea; %rename hw area


% Plot BUFFER area
%In the buffer.csv, col6: time elapsed during experiment in minutes

[m,n] = size(buff); %get size for looping through all rows

%Establish variables
time = buff.time_min_; %rename column
frame = buff.frame; %number of frames
dtime = buff.dissection_time; %when the wings were removed
fwL = buff.fwArea; %rename fw
hwL = buff.hwArea; %rename hw 


indx = find(frame == 1); %find when the time equals one, this is how we pick out trials

for i = 1:length(indx)
    
    if indx(i) < 77
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,13)
            x = time(first:last)+5;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on
            xlabel('BUFFER 5 min', 'FontSize',20)
            
        elseif dtime(indx(i)) == 10
            subplot(5,4,14)
            x = time(first:last)+10;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)            
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on

        elseif dtime(indx(i)) == 15
            subplot(5,4,15)
            x = time(first:last)+15;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on

        elseif dtime(indx(i)) == 20
            subplot(5,4,16)
            x = time(first:last)+20;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on

        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 15 min treatment
        subplot(5,4,13)
        x = time(first:last)+15;
        y = fwL(first:last);
        y2 = hwL(first:last);
        plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
        plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on

    end

    hold on
end

hold on
% Plot DI WATER area
%In the di_h2o.csv, col6: time elapsed during experiment in minutes

[m,n] = size(water); %get size for looping through all rows

%Establish variables
time = water.time_min_; %rename column
frame = water.frame; %number of frames
dtime = water.dissection_time; %when the wings were removed
fwL = water.fwArea; %rename fw length
hwL = water.hwArea; %rename hw length


indx = find(frame == 1); %find when the time equals one, this is how we pick out trials

for i = 1:length(indx)
    
    if indx(i) < 128 %last trial of the file
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,9)
            x = time(first:last)+5;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on
            xlabel('DI Water 5 min', 'FontSize',20)
            
        elseif dtime(indx(i)) == 10
            subplot(5,4,10)
            x = time(first:last)+10;
            y = fwL(first:last);
            y2 = hwL(first:last);     
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on

        elseif dtime(indx(i)) == 15
            subplot(5,4,11)
            x = time(first:last)+15;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on

        elseif dtime(indx(i)) == 20
            subplot(5,4,12)
            x = time(first:last)+20;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on
        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 5 min treatment
        subplot(5,4,9)
        x = time(first:last)+5;
        y = fwL(first:last);
        y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on
    end

    hold on
end

% Plot MINERAL OIL AREA
%In the mo.csv, col6: time elapsed during experiment in minutes

[m,n] = size(mo); %get size for looping through all rows

%Establish variables
time = mo.time_min_; %rename column
frame = mo.frame; %number of frames
dtime = mo.dissection_time; %when the wings were removed
fwL = mo.fwArea; %rename fw length
hwL = mo.hwArea; %rename hw length


indx = find(frame == 1); %find when the time equals one, this is how we pick out trials

for i = 1:length(indx)
    
    if indx(i) < 40 %last entry
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,17)
            x = time(first:last)+5;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on
            xlabel('Mineral Oil 5 min', 'FontSize',20)
            
        elseif dtime(indx(i)) == 10
            subplot(5,4,18)
            x = time(first:last)+10;
            y = fwL(first:last);
            y2 = hwL(first:last);   
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)          
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on

        elseif dtime(indx(i)) == 15
            subplot(5,4,19)
            x = time(first:last)+15;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on

        elseif dtime(indx(i)) == 20
            subplot(5,4,20)
            x = time(first:last)+20;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on
        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 5 min treatment
        subplot(5,4,18)
        x = time(first:last)+10;
        y = fwL(first:last);
        y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on
        
        %plot(timeS,fwLS,'-','Color',pink,'LineWidth',widthLine)
        %plot(timeS,hwLS,'-','Color',red,'LineWidth',widthLine)
    end

    hold on
end

% Plot GRAVITY AREA
%In the grav_length.csv, col3: time elapsed during experiment in minutes

[m,n] = size(gL); %get size for looping through all rows

%Establish variables
time = gL.time_min_; %rename column
dtime = gL.dissection_time; %when the wings were removed
fwL = gL.fwArea; %rename fw length
hwL = gL.hwArea; %rename hw length


indx = find(time == 0); %find when the time equals zero

for i = 1:length(indx)
    
    if indx(i) < 184 %this is the last zero
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,5)
            x = time(first:last)+5;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on            
            xlabel('Gravity 5 min', 'FontSize',20)
            
        elseif dtime(indx(i)) == 10
            subplot(5,4,6)
            x = time(first:last)+10;
            y = fwL(first:last);
            y2 = hwL(first:last);         
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)           
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on
            
        elseif dtime(indx(i)) == 15
            subplot(5,4,7)
            x = time(first:last)+15;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on
            
        elseif dtime(indx(i)) == 20
            subplot(5,4,8)
            x = time(first:last)+20;
            y = fwL(first:last);
            y2 = hwL(first:last);
            plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
            plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            axis([0 60 0 800])
            hold on

        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a (5 min - grav, 5 min- water, 15 min buff, 10 min oil) 
        subplot(5,4,5)
        x = time(first:last)+5; %this +X number changes depending on treatment
        y = fwL(first:last);
        y2 = hwL(first:last);
        plot(x, y,'-','Color',lightgray,'LineWidth',widthLine)
        plot(x, y2,'-','Color',gray,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on
    end

    hold on
end


%PLOT INTACT SCHISTOS: in the leftover mineral oil plots
indx = find(timeS == 0); %find when the time equals zero, this is how we pick out trials

%schisto.csv info. This insect was just observed, no treatments or cutting
timeS = schisto.time_min_; %rename column
fwLS = schisto.fwArea; %rename fw length
hwLS = schisto.hwArea; %rename hw length
dtime = schisto.timeOfMeasurement_min_;
circleSize = 50;
for i = 1:9
    
    if indx(i) < 71 %last zero
        
        first = indx(i); last = indx(i+1)-1;

        if dtime(indx(i)) == 5
            subplot(5,4,19)
            x = timeS(first:last)+5;
            y = fwLS(first:last);
            y2 = hwLS(first:last);
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
            xlabel('Intact case', 'FontSize',20)
            %axis([0 75 0 50])
            hold on
            subplot(5,4,20)
            h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
            hold on
            h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
             xlabel('Intact case', 'FontSize',20)
             
        elseif dtime(indx(i)) == 10
            subplot(5,4,19)
            x = timeS(first:last)+10;
            y = fwLS(first:last);
            y2 = hwLS(first:last);
     
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)          
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
          % axis([0 75 0 50])
            hold on
            subplot(5,4,20)
            h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
            hold on
            h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);

        elseif dtime(indx(i)) == 15
            subplot(5,4,19)
            x = timeS(first:last)+15;
            y = fwLS(first:last);
            y2 = hwLS(first:last);
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
           % axis([0 75 0 50])
            hold on
            subplot(5,4,20)
            h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
            hold on
            h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);

        elseif dtime(indx(i)) == 20
            subplot(5,4,19)
            x = timeS(first:last)+20;
            y = fwLS(first:last);
            y2 = hwLS(first:last);
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)
            ax = gca; ax.FontSize = 14; %change axes numbers to larger font
          %  axis([0 75 0 50])
            hold on
            subplot(5,4,20)
            h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',pink,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
            hold on
            h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',red,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
        end
    
    else 
        first = indx(end); last = m; %to account for the last indx of zero
        
        %last trial in the spreadsheet was a 5 min treatment
        subplot(5,4,19)
            x = timeS(first:last);
            y = fwLS(first:last);
            y2 = hwLS(first:last);
            plot(x, y,'-','Color',pink,'LineWidth',widthLine)
            plot(x, y2,'-','Color',red,'LineWidth',widthLine)
        ax = gca; ax.FontSize = 14; %change axes numbers to larger font
        hold on
        subplot(5,4,20)
        h1 = scatter(x,y,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
          'MarkerFaceColor',pink,...
          'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
        hold on
        h2 = scatter(x,y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
          'MarkerFaceColor',red,...
          'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
    end
    ax = gca; ax.FontSize = 14; %change axes numbers to larger font

    hold on
end


%% Scatter plot of wing length for all treatments with trendline
% this plot includes a gray mean line 

close all;

%plot aesthetics
alpha = 0.7; %opacity of circles
k = 15; %window for movmean function
k2 = 40;
circleSize = 350;
circleLine = 0.1;
trendcolor1 = gray;
trendcolor2 = gray;
edgeColor = lightgray; %circle edge color

%intact_schisto_v2.csv info. This insect was just observed, no treatments or cutting
timeSV2 = S2.time2; %rename column
fwLS = S2.fwLength_mm_; %rename fw length
hwLS = S2.hwLength_mm_; %rename hw length

X1 = timeSV2;
X2 = timeSV2;
Y1 = fwLS;
Y2 = hwLS;


%PLOT:
figure
subplot(1,5,1)
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
title('Intact Schistos','FontSize',20)
ylabel('Wing Length  (mm)','FontSize',20)
xlabel('Time (min)','FontSize',20)

legend('forewing','hindwing')
lgd = legend;
lgd.FontSize = 16;
lgd.Title.String = 'Wings';

%Plot gravity
k = 40;
time = gL2.time2; %rename column
fwLS = gL2.fwLength_mm_; %rename fw length
hwLS = gL2.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,2)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(time, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(time, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

legend('forewing','hindwing')
lgd = legend;
lgd.FontSize = 16;
lgd.Title.String = 'Wings';


%Plot buffer
time = buff2.time2; %rename column
fwLS = buff2.fwLength_mm_; %rename fw length
hwLS = buff2.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,3)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(time, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(time, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Buffer ','FontSize',20)
% ylabel('Wing Length  (mm)','FontSize',20)
% xlabel('Time (min)','FontSize',20)


%Plot water
time = water2.time2; %rename column
fwLS = water2.fwLength_mm_; %rename fw length
hwLS = water2.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,4)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(time, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(time, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Water ','FontSize',20)
% ylabel('Wing Length  (mm)','FontSize',20)
% xlabel('Time (min)','FontSize',20)

%Plot mineral oil
k = 30;
time = mo2.time2; %rename column
fwLS = mo2.fwLength_mm_; %rename fw length
hwLS = mo2.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,5)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(time, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(time, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 50])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('MO','FontSize',20)
% ylabel('Wing Length  (mm)','FontSize',20)
% xlabel('Time (min)','FontSize',20)


%%  Scatter plot of wing area for all treatments with trendline
% this plot includes a gray mean line 

close all;

%plot aesthetics
alpha = 0.7; %opacity of circles
k = 15; %window for movmean function
k2 = 40;
circleSize = 350;
circleLine = 0.1;
trendcolor1 = gray;
trendcolor2 = gray;
edgeColor = lightgray; %circle edge color

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
subplot(1,5,1)
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
ylabel('Wing Area  (mm^2)','FontSize',20)
xlabel('Time (min)','FontSize',20)

legend('forewing','hindwing')
lgd = legend;
lgd.FontSize = 16;
lgd.Title.String = 'Wings';

%Plot gravity
k = 40;
time = gL2.time2; %rename column
fwLS = gL2.fwArea; %rename fw length
hwLS = gL2.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,2)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(time, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(time, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Gravity ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)


%Plot buffer
time = buff2.time2; %rename column
fwLS = buff2.fwArea; %rename fw length
hwLS = buff2.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,3)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(time, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(time, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Buffer ','FontSize',20)
% ylabel('Wing Length  (mm)','FontSize',20)
% xlabel('Time (min)','FontSize',20)


%Plot water
time = water2.time2; %rename column
fwLS = water2.fwArea; %rename fw length
hwLS = water2.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,4)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(time, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(time, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('Water ','FontSize',20)
% ylabel('Wing Length  (mm)','FontSize',20)
% xlabel('Time (min)','FontSize',20)

%Plot mineral oil
k = 30;
time = mo2.time2; %rename column
fwLS = mo2.fwArea; %rename fw length
hwLS = mo2.hwArea; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,5)
set(gcf,'color','w') %change whole figure background to white
h1 = scatter(X1,Y1,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',lightgray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
hold on
h2 = scatter(X2,Y2,circleSize,'filled', ...%'MarkerEdgeColor',edgeColor,...
              'MarkerFaceColor',gray,...
              'MarkerFaceAlpha',alpha,'LineWidth',circleLine);
          
%Mean
M1 = movmean(Y1,k,'omitnan');
plot(time, M1,'-','Color',trendcolor1,'LineWidth',5)

M2 = movmean(Y2,k,'omitnan');
plot(time, M2,'-','Color',trendcolor2,'LineWidth',5)

%Axes labels and formatting
axis([0 60 0 800])
ax = gca; ax.FontSize = 14; %change axes numbers to larger font
title('MO ','FontSize',20)
% ylabel('Wing Length  (mm)','FontSize',20)
% xlabel('Time (min)','FontSize',20)
%% Trendlines over each time point

%Plot gravity
k = 40; %smoothing factor
time = gL2.time2; %this column sorts by time


fwLS = gL2.fwLength_mm_; %rename fw length
hwLS = gL2.hwLength_mm_; %rename hw length

X1 = time; X2 = time;
Y1 = fwLS; Y2 = hwLS;


subplot(1,5,1)
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
title('Gravity ','FontSize',20)
%ylabel('Wing Length  (mm)','FontSize',20)
%xlabel('Time (min)','FontSize',20)

legend('forewing','hindwing')
lgd = legend;
lgd.FontSize = 16;
lgd.Title.String = 'Wings';



%% Scatter plot of all intact points

%Length
% this plot includes a gray mean line 

close all;

%plot aesthetics
alpha = 0.7; %opacity of circles
k = 15; %window for movmean function
k2 = 40;
circleSize = 350;
circleLine = 0.1;
trendcolor1 = gray;
trendcolor2 = gray;
edgeColor = lightgray; %circle edge color

%intact_schisto_v2.csv info. This insect was just observed, no treatments or cutting
timeSV2 = S2.time2; %rename column
fwLS = S2.fwLength_mm_; %rename fw length
hwLS = S2.hwLength_mm_; %rename hw length

X1 = timeSV2;
X2 = timeSV2;
Y1 = fwLS;
Y2 = hwLS;


%PLOT:
figure
subplot(2,1,1)
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
title('Intact Schistos','FontSize',20)
ylabel('Wing Length  (mm)','FontSize',20)
xlabel('Time (min)','FontSize',20)

legend('forewing','hindwing')
lgd = legend;
lgd.FontSize = 16;
lgd.Title.String = 'Wings';

%Area
%intact_schisto_v2.csv info. This insect was just observed, no treatments or cutting
timeSV2 = S2.time2; %rename column
fwLS = S2.fwArea; %rename fw length
hwLS = S2.hwArea; %rename hw length

X1 = timeSV2;
X2 = timeSV2;
Y1 = fwLS;
Y2 = hwLS;


%PLOT intact schistos - don't have area
subplot(2,1,2)
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
ylabel('Wing Area  (mm^2)','FontSize',20)
xlabel('Time (min)','FontSize',20)

legend('forewing','hindwing')
lgd = legend;
lgd.FontSize = 16;
lgd.Title.String = 'Wings';


