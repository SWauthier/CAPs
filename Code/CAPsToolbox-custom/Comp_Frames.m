function Frames = Comp_Frames(Data,Params,TH)

% Creates array of frames above threshold.
% Created by SW Aug 2018.

Perc = Params.Rate1;
Index = Params.Ind1;
thr = TH;

fprintf('\n Collecting frames threshold %d percent \n',thr);
New_data = Data{1}; 
index = find(Perc>=(100-thr)); 
IndFrames = Index{index(end)};
Frames = New_data(IndFrames,:);
return

