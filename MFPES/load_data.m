function [XTemp, yTemp, thresholds, means, stds] = load_data()
load('EMINIST_dataset');
XTemp =  cell([1 2]);
XTemp{1} = transX(mainFiltered(:, 1:5), 'mobile', false);
XTemp{2} = transX(mainFiltered(:, 1:5), 'mobile', false);
yTemp =  cell([1 2]);
tarCPU = mainFiltered(:, 6);
tarAcc = mainFiltered(:, 7);
auxCPU = mainFiltered(:, 8);
auxAcc = mainFiltered(:, 9);

% Transform based on threshold
thresholds = cell([1,2]);
thresholds{1} = mean(mainFiltered(:, 7));
thresholds{2} = mean(mainFiltered(:, 9));

tarAcc(tarAcc > thresholds{1}) = 1;	
auxAcc(auxAcc > thresholds{2}) = 1;	
yTemp{1} = tarCPU./tarAcc;
yTemp{2} = auxCPU./auxAcc;

% Normalize
means = cell([1,2]);
means{1} = mean(tarCPU./tarAcc);
means{2} = mean(auxCPU./auxAcc);
stds= cell([1,2]);
stds{1} = std(tarCPU./tarAcc);
stds{2} = std(auxCPU./auxAcc);

yTemp{1} = (yTemp{1} - means{1}) / stds{1};
yTemp{2} = (yTemp{2} - means{2}) / stds{2};
yTemp{1} = -yTemp{1};
yTemp{2} = -yTemp{2};

end

% tarThres = mean(mainFiltered(:, 7));
% tarPenalty = tarAcc;
% alpha=10;
% for i = 1:size(tarAcc, 1)
%     if tarAcc >= tarThres
%         tarPenalty(i) = 1;
%     else
%         tarPenalty = exp(alpha * (tarThres - tarAcc));
%     end
%     yTemp{1}(i) = -log(tarCPU(i) * tarPenalty(i));
% end
% auxThres = mean(mainFiltered(:, 9));
% auxPenalty = auxAcc;
% for i = 1:size(tarAcc, 1)
%     if auxAcc >= auxThres
%         auxPenalty(i) = 1;
%     else
%         auxPenalty = exp(alpha * (auxThres - auxAcc));
%     end
%     yTemp{2}(i) = -log(auxCPU(i) * auxPenalty(i));
% end
% 
% yTemp{1} = yTemp{1}';
% yTemp{2} = yTemp{2}';
