function f = pskernelObjective(lntheta, models, prior)

% PSKERNELOBJECTIVE Likelihood approximation for point set IVM.
%
%	Description:
%	f = pskernelObjective(lntheta, models, prior)
%% 	pskernelObjective.m CVS version 1.2
% 	pskernelObjective.m SVN version 1
% 	last update 2009-03-04T16:40:16.800849Z


% PSIVM

if nargin < 3
  prior = 1;
end
f = 0;
numTasks = length(models.task);
for taskNo = 1:numTasks
  models.task(taskNo).lntheta = models.lntheta;
  f = f + kernelObjective(lntheta, models.task(taskNo), prior);
end