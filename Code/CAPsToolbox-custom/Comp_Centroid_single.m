function New_Centroid = Comp_Centroid_single(Frames,brind,V,flag)  

% This function creates CAP centroid from an independent dataset
%  
% usage:
% [Centroid] = Comp_Centroid_single(Frames,brind,V,flag)
%
% Input:
% Frames - (n x a) array of n time frames.
% brind - brain mask, organized as 1xM, with M=number of brain voxels.
% V - spm vector of structures containing image volume information. Needed 
% as reference for the voxel to world transformation (see spm_vol for
% info).
% flag - if 1, it will mask the time frames as in (Liu et al., PNAS 2013)
%
% Output: 
% New_Centroid = Cell array (1, number of thresholds). Each cell contains
% a matrix (number of clusters, number of voxels), which specifies the
% centroid of each CAP.
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

Dim = V.dim;
NCap = 8;    
    
%%%% Masking on the frames (Liu et al., PNAS 2013)
if(flag==1)
	Frames = Comp_LiuMask(Frames,Dim);
end
NTOT_Frames = size(Frames,1);
fprintf('\n %d Frames collected \n',NTOT_Frames);
ActiMap1 = zeros(1,size(Frames,2)); % or ActiMap1 = Inf(1,size(New_data,2));
tmp = mean(Frames,1); 
ActiMap1(brind) = tmp(brind);
    
%%%% Kmeans clustering
fprintf('\n Kmeans... \n');
[~, C] = kmeans(Frames,NCap,'distance','correlation');
Centroid=C;
fprintf('\n Computing CAP \n');
for j = 1:NCap
	SpatCorr(j) = corr(ActiMap1(brind)',Centroid(j,brind)');
end
    
%%%% Similarity
Sim = SpatCorr./sum(SpatCorr);
[~,IX] = sort(Sim,'descend');
    
%%% Sort the centroids
New_Centroid = Centroid(IX,:);
       
return
