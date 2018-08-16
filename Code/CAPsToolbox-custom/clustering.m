function clustering(population, Centroid)

workdir = pwd;
TH = 15;
load(fullfile(workdir,['TotFrames_' population '.mat']));
load(fullfile(workdir,['extras_' population '.mat']));

Dir = workdir;State = population;

[Cap_par, S_CAP] = Comp_CAP_single(TotFrames,brind,V(1),TH,State,Centroid,Dir);