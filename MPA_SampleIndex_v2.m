function [SelectedData2, SelectedColumnNames, SelectedRowNames, SelectedInfo, SelectedLabelInfo, Selection, errormess] = MPA_SampleIndex_v2(Database, CustomVariableIndex, CustomVariablesItemIndex, CustomVariableHeadersListbox, SamplesListBox, GroupsListBox, AbMixesListBox, CaptureAbListBox, AbSelectionItemIndex)

%% collate selected criteria from GUI
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

TableHeaders = contains(Database.Sample.Properties.VariableNames, ListboxHeaders); % identify headers matching those in GUI
SampleTable = Database.Sample(:, TableHeaders); % shrink table to selectable GUI variables

SampleInd = logical(ones(size(SampleTable,1),1));
for i = 1:size(SampleTable,2)
    
    SampleTable.(ListboxHeaders{i}) = categorical(SampleTable.(ListboxHeaders{i}));
    
    if contains(ListboxItems{i}{ListboxIndex{i}}, 'All') == 1
        TempInd = logical(ones(size(SampleTable,1),1));
    else
        TempInd = SampleTable.(ListboxHeaders{i}) == ListboxItems{i}{ListboxIndex{i}};
    end
    SampleInd = and(SampleInd, TempInd);
end


return


%% may be redundant
  if strcmp(class(SampleTable.(ListboxHeaders{i})),'cell') == 1
        TableVarType = class(SampleTable.(ListboxHeaders{i}){1});
    else
        TableVarType = class(SampleTable.(ListboxHeaders{i})(1));
    end
    
    GUIVarType = class(ListboxItems{i}{ListboxIndex{i}});
    
    if strcmp(TableVarType, GUIVarType) == 1
    elseif strcmp(TableVarType, 'double') && strcmp(GUIVarType, 'char')
        TransVar = cellstr(num2str(SampleTable.(ListboxHeaders{i}))); % convert double to cells of strings
        SampleTable.(ListboxHeaders{i}) = TransVar; % overwrite double to string data in table
    else
        error(['Variable ', num2str(i), ' types do not match Table Var = ', TableVarType,' & GUI Var = ', GUIVarType])
    end
    

% Create an index of the samples to select based on the selected GUI
% listbox criteria

for  i = 1:numel(ListboxHeaders) % convert table variables to categorical selections
    DatabaseClassType{i} = class(Database.Sample.(ListboxHeaders{i}));
    if strcmp(DatabaseClassType{i},'double') == 1
        test = ListboxItems{i}{ListboxIndex{i}};
        if strcmp(class(test),'double') == 1
        else
            %            ListboxItems{i}(2:end) = cellstring(cellfun(@num2str, ListboxItems{i}(2:end)));
            ListboxItems{i}(2:end) =  cellfun(@num2str, ListboxItems{i}(2:end), 'UniformOutput', false);
            
        end
    else
    end
    Database.Sample.(ListboxHeaders{i}) = categorical(Database.Sample.(ListboxHeaders{i}));
end

IndexedSampleInfo = [];

if CaptureAbListBox.Value ==1 % all capture beads selected
    Data = Database.Norm.Cell;
else                        % subset of capture beads selected
    Data = Database.Norm.Cell(CaptureAbListBox.Value-1,:);
end

for  i = 1:numel(ListboxHeaders)
    if ListboxIndex{i} == 1 % if all variables are selected
    else
        IndexedSampleInfo = Database.Sample(Database.Sample.(ListboxHeaders{i}) == ListboxItems{i}{ListboxIndex{i}},:);
        Data = Data(:,IndexedSampleInfo.(ListboxHeaders{i}) == ListboxItems{i}{ListboxIndex{i}});
    end
end

ColumnIndex = [];
for i = 1:size(Data,2)
    ColumnIndex = horzcat(ColumnIndex,[1:size(Data{1,i},2)]);
end

% reduce dataset from nested mix arrays to Filename 'x1', mix 'y1', ab 'z', by
% capture bead array. Still requires restructuring to put all mixes under
% one sample.

Data2 = cell2mat(Data);
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

RowInfo2 = [];

for i = 1:height(RowInfo)
    RowInfo2 = vertcat(RowInfo2, repmat(RowInfo(i,:),size(Data,1),1));
end

% create row names using capture bead targets
if CaptureAbListBox.Value == 1
    Capture = repmat(CaptureAbListBox.Items(2:end),1,numel(CellIndex==1)/numel(unique(IndexedSampleInfo.Sample_Set_ID)));
    tempinfo = repmat(Database.Beads,numel(CellIndex==1)/numel(unique(IndexedSampleInfo.Sample_Set_ID)),1);
    SelectedLabelInfo = horzcat(tempinfo, RowInfo2);
    SelectedRowNames = strcat(Capture(:),{' + '},AbNames(:));
else
    Capture = repmat(CaptureAbListBox.Items(CaptureAbListBox.Value),numel(CellIndex==1)/numel(unique(IndexedSampleInfo.Sample_Set_ID)),1);
    tempinfo = repmat(Database.Beads(CaptureAbListBox.Value-1,:),numel(CellIndex==1)/numel(unique(IndexedSampleInfo.Sample_Set_ID)),1);
    SelectedLabelInfo = horzcat(tempinfo,RowInfo2);
    SelectedRowNames = strcat(Capture(:),{' + '}, AbNames(:));
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