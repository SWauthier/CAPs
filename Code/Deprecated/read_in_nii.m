% cd 'D:\Documents\University\Thesis 2\Data_zipped'
workdir = pwd;

files = dir([workdir filesep 'Controls']);
files = files(~ismember({files.name},{'.','..'}));

len = floor(length(files)/4);

brain_mask = {};
Data = {};
for i = 1:len

brainmask = [workdir filesep 'Controls' filesep files(i).name filesep 'rbrainmask.nii']; %link to the brain mask
vmask = spm_vol(brainmask);
brain_mask{i} = spm_read_vols(vmask);
brind = find(brain_mask{i})'; %find voxels in the brain according to the mask

dataname = ls([workdir filesep 'Controls' filesep files(i).name filesep 'niftiDATA*.nii']);
datafile = [workdir filesep 'Controls' filesep files(i).name filesep dataname]; %change if needed
V=spm_vol(datafile);
data1 = spm_read_vols(V);
nobs = size(data1,4);
data1 = reshape(data1,[],nobs)';
Data{i} = data1;

fprintf([num2str(i) '/' num2str(len) '\n']);

end

summask = brain_mask{1};
for k=2:length(brain_mask)
    summask = summask + brain_mask{k};
end
summask=summask/length(brain_mask);

brind = find(summask)'; %find voxels in the brain according to the mask

clearvars -except workdir Data brind V