function kern = kernReadFromFID(FID)

% KERNREADFROMFID Load from an FID written by the C++ implementation.
%
%	Description:
%
%	KERN = KERNREADFROMFID(FID) loads in from a file stream the data
%	format produced by C++ implementations.
%	 Returns:
%	  KERN - the kernel loaded in from the file.
%	 Arguments:
%	  FID - the file ID from where the data is loaded.
%	
%
%	See also
%	MODELREADFROMFID, KERNCREATE, KERNREADPARAMSFROMFID


%	Copyright (c) 2005, 2006, 2008 Neil D. Lawrence
% 	kernReadFromFID.m CVS version 1.2
% 	kernReadFromFID.m SVN version 1
% 	last update 2009-03-04T16:40:07.558586Z

type = readStringFromFID(FID, 'type');
kern = kernCreate(zeros(1), type);

kern = kernReadParamsFromFID(kern, FID);
