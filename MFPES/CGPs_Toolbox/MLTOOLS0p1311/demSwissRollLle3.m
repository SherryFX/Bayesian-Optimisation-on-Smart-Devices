
% DEMSWISSROLLLLE3 Demonstrate LLE on the oil data.
%
%	Description:
%	% 	demSwissRollLle3.m SVN version 97
% 	last update 2008-10-05T23:10:16.323155Z

[Y, lbls] = lvmLoadData('swissRoll');

options = lleOptions(16, 2);
model = lleCreate(2, size(Y, 2), Y, options);
model = lleOptimise(model);

lvmScatterPlotColor(model, model.Y(:, 2));

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, model.Y(:, 2), 'SwissRoll', 3, true);
end
