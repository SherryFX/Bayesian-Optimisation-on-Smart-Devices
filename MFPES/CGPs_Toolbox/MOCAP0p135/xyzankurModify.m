function handle = xyzankurModify(handle,pos)

% XYZANKURMODIFY
%
%	Description:
%	


%	Copyright (c) 2008 Carl Henrik Ek and Neil Lawrence
% 	xyzankurModify.m SVN version 119
% 	last update 2008-10-21T09:45:45.000000Z


joint = xyzankur2joint(pos);

if(iscell(handle))
  for(i = 1:1:length(handle))
    xyzankurDraw(joint,handle{i}); 
  end
else
  xyzankurDraw(joint,handle);
end

return