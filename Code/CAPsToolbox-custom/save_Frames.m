function m = save_Frames(population)

% Computes relevant time points in CAP data reduction proces and (1) saves
% frames for each dataset in separate .mat file, (2) merges separate files
% into one MAT-file with write access. Subsequently, returns MAT-file
% object connected to existing MAT-file.
%
% Input:
% population - the population to be computed on. ('Patients' or 'Controls')
%
% Output:
% m - MAT-file object connected to existing MAT-file.
%__________________________________________________________________________


pop = population;

seed_mni=[0 53 26]; %MFG
seed_radius=6;
TH=15; %~1SD

workdir = pwd;
files = dir([workdir filesep pop]);
files = files(~ismember({files.name},{'.','..'}));

len = length(files);

[brind, V]  = Comp_Brind(workdir,'population',pop);
save(['extras_' pop '.mat'],'brind','V');

for i = 1:len
    fprintf('\n Processing Subj %d \n',i);
    
    Data = read_nii(workdir, i, 'population', pop);

    [CMap, TS] = Comp_CMap_single(Data,V,brind,seed_mni,seed_radius);
    
    Params = Comp_Params_single(TS,Data,CMap,brind);
    
    Frames = Comp_Frames(Data,Params,TH);
    
    fprintf('\n Saving \n');
    save(['Frames_' pop filesep 'Frames_' num2str(i) '.mat'],'Frames');
end

fprintf('\n Creating MATfile \n');
m = matfile(['TotFrames_' pop '.mat'],'Writable',true);
m.TotFrames = [];
x = 1;
for i = 1:len
    fprintf('\n Processing subject %d \n',i);
    load(['Frames_' pop filesep 'Frames_' num2str(i) '.mat'],'Frames')
    xend = x + size(Frames,1) - 1; yend = size(Frames,2);
    m.TotFrames(x:xend,1:yend) = Frames;
    x = xend + 1;
end

load handel
sound(y,Fs)

return