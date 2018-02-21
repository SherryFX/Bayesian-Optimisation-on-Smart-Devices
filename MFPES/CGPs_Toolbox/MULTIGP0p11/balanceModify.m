function balanceModify(handle, channels, skel, padding, zeroIndices)

% BALANCEMODIFY Update visualisation of skeleton data for balance motion
%
%	Description:
%
%	BALANCEMODIFY(HANDLE, CHANNELS, SKEL, PADDING) updates a skeleton
%	representation in a 3-D plot for balance motion.
%	 Arguments:
%	  HANDLE - a vector of handles to the structure to be updated.
%	  CHANNELS - the channels to update the skeleton with.
%	  SKEL - the skeleton structure.
%	  PADDING - a vector with positions to fill the channel (default
%	   zeros)
%	
%
%	See also
%	BALANCEVISUALISE


%	Copyright (c) Neil D. Lawrence, 2009 Mauricio Alvarez
% 	balanceModify.m SVN version 399
% 	last update 2009-06-10T20:53:56.000000Z

  global ffPos
  global rotMat
if nargin<4
  padding = 0;
end
channels = [channels zeros(1, padding)];
vals = skel2xyz(skel, channels);
connect = skelConnectionMatrix(skel);

indices = find(connect);
[I, J] = ind2sub(size(connect), indices);


 vals = vals - repmat(vals(4,:), size(vals,1), 1);

 vals = vals*rotMat';

 thet = acos((vals(5, 2))/sqrt(vals(5, [2 3])*vals(5, [2 3])'))+3*pi/2;
 rotMat2 = rotationMatrix(thet, 0, 0, 'x');
 vals = vals*rotMat2';
 thet = acos(-(0.6*ffPos(2))/sqrt(vals(5, [2 3])*vals(5, [2 3])'))+3*pi/2;
 rotMat2 = rotationMatrix(thet, 0, 0, 'x');
 vals = vals*rotMat2';
% %disp(thet)
% %disp(vals(5, :))
set(handle(1), 'Xdata', vals(:, 1) , 'Ydata', vals(:, 3), 'Zdata', ...
                 vals(:, 2));
             




for i = 1:length(indices)
  set(handle(i+1), 'Xdata', [vals(I(i), 1) vals(J(i), 1)], ...
            'Ydata', [vals(I(i), 3) vals(J(i), 3)], ...
            'Zdata', [vals(I(i), 2) vals(J(i), 2)]);
end


function [vals, connect] = wrapAround(vals, lim, connect);


quot = lim(2) - lim(1);
vals = rem(vals, quot)+lim(1);
nVals = floor(vals/quot);
for i = 1:size(connect, 1)
  for j = find(connect(i, :))
    if nVals(i) ~= nVals(j)
      connect(i, j) = 0;
    end
  end
end
