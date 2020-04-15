function [Sample, BeadAssay, Label, General, Control] = MPA_Database_Construction(SampleDirectoryFiles,BeadCriteria, Dir)

%% Sample metadata
ii = 1:numel(SampleDirectoryFiles);   % index for number of samples

% Variable names
Sample.Header(1,1) = {'Sample_Filename_Prefix'};
Sample.Data(ii,1) = SampleDirectoryFiles(ii);

Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Set_ID'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_ID'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Grouping_ID'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Control_ID'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Label_Mix_No'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Incubated_Sample_Volume_Microliters'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Incubated_Sample_Concentration_per_mL'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Source'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Isolation_Tube'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Purification_Method'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Incubation_Time_With_CaptureBead'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Sample_Incubation_Time_With_Antibody'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Antibody_Wash_Method'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Flow_Cytometer'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Plate_type'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Plate_Number'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Plate_Well_ID'};
Sample.Header(1,size(Sample.Header,2)+1) = {'Acquisition_Date_YYYYMMDD'};

Sample.Data(ii,size(Sample.Data,2)+1:size(Sample.Header,2)) = {''}; % empty cells for user's metadata input

%% BeadAssay metadata 
ii2 = 1:numel(BeadCriteria.Nos);

BeadAssay.Header(1,1) = {'Bead_Identifier'};
BeadAssay.Data(ii2,1) = BeadCriteria.Nos(ii2);

BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_CaptureAntibody_Target'};
BeadAssay.Data(ii2,size(BeadAssay.Data,2)+1) = BeadCriteria.Labels(ii2);

BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_CaptureAntibody_Isotype'};
BeadAssay.Data(ii2,size(BeadAssay.Data,2)+1) = BeadCriteria.Isotype(ii2);

BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_Capture_Antibody_Clone'};
BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_CaptureAntibody_Manufacturer'};
BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_CaptureAntibody_CatNo'};
BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_CaptureAntibody_LotNo'};
BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_Wash_Buffer'};

BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_Diameter'};
BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_Manufacturer'};
BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_Conjugation_Molecule'};
BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_Volume_Incubated'};
BeadAssay.Header(1,size(BeadAssay.Header,2)+1) = {'Bead_Count_Incubated'};

BeadAssay.Data(ii,size(BeadAssay.Data,2)+1:size(BeadAssay.Header,2)) = {''}; % empty cells for user's metadata input

%% Label metadata

Label.Header(1,1) = {'Mix_Number'};
Label.Data(1,1) = {1};

Label.Header(2,1) = {'Import_Column_Number'};
Label.Data(1,2) = {1};

Label.Header(3,1) = {'Label_Target'};
Label.Data(1,3) = {''};

Label.Header(4,1) = {'Label_Incubated_Concentration'};
Label.Data(1,4) = {''};

Label.Header(5,1) = {'Label_Fluorophore'};
Label.Data(1,5) = {''};

Label.Header(6,1) = {'Label_Isotype'};
Label.Data(1,6) = {''};

Label.Header(7,1) = {'Label_Manufacturer'};
Label.Data(1,7) = {''};

Label.Header(8,1) = {'Label_Catalogue_Number'};
Label.Data(1,8) = {''};

%% General metadata
General.Header(1,1) = {'CSV_Directory'};
General.Data(1,1) = {Dir};

%% Control metadata
Control.Header(1,1) = {'Control_Filename_Prefix'};
Control.Header(1,2) = {'Sample_Control_ID'};
Control.Header(1,3) = {'Control_Name'};
Control.Header(1,4) = {'Sample_Label_Mix_No'};
Control.Header(1,5) = {'Control_Incubation_Time_With_Antibody'};
Control.Header(1,6) = {'Antibody_Wash_Method'};
Control.Header(1,7) = {'Flow_Cytometer'};

Control.Data(ii,size(Control.Header,2)) = {''}; % empty cells for user's metadata input




end

