% We evaluate the target function.

function [ ret ] = target_Branin(xx, noise)

	x1 = xx(:, 1);
	x2 = xx(:, 2);

	x1bar = 15.*x1 - 5;
	x2bar = 15.*x2;

	term1 = x2bar - 5.1.*x1bar.^2/(4*pi^2) + 5.*x1bar./pi - 6;
	term2 = (10 - 10/(8*pi)) .* cos(x1bar);
    
    n = size(xx, 1);
    
	ret = -((term1.^2 + term2 - 44.81) ./ 51.95) + noise .* randn(n, 1);
    
%     for i=1:size(xx, 1)
%         myseed = abs((xx(i, 1) + 1.56*xx(i, 2) + xx(i, 1).^2 - exp(xx(i, 2)))*1000000*T);
%         rng(myseed, 'twister');
%         ret(i) = ret(i) - noise * randn;
%     end
%     rng('shuffle');
