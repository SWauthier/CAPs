function [Data, brind, V] = read_all_nii(workpath, varargin)
% This function reads in all the data. 
%
% Format:
% [Data, brind, V] = read_all_nii(workpath,'length',len,'population',pop)
%
% Input:
% workpath - character array of the path to the data. (Assumes different
% nifti files in different folders: ~data/"sample"/"person"/niftiDATA*.nii.)
% Optional: 'length' - amount of persons to be read in. 
%   Default = 0, i.e. all data.
% Optional: 'population' - choose 'Patients' or 'Controls'. 
%   Default = 'Patients'.
%
% Output: 
% Data - cell array of data of chosen population.
% brind - brain mask, organized as 1xM, with M=number of brain voxels.
% V - spm vector of structures containing image volume information. Needed 
% as reference for the voxel to world transformation.


workdir = workpath;

fprintf(['Parsing \n']);

defaultLength = 0;
defaultPopulation = 'Patients';
expectedPopulation = {'Patients','Controls'};

p = inputParser;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(p,'workpath',@ischar);
addOptional(p,'length',defaultLength,validScalarPosNum);
addParameter(p,'population',defaultPopulation,@(x) any(validatestring(x,expectedPopulation)));
parse(p,workpath,varargin{:});

if strcmp(p.Results.population, 'Controls')
    files = dir([workdir filesep 'Controls']);
    per = 'Controls';
else
    files = dir([workdir filesep 'Patients']);
    per = 'Patients';
end
files = files(~ismember({files.name},{'.','..'}));

if p.Results.length == 0
    len = length(files);
elseif p.Results.length > length(files)
    error('myfuns:read_all_nii:TooBigPopulation','check size of population');
else
    len = p.Results.length;
end

Data = {};
brain_mask = {};

fprintf(['Start read-in \n']);

for i = 1:len

brainmask = [workdir filesep per filesep files(i).name filesep 'rbrainmask.nii']; %path to the brain mask
vmask = spm_vol(brainmask);
brain_mask{i} = spm_read_vols(vmask);

dataname = ls([workdir filesep per filesep files(i).name filesep 'niftiDATA*.nii']);
datafile = [workdir filesep per filesep files(i).name filesep dataname]; %change if needed
V = spm_vol(datafile);
data1 = spm_read_vols(V);
nobs = size(data1,4);
data1 = reshape(data1,[],nobs)';
Data{i} = data1;

fprintf([num2str(i) '/' num2str(len) '\n']);

end

fprintf(['Generating mask \n']);
summask = brain_mask{1};
for k=2:length(brain_mask)
    summask = summask + brain_mask{k};
end
summask=summask/length(brain_mask);
brind = find(summask)'; %find voxels in the brain according to the mask

return