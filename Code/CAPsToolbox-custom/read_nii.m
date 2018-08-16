function [Data, brind, V] = read_nii(workpath, number, varargin)
% This function reads in all the data. 
%
% Format:
% [Data, brind, V] = read_all_nii(workpath,'length',len,'population',pop)
%
% Input:
% workpath - character array of the path to the data. (Assumes different
% nifti files in different folders: ~data/"sample"/"person"/niftiDATA*.nii.)
% number - index of person to be read in.
% Optional: 'population' - choose 'Patients' or 'Controls'. 
%   Default = 'Patients'.
%
% Output: 
% Data - cell array of data of chosen population.
% brind - brain mask, organized as 1xM, with M=number of brain voxels.
% V - spm vector of structures containing image volume information. Needed 
% as reference for the voxel to world transformation.


workdir = workpath;

fprintf('Parsing \n');

defaultPopulation = 'Patients';
expectedPopulation = {'Patients','Controls'};

p = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(p,'workpath',@ischar);
addRequired(p,'number',validScalarPosNum);
addParameter(p,'population',defaultPopulation,@(x) any(validatestring(x,expectedPopulation)));
parse(p,workpath,number,varargin{:});

if strcmp(p.Results.population, 'Controls')
    files = dir([workdir filesep 'Controls']);
    per = 'Controls';
else
    files = dir([workdir filesep 'Patients']);
    per = 'Patients';
end
files = files(~ismember({files.name},{'.','..'}));

if number == 0
    error('myfuns:read_nii:SubjectIndex','please specify number of subject');
elseif number > length(files)
    error('myfuns:read_all_nii:SubjectIndex','please verify number of subject');
else
    num = number;
end

fprintf('Start read-in \n');

brainmask = [workdir filesep per filesep files(num).name filesep 'rbrainmask.nii']; %path to the brain mask
vmask = spm_vol(brainmask);
brain_mask = spm_read_vols(vmask);
brind = find(brain_mask)'; %find voxels in the brain according to the mask

dataname = ls([workdir filesep per filesep files(num).name filesep 'niftiDATA*.nii']);
datafile = [workdir filesep per filesep files(num).name filesep dataname];
V = spm_vol(datafile);
data1 = spm_read_vols(V);
nobs = size(data1,4);
data1 = reshape(data1,[],nobs)';
Data = {data1};

fprintf([num2str(num) '\n']);

return