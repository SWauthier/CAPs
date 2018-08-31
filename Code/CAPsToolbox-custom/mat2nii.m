% Convert .mat to .nii

pop = 'Controls';

load(['extras_' pop '.mat'],'V');
V = V(1);

NCAP = 8;
for i = 1:NCAP
    load(['CAP_' num2str(i) '_Frames_' pop '.mat']);

    NFRAMES = size(CAP_Frames);
    for j = 1:NFRAMES
        V.fname = [pwd filesep 'Individual_Frames' filesep 'CAP_' num2str(i) '_Frame_' pop '_' num2str(j) '.nii'];
        S_CAP_Frame = reshape(CAP_Frames(1,:),V.dim);
        Image = spm_write_vol(V,S_CAP_Frame);
    end
end