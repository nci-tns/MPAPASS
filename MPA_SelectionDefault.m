function [UI, DatasetIndex] = MPA_SelectionDefault(DataX)

% Antibody Mix Table Creation
MixTable = table(DataX.AbMixes.SecMarker', cell2mat(DataX.AbMixes.MixNum'), DataX.AbMixes.MixName');
MixTable.Properties.VariableNames={'Sec', 'Num', 'Mix'};

UniqueMixNum=unique(DataX.Loaded_Samples_Listbox.Ab_Mix_No,'stable');    % Unique Antibody Mixes

% Load Default Listbox Values
UI.SampleListBox.Items         = horzcat({'All'}, unique(string(DataX.Loaded_Samples_Listbox.Sample_Name))); % Sample names
UI.SampleListBox.ItemsData     = 1:numel(UI.SampleListBox.Items);

UI.GroupListBox.Items          = horzcat({'All'}, unique(string(DataX.Loaded_Samples_Listbox.GroupName)));   % R Group
UI.GroupListBox.ItemsData      = 1:numel(UI.GroupListBox.Items);

UI.BeadAntibodyListBox.Items   = vertcat({'All'}, DataX.MPA_Beads.Labels(:));                                % Capture Bead Labels
UI.BeadAntibodyListBox.ItemsData = 1:numel(UI.BeadAntibodyListBox.Items);

UI.MixesListBox.Items          = horzcat({'All'}, unique(string(DataX.Loaded_Samples_Listbox.Ab_Mix_No)));   % Unique mixes
UI.MixesListBox.ItemsData      = 1:numel(UI.MixesListBox.Items);

UI.EVAntibodyListBox.Items     = horzcat({'All'}, MixTable.Sec(contains(MixTable.Mix, UniqueMixNum))');  % Secondary antibodies
UI.EVAntibodyListBox.ItemsData = 1:numel(UI.EVAntibodyListBox.Items);

UI.SampleDropDown.Items = unique(string(DataX.Loaded_Samples_Listbox.Sample_Name),'stable');
UI.SampleDropDown.ItemsData = 1:numel(UI.SampleDropDown.Items);

UI.MixDropDown.Items = unique(DataX.Loaded_Samples_Listbox.Ab_Mix_No,'stable');
UI.MixDropDown.ItemsData = 1:numel(UI.MixDropDown.Items);

UI.SecondaryMarkerDropDown.Items = MixTable.Sec(contains(MixTable.Mix, UniqueMixNum));
UI.SecondaryMarkerDropDown.ItemsData = 1:numel(UI.SecondaryMarkerDropDown.Items);

UI.BeadPopulationDropDown.Items = DataX.MPA_Beads.Labels;
UI.BeadPopulationDropDown.ItemsData = 1:numel(UI.BeadPopulationDropDown.Items);

DatasetIndex.Names = (strcat(string(DataX.Loaded_Samples_Listbox.Sample_Name), {' '}, string(DataX.Loaded_Samples_Listbox.Ab_Mix_No))); % sample + mix names
DatasetIndex.Num = 1:2:((2*numel(DatasetIndex.Names))-1); % index for samples in un-normalised dataset

end