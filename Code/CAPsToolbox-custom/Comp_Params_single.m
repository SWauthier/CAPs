function Params = Comp_Params_single(TS,Data,CMap,brind) 

% This function computes the params needed for the CAP computation.
%  
% usage:
% [Params] = Comp_Params_single(TS,Data,CMap,brind)
%
% Input:
% TS - cell array (number of subjects,number of seeds). Each cell contain the seed Time 
% course Mx1 array with M=number of time points (e.g fMRI volumes).
% Data - cell array (1,number of subjects). Each cell should contain an 
% NxM matrix for N time points (e.g. functional volumes) in M voxels;
% CMap - cell array (number of subjects, number of seeds). Each cell 
% contain the seed-voxel correlation map as a 1xM array with M=number of 
% voxels.It can be saved into an .img/.nii file using the spm_write 
% function (see spm_write help for info). 
% brind - brain mask, organized as 1xM, with M=number of brain voxels.
%
% Output: 
% Params= Struct array of parameters needed for CAPs computation.
%
% Ref: Amico, Enrico, et al. "Posterior Cingulate Cortex-Related 
% Co-Activation Patterns: A Resting State fMRI Study in Propofol-Induced 
% Loss of Consciousness." PloS one 9.6 (2014): e100012.
% 
% Written by EA Sep 2014. (Edited by SW Aug 2018).
%__________________________________________________________________________
% License
%
% This file is part of CAPsTOOLBOX.  It is Copyright (C) Enrico Amico, 
% 
% CAPsTOOLBOX is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% CAPsTOOLBOX is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% For a copy of the GNU General Public License, see <http://www.gnu.org/licenses/>.
%__________________________________________________________________________

CorrMap = CMap{1}; 
New_data = Data{1};
New_data(isnan(New_data))=0;
Tseries = TS{1};
TotN = max(size(Tseries));
M = max(Tseries);
m = min(Tseries);
Start = M;
Step = (M-m)/50;
count = 1;
for thr = Start:-Step:m
    fprintf('.');
    index1 = find(Tseries >= thr);
    IndStruct{1,count} = index1;
    ActiMap1 = zeros(1,size(New_data,2));
    tmp = mean(New_data(index1,:),1); %% something like 1 x nvoxels
    ActiMap1(brind) = tmp(brind);
    rate1(1,count) = (1-(length(index1)/TotN))*100;
    SpatCorr1(1,count) = corr(CorrMap',ActiMap1'); %%% needs transpose for this kind of arrays
    count = count+1;
end
fprintf('\n');

Params.Ind1 = IndStruct;
Params.Rate1 = rate1;
Params.SpatCorr1 = SpatCorr1;

return;
