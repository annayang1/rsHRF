function HRFrs = tbx_cfg_rsHRF
% Configuration file for toolbox 'rsHRF'
% https://github.com/guorongwu/rsHRF
% $Id: rsHRF.m

if ~isdeployed
	addpath(fullfile(spm('Dir'),'toolbox','rsHRF'));
end

% ---------------------------------------------------------------------
% NIfTI Data
% ---------------------------------------------------------------------
NIfTI_Data         = cfg_files;
NIfTI_Data.tag     = 'images';
NIfTI_Data.name    = 'Preprocessed Volumes';
NIfTI_Data.help    = {'Select NIfTI images.'};
NIfTI_Data.filter  = 'image';
NIfTI_Data.ufilter = '.*';
NIfTI_Data.num     = [1 inf];
NIfTI_Data.help    = {'3D or 4D NIfTI images;'
    'or select 1st volume/frame of a 4D NIfTI file,'
    'we will expand all the volumes from this file.'};

% ---------------------------------------------------------------------
% ROI signal Data
% ---------------------------------------------------------------------
Signal_file         = cfg_files;
Signal_file.tag     = 'sigdata';
Signal_file.name    = 'Preprocessed ROI signals';
Signal_file.help    = {'Select ROI signal files.'};
Signal_file.filter  = 'any';
Signal_file.ufilter = '.*';
Signal_file.num     = [1 1];
Signal_file.help    = { 'Select the *.txt/*.mat file(s) containing your ROI signal.' };

% ---------------------------------------------------------------------
% name Name
% ---------------------------------------------------------------------
name         = cfg_entry;
name.tag     = 'name';
name.name    = 'Variable Name in Mat-file';
name.help    = {
    'Only for *.mat file'
    'Enter the variable name of your ROI signals in Mat file; eg. ''data'' '};
name.strtype = 's';
name.val    = {''};
name.num     = [1 inf];

Signal_Dat         = cfg_branch;
Signal_Dat.tag     = 'Datasig';
Signal_Dat.name    = 'Data';
Signal_Dat.val  = {Signal_file, name};
Signal_Dat.help    = {
    'Select the *.txt/*.mat file(s) containing details of your ROI signal.' 
    'You will need to enter the "Variable Name in Mat-file" if you select Mat-file '
    };

Signal_Data         = cfg_repeat;
Signal_Data.tag     = 'Data';
Signal_Data.name    = 'Data';
Signal_Data.values  = {Signal_Dat};
Signal_Data.num     = [1 inf];
Signal_Data.help    = {
    'The same parameters specified below '
    'will be applied to all data'
    };
% ---------------------------------------------------------------------
% odir Output Directory
% ---------------------------------------------------------------------
Outdir         = cfg_files;
Outdir.tag     = 'outdir';
Outdir.name    = 'Output Directory';
Outdir.help    = {'Select the directory where write analysis results.'};
Outdir.filter = 'dir';
Outdir.ufilter = '.*';
Outdir.num     = [1 1];
Outdir.val     = {{''}};
% ---------------------------------------------------------------------
% RT Interscan interval
% ---------------------------------------------------------------------
TR         = cfg_entry;
TR.tag     = 'TR';
TR.name    = 'TR';
TR.help    = {'Interscan interval, TR, (specified in seconds).  This is the time between acquiring a plane of one volume and the same plane in the next volume.  It is assumed to be constant throughout.'};
TR.strtype = 'r';
TR.num     = [1 1];

% ---------------------------------------------------------------------
% Bands
% ---------------------------------------------------------------------
Bands         = cfg_entry;
Bands.tag     = 'bands';
Bands.name    = 'Band-pass filter(Hz)';
Bands.help    = {'0.01 ~ 0.1 Hz. '};
Bands.strtype = 'e';
Bands.val     = {[0.01, 0.1]};
Bands.num     = [1 2];

