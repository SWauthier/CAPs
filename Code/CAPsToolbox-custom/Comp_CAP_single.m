function [Cap_par, S_CAP] = Comp_CAP_single(Frames,brind,V,TH,State,Centroid,Dir)   

% This function creates CAPs, after clustering with centroid fixed. It also
% writes CAPs and Mean Activation Maps into images and saves Cap_par as a 
% .mat file under the label defined by State input and the folder by Dir input.
%  
% usage:
% [Cap_par S_CAP] = Comp_CAP_single(Frames,brind,V,TH,State,Centroid,Dir)   
%
% Input:
% Frames - (n x a) array of n time frames.
% brind - brain mask, organized as 1xM, with M=number of brain voxels.
% V - spm vector of structures containing image volume information. Needed 
% as reference for the voxel to world transformation (see spm_vol for info)
% TH - the threshold for the time frames collection (e.g. in the paper, 1SD
% is ~= 15%, so in that case TH=15). It can be a single number. 
% Centroid - The Centroid.mat file created with the Comp_Centroid function
% State - String array for labeling the files to save (i.e. State='Wake')
% Dir - String array for the Directory where the files will be saved 
% (i.e. Dir='F:\Results\Multisubj')
%
% Output: 
% Cap_par - Struct array containing information about each CAP such as:
%         - Spatial Similarity with the mean Activation Map
%         - Occurence (how often the pattern repeats itself in time) 
%         - ClusterInd (which time Frames belong to that particular CAP) 
% S_CAP - Cell array (1, number of clusters). Each cell contains
% a matrix 1xM, with M=number of voxels, being the CAP image corresponding
% to that cluster.
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
thr = TH;

Cap_par = {};
sizeF = size(Frames,2);
    
%%%% Liu Masking on the frames
Frames = Comp_LiuMask(Frames,Dim);
%%%%%
            
NTOT_Frames = size(Frames,1);
fprintf('\n %d Frames collected \n',NTOT_Frames);
ActiMap1 = zeros(1,sizeF);% or ActiMap1 = Inf(1,size(New_data,2));
tmp = mean(Frames,1); %%% overall mean
ActiMap1(brind) = tmp(brind);
fprintf('\n Kmeans... \n');
C = Centroid;
Liu_NCap = size(C,1);
fprintf('\n Number of CAP %d \n',Liu_NCap);
D = zeros(size(C,1),size(Frames,1));
for cen = 1:Liu_NCap
	for f = 1:size(Frames,1)  
        X = [C(cen,brind); Frames(f,brind)];  
        D(cen,f) = pdist(X,'correlation');
	end
end
[~, I] = min(D);
CAP_Ind = I';
fprintf('\n Computing CAP \n');
for j = 1:Liu_NCap
	NCAP_Frames(j)=size(Frames(CAP_Ind==j,:),1);
	CAP{j} = zeros(1,sizeF);% or CAP{j} = Inf(1,size(New_data,2));
	cap_tmp = mean(Frames(CAP_Ind==j,:),1);          
	CAP{j}(brind) = cap_tmp(brind);
        
	%%% Similarity
	SpatCorr(j) = corr(ActiMap1(brind)',CAP{j}(brind)');

	%%% Occurence
	CAP_Occ(j) = NCAP_Frames(j)./NTOT_Frames;
end
%%%% Similarity
Sim = SpatCorr./sum(SpatCorr);
for k = 1:Liu_NCap
	V.fname = [Dir filesep 'CAP_' num2str(k) '_' State '_' num2str(thr) 'Percent.nii'];
	V.dt=[16,0];
	S_CAP{k} = reshape( CAP{k},V.dim);
	Image = spm_write_vol(V,S_CAP{k});     
end
V.fname = [Dir filesep 'MeanAct_' State '_' num2str(thr) 'Percent.nii'];
V.dt=[16,0];
ActiMap1 = reshape( ActiMap1,V.dim);
Image = spm_write_vol(V, ActiMap1);
Cap_par.Similarity = Sim ;
Cap_par.occurence = CAP_Occ;
Cap_par.ClusterInd = CAP_Ind;
save([Dir filesep 'Cap_par_' State '_' num2str(thr) '.mat'],'Cap_par');
save([Dir filesep 'CAP_' State '_' num2str(thr) '.mat'],'S_CAP');

return;
     
