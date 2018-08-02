population = 'Patients';

seed_mni=[0 53 26]; seed_name={'PCC'}; seed_radius=6;
TH=15;

workdir = pwd;
files = dir([workdir filesep population]);

len = length(files);
num_seed = size(seed_mni,1);

CMap = cell(len,num_seed);
TS = cell(len,num_seed);
Params = {};
Frames = [];
for i = 1:len
    [Data, brind, V] = read_nii(workdir, i);

    fprintf('\n Processing Subj %d \n',i);
    [CMap, TS] = Comp_CMap_single(Data,V,brind,seed_mni,seed_name,seed_radius);
    
    [Params.Ind1(i,:), Params.Rate1(i,:), Params.SpatCorr1(i,:)] = Comp_Params_single(TS,Data,CMap,brind,1);
    
    NewFrames = Comp_Frames(Data,Params,TH,i);
    Frames = [Frames; NewFrames];
end

flag=0;
Centroid = Comp_Centroid_single(Frames,brind,V,flag);

Dir=workdir;State='test_patients';
[Cap_par, S_CAP] = Comp_CAP_single(Frames,brind,V(1),TH,State,Centroid,Dir);