TR2filter   = TR;
TR2filter.val     = {nan};
TR2filter.help    = {'Keep "nan" if it has been specified in HRF estimation step.'};

% ---------------------------------------------------------------------
% Bandfilters
% ---------------------------------------------------------------------
Bandfilter         = cfg_repeat;
Bandfilter.tag     = 'BPF';
Bandfilter.name    = 'Band-pass Filter';
Bandfilter.help    = {'Band-pass Filter.'};
Bandfilter.values  = {Bands,TR2filter};
Bandfilter.num     = [0 2];

% ---------------------------------------------------------------------
% Despiking
% ---------------------------------------------------------------------
Despiking         = cfg_menu;
Despiking.tag     = 'Despiking';
Despiking.name    = 'Despiking';
Despiking.help    = {'Temporal despiking with a hyperbolic tangent squashing function'};
Despiking.labels = {'No', 'Yes'};
Despiking.values = {0,1};         
Despiking.val    = {0};

% ---------------------------------------------------------------------
% Detrend
% ---------------------------------------------------------------------
Detrending         = cfg_menu;
Detrending.tag     = 'Detrend';
Detrending.name    = 'Polynomial Detrending';
Detrending.help    = {'...'};
Detrending.labels = {'No', 'Linear', '2nd order Poly', '3rd order Poly'};
Detrending.values = {0,1,2,3};         
Detrending.val    = {0};

% ---------------------------------------------------------------------
% ROI
% ---------------------------------------------------------------------
ROIs_coordinate         = cfg_entry;
ROIs_coordinate.tag     = 'ROI';
ROIs_coordinate.name    = 'ROI (x,y,z,radius [in mm])';
ROIs_coordinate.strtype = 'e';
ROIs_coordinate.num     = [inf 4];
ROIs_coordinate.val	  = {[4,-53,26,6];};
ROIs_coordinate.help    = {'ROI (x, y & z, in mm, with k mm radius)'};

% ---------------------------------------------------------------------
% ROI mask
% ---------------------------------------------------------------------
ROImasks         = cfg_files;
ROImasks.tag     = 'images';
ROImasks.name    = 'ROI mask images';
ROImasks.help    = {'Select ROI mask images (>=1).'};
ROImasks.filter  = 'image';
ROImasks.ufilter = '.*';
ROImasks.val     = {{''}};
ROImasks.num     = [1 inf];
ROImasks.help    = {'you can select more than one NIfTI image'};

% ---------------------------------------------------------------------
% White matter/CSF/Whole brain mask
% ---------------------------------------------------------------------

covmasks = ROImasks ;
covmasks.name    = 'Covariate images (white matter, CSF, whole brain mask etc.)';

% ---------------------------------------------------------------------
% Mean or Principal component for covariate images
% ---------------------------------------------------------------------
mpc         = cfg_entry;
mpc.tag     = 'mpc';
mpc.name    = 'Mean or Eigenvariate';
mpc.help    = {'0: mean signal'
'1: 1st eigenvariate (principal component,PC)'    
'5: 1st to 5th eigenvariates'    
'[0 1 2]: Extract mean from the 1st mask, 1st PC from 2nd mask, 1st to 2nd PCs from 3rd mask'
};
mpc.strtype = 'e';
mpc.val     = {[0]};
mpc.num     = [1 inf];


WMCSFmasks = cfg_branch;
WMCSFmasks.tag     = 'imcov';
WMCSFmasks.name    = 'Image Covariates';
WMCSFmasks.help    = {'Regressors that may confound the data.'};
WMCSFmasks.val  = {covmasks, mpc};

% ---------------------------------------------------------------------
% multi_reg Multiple regressors
% ---------------------------------------------------------------------
multi_reg         = cfg_files;
multi_reg.tag     = 'multi_reg';
multi_reg.name    = 'Multiple regressors';
multi_reg.val     = {{''}};
multi_reg.help    = {
                     'Select the *.txt/*.mat file(s) containing details of your multiple regressors. '
                     'If you have multiple regressors eg. realignment parameters (rp_*.txt), then entering the details a regressor at a time is very inefficient. This option can be used to load all the required information in one go. '
                     'You will first need to create a *.mat file containing a matrix R or a *.txt file containing the regressors. Each column of R will contain a different regressor.'
                     ''
                     }';
