function m = simMeanCompute(meanFunction, X, varargin)

% SIMMEANCOMPUTE Give the output of the SIM mean function model for given X.
%
%	Description:
%
%	Y = SIMMEANCOMPUTE(MODEL, X) gives the output of the sim mean
%	function model for a given input X.
%	 Returns:
%	  Y - output location(s) corresponding to given input locations.
%	 Arguments:
%	  MODEL - structure specifying the model.
%	  X - input location(s) for which output is to be computed.
%	
%
%	See also
%	SIMMEANCREATE


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence
% 	simMeanCompute.m SVN version 156
% 	last update 2008-11-30T22:05:54.000000Z


nlf = varargin{1};
startVal=1;
endVal=0;
for i =1:nlf,
    endVal = endVal + size(X{i}, 1);
    m(startVal:endVal, 1) =  zeros(length(X{i}),1);
    startVal = endVal+1;
end

for i = nlf+1:length(X),
    endVal = endVal + size(X{i}, 1);
    m(startVal:endVal, 1) = meanFunction.basal(i-nlf)/meanFunction.decay(i-nlf) * ...
        ones(length(X{i}),1);
    startVal = endVal+1;
end