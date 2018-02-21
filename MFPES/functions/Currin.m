% We evaluate the target function.

function [ ret ] = target_Currin(xx, noise)

	x1 = xx(:, 1);
	x2 = xx(:, 2);

	term1 = 2300*x1.^3 + 1900*x1.^2 + 2092*x1 + 60;
    term2 = 100*x1.^3 + 500*x1.^2 + 4*x1 + 20;
    
    n = size(xx, 1);
    
	ret = (1-exp(-1./2*x2)).*term1./term2./1.5 + noise .* randn(n, 1);