multi_reg.filter = 'mat';
multi_reg.ufilter = '.*';
multi_reg.num     = [0 Inf];



% ---------------------------------------------------------------------
% generic Regressors
% ---------------------------------------------------------------------
covreg         = cfg_repeat;
covreg.tag     = 'generic';
covreg.name    = 'Nuisance Covariates';
covreg.help    = {'Regressors that may confound the data.'};
covreg.values  = {multi_reg WMCSFmasks};
covreg.num     = [0 Inf];

% ---------------------------------------------------------------------
% ROI Atlas
% ---------------------------------------------------------------------
Atlas         = cfg_files;
Atlas.tag     = 'atlas';
Atlas.name    = 'Atlas image';
Atlas.help    = {'Select a Atlas image.'};
Atlas.filter  = 'image';
Atlas.ufilter = '.*';
Atlas.val     = {{''}};
Atlas.num     = [1 1];

% ---------------------------------------------------------------------
% ROI All together
% ---------------------------------------------------------------------
genericROI         = cfg_repeat;
genericROI.tag     = 'genericROI';
genericROI.name    = 'ROI (Coordinate / NIfTI)';
genericROI.help    = {
                   'Select ROIs (Coordinates / NIfTI)'
}';
genericROI.values  = {ROIs_coordinate ROImasks Atlas};
genericROI.num     = [1 Inf];

% ---------------------------------------------------------------------
% Denoising 
% ---------------------------------------------------------------------
Denoising         = cfg_branch;
Denoising.tag     = 'Denoising';
Denoising.name    = 'Denoising';
Denoising.val     = {covreg, Detrending, Bandfilter, Despiking};
Denoising.help    = {'Remove possible confounds.'};

% ---------------------------------------------------------------------
% Despiking
% ---------------------------------------------------------------------
rmoutlier         = cfg_menu;
rmoutlier.tag     = 'rmoutlier';
rmoutlier.name    = 'Remove Outlier& Inpaint 3D';
rmoutlier.help    = {'Remove Outlier in HRF parameters (replaced by nan ) and inpaint nan value by inpaint_nans3.m'};
rmoutlier.labels = {'No', 'Yes'};
rmoutlier.values = {0,1};         
rmoutlier.val    = {1};

% ---------------------------------------------------------------------
% Explicit Mask
% ---------------------------------------------------------------------
brainmask         = cfg_files;
brainmask.tag     = 'mask';
brainmask.name    = 'Explicit Mask';
brainmask.help    = {'Specify an image for expicity masking the analysis.'};
brainmask.filter  = 'image';
brainmask.ufilter = '.*';
brainmask.val     = {{''}};
brainmask.num = [1 1];

%--------------------------------------------------------------------------
% prefix Filename Prefix
%--------------------------------------------------------------------------
prefix         = cfg_entry;
prefix.tag     = 'prefix';
prefix.name    = 'Filename prefix';
prefix.strtype = 's';
prefix.num     = [1 Inf];
prefix.help    = {'String to be prepended to the filenames of the HRF deconvolved image file(s). Default prefix is ''Deconv_''.'};
prefix.val     =  {'Deconv_'};

%--------------------------------------------------------------------------
% HRF model
%--------------------------------------------------------------------------
hrfm         = cfg_menu;
hrfm.tag     = 'hrfm';
hrfm.name    = 'HRF Basis Functions';
hrfm.labels = {
              'Canon2DD'              
              'FIR'
              'CanonTD'
              'sFIR'}';
