function clustering(population,reference)

% Clustering with respect to a reference set of centroids.

workdir = pwd;
TH = 15;
load(fullfile(workdir,['TotFrames_' population '.mat']));
load(fullfile(workdir,['extras_' population '.mat']));
load(fullfile(workdir,['Centroid_Liu_' reference '.mat']));

Dir = workdir;State = population;

[Cap_par, S_CAP] = Comp_CAP_single(TotFrames,brind,V(1),TH,State,Centroid,Dir);