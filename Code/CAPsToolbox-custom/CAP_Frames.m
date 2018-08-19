function CAP_Frames = CAP_Frames(population,CAP_number)

CAP_Num = CAP_number;
pop = population;

m = matfile(['TotFrames_' pop '.mat'],'Writable',true);
load(['Cap_par_' pop '_15.mat']);
Index = Cap_par.ClusterInd;
Ind1 = find(Index == CAP_Num);

d = diff(Ind1) == 1;
aInd = find(d == 0);
aInd = [aInd; length(Ind1)];

CAP_Frames = [];
sInd = 1;
for i = aInd.'
    tmp = m.TotFrames(Ind1(sInd):Ind1(i),:);
    CAP_Frames = [CAP_Frames; tmp];
    sInd = i+1;
end
% for i = Ind1.'
%     tmp = m.TotFrames(i,:);
%     CAP_Frames = [CAP_Frames; tmp];
% end
% CAP_Frames = m.TotFrames(Ind1,:);

save(['CAP_' num2str(CAP_Num) '_Frames_' pop '.mat'],'CAP_Frames')