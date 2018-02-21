
% DEMAISTATS Reproduces demo presented at AISTATS 2009
%
%	Description:
%	% 	demAistats.m SVN version 399
% 	last update 2009-06-10T20:53:56.000000Z

colordef white
clc
clear
close all

%addToolboxes(0,1);

nSamples = 100;
nReps = 2;
load 'data18'


ind = round(linspace(1, size(channels, 1), nSamples));
figure(1)
set(gcf, 'Position', [ 67 277 560 420]);

for j=1: nReps
    clf
    balancePlayData(skel, channels(ind, :), limits, 18, 49, 1/25);
    pause(1.5)
end


figure(2)
set(gcf, 'Position', [671 272 560 420]);
load 'data19'

ind = round(linspace(1, size(channels, 1), nSamples));

for j=1: nReps
    clf
    balancePlayData(skel, channels(ind, :), limits, 19, 49, 1/25);
    pause(1.5)
end

clear 
close all
clc

load additionalCmu49BalanceArmMod2.mat

lfmResultsDynamic('LfmCmu49BalanceArm', 27, 'balance', initPos, skel, muMod, muMod2)
