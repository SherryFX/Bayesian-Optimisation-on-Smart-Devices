
function [sigma2_n] = getNoise(model)

M = model.M;
params = model.params;
% nlf = model.nlf;
 
% sigma2_n = zeros(M, 1);
% 
% for i=1:M
%     sigma2_n(i) = model.kern.comp{nlf+1}.comp{i+nlf}.variance;
%     if sigma2_n(i) < 0.0001
%         sigma2_n(i) = 0.0001;
%     end
% end

sigma2_n = exp(params(end-M+1:end)');
sigma2_n(sigma2_n < 0.0001) = 0.0001;