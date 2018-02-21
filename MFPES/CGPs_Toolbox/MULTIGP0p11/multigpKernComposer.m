function kernType = multigpKernComposer(type, numOut, numLatent, approx, specLatent)

% MULTIGPKERNCOMPOSER Composes kernel types from some generic options.
%
%	Description:
%
%	KERNTYPE = MULTIGPKERNCOMPOSER(TYPE, NUMOUT, NUMLATENT, SPECLATENT)
%	composes a kernel type to pass to kernel create from a generic type
%	and a few options.
%	 Returns:
%	  KERNTYPE - an array of cells which indicates the types of kernel
%	 Arguments:
%	  TYPE - kernel type
%	  NUMOUT - number of outputs.
%	  NUMLATENT - number of latent functions.
%	  SPECLATENT - indicating number for the latent function.
%	
%	
%	
%
%	See also
%	MULTIGPCREATE


%	Copyright (c) 2008 Mauricio Alvarez
%	Copyright (c) 2008 Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	multigpKernComposer.m SVN version 384
% 	last update 2009-06-04T19:57:30.000000Z

if nargin<5,
    specLatent = [];
end

switch approx
    case 'ftc'
        kernType = cell(1, numOut+1);
        limit = numOut-numLatent;
    case {'dtc','fitc', 'pitc'}
        kernType = cell(1, numOut+numLatent+1);
        limit = numOut;    
end

kernType{1} = 'multi';
for i =1:numLatent,
    switch type
        case 'white'
            if strcmp(approx, 'ftc')
                kernType{i+1} = 'none';
            else
                kernType{i+1} = 'white';
%                kernType{i+1} = 'none';
            end
        otherwise
            kernType{i+1} = 'none';
    end
end


switch type
    case 'gg' % The diffusion kernel.
        kernType{specLatent+1} = 'gaussian';
        for i = 1:limit
            kernType{i+numLatent+1} = 'gg';
        end

    case 'lfm' % the 2nd order differential equation.

        kernType{specLatent+1} = 'rbf';
        for i = 1:limit
            kernType{i+numLatent+1} = 'lfm';
        end
        
    case 'lfmwhite' % the 2nd order differential equation with white noise as input

        if strcmp(approx, 'ftc')
            kernType{specLatent+1} = 'white';
        else
            kernType{specLatent+1} = 'rbfinfwhite';
        end
        for i = 1:limit
            kernType{i+numLatent+1} = 'lfmwhite';
        end
           
        
    case 'sim' % The 1st order differential equation.

        kernType{specLatent+1} = 'rbf';
        for i = 1:limit
            kernType{i+numLatent+1} = 'sim';
        end
           
    case 'simwhite' % the 1st order differential equation with white noise as input

        if strcmp(approx, 'ftc')
            kernType{specLatent+1} = 'white';
        else
            kernType{specLatent+1} = 'rbfinfwhite';
        end
        for i = 1:limit
            kernType{i+numLatent+1} = 'simwhite';
        end    
               
    case 'ggwhite'   
        
        if strcmp(approx, 'ftc')
            kernType{specLatent+1} = 'white';
        else
            kernType{specLatent+1} = 'gaussianwhite';
        end
        
        for i = 1:limit
            kernType{i+numLatent+1} = 'ggwhite';
        end    
        
    case 'rbf' % An independent set of RBF kernels.

        for i = 1:limit
            kernType{i+numLatent+1} = 'rbf';
        end

    case 'white' % Different noise for each output.

        for i = 1:limit
            kernType{i+numLatent+1} = 'white';
        end
end

end

