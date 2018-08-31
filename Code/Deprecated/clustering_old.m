function clustering_old(population)

workdir = pwd;
TH = 15;
load(fullfile(workdir,['TotFrames_' population '.mat']));
load(fullfile(workdir,['extras_' population '.mat']));

Centroid = Comp_Centroid_single(TotFrames,brind,V,1);

Dir = workdir;State = population;

[Cap_par, S_CAP] = Comp_CAP_single(TotFrames,brind,V(1),TH,State,Centroid,Dir);