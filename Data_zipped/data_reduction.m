population = 'Patients';

seed_mni=[0 53 26]; seed_name={'PCC'}; seed_radius=6;
TH=15;

workdir = pwd;
files = dir([workdir filesep population]);
files = files(~ismember({files.name},{'.','..'}));

len = length(files);
num_seed = size(seed_mni,1);

CMap = cell(1,num_seed);
TS = cell(1,num_seed);
Params = {};

[brind, V]  = Comp_Brind(workdir,'population',population);

for i = 1:len
    fprintf('\n Processing Subj %d \n',i);
    
    Data = read_nii(workdir, i);

    [CMap, TS] = Comp_CMap_single(Data,V,brind,seed_mni,seed_name,seed_radius);
    
    [Params.Ind1, Params.Rate1, Params.SpatCorr1] = Comp_Params_single(TS,Data,CMap,brind,1);
    
    Frames = Comp_Frames(Data,Params,TH);
    
    fprintf('\n Saving \n');
    save(['Frames' filesep 'Frames_' num2str(i) '.mat'],'Frames');
end

m = matfile(['TotFrames_' population '.mat'],'Writable',true);
m.TotFrames = [];
x = 1;
for i = 1:len
    
    fprintf('\n Processing subject %d \n',i);
    load(['Frames_' num2str(i) '.mat'])
    xend = x + size(Frames,1) - 1; yend = size(Frames,2);
    m.TotFrames(x:xend,1:yend) = Frames;
    x = xend + 1;
    
end

% clearvars -except brind V TH workdir m