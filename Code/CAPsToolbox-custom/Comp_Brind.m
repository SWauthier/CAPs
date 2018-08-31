function [brind, V] = Comp_Brind(workpath, varargin)

% Computes brain index from all subjects

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

brain_mask = {};

fprintf('Start read-in \n');

for i = 1:len
    brainmask = [workdir filesep per filesep files(i).name filesep 'rbrainmask.nii']; %path to the brain mask
    vmask = spm_vol(brainmask);
    brain_mask{i} = spm_read_vols(vmask);

    fprintf([num2str(i) '/' num2str(len) '\n']);
end

fprintf('Generating mask \n');
summask = brain_mask{1};
for k=2:length(brain_mask)
    summask = summask .* brain_mask{k};
end
brind = find(summask)'; %find voxels in the brain according to the mask

dataname = ls([workdir filesep per filesep files(i).name filesep 'niftiDATA*.nii']);
datafile = [workdir filesep per filesep files(i).name filesep dataname]; %change if needed
V = spm_vol(datafile);

return