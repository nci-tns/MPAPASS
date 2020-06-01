function [CollatedData, SelectedColumnNames, SelectedRowNames, SelectedInfo, SelectedLabelInfo, Selection, errormess] = MPA_SampleIndex_v4(Database, CustomVariableIndex, CustomVariablesItemIndex, CustomVariableHeadersListbox, SamplesListBox, GroupsListBox, AbMixesListBox, CaptureAbListBox, AbSelectionItemIndex, MarkerLabelsListBox, SampleLabelsListBox)

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

[~, Sample_Set_ID_ind] = sort(cellfun(@(x)str2double(x), table2cell(Database.Sample(:,2))));

Database.Sample= Database.Sample(Sample_Set_ID_ind,:);

TableHeaders = contains(Database.Sample.Properties.VariableNames, ListboxHeaders); % identify headers matching those in GUI
SampleTable = Database.Sample(:, TableHeaders); % shrink table to selectable GUI variables

SampleInd = logical(ones(size(SampleTable,1),1));
for i = 1:size(SampleTable,2)
    
    SampleTable.(ListboxHeaders{i}) = categorical(SampleTable.(ListboxHeaders{i}));
    
    if max(contains(string(char(ListboxItems{i}{ListboxIndex{i}})),'All')) == 1
        TempInd = logical(ones(size(SampleTable,1),1)); % if All is selected
    else
        TempInd = logical(zeros(size(SampleTable,1),1));
        for ii = 1:numel(categorical({ListboxItems{i}{ListboxIndex{i}}}))
            TempIndA = SampleTable.(ListboxHeaders{i}) == categorical({ListboxItems{i}{ListboxIndex{i}(ii)}}); % is a specific set is select
            TempInd = or(TempInd,TempIndA);
        end
    end
    
    SampleInd = and(SampleInd, TempInd); % create an index based on all selections
    
end

if sum(SampleInd) == 0
    errormess = {'Selection does not exist'};
    CollatedData= [];
    SelectedColumnNames= [];
    SelectedRowNames= [];
    SelectedInfo= [];
    SelectedLabelInfo= [];
    Selection = [];
    return
end

Data = Database.Norm.Cell;

% debugging %
% DebugData1 = num2cell(double(repmat(SampleTable.Sample_Label_Mix_No, 1, 39)')); % color by mix
% DebugData2 = num2cell(repmat(1:39, numel(SampleTable.Sample_Label_Mix_No), 1)'); % color by bead
% Data = DebugData2;
% debugging %

IndexedSampleInfo = SampleTable(SampleInd,:);
IndexedSampleInfoFull = Database.Sample(SampleInd,:);

FullSampleInfoGUI = SampleTable;
FullSampleInfoFull = Database.Sample;

% reduce dataset from nested mix arrays to Filename 'x1', mix 'y1', ab 'z', by
% capture bead array. Still requires restructuring to put all mixes under
% one sample.

IndexedSampleID = unique(IndexedSampleInfoFull.Sample_Set_ID,'stable');
IndexedMixNum = unique(IndexedSampleInfoFull.Sample_Label_Mix_No,'stable');

LabelDatabase = Database.Labelling;
LabelDatabase = convertvars(LabelDatabase, LabelDatabase.Properties.VariableNames,'categorical');

SampleData = [];
CollatedData = [];
SelectedRowNames = [];
SelectedColumnNames = [];
SampleInfoTable = [];
LabelInfoData = [];
ID_Comp = '';
VarFieldNames = SampleLabelsListBox.Items(SampleLabelsListBox.Value);

for i = 1:numel(IndexedSampleID)
    
    SampleInd = FullSampleInfoFull.Sample_Set_ID==categorical(IndexedSampleID(i)); % index selected samples 1-by-1
    SampleInd2 = find(SampleInd);
    
    for ii = 1:numel(VarFieldNames) % construct custom sample labels
        TempFieldName = VarFieldNames{ii};
        TempFieldNameInd = IndexedSampleInfoFull.Sample_Set_ID==categorical(IndexedSampleID(i));
        if ii == 1
            TempSelectedColumnNames = char(unique(IndexedSampleInfoFull.(TempFieldName)(TempFieldNameInd)));
        else
            TempSelectedColumnNames  = strcat(TempSelectedColumnNames, {', '}, char(unique(IndexedSampleInfoFull.(TempFieldName)(TempFieldNameInd))));
        end
    end
    
    for ii = 1:numel(IndexedMixNum)
        
        MixInd = FullSampleInfoGUI.Sample_Label_Mix_No==categorical(IndexedMixNum(ii)); % index selected mixes 1-by-1
        DataInd = and(SampleInd, MixInd); % index meeting sample and mix criteria
        
        if  AbSelectionItemIndex{IndexedMixNum(ii)} == 1 % if all detection abs are selected
            AbInd = 1:numel(LabelDatabase.Import_Column_Number(LabelDatabase.Mix_Number==categorical(IndexedMixNum(ii))));
        else  % if subgroup of detection abs are selected
            AbInd = AbSelectionItemIndex{IndexedMixNum(ii)}-1;
        end
        
        if  CaptureAbListBox.Value == 1 % if all capture beads are selected
            BeadInd = 1:size(Database.Beads,1);
        else                        % if a subset of capture beads are selected
            BeadInd = CaptureAbListBox.Value-1;
        end
        
        LabelNames = cellstr(LabelDatabase.Label_Target(LabelDatabase.Mix_Number==categorical(IndexedMixNum(ii))));
        TempLabelTable = LabelDatabase(LabelDatabase.Mix_Number==categorical(IndexedMixNum(ii)),:);
        
        for iii = 1:numel(AbInd)
            TempData = cell2mat(Data(:, DataInd)); % index the data for sample and mix
            SampleData = [SampleData; TempData(BeadInd, AbInd(iii))]; % index data for ab selection and add to other sample mixes
            TempData = []; % clear temp data
            
            
            if i == 1
                ID_Comp = FullSampleInfoFull.Sample_Set_ID{SampleInd2(1)};
                ToAdd = horzcat(Database.Beads(BeadInd,:), repmat(TempLabelTable(AbInd(iii),:), numel(BeadInd), 1));
                LabelInfoData = vertcat(LabelInfoData, ToAdd);
            end
        end
        
        
    end
    SelectedColumnNames{i} = char(TempSelectedColumnNames);
    CollatedData = [CollatedData, SampleData]; % collate all sample data
    SampleData = []; % clear sample data
    TempSelectedColumnNames = [];
    SampleInfoTable = vertcat(SampleInfoTable, FullSampleInfoFull(SampleInd2(1),:));
end

% Unassigned variables
SelectedInfo = SampleInfoTable;
SelectedLabelInfo = LabelInfoData;

for i = 1:numel(MarkerLabelsListBox.Value)
    if numel(MarkerLabelsListBox.Value) == 1
        SelectedRowNames = cellstr(LabelInfoData.(MarkerLabelsListBox.Items{MarkerLabelsListBox.Value(i)}));
    elseif i == numel(MarkerLabelsListBox.Value)
        SelectedRowNames = strcat(SelectedRowNames,cellstr(LabelInfoData.(MarkerLabelsListBox.Items{MarkerLabelsListBox.Value(i)})));
    else
        SelectedRowNames = strcat(SelectedRowNames, strcat(cellstr(LabelInfoData.(MarkerLabelsListBox.Items{MarkerLabelsListBox.Value(i)})), {', '}));
    end
end
Selection = [];
errormess = [];

end