hrfm.values = {1,2,3,4};         
hrfm.val    = {1};
hrfm.help    = {
'Canon2DD: Canonical HRF with Time and Dispersion Derivatives'
'FIR: Finite Impulse Response'    
'CanonTD: Canonical HRF with Time Derivative'
};

% ---------------------------------------------------------------------
% length of HRF {seconds} 
% ---------------------------------------------------------------------
hrflen         = cfg_entry;
hrflen.tag     = 'hrflen';
hrflen.name    = 'Length of HRF (seconds)';
hrflen.help    = {'Enter the length of HRF {seconds} '};
hrflen.strtype = 'r';
hrflen.num     = [Inf 1];
hrflen.val    = {32};

% ---------------------------------------------------------------------
% Bands
% ---------------------------------------------------------------------
mdelay         = cfg_entry;
mdelay.tag     = 'mdelay';
mdelay.name    = 'minimum & maximum delay (seconds)';
mdelay.help    = {'4 ~ 8 s'};
mdelay.strtype = 'e';
mdelay.val     = {[4, 8]};
mdelay.num     = [1 2];

% ---------------------------------------------------------------------
% RT Interscan interval
% ---------------------------------------------------------------------
thr         = cfg_entry;
thr.tag     = 'thr';
thr.name    = 'Threshold (SD) for event detection';
thr.help    = {'default Threshold = 1, i.e. Threshold*standard deviation threshold to detect event'};
thr.strtype = 'r';
thr.val     = {1};
thr.num     = [1 1];

% ---------------------------------------------------------------------
% cvi Serial correlations
% ---------------------------------------------------------------------
cvi         = cfg_menu;
cvi.tag     = 'cvi';
cvi.name    = 'Serial correlations';
cvi.help    = {
               'Serial correlations in fMRI time series due to aliased biorhythms and unmodelled neuronal activity can be accounted for using an autoregressive AR(1) model during parameter estimation.  '
%                'This estimate assumes the same correlation structure for each voxel, within each session.  ReML estimates are then used to correct for non-sphericity during inference by adjusting the statistics and degrees of freedom appropriately.  The discrepancy between estimated and actual intrinsic (i.e. prior to filtering) correlations are greatest at low frequencies.  Therefore specification of the high-pass filter is particularly important. '
%                'Serial correlation can be ignored if you choose the ''none'' option. Note that the above options only apply if you later specify that your model will be estimated using the Classical (ReML) approach. If you choose Bayesian estimation these options will be ignored. For Bayesian estimation, the choice of noisemodel (AR model order) is made under the estimation options. '
}';
cvi.labels  = {'none', 'AR(1)', 'AR(2)','AR(3)'};
cvi.values  = {0,1,2,3};
cvi.val    = {0};

% ---------------------------------------------------------------------
% fmri_t Microtime resolution
% ---------------------------------------------------------------------
fmri_t         = cfg_entry;
fmri_t.tag     = 'fmri_t';
fmri_t.name    = 'Microtime resolution';
fmri_t.help    = {
'value >1 works for Canon2DD or CanonTD'    
''
                  'The microtime resolution, t, is the number of time-bins per scan used when building regressors. '
                  'If you have performed slice-timing correction, change this parameter to match the number of slices specified there; otherwise, you would typically not need to change this.'
                  ''
}';
fmri_t.strtype = 'n';
fmri_t.num     = [1 1];
fmri_t.val     = {1};
% ---------------------------------------------------------------------
% fmri_t0 Microtime onset
% ---------------------------------------------------------------------
fmri_t0         = cfg_entry;
fmri_t0.tag     = 'fmri_t0';
fmri_t0.name    = 'Microtime onset';
fmri_t0.help    = {
    'value >1 works for Canon2DD or CanonTD'    
''
                   'The microtime onset, t0, is the reference time-bin at which the regressors are resampled to coincide with data acquisition.'
                   'If you have performed slice-timing correction, you must change this parameter to match the reference slice specified there.'
                   'Otherwise, you might still want to change this if you have non-interleaved acquisition and you wish to sample the regressors so that they are appropriate for a slice in a particular part of the brain.'
                   'For example, if t0 = 1, then the regressors will be appropriate for the first slice; if t0=t, then the regressors will be appropriate for the last slice.'
                   'Setting t0 = t/2 is a good compromise if you are interested in slices at the beginning and end of the acquisition, or if you have interleaved data, or if you have 3D EPI data.'
                   ''
}';
fmri_t0.strtype = 'n';
fmri_t0.num     = [1 1];
fmri_t0.val     = {1};

