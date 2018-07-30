%% Patients
workdir = pwd;
[Data, brind, V] = read_all_nii(workdir, 'population', 'Patients');

seed_mni=[0 53 26];seed_name={'PCC'};seed_radius=6;
CMap = Comp_CMap(Data,V,brind,seed_mni,seed_name,seed_radius);

TS = TS_Extraction(Data,V,seed_mni,seed_radius);

Params = Comp_Params(TS,Data,CMap,brind,1);

TH=15;flag=0;
Centroid = Comp_Centroid(Data,Params,brind,V,TH,flag);

Dir=workdir;State='patients';
[Cap_par, S_CAP] = Comp_CAP(Data,Params,brind,V(1),State,TH,Centroid,Dir);

[FrameInd, CAP_Ind] = Comp_FrameInd(Params,TH,Cap_par);

%% Controls
workdir = pwd;
[Data, brind, V] = read_all_nii(workdir, 'population', 'Controls');

seed_mni=[0 53 26];seed_name={'PCC'};seed_radius=6;
CMap = Comp_CMap(Data,V,brind,seed_mni,seed_name,seed_radius);

TS = TS_Extraction(Data,V,seed_mni,seed_radius);

Params = Comp_Params(TS,Data,CMap,brind,1);

TH=15;flag=0;
Centroid = Comp_Centroid(Data,Params,brind,V,TH,flag);

Dir=workdir;State='controls';
[Cap_par, S_CAP] = Comp_CAP(Data,Params,brind,V(1),State,TH,Centroid,Dir);

[FrameInd, CAP_Ind] = Comp_FrameInd(Params,TH,Cap_par);