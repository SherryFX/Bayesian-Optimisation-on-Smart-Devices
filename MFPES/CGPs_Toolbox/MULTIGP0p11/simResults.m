function simResults(dataSetName, experimentNo, numModel, seedVal)

% SIMRESULTS Display the results of the Barenco sim experiment
%
%	Description:
%
%	SIMRESULTS(DATASETNAME, EXPERIMENTNO) display the results for the
%	sim experiment with Barenco data.
%	 Arguments:
%	  DATASETNAME - name of the dataset used for the demo
%	  EXPERIMENTNO - number of the experiment


%	Copyright (c) 2008 Mauricio Alvarez
% 	simResults.m SVN version 305
% 	last update 2009-04-08T10:39:37.000000Z

saveFigures    = false;
displayOutputs = true;
scaleVal = 1;

if nargin<3
    numModel =1;
    seedVal = 1e6;
end
if nargin<4,
    seedVal = 1e6;
end

rand('seed', seedVal);
randn('seed', seedVal);

capName = dataSetName;
capName(1) = upper(capName(1));
load(['dem' capName num2str(experimentNo) '.mat'], 'model');

modelFig = model.comp{numModel};

if displayOutputs
    [xTemp, yTemp, xTestTemp, yTestTemp] = mapLoadData(dataSetName);
    if strcmp(modelFig.approx, 'ftc')
        X = cell(1, size(yTemp, 2) + modelFig.nlf);
        y = cell(1, size(yTemp, 2) + modelFig.nlf);
        for i = 1:modelFig.nlf
            X{i} = 0;
            y{i} = 0;
        end
        for i = 1:size(yTemp, 2)
            y{i+modelFig.nlf} = yTemp((numModel-1)*7+1:numModel*7, i);
            X{i+modelFig.nlf} = xTemp;
        end
    else
        % Set the inputs and outputs in the correct format
        X = cell(1, size(yTemp, 2));
        y = cell(1, size(yTemp, 2));
        for i = 1:size(yTemp, 2)
            y{i} = yTemp((numModel-1)*7+1:numModel*7, i);
            X{i} = xTemp;
        end
    end
end



Xt = linspace(min(modelFig.X{modelFig.nlf+1}),max(modelFig.X{modelFig.nlf+1}),200)';
[mu, varsigma] = multigpPosteriorMeanVar(modelFig, Xt, displayOutputs);
close all

if strcmp(modelFig.approx,'ftc')
    if displayOutputs
        nFigs = modelFig.d;
    else
        nFigs = modelFig.nlf;
    end
else
    if displayOutputs
        nFigs = modelFig.nout+modelFig.nlf;
    else
        nFigs = modelFig.nlf;
    end
    %    xlim = [min(modelFig.X_u)  max(modelFig.X_u)];
end
for k=1:nFigs,
    figure
    hold on
    f = [(mu{k}+2*real(sqrt(varsigma{k})))*scaleVal;flipdim((mu{k}-2*real(sqrt(varsigma{k})))*scaleVal,1)];
    a = fill([Xt; flipdim(Xt,1)], f, [7 7 7]/8, 'EdgeColor', [7 7 7]/8);
    a =[ a plot(Xt, mu{k}*scaleVal,'k-')];
    if k>modelFig.nlf
        if strcmp(modelFig.approx, 'ftc')
            c =plot(X{k},y{k}*scaleVal,'k.');
        else
            c =plot(X{k-modelFig.nlf},y{k-modelFig.nlf}*scaleVal,'k.');
        end
    end
    minimum = min((mu{k}-2*real(sqrt(varsigma{k})))*scaleVal);
    maximum = max((mu{k}+2*real(sqrt(varsigma{k})))*scaleVal);
    if isfield(modelFig, 'X_u') && ~isempty(modelFig.X_u);
        b = plot(modelFig.X_u, minimum*0.9, 'kx');
        set(b, 'linewidth', 2)
        set(b, 'markersize', 10);
        if nargin ==5
            hold on
            d = plot(initialLoc, maximum*0.9, 'kx');
            set(d, 'linewidth', 2)
            set(d, 'markersize', 10);
        end
    end
    if k>modelFig.nlf
        set(c,   'markersize', 20);
    else
    end
    set(a,   'lineWidth', 2);
    set(gca, 'fontname', 'arial', 'fontsize', 15, 'ylim', ylim, 'Color', 'none')
    box on
    if saveFigures==1
        fileName = ['simPrediction' upper(modelFig.approx)  num2str(k)];
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
