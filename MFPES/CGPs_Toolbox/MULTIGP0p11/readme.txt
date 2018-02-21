MULTIGP software
Version 0.11		Wednesday 10 Jun 2009 at 22:34

The multigp toolbox is a toolbox for multiple output Gaussian
processes. Version 0.1 is the first official release, we have an older
release 0.001 which was used to publish the results in our NIPS paper,
this older release is available on request.

The toolbox allows the use of multioutput Gaussian processes in
combination with the "multi" kern type, first developed for use with
the gpsim code. The aim for this toolbox is that it should be more
general than the gpsim code. In particular it should allow for sparse
approximations for multiple output GPs. 

The multioutput GPs are constructed through convolution processes. For
more details see our NIPS paper and work by Dave Higdon and the NIPS
paper by Boyle and Frean.


Version 0.11
------------

Updated version which allows for variational outputs and includes a financial data example.

Version 0.1
-----------

First version of the software with implementation of the 2008 NIPS paper.


MATLAB Files
------------

Matlab files associated with the toolbox are:

multigpKernComposer.m: Composes kernel types from some generic options.
demMocap3.m: Demo of Sparse Multi Output Gaussian Process using PITC and the lfm kernel 
multigpOptimise.m: Optimise the inducing variable multigp based kernel.
demSimp53.m: Demonstrate latent force model on gene expression data.
sparseKernGradient.m: Computes the gradients of the parameters for sparse multigp kernel.
simMeanExpandParam.m: Extract the parameters of the vector parameter and put 
simMeanCreate.m: returns a structure for the SIM mean function.
simwhiteMeanCompute.m: Give the output of the SIM-WHITE mean function model
balanceVisualise.m: Draws a skel representation of 3-D data balance motion
simMeanGradient.m: Gradient of the parameters of the mean function in the
balancePlayData.m: Play balance motion capture data.
demToy2.m: Demonstration of sparse multioutput model using FITC.
fxDataResults.m: Show the results of any given demo for the foreign exchange
meanCompute.m: Give the output of the lfm mean function model for given X.
demGpsim1.m: Demo of full multi output GP with the sim kernel.
lfmMeanCompute.m: Give the output of the lfm mean function model for given X.
simwhiteMeanExpandParam.m: Extract the parameters of the vector parameter
ggSpmgpToyResults.m: Show the prediction results for the demSpmgpGgToy's demos.
lfmwhiteMeanCreate.m: returns a structure for the mean function LFM-WHITE kernel.
multigpToolboxes.m: Load in the relevant toolboxes for MULTIGP.
batchJura3.m:  Batch of the Sparse Multi Output Gaussian Process using the PITC approx over the Jura datatset. 
demPpcaFxData.m: Demonstrate PPCA model (for comparison purposes with LFM
demSimFxData.m: Demonstrate latent force model on exchange rates data.
multigpOptions.m: Return default options for the MOCAP examples in the LFM model.
lfmMeanExpandParam.m: Extract the parameters of the vector parameter and put 
multigpUpdateKernels.m: Updates the kernel representations in the MULTIGP structure.
demGgJura.m: Demonstrate multigp convolution model on JURA data using
lfmMeanExtractParam.m: Extract parameters from the LFM MEAN function structure.
simwhiteMeanCreate.m: mean function structure for the SIM-WHITE kernel.
demToy4.m: Demo of Full Multi Output Gaussian Process. In this demo, we use the Gaussian Kernel for all the covariances (or Kernels) involved and only one hidden function.
demJuraBatch.m: Demonstrate convolution models on JURA data.
generateDataset.m: Generates samples from a multigp model 
batchJura1.m: Batch of the Full Multi Output Gaussian Process using the Jura Dataset. 
multigpDisplay.m: Display a Gaussian process model.
multigpExtractParam.m: Extract the parameters of a MULTIGP model.
meanExtractParam.m: Extract parameters from a MEAN FUNCTION structure.
lfmwhiteMeanExtractParam.m: Extract parameters from the LFM-WHITE mean function structure.
batchJura4.m:  Batch of an Independent Gaussian Process using the Jura Dataset. 
demMocap1.m: Demo of full multi output GP with the lfm kernel.
multigpExpandParam.m: Expand the given parameters into a MULTIGP structure.
ggToyResults.m: Show the prediction results for the demGgToy demo.
demCmu49BalanceArm4.m: Demonstrate latent force model on CMU data.
convolveDiagram.m: Plots for a diagram of convolution.
lfmwhiteMeanExpandParam.m: Extract the parameters of the vector parameter
spmultigpCreate.m:
demSpmgpGgToy1.m: Demonstrate sparse multigp on TOY data using the PITC
demGpsim1_v2.m: Demo of full multi output GP with the sim kernel using data 2 
spmultigpUpdateAD.m: Update the representations of A and D associated with 
demSpmgpGgToy3.m: Sparse multigp on TOY data using PITC
multigpCreate.m: creates a multi output GP based on a convolution.
meanGradient.m: Gradient of the parameters of the mean function in the
meanCreate.m: creates the mean function for a multi output GP
demGgToy1.m: Demo of full multi output GP with missing data.
batch_demJura.m: 
demSpmgpJuraBatch.m: Demonstrate sparse convolution models on JURA data.
demSpmgpSimp53.m: Demonstrate latent force model on gene network data using an
blockChol.m: obtains a block Cholesky Factorization of a Matriz A according
demTide4.m: Example of Multi Output Gaussian Process using an independent Gp for each output over the heigth tide dataset of the sensor network. 
demPitcCmu49Balance.m: Trains latent force model for motion 19, CMU dataset
demTide3.m: Example of Sparse Multi Output Gaussian Process using PITC over the
multigpComputeM.m: Compute the matrix m given the model.
simResults.m: Display the results of the Barenco sim experiment
demSpmgpLfmToy.m: Demonstrate latent force model on TOY data.
lfmwhiteMeanCompute.m: Give the output of the LFM-WHITE mean function model
demAistats.m: Reproduces demo presented at AISTATS 2009
multigpOut.m: outputs of a multigp given the latent forces
demGpsim3_v2.m: Demo of full multi output GP with the sim kernel with PITC using data 2
meanFactors.m: Extract factors associated with transformed optimisation space.
multigpLogLikeGradients.m: Compute the gradients for the parameters and X_u.
lfmMeanGradient.m: Gradient of the parameters of the mean function in the
demToy1.m: Demo of full multi output GP with missing data.
initDemSimDtcFxData.m: initialisation of the parameters of the SIM and SIM-WHITE models using an independent GP for each output.
simMeanCompute.m: Give the output of the SIM mean function model for given X.
demSpmgpCmu49BalanceArm5.m: Demonstrate latent force model on CMU data using an
multigpComputeAlpha.m: Update the vector `alpha' for computing posterior mean quickly.
spmultigpUpdateKernels.m: 
spmultigpExtractParam.m: Extract a parameter vector from a sparse MULTIGP model.
multigpObjective.m: Wrapper function for MULTIGPOPTIMISE objective.
demSimwhiteFxData.m: Demonstrate latent force model on exchange rates data.
demGpsim3.m: Demo of full multi output GP with the sim kernel using PITC
simMeanExtractParam.m: Extract parameters from the SIM MEAN FUNCTION structure.
multigpUpdateTopLevelParams.m: Update parameters at top level from kernel.
demSimwhiteDtcFxData.m: Demonstrate latent force model on exchange rates
lfmwhiteMeanGradient.m: Gradient of the parameters of the mean function in
sparseKernCompute.m: Computes the kernels for the sparse approximation in the convolution process framework.
demCmu49BalanceArm5.m: Demonstrate latent force model on CMU data. In this
multigpLogLikelihood.m: Compute the log likelihood of a MULTIGP.
demSimDtcFxData.m: Demonstrate latent force model on exchange rates data
spmultigpExpandParam.m: Expand a parameter vector into a SPMULTIGP model.
multigpPosteriorMeanVar.m: gives mean and variance of the posterior distribution.
demLfmToy.m: Demonstrate latent force model on TOY data.
demCmu49BalanceArm1.m: Demonstrate latent force model on CMU data.
simwhiteMeanGradient.m: Gradient of the parameters of the mean function in
multigpGradient.m: Gradient wrapper for a MULTIGP model.
balanceModify.m: Update visualisation of skeleton data for balance motion
demSpmgpGgToy4.m: Sparse multigp on TOY data using DTC VAR
checkKernelSymmetry.m: Check the kernel symmetry.
spmultigpLogLikelihood.m: Compute the log likelihood of a SPARSE MULTIGP.
loadFxData.m: Load the text file with the foreign exchange rates data set and store it in a format easily accessible by Matlab.
trainModelHighInGgwhite.m: Trains the DTC VAR approx for GGWHITE kernel
batchHighInputsGgwhite.m: Computes DTC VAR bound and full gp likelihood 
demToy3.m: Demo of Sparse Multi Output Gaussian Process using PITC. 
simwhiteMeanExtractParam.m: Extract parameters from the SIM-WHITE mean function structure.
meanExpandParam.m: Extract the parameters of the vector parameter and put 
spmultigpLocalCovGradient.m: Computes the derivatives of the likelihood
