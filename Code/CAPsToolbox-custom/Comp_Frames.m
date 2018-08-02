function Frames = Comp_Frames(Data,Params,TH,number)

Perc = Params.Rate1;
Index = Params.Ind1;
thr = TH;
num = number;

fprintf('\n Collecting frames threshold %d percent \n',thr);
New_data = Data{1}; 
index = find(Perc(num,:)>=(100-thr)); 
IndFrames = Index{num,index(end)};
Frames = New_data(IndFrames,:);
return

