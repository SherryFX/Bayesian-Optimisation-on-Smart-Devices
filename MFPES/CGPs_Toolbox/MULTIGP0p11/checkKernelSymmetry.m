function K = checkKernelSymmetry( K )

% CHECKKERNELSYMMETRY Check the kernel symmetry.
%
%	Description:
%	K = checkKernelSymmetry( K )
%% 	checkKernelSymmetry.m SVN version 267
% 	last update 2008-06-06T20:25:25.000000Z
  
asim_K = max(max(K-K.'));
if (asim_K ~= 0)
    K = (K + K.')/2;
end;
