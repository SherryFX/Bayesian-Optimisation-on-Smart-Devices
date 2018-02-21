function biasKernDisplay(kern, spacing)

% BIASKERNDISPLAY Display parameters of the BIASkernel.
%
%	Description:
%
%	BIASKERNDISPLAY(KERN) displays the parameters of the bias kernel and
%	the kernel type to the console.
%	 Arguments:
%	  KERN - the kernel to display.
%
%	BIASKERNDISPLAY(KERN, SPACING)
%	 Arguments:
%	  KERN - the kernel to display.
%	  SPACING - how many spaces to indent the display of the kernel by.
%	
%
%	See also
%	BIASKERNPARAMINIT, MODELDISPLAY, KERNDISPLAY


%	Copyright (c) 2004, 2005, 2006 Neil D. Lawrence
% 	biasKernDisplay.m CVS version 1.5
% 	biasKernDisplay.m SVN version 1
% 	last update 2009-03-04T16:39:59.940017Z


if nargin > 1
  spacing = repmat(32, 1, spacing);
else
  spacing = [];
end
spacing = char(spacing);
fprintf(spacing);
fprintf('Bias Variance: %2.4f\n', kern.variance)