% ---------------------------------------------------------------------
% HRF estimation 
% ---------------------------------------------------------------------
HRFE         = cfg_branch;
HRFE.tag     = 'HRFE';
HRFE.name    = 'HRF estimation';
HRFE.val     = {hrfm, TR, hrflen,thr, mdelay, cvi, fmri_t, fmri_t0 };
HRFE.help    = {'HRF estimation.'};

% ---------------------------------------------------------------------
% save deconvolved signal
% ---------------------------------------------------------------------
deconv_save         = cfg_menu;
deconv_save.tag     = 'deconv_save';
deconv_save.name    = 'Save Deconvolved Data';
deconv_save.labels = {'No', 'Yes'};
deconv_save.values = {0,1};         
deconv_save.val    = {1};
deconv_save.help    = {'...'};

% ---------------------------------------------------------------------
% save HRF in mat-file
% ---------------------------------------------------------------------
hrfmat_save         = deconv_save;
hrfmat_save.tag     = 'hrfmat_save';
hrfmat_save.name    = 'Save HRF in mat-file';

% ---------------------------------------------------------------------
% save HRF in NIfTI-file
% ---------------------------------------------------------------------
hrfnii_save         = deconv_save;
hrfnii_save.tag     = 'hrfnii_save';
hrfnii_save.name    = 'Save HRF in NIfTI-file';

% ---------------------------------------------------------------------
% save Job parameters in mat-file
% ---------------------------------------------------------------------
job_save         = deconv_save;
job_save.tag     = 'job_save';
job_save.name    = 'Save job parameters';

% ---------------------------------------------------------------------
% Save files
% ---------------------------------------------------------------------
Datasave         = cfg_branch;
Datasave.tag     = 'savedata';
Datasave.name    = 'Save Data';
Datasave.val     = {deconv_save,hrfmat_save,hrfnii_save, job_save};
Datasave.help    = {'Save files.'};

DatasaveROI = Datasave;
DatasaveROI.val     = {deconv_save,hrfmat_save, job_save};

% ---------------------------------------------------------------------
% seed to voxels or ROI2ROI
% ---------------------------------------------------------------------
seedROI         = cfg_menu;
seedROI.tag     = 'Seed_ROI';
seedROI.name    = 'Seed or ROI';
seedROI.help    = {'Seed: 1 to n'; ' ROI: n to n'};
seedROI.labels = {'Seed to voxels', 'ROI to ROI'};
seedROI.values = {0,1};         
seedROI.val    = {0};

% ---------------------------------------------------------------------
% connectivity method FC
% ---------------------------------------------------------------------
FCM         = cfg_menu;
FCM.tag     = 'method';
FCM.name    = 'Method';
FCM.help    = {'...'};
FCM.labels = {'Pearson correlation', 'Spearman correlation'};
FCM.values = {3,4};         
FCM.val    = {3};

% ---------------------------------------------------------------------
% connectivity method GC
% ---------------------------------------------------------------------
GCM         = FCM;
GCM.labels = {'Pairwise GC(Granger causality)', 'Conditional GC (only for ROIs)', 'Partially Conditioned GC (only for ROIs)'};
GCM.values = {1,2,5};         
GCM.val    = {1};


