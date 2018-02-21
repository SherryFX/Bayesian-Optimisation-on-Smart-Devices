function balancePlayData(skelStruct, channels, limits, motion, subject, frameLength) 

% BALANCEPLAYDATA Play balance motion capture data.
%
%	Description:
%
%	BALANCEPLAYDATA(SKELSTRUCT, CHANNELS, LIMITS, MOTION, SUBJECT,
%	FRAMELENGTH) plays channels from a motion capture skeleton and
%	channels.
%	 Arguments:
%	  SKELSTRUCT - the skeleton for the motion.
%	  CHANNELS - the channels for the motion.
%	  LIMITS - limits to plot the axes
%	  MOTION - number ID for the motion to be displayed in the plot
%	  SUBJECT - number of the subject to be displayed in the plot
%	  FRAMELENGTH - the framelength for the motion.
%	
%
%	See also
%	SKELPLAYDATA, ACCLAIMPLAYDATA


%	Copyright (c) Neil D. Lawrence, 2009 Mauricio Alvarez
% 	balancePlayData.m SVN version 399
% 	last update 2009-06-10T20:53:56.000000Z

if nargin < 4
  frameLength = 1/120;
end

clf
handle = skelVisualise(channels(1, :), skelStruct);

xlim = [limits(1,1) limits(1,2)];
ylim = [limits(2,1) limits(2,2)];
zlim = [limits(3,1) limits(3,2)];
set(gca, 'xlim', xlim, ...
         'ylim', ylim, ...
         'zlim', zlim);
title(['Subject ' num2str(subject) ' Motion ' num2str(motion)], 'FontSize', 15);

% Play the motion
for j = 1:size(channels, 1)
  pause(frameLength)
  skelModify(handle, channels(j, :), skelStruct);
end
