function joint = xyzankur2joint(pos)

% XYZANKUR2JOINT
%
%	Description:
%	


%	Copyright (c) 2008 Carl Henrik Ek and Neil Lawrence
% 	xyzankur2joint.m SVN version 119
% 	last update 2008-10-21T09:46:01.000000Z


joint(:,1) = pos(3:3:end);
joint(:,2) = -pos(1:3:end);
joint(:,3) = -pos(2:3:end);

return