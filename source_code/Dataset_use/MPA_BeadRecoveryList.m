function [Sample_Mix_Bead_Array, Sample_Mix_Name] = MPA_BeadRecoveryList(Database)

for i = 1:numel(Database.Sample.Sample_ID)
    
    Sample_Mix(i) = strcat(Database.Sample.Sample_ID{i}, {' - '}, num2str(Database.Sample.Sample_Label_Mix_No(i)));
    Sample_Mix_Array(:,i) = repmat(Sample_Mix(i),numel(Database.Beads.Bead_CaptureAntibody_Target), 1);
    
    for j = 1:size(Sample_Mix_Array,1)
        Sample_Mix_Bead_Array(j,i) = strcat(Sample_Mix_Array(j,i), {' - '}, Database.Beads.Bead_CaptureAntibody_Target(j), {' Pop.'});
    end
end
Sample_Mix_Name = Sample_Mix;
end