function m = simwhiteMeanCompute(meanFunction, X, varargin)

% SIMWHITEMEANCOMPUTE Give the output of the SIM-WHITE mean function model
%
%	Description:
%	for given X.
%
%	Y = SIMWHITEMEANCOMPUTE(MODEL, X) gives the output of the SIM-WHITE
%	mean function model for a given input X.
%	 Returns:
%	  Y - output location(s) corresponding to given input locations.
%	 Arguments:
%	  MODEL - structure specifying the model.
%	  X - input location(s) for which output is to be computed.
%	
%	
%
%	See also
%	SIMWHITEMEANCREATE


%	Copyright (c) 2008 Mauricio Alvarez and Neil D. Lawrence


%	With modifications by David Luengo 2009
% 	simwhiteMeanCompute.m SVN version 277
% 	last update 2009-03-04T20:54:27.000000Z


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
