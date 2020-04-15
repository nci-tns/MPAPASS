function [PlotData, MarkerLabels, SampleNames, Group, GroupName, SecLabels, BeadLabels, Mixes] = CollateData(Norm_Dataset,ThresholdDropDown,ThresholdStatisticDropDown,ThresholdEditField, DatasetScalingDropDown)

% testing github changes 2
SampleNames = cellstr(unique(string(Norm_Dataset.SelectedSampleTable.Names.Sample),'stable'));

for i=1:numel(SampleNames)
    X = table2array(Norm_Dataset.SelectedSampleTable.Data(strcmp(SampleNames(i),string(Norm_Dataset.SelectedSampleTable.Names.Sample)),:));
    X = X';               % rotate array before concat
    PlotData(:,i) = X(:); % concat data into single column
    
    indexy = strcmp(SampleNames(i),string(Norm_Dataset.SelectedSampleTable.Names.Sample));
    Group(i,1) = unique(Norm_Dataset.SelectedSampleTable.Names.GroupNo(indexy));
    GroupName(i,1) = unique(Norm_Dataset.SelectedSampleTable.Names.GroupName(indexy));
    
end

Mixes = [];
UniqueMarkers = unique(Norm_Dataset.SelectedSampleTable.Names.SecMarker,'stable');  % unique secondary ab names

for i = 1:numel(unique(Norm_Dataset.SelectedSampleTable.Names.SecMarker))
    
    Labels1(:,i) = repmat(UniqueMarkers(i), numel(Norm_Dataset.SelectedSampleVarNames),1);
    
    SecLabels = Labels1;
    
    for j = 1:size(Labels1,1)
        
        Labels2(j,i) = strcat(Norm_Dataset.SelectedSampleVarNames(j), {' + '}, Labels1(j,i));
        
    end
end

Divis = size(PlotData,1)/numel(Norm_Dataset.SelectedSampleVarNames);
BeadLabels = repmat(Norm_Dataset.SelectedSampleVarNames, 1, Divis);

MarkerLabels = Labels2(:);


switch ThresholdDropDown.Value
    case 'On'
        PlotDataX = [];
        
        for ii = 1:size(PlotData,1)
            switch ThresholdStatisticDropDown.Value
                case 'Minimum'
                    
                    if min(PlotData(ii,:)) > ThresholdEditField.Value
                        PlotDataX(size(PlotDataX,1)+1,:) = PlotData(ii,:);
                        MarkerLabelsX(size(PlotDataX,1)) = MarkerLabels(ii);
                        SecLabelsX(size(PlotDataX,1)) = SecLabels(ii);
                        BeadLabelsX(size(PlotDataX,1)) = BeadLabels(ii);
                        %                                     MixesX(size(PlotDataX,1)) = Mixes(ii);
                    else
                    end
                    
                case 'Median'
                    
                    if median(PlotData(ii,:)) > ThresholdEditField.Value
                        PlotDataX(size(PlotDataX,1)+1,:) = PlotData(ii,:);
                        MarkerLabelsX(size(PlotDataX,1)) = MarkerLabels(ii);
                        SecLabelsX(size(PlotDataX,1)) = SecLabels(ii);
                        BeadLabelsX(size(PlotDataX,1)) = BeadLabels(ii);
                        %                                     MixesX(size(PlotDataX,1)) = Mixes(ii);
                    else
                    end
                    
                case 'Mean'
                    
                    if mean(PlotData(ii,:)) > ThresholdEditField.Value
                        PlotDataX(size(PlotDataX,1)+1,:) = PlotData(ii,:);
                        MarkerLabelsX(size(PlotDataX,1)) = MarkerLabels(ii);
                        SecLabelsX(size(PlotDataX,1)) = SecLabels(ii);
                        BeadLabelsX(size(PlotDataX,1)) = BeadLabels(ii);
                        %                                     MixesX(size(PlotDataX,1)) = Mixes(ii);
                    else
                    end
                    
            end
        end
        
        PlotData = PlotDataX;
        if size(PlotData,1) == 0
            %             UpdateStatusWindow(app, [' | Error: No samples above threshold value'])
            %             error % stop execution
            return
        else
            MarkerLabels = MarkerLabelsX;
            SecLabels = SecLabelsX;
            BeadLabels = BeadLabelsX;
            %                     Mixes = MixesX;
            %             UpdateStatusWindow(app, [' | Threshold applied to loaded dataset'])
        end
        
    case 'Off'
end

switch DatasetScalingDropDown.Value
    case 'Log10'
        PlotDataTest = PlotData(:);
        
        if numel(PlotDataTest(PlotDataTest<=0)) >= 1
            %             UpdateStatusWindow(app, [' | Error: Log10 transformation has created complex data. Try alternative normalisation method'])
            %             UpdateStatusWindow(app, [' | Error: Linear scaling maintained'])
            error % stop execution
            return
        else
            PlotData=log10(PlotData);
            %             UpdateStatusWindow(app, [' | Dataset Log10 transformed'])
        end
    case 'Linear'
        PlotData=PlotData;
end

end
