function ggToyResults(dataSetName, experimentNo, XTemp, yTemp)

% GGTOYRESULTS Show the prediction results for the demGgToy demo.
%
%	Description:
%
%	GGTOYRESULTS(DATASETNAME, EXPERIMENTNO, XTEMP, YTEMP) Show the
%	prediction results for the demGgToy demo.
%	 Arguments:
%	  DATASETNAME - name of the dataset used for the demo
%	  EXPERIMENTNO - number of the experiment
%	  XTEMP - input locations training data
%	  YTEMP - output values for training data


%	Copyright (c) 2008 Mauricio Alvarez
% 	ggToyResults.m SVN version 289
% 	last update 2009-03-04T20:54:21.000000Z


capName = dataSetName;
capName(1) = upper(capName(1));
load(['dem' capName num2str(experimentNo) '.mat'], 'model');
saveFigures = false;
scaleVal = 1;

X = cell(size(yTemp, 2)+model.nlf,1);
y = cell(size(yTemp, 2)+model.nlf,1);

for j=1:model.nlf
   y{j} = 0;
   X{j} = 0;
end
for i = 1:size(yTemp, 2)
  y{i+model.nlf} = yTemp{i};
  X{i+model.nlf} = XTemp{i};
end

Xt = linspace(min(X{model.nlf+1})-0.5,max(X{model.nlf+1})+0.5,200)';

[mu, varsigma] = multigpPosteriorMeanVar(model, Xt);
close all
%
xlim = [-1.05 1.05];
if strcmp(model.approx,'ftc')
    nFigs = model.d;
else
    nFigs = model.nout+model.nlf;
end
for k=1:nFigs,
    figure
    hold on
    f = [(mu{k}+2*real(sqrt(varsigma{k})))*scaleVal;flipdim((mu{k}-2*real(sqrt(varsigma{k})))*scaleVal,1)];
    a = fill([Xt; flipdim(Xt,1)], f, [7 7 7]/8, 'EdgeColor', [7 7 7]/8);
    a =[ a plot(Xt, mu{k}*scaleVal,'k-')];
    %if k>model.nlf
       %c =plot(X{k},y{k}*scaleVal,'k.');
    %end
    minimum = min((mu{k}-2*real(sqrt(varsigma{k})))*scaleVal);
    maximum = max((mu{k}+2*real(sqrt(varsigma{k})))*scaleVal);
    if isfield(model, 'X_u') && ~isempty(model.X_u);
        b = plot(model.X_u, -8, 'kx');
        set(b, 'linewidth', 2)
        set(b, 'markersize', 10);
    end
%     if k>model.nlf
%         ylim = [min(minimum,min(y{k}*scaleVal)) max(maximum,max(y{k}*scaleVal))];
%         set(c,   'markersize', 10);
%     else
        ylim = [min(minimum,min(y{model.nlf+1}*scaleVal)) max(maximum,max(y{model.nlf+1}*scaleVal))];
    end
    set(a,   'lineWidth', 2);
    set(gca, 'fontname', 'arial', 'fontsize', 15, 'xlim', xlim, 'ylim', ylim, 'Color', 'none')
    box on
    if saveFigures==1
        aaa
        fileName = ['Toy_prediction' upper(model.approx) num2str(k)];
        print('-depsc', ['./results/' fileName]);
        saveas(gcf,['./results/' fileName],'fig');
        pos = get(gcf, 'paperposition');
        origpos = pos;
        pos(3) = pos(3)/2;
        pos(4) = pos(4)/2;
        set(gcf, 'paperposition', pos);
        lineWidth = get(gca, 'lineWidth');
        set(gca, 'lineWidth', lineWidth);
        print('-dpng', ['./results/' fileName])
        set(gca, 'lineWidth', lineWidth);
        set(gcf, 'paperposition', origpos);
    end
end