% ---------------------------------------------------------------------
% data for connectivity 
% ---------------------------------------------------------------------
CONNData         = cfg_menu;
CONNData.tag     = 'data4conn';
CONNData.name    = 'Data for Connectivity';
CONNData.help    = {'Select BOLD or/and Deconvolved BOLD'};
CONNData.labels = {'BOLD', 'Deconvolved BOLD', 'BOLD and Deconvolved BOLD'};
CONNData.values = {1,2,3};         
CONNData.val    = {2};

% ---------------------------------------------------------------------
% Model order for GC
% ---------------------------------------------------------------------
Morder         = cfg_entry;
Morder.tag     = 'morder';
Morder.name    = 'Model order for GC';
Morder.help    = {'default model order = 1, input only for Granger causality analysis'};
Morder.strtype = 'r';
Morder.val     = {1};
Morder.num     = [1 1];

% ---------------------------------------------------------------------
% Information for PCGC
% ---------------------------------------------------------------------
ndinfo         = cfg_entry;
ndinfo.tag     = 'ndinfo';
ndinfo.name    = 'Parameters for PCGC';
ndinfo.help    = {'Number of conditional variable (nd), Maximum nd'
    'Parameters for Partially Conditioned Granger Causality Analysis'
    'Recommended value: nd = 6, maximum nd = nd+1'};
ndinfo.strtype = 'r';
ndinfo.val     = {[nan nan]};
ndinfo.num     = [1 2];

%--------------------------------------------------------------------------
% prefix Connectivity Prefix
%--------------------------------------------------------------------------
conname = prefix;
conname.val    =  {'Conn_'};
conname.num = [1 Inf];
conname.help ={'String to be prepended to the filenames of the connectivity file(s). Default prefix is "Conn_".'};

% ---------------------------------------------------------------------
% Connectivity Analysis FC
% ---------------------------------------------------------------------
FCA         = cfg_branch;
FCA.tag     = 'conn';
FCA.name    = 'FC';
FCA.val     = {CONNData, seedROI, genericROI, FCM, conname};
FCA.help    = {'Functional connectivity analysis.'};

FCA2 = FCA;
FCA2.val     = {seedROI, genericROI, FCM, conname};


FCAROI = FCA;
FCAROI.val     = {CONNData, FCM, conname};
FCAROI2 = FCAROI;
FCAROI2.val     = {FCM,  conname};

% ---------------------------------------------------------------------
% Connectivity Analysis GC
% ---------------------------------------------------------------------
GCA         = cfg_branch;
GCA.tag     = 'connG';
GCA.name    = 'GC';
GCA.val     = {CONNData, seedROI, genericROI, GCM, Morder, ndinfo, conname};
GCA.help    = {'Granger causality analysis.'};

GCA2 = GCA;
GCA2.val     = {seedROI, genericROI, GCM, Morder, ndinfo, conname};


GCAROI = GCA;
GCAROI.val     = {CONNData, GCM, Morder, ndinfo, conname};
GCAROI2 = GCAROI;
GCAROI2.val     = {GCM, Morder, ndinfo,conname};

% connectivity
% ---------------------------------------------------------------------
cona         = cfg_repeat;
cona.tag     = 'connectivity';
cona.name    = 'Connectivity Analysis';
cona.help    = {'Granger causality or Functional connectivity analysis.'};
cona.values  = {FCA,GCA};
cona.num     = [0 inf];

cona2 = cona;
cona2.values  = {FCA2,GCA2};


connROI = cona;
connROI.values  = {FCAROI, GCAROI};
connROI2 = cona;
connROI2.values  = {FCAROI2, GCAROI2};


% ---------------------------------------------------------------------
% ROI-wise HRF deconvolution
% ---------------------------------------------------------------------
ROI_rsHRF         = cfg_exbranch;
ROI_rsHRF.tag     = 'ROI_rsHRF';
ROI_rsHRF.name    = 'ROI-wise HRF deconvolution';
ROI_rsHRF.val     = {NIfTI_Data, genericROI, HRFE,Denoising, brainmask, connROI, Outdir, DatasaveROI, prefix};
ROI_rsHRF.prog = @wgr_vox_ROI_rsHRF_conn;
ROI_rsHRF.help    = {'NIfTI data'}; %{'ROI-wise HRF deconvolution'};

