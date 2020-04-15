function [SelectedData2, SelectedColumnNames, SelectedRowNames, SelectedInfo, SelectedLabelInfo, Selection, errormess] = SampleIndex(Database,...
    CustomVariableIndex, CustomVariablesItemIndex, CustomVariableHeadersListbox, SamplesListBox, GroupsListBox, AbMixesListBox, CaptureAbListBox, AbSelectionItemIndex)

ListboxIndex{1} = SamplesListBox.Value;
ListboxItems{1} = SamplesListBox.Items;
ListboxHeaders{1} = 'Sample_ID';

ListboxIndex{2} = GroupsListBox.Value;
ListboxItems{2} = GroupsListBox.Items;
ListboxHeaders{2} = 'Sample_Grouping_ID';


ListboxIndex{3} = AbMixesListBox.Value;
ListboxItems{3} = AbMixesListBox.Items;
ListboxHeaders{3} = 'Sample_Label_Mix_No';

ListboxIndex = horzcat(ListboxIndex, CustomVariableIndex);
ListboxItems = horzcat(ListboxItems, CustomVariablesItemIndex);
ListboxHeaders = horzcat(ListboxHeaders, strrep(CustomVariableHeadersListbox.Items(2:end),' ','_'));

% Create an index of the samples to select based on the selected GUI
% listbox criteria
for i = 1:numel(ListboxIndex)
    
    for ii = 1:numel(ListboxIndex{i})
        
        if ListboxIndex{i}(ii) == 1 % if 'All' is selected
            SampleTableIndexInner(:,ii) = logical(ones(1,size(Database.Sample,1)));
        else
            try
                if isnumeric(Database.Sample.(ListboxHeaders{i})) == 1 % if the variable input is numeric
                    SampleTableIndexInner(:,ii) = strcmp(strtrim(cellstr(num2str(Database.Sample.(ListboxHeaders{i})))), ListboxItems{i}{ListboxIndex{i}(ii)});
                else % if the variable input is a string
                    SampleTableIndexInner(:,ii) = strcmp(Database.Sample.(ListboxHeaders{i}), ListboxItems{i}{ListboxIndex{i}(ii)});
                end
            catch
            end
        end
        
    end
    
    for iii = 1:size(Database.Sample,1)
        
        if sum(SampleTableIndexInner(iii,:)==1,2) >= 1
            SampleTableIndexOuter(iii,i) = 1;
        else
            SampleTableIndexOuter(iii,i) = 0;
        end
        
    end
    
    SampleTableIndexInner = [];
    SelectionCriteria{i} = {ListboxItems{i}{ListboxIndex{i}}};
    
end

% sample filename selection criteria
SampleIndex(:,1) = all(SampleTableIndexOuter,2);
IndexedSampleInfo = Database.Sample(SampleIndex,:);

% reduce dataset from nested mix arrays to Filename 'x1', mix 'y1', ab 'z', by
% capture bead array. Still requires restructuring to put all mixes under
% one sample.

if CaptureAbListBox.Value ==1
    Data = cell2mat(Database.Norm.Cell(:,SampleIndex));
else
    Data = cell2mat(Database.Norm.Cell(CaptureAbListBox.Value-1,SampleIndex));
end

CellIndex = [];
CellIndex2 = [];
MaxInd = 0;

for i = 1:size(Database.Norm.Cell(:,SampleIndex),2)
    NumAbs = numel(Database.Labelling.Mix_Number(Database.Labelling.Mix_Number==IndexedSampleInfo.Sample_Label_Mix_No(i)));
    
    if AbSelectionItemIndex{IndexedSampleInfo.Sample_Label_Mix_No(i)} == 1 % put index here for if all is selected
        MixIndex = Database.Labelling.Import_Column_Number(Database.Labelling.Mix_Number==IndexedSampleInfo.Sample_Label_Mix_No(i));
        CellIndex(length(CellIndex)+1:length(CellIndex)+NumAbs) = Database.Labelling.Import_Column_Number(Database.Labelling.Mix_Number==IndexedSampleInfo.Sample_Label_Mix_No(i));
        CellIndex2(length(CellIndex2)+1:length(CellIndex2)+NumAbs) = Database.Labelling.Import_Column_Number(Database.Labelling.Mix_Number==IndexedSampleInfo.Sample_Label_Mix_No(i)) + MaxInd;
        MaxInd = numel(MixIndex) + MaxInd;
    else % put index here for if a certain selection is selected
        MixIndex = Database.Labelling.Import_Column_Number(Database.Labelling.Mix_Number==IndexedSampleInfo.Sample_Label_Mix_No(i));
        CellIndex(length(CellIndex)+1:length(CellIndex)+NumAbs) = MixIndex(AbSelectionItemIndex{IndexedSampleInfo.Sample_Label_Mix_No(i)}-1);
        CellIndex2(length(CellIndex2)+1:length(CellIndex2)+NumAbs) = MixIndex(AbSelectionItemIndex{IndexedSampleInfo.Sample_Label_Mix_No(i)}-1) + MaxInd;
        MaxInd = MaxInd + numel(MixIndex);
    end
    
