function ggSpmgpToyResults(dataSetName, experimentNo, XTemp, yTemp, initialLoc)

% GGSPMGPTOYRESULTS Show the prediction results for the demSpmgpGgToy's demos.
%
%	Description:
%
%	GGSPMGPTOYRESULTS(DATASETNAME, EXPERIMENTNO, XTEMP, YTEMP) shows the
%	prediction results for the demSpmgpGgToy's demos.
%	 Arguments:
%	  DATASETNAME - name of the dataset used for the demo
%	  EXPERIMENTNO - number of the experiment
%	  XTEMP - input locations training data
%	  YTEMP - output values for training data
%	DESC shows the prediction results for the demSpmgpGgToy's
%	demos.
%	ARG dataSetName : name of the dataset used for the demo
%	ARG experimentNo : number of the experiment
%	ARG XTemp : input locations training data
%	ARG yTemp : output values for training data
%	ARG initialLoc : initial location of spseudo inputs.
%	


%	Copyright (c) 2008 Mauricio Alvarez
% 	ggSpmgpToyResults.m SVN version 399
% 	last update 2009-06-10T20:54:00.000000Z

capName = dataSetName;
capName(1) = upper(capName(1));
load(['demSpmgp' capName num2str(experimentNo) '.mat'], 'model');

saveFigures = false;
scaleVal = 1;
X = cell(size(yTemp, 2),1);
y = cell(size(yTemp, 2),1);

for i = 1:size(yTemp, 2)
    y{i} = yTemp{i};
    X{i} = XTemp{i};
end

Xt = linspace(min(X{model.nlf+1})-0.5,max(X{model.nlf+1})+0.5,200)';
Xt = linspace(-1.3,1.3,200)';
%Xt = [-1.25 1.27];
[mu, varsigma] = multigpPosteriorMeanVar(model, Xt);
close all
%xlim = [min(model.X_u)  max(model.X_u)];
xlim = [-1.2560 1.2723];
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
    if k>model.nlf
        c =plot(X{k-model.nlf},y{k-model.nlf}*scaleVal,'k.');
    end
    minimum = min((mu{k}-2*real(sqrt(varsigma{k})))*scaleVal);
    maximum = max((mu{k}+2*real(sqrt(varsigma{k})))*scaleVal);
    if isfield(model, 'X_u') && ~isempty(model.X_u);
        b = plot(model.X_u, minimum*0.9, 'kx');
        set(b, 'linewidth', 2)
        set(b, 'markersize', 10);
        if nargin ==5
            hold on
            d = plot(initialLoc, maximum*0.9, 'kx');
            set(d, 'linewidth', 2)
            set(d, 'markersize', 10);
        end
    end
    if k>model.nlf        
        set(c,   'markersize', 10);
    else
    end
    set(a,   'lineWidth', 2);
    set(gca, 'fontname', 'arial', 'fontsize', 15, 'xlim', xlim, 'ylim', ylim, 'Color', 'none')
    box on
    if saveFigures==1
        fileName = ['Toy_prediction' upper(model.approx)  num2str(k)];
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
