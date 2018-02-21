
% DEMSWISSROLLLLE2 Demonstrate LLE on the oil data.
%
%	Description:
%	% 	demSwissRollLle2.m SVN version 97
% 	last update 2008-10-05T23:10:16.292977Z

[Y, lbls] = lvmLoadData('swissRoll');

options = lleOptions(8, 2);
model = lleCreate(2, size(Y, 2), Y, options);
model = lleOptimise(model);

lvmScatterPlotColor(model, model.Y(:, 2));

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, model.Y(:, 2), 'SwissRoll', 2, true);
end
