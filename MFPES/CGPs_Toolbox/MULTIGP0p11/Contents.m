% MULTIGP toolbox
% Version 0.11		10-Jun-2009
% Copyright (c) 2009, Neil D. Lawrence
% 
, Neil D. Lawrence
% MULTIGPKERNCOMPOSER Composes kernel types from some generic options.
% DEMMOCAP3 Demo of Sparse Multi Output Gaussian Process using PITC and the lfm kernel 
% MULTIGPOPTIMISE Optimise the inducing variable multigp based kernel.
% DEMSIMP53 Demonstrate latent force model on gene expression data.
% SPARSEKERNGRADIENT Computes the gradients of the parameters for sparse multigp kernel.
% SIMMEANEXPANDPARAM Extract the parameters of the vector parameter and put 
% SIMMEANCREATE returns a structure for the SIM mean function.
% SIMWHITEMEANCOMPUTE Give the output of the SIM-WHITE mean function model
% BALANCEVISUALISE Draws a skel representation of 3-D data balance motion
% SIMMEANGRADIENT Gradient of the parameters of the mean function in the
% BALANCEPLAYDATA Play balance motion capture data.
% DEMTOY2 Demonstration of sparse multioutput model using FITC.
% FXDATARESULTS Show the results of any given demo for the foreign exchange
% MEANCOMPUTE Give the output of the lfm mean function model for given X.
% DEMGPSIM1 Demo of full multi output GP with the sim kernel.
% LFMMEANCOMPUTE Give the output of the lfm mean function model for given X.
% SIMWHITEMEANEXPANDPARAM Extract the parameters of the vector parameter
% GGSPMGPTOYRESULTS Show the prediction results for the demSpmgpGgToy's demos.
% LFMWHITEMEANCREATE returns a structure for the mean function LFM-WHITE kernel.
% MULTIGPTOOLBOXES Load in the relevant toolboxes for MULTIGP.
% BATCHJURA3  Batch of the Sparse Multi Output Gaussian Process using the PITC approx over the Jura datatset. 
% DEMPPCAFXDATA Demonstrate PPCA model (for comparison purposes with LFM
% DEMSIMFXDATA Demonstrate latent force model on exchange rates data.
% MULTIGPOPTIONS Return default options for the MOCAP examples in the LFM model.
% LFMMEANEXPANDPARAM Extract the parameters of the vector parameter and put 
% MULTIGPUPDATEKERNELS Updates the kernel representations in the MULTIGP structure.
% DEMGGJURA Demonstrate multigp convolution model on JURA data using
% LFMMEANEXTRACTPARAM Extract parameters from the LFM MEAN function structure.
% SIMWHITEMEANCREATE mean function structure for the SIM-WHITE kernel.
% DEMTOY4 Demo of Full Multi Output Gaussian Process. In this demo, we use the Gaussian Kernel for all the covariances (or Kernels) involved and only one hidden function.
% DEMJURABATCH Demonstrate convolution models on JURA data.
% GENERATEDATASET Generates samples from a multigp model 
% BATCHJURA1 Batch of the Full Multi Output Gaussian Process using the Jura Dataset. 
% MULTIGPDISPLAY Display a Gaussian process model.
% MULTIGPEXTRACTPARAM Extract the parameters of a MULTIGP model.
% MEANEXTRACTPARAM Extract parameters from a MEAN FUNCTION structure.
% LFMWHITEMEANEXTRACTPARAM Extract parameters from the LFM-WHITE mean function structure.
% BATCHJURA4  Batch of an Independent Gaussian Process using the Jura Dataset. 
% DEMMOCAP1 Demo of full multi output GP with the lfm kernel.
% MULTIGPEXPANDPARAM Expand the given parameters into a MULTIGP structure.
% GGTOYRESULTS Show the prediction results for the demGgToy demo.
% DEMCMU49BALANCEARM4 Demonstrate latent force model on CMU data.
% CONVOLVEDIAGRAM Plots for a diagram of convolution.
% LFMWHITEMEANEXPANDPARAM Extract the parameters of the vector parameter
% SPMULTIGPCREATE
% DEMSPMGPGGTOY1 Demonstrate sparse multigp on TOY data using the PITC
% DEMGPSIM1_V2 Demo of full multi output GP with the sim kernel using data 2 
% SPMULTIGPUPDATEAD Update the representations of A and D associated with 
% DEMSPMGPGGTOY3 Sparse multigp on TOY data using PITC
% MULTIGPCREATE creates a multi output GP based on a convolution.
% MEANGRADIENT Gradient of the parameters of the mean function in the
% MEANCREATE creates the mean function for a multi output GP
% DEMGGTOY1 Demo of full multi output GP with missing data.
% BATCH_DEMJURA 
% DEMSPMGPJURABATCH Demonstrate sparse convolution models on JURA data.
% DEMSPMGPSIMP53 Demonstrate latent force model on gene network data using an
% BLOCKCHOL obtains a block Cholesky Factorization of a Matriz A according
% DEMTIDE4 Example of Multi Output Gaussian Process using an independent Gp for each output over the heigth tide dataset of the sensor network. 
% DEMPITCCMU49BALANCE Trains latent force model for motion 19, CMU dataset
% DEMTIDE3 Example of Sparse Multi Output Gaussian Process using PITC over the
% MULTIGPCOMPUTEM Compute the matrix m given the model.
% SIMRESULTS Display the results of the Barenco sim experiment
% DEMSPMGPLFMTOY Demonstrate latent force model on TOY data.
% LFMWHITEMEANCOMPUTE Give the output of the LFM-WHITE mean function model
% DEMAISTATS Reproduces demo presented at AISTATS 2009
% MULTIGPOUT outputs of a multigp given the latent forces
% DEMGPSIM3_V2 Demo of full multi output GP with the sim kernel with PITC using data 2
% MEANFACTORS Extract factors associated with transformed optimisation space.
% MULTIGPLOGLIKEGRADIENTS Compute the gradients for the parameters and X_u.
% LFMMEANGRADIENT Gradient of the parameters of the mean function in the
% DEMTOY1 Demo of full multi output GP with missing data.
% INITDEMSIMDTCFXDATA initialisation of the parameters of the SIM and SIM-WHITE models using an independent GP for each output.
% SIMMEANCOMPUTE Give the output of the SIM mean function model for given X.
% DEMSPMGPCMU49BALANCEARM5 Demonstrate latent force model on CMU data using an
% MULTIGPCOMPUTEALPHA Update the vector `alpha' for computing posterior mean quickly.
% SPMULTIGPUPDATEKERNELS 
% SPMULTIGPEXTRACTPARAM Extract a parameter vector from a sparse MULTIGP model.
% MULTIGPOBJECTIVE Wrapper function for MULTIGPOPTIMISE objective.
% DEMSIMWHITEFXDATA Demonstrate latent force model on exchange rates data.
% DEMGPSIM3 Demo of full multi output GP with the sim kernel using PITC
% SIMMEANEXTRACTPARAM Extract parameters from the SIM MEAN FUNCTION structure.
% MULTIGPUPDATETOPLEVELPARAMS Update parameters at top level from kernel.
% DEMSIMWHITEDTCFXDATA Demonstrate latent force model on exchange rates
% LFMWHITEMEANGRADIENT Gradient of the parameters of the mean function in
% SPARSEKERNCOMPUTE Computes the kernels for the sparse approximation in the convolution process framework.
% DEMCMU49BALANCEARM5 Demonstrate latent force model on CMU data. In this
% MULTIGPLOGLIKELIHOOD Compute the log likelihood of a MULTIGP.
% DEMSIMDTCFXDATA Demonstrate latent force model on exchange rates data
% SPMULTIGPEXPANDPARAM Expand a parameter vector into a SPMULTIGP model.
% MULTIGPPOSTERIORMEANVAR gives mean and variance of the posterior distribution.
% DEMLFMTOY Demonstrate latent force model on TOY data.
% DEMCMU49BALANCEARM1 Demonstrate latent force model on CMU data.
% SIMWHITEMEANGRADIENT Gradient of the parameters of the mean function in
% MULTIGPGRADIENT Gradient wrapper for a MULTIGP model.
% BALANCEMODIFY Update visualisation of skeleton data for balance motion
% DEMSPMGPGGTOY4 Sparse multigp on TOY data using DTC VAR
% CHECKKERNELSYMMETRY Check the kernel symmetry.
% SPMULTIGPLOGLIKELIHOOD Compute the log likelihood of a SPARSE MULTIGP.
% LOADFXDATA Load the text file with the foreign exchange rates data set and store it in a format easily accessible by Matlab.
% TRAINMODELHIGHINGGWHITE Trains the DTC VAR approx for GGWHITE kernel
% BATCHHIGHINPUTSGGWHITE Computes DTC VAR bound and full gp likelihood 
% DEMTOY3 Demo of Sparse Multi Output Gaussian Process using PITC. 
% SIMWHITEMEANEXTRACTPARAM Extract parameters from the SIM-WHITE mean function structure.
% MEANEXPANDPARAM Extract the parameters of the vector parameter and put 
% SPMULTIGPLOCALCOVGRADIENT Computes the derivatives of the likelihood
