function xyzankurAnim(X,fid,fps)

% XYZANKURANIM
%
%	Description:
%	


%	Copyright (c) 2008 Carl Henrik Ek and Neil Lawrence
% 	xyzankurAnim.m SVN version 119
% 	last update 2008-10-21T09:46:08.000000Z


if(nargin<3)
  fps = 24;
  if(nargin<2)
    fid = 1;
    if(nargin<1)
      error('To Few Arguments');
    end
  end
end

for(i = 1:1:size(X,1))
  if(i==1)
    handle = xyzankurVisualise(X(i,:),1);
  else
    xyzankurModify(handle,X(i,:));
  end
  pause(1/fps);
end