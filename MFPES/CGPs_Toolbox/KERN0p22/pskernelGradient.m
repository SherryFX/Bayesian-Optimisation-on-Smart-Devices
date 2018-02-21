function g = pskernelGradient(lntheta, models, prior)

% PSKERNELGRADIENT Gradient on likelihood approximation for point set IVM.
%
%	Description:
%	g = pskernelGradient(lntheta, models, prior)
%% 	pskernelGradient.m CVS version 1.2
% 	pskernelGradient.m SVN version 1
% 	last update 2009-03-04T16:40:16.746382Z


% PSIVM

if nargin < 3
  prior = 1;
end

g = zeros(size(lntheta));
numTasks = length(models.task);
for taskNo = 1:numTasks
  models.task(taskNo).lntheta = models.lntheta;
  g = g + kernelGradient(lntheta, models.task(taskNo), prior);
end
  
