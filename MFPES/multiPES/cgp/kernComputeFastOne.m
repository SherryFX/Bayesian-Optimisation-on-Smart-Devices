function [K] = kernComputeFastOne(x1, type1, x2, type2, params)

    nlf = size(params.sigma, 1);
    d = size(params.Pinv, 2);
    
    K = zeros(size(x1, 1), 1);
    
    Ankinv = params.Ptinv(type1, :);
    Amkinv = params.Ptinv(type2, :);
    
    for i=1:nlf
        
        Bkinv = params.Pinv(i, :);
        sigma1_y = params.sigma(i, type1);
        sigma2_y = params.sigma(i, type2);
        
        mu_n = zeros(1, d);
        mu_m = zeros(1, d);

        detBkinv = prod(Bkinv);
        P = Ankinv + Amkinv + Bkinv;
        ldet = prod(P);
        Linv = sqrt(1./P);
        Linvx = (x1- repmat(mu_n,size(x1,1),1))*diag(Linv);
        Linvx2 = (x2- repmat(mu_m,size(x2,1),1))*diag(Linv);
        n2 = dist2(Linvx, Linvx2);
        K = K + sigma1_y*sigma2_y*sqrt((detBkinv)/ldet)*exp(-0.5*n2);
    end

% Ank = ggKern1.precision_y;
% Amk = ggKern2.precision_y;
% Bk = ggKern1.precision_u;
% mu_n = ggKern1.translation;
% mu_m = ggKern2.translation;
% Ankinv = 1./Ank;
% Amkinv = 1./Amk;
% Bkinv = 1./Bk;
% detBkinv = prod(Bkinv);
% P = Ankinv + Amkinv + Bkinv;
% ldet = prod(P);
% Linv = sqrt(1./P);
% Linvx = (x- repmat(mu_n',size(x,1),1))*diag(Linv);
% Linvx2 = (x2- repmat(mu_m',size(x2,1),1))*diag(Linv);
% n2 = dist2(Linvx, Linvx2);
% K = ggKern1.sigma2_y*ggKern2.sigma2_y*ggKern1.sigma2_u*sqrt((detBkinv)/ldet)...
%     *exp(-0.5*n2);


