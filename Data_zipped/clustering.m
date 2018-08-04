population = 'Patients';

workdir = pwd;
TH = 15;
m = matfile(['TotFrames_' population '.mat'],'Writable',true);
TotFrames = m.TotFrames(1:200,:);
% load(fullfile(workdir,['TotFrames_' population '.mat']));
[brind, V] = Comp_Brind(workdir,'population',population);

flag = 1;
Centroid = Comp_Centroid_single(TotFrames,brind,V,flag);

Dir = workdir;State = population;
[Cap_par, S_CAP] = Comp_CAP_single(TotFrames,brind,V(1),TH,State,Centroid,Dir);

exit;