end

% restructure selected data so each column is the same sample
SelectedData = reshape(Data(:,CellIndex==1),[],numel(unique(IndexedSampleInfo.Sample_Set_ID)));
SelectedData2 = reshape(Data(:,CellIndex2),[],numel(unique(IndexedSampleInfo.Sample_Set_ID)));

% select names of the unique detection antibodies for labelling of the rows
if AbMixesListBox.Value == 1
    AbNames = repmat(Database.Labelling.Label_Target,size(Data,1),1);
    RowInfo = Database.Labelling;
else
    AbNames = [];
    RowInfo = [];
    SelectedMixes = unique(IndexedSampleInfo.Sample_Label_Mix_No);
    for i = 1:numel(SelectedMixes)
        if AbSelectionItemIndex{IndexedSampleInfo.Sample_Label_Mix_No(i)}-1 == 0
            tempnames = Database.Labelling.Label_Target(Database.Labelling.Mix_Number==SelectedMixes(i));
            AbNames = vertcat(AbNames, tempnames(:));
            RowInfo = vertcat(RowInfo, Database.Labelling(Database.Labelling.Mix_Number==SelectedMixes(i),:));
            
        else
            iNames = Database.Labelling(Database.Labelling.Mix_Number==SelectedMixes(i),:);
            tempnames = iNames(AbSelectionItemIndex{IndexedSampleInfo.Sample_Label_Mix_No(i)}-1,:);
            AbNames = vertcat(AbNames,tempnames.Label_Target(:) );
            RowInfo = vertcat(RowInfo, tempnames);
            
        end
    end
    AbNames = repmat(AbNames',size(Data,1),1);
end
%% check for strings
if isnumeric(AbNames)
    AbNames = cellstr(num2str(AbNames));
end

%% need to add 'tempinfo' into above loop rather than extract from below

RowInfo2 = [];

for i = 1:height(RowInfo)
    RowInfo2 = vertcat(RowInfo2, repmat(RowInfo(i,:),size(Data,1),1));
end

% create row names using capture bead targets
if CaptureAbListBox.Value == 1
    Capture = repmat(CaptureAbListBox.Items(2:end), 1, numel(CellIndex==1) / numel(unique(IndexedSampleInfo.Sample_Set_ID)));
    tempinfo = repmat(Database.Beads, numel(CellIndex==1) / numel(unique(IndexedSampleInfo.Sample_Set_ID)),1);
    SelectedLabelInfo = horzcat(tempinfo, RowInfo2);
    SelectedRowNames = strcat(Capture(:), {' + '}, AbNames(:));
else
    Capture = repmat(CaptureAbListBox.Items(CaptureAbListBox.Value), numel(CellIndex==1) / numel(unique(IndexedSampleInfo.Sample_Set_ID)),1);
    tempinfo = repmat(Database.Beads(CaptureAbListBox.Value-1,:), numel(CellIndex==1) / numel(unique(IndexedSampleInfo.Sample_Set_ID)),1);
    SelectedLabelInfo = horzcat(tempinfo,RowInfo2);
    SelectedRowNames = strcat(Capture(:), {' + '}, AbNames(:));
end

% create sample ID names
[~,NameIndex] = unique(IndexedSampleInfo.Sample_Set_ID(:),'stable');
SelectedColumnNames = IndexedSampleInfo.Sample_ID(NameIndex);

if ListboxIndex{3} > 1
    SelectedInfo = IndexedSampleInfo(IndexedSampleInfo.Sample_Label_Mix_No == min(ListboxIndex{3}-1),:);
else
    SelectedInfo = IndexedSampleInfo(IndexedSampleInfo.Sample_Label_Mix_No == 1,:);
end

Selection = [];
errormess = [];

end