% ---------------------------------------------------------------------
% ROI-wise CONN
% ---------------------------------------------------------------------
ROI_conn         = cfg_exbranch;
ROI_conn.tag     = 'ROI_conn';
ROI_conn.name    = 'ROI-wise Connectivity Analysis';
ROI_conn.val     = {NIfTI_Data, genericROI, Denoising, brainmask, connROI2, Outdir,job_save};
ROI_conn.prog = @wgr_vox_ROI_rsHRF_conn;
ROI_conn.help    = {'NIfTI data'};

% ---------------------------------------------------------------------
% voxel-wise HRF deconvolution
% ---------------------------------------------------------------------
vox_rsHRF         = cfg_exbranch;
vox_rsHRF.tag     = 'vox_rsHRF';
vox_rsHRF.name    = 'Voxel-wise HRF deconvolution';
vox_rsHRF.val     = {NIfTI_Data, HRFE, Denoising, rmoutlier,brainmask, cona, Outdir, Datasave, prefix};
vox_rsHRF.prog = @wgr_vox_ROI_rsHRF_conn;
vox_rsHRF.help    = {'NIfTI data'}; %{'Voxel-wise HRF deconvolution'};

% ---------------------------------------------------------------------
% voxel-wise CONN
% ---------------------------------------------------------------------
vox_conn         = cfg_exbranch;
vox_conn.tag     = 'vox_conn';
vox_conn.name    = 'Voxel-wise Connectivity Analysis';
vox_conn.val     = {NIfTI_Data, Denoising, brainmask, cona2, Outdir, job_save};
vox_conn.prog = @wgr_vox_ROI_rsHRF_conn;
vox_conn.help    = {'NIfTI data'};

% ---------------------------------------------------------------------
% ROI-signal HRF deconvolution
% ---------------------------------------------------------------------
sig_rsHRF         = cfg_exbranch;
sig_rsHRF.tag     = 'sig_rsHRF';
sig_rsHRF.name    = 'ROI signal HRF deconvolution';
sig_rsHRF.val     = {Signal_Data, HRFE, Denoising, connROI, Outdir, DatasaveROI, prefix};
sig_rsHRF.help    = {'..'};
sig_rsHRF.prog = @wgr_sig_rsHRF_conn;
sig_rsHRF.help    = {'Please DO NOT select NIFTI files in Nuisance Covariates!'}; %{'ROI-signal HRF deconvolution'
%'Please DO NOT select NIFTI files in Nuisance Covariates!'    
%};

% ---------------------------------------------------------------------
% ROI-signal CONN
% ---------------------------------------------------------------------
sig_conn         = cfg_exbranch;
sig_conn.tag     = 'sig_conn';
sig_conn.name    = 'ROI-signal Connectivity Analysis';
sig_conn.val     = {Signal_Data, Denoising, connROI2, Outdir,job_save};
sig_conn.help    = {'..'};
sig_conn.prog = @wgr_sig_rsHRF_conn;
sig_conn.help    = {'Please DO NOT select NIFTI files in Nuisance Covariates!'};

% ---------------------------------------------------------------------
% rsHRF deconvolution & connectivity analysis
% ---------------------------------------------------------------------
HRFrs         = cfg_choice;
HRFrs.tag     = 'rsHRF';
HRFrs.name    = 'rsHRF';
HRFrs.help    = {'resting state HRF deconvolution and connectivity analysis.'};
HRFrs.values  = {vox_rsHRF, ROI_rsHRF, sig_rsHRF, vox_conn, ROI_conn, sig_conn};

%======================================================================
function wgr_vox_ROI_rsHRF_conn(job)
rsHRF(job,'vox')
%======================================================================
function wgr_sig_rsHRF_conn(job)
rsHRF(job,'sig')
