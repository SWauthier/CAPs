population = 'Controls';

workdir = pwd;
TH = 15;
load(fullfile(workdir,['TotFrames_' population '.mat']));
load('extras_C.mat')

flag = 1;
Centroid = Comp_Centroid_single(TotFrames,brind,V,flag);

Dir = workdir;State = population;
[Cap_par, S_CAP] = Comp_CAP_single(TotFrames,brind,V(1),TH,State,Centroid,Dir);

population = 'Patients';

workdir = pwd;
TH = 15;
load(fullfile(workdir,['TotFrames_' population '.mat']));
load('extras_P.mat')
% [brind, V] = Comp_Brind(workdir,'population',population);

flag = 1;
Centroid = Comp_Centroid_single(TotFrames,brind,V,flag);

Dir = workdir;State = population;
[Cap_par, S_CAP] = Comp_CAP_single(TotFrames,brind,V(1),TH,State,Centroid,Dir);