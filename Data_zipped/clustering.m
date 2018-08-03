population = 'Patients';

workdir = pwd;
TH = 15;
m = matfile('TotFrames.mat','Writable',true);
[brind, V]  = Comp_Brind(workdir,'population',population);

flag = 1;
Centroid = Comp_Centroid_single(m.TotFrames,brind,V,flag);

Dir = workdir;State = population;
[Cap_par, S_CAP] = Comp_CAP_single(m.Frames,brind,V(1),TH,State,Centroid,Dir);