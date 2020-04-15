function [Dataset, Status] = MPA_Scaling(Selection, ThresholdDropDown, ThresholdStatisticDropDown, ThresholdEditField, DatasetScalingDropDown, NormType)

Status = [];
Dataset = Selection;
MarkerLabelsX = [];
ColumnInfo = [];
LabelInfoX = [];


switch ThresholdDropDown.Value
    case 'On'
        PlotDataX = [];
        
        for ii = 1:size(Dataset.SelectedData,1)
            switch ThresholdStatisticDropDown.Value
                case 'Minimum'
                    if min(Dataset.SelectedData(ii,:)) > ThresholdEditField.Value
                        PlotDataX(size(PlotDataX,1)+1,:) = Dataset.SelectedData(ii,:);
                        %                         MarkerLabelsX(size(PlotDataX,1),:) = Dataset.SelectedInfo(ii,:);
                        LabelInfoX = vertcat(LabelInfoX,Dataset.SelectedLabelInfo(ii,:));
                        %                         ColumnInfo(size(PlotDataX,1),:) = Dataset.SelectedColumnNames(ii,:);
                        
                    else
                    end
                    
                case 'Max'
                    
                    if max(Dataset.SelectedData(ii,:)) > ThresholdEditField.Value
                        PlotDataX(size(PlotDataX,1)+1,:) = Dataset.SelectedData(ii,:);
                        %                         MarkerLabelsX(size(PlotDataX,1),:) = Dataset.SelectedInfo(ii,:);
                        LabelInfoX = vertcat(LabelInfoX,Dataset.SelectedLabelInfo(ii,:));
                        %                         ColumnInfo(size(PlotDataX,1),:) = Dataset.SelectedColumnNames(ii,:);
                        
                    else
                    end
                    
                case 'Median'
                    
                    if median(Dataset.SelectedData(ii,:)) > ThresholdEditField.Value
                        PlotDataX(size(PlotDataX,1)+1,:) = Dataset.SelectedData(ii,:);
                        %                         MarkerLabelsX(size(PlotDataX,1),:) = Dataset.SelectedInfo(ii,:);
                        LabelInfoX = vertcat(LabelInfoX,Dataset.SelectedLabelInfo(ii,:));
                        %                         ColumnInfo(size(PlotDataX,1),:) = Dataset.SelectedColumnNames(ii,:);
                        
                    else
                    end
                    
                case 'Mean'
                    
                    if mean(Dataset.SelectedData(ii,:)) > ThresholdEditField.Value
                        PlotDataX(size(PlotDataX,1)+1,:) = Dataset.SelectedData(ii,:);
                        %                         MarkerLabelsX(size(PlotDataX,1),:) = Dataset.SelectedInfo(ii,:);
                        LabelInfoX = vertcat(LabelInfoX,Dataset.SelectedLabelInfo(ii,:));
                        %                         ColumnInfo(size(PlotDataX,1),:) = Dataset.SelectedColumnNames(ii,:);
                        
                    else
                    end
                    
            end
        end
        
        Dataset.SelectedData = PlotDataX;
        if size(Dataset.SelectedData,1) == 0
            
            Status{numel(Status)+1} = 'Error: No samples above threshold value';
            return
        else
            Dataset.SelectedData = PlotDataX;
            %             Dataset.SelectedInfo = MarkerLabelsX;
            Dataset.SelectedLabelInfo = LabelInfoX;
            %             Dataset.SelectedColumnInfo = ColumnInfo;
            
            Status{numel(Status)+1} = 'Threshold applied to loaded dataset successfully';
            
            [Dataset, Status] = Transformation(DatasetScalingDropDown, Dataset, Status);
        end
        
    case 'Off'
        [Dataset, Status] = Transformation(DatasetScalingDropDown, Dataset, Status);
end

end

function [Dataset, Status] = Transformation(DatasetScalingDropDown, Dataset, Status)

switch DatasetScalingDropDown.Value
    case 'Log10'
        PlotDataTest = Dataset.SelectedData(:);
        if numel(PlotDataTest(PlotDataTest<=0)) >= 1
            Status{numel(Status)+1} = 'Dataset contained negative values after background subtraction. Negative values have been converted to 1 before Log10 transformation';
            DataX = Dataset.SelectedData;
            DataX(DataX<=0) = 1;
            DataX(isnan(DataX)) = 1;
            DataX(isinf(DataX)) = 1;
            Dataset.SelectedData = log10(DataX);
            return
        else
            Dataset.SelectedData=log10(Dataset.SelectedData);
            Status{numel(Status)+1} = 'Dataset Log10 transformation successful';
        end
         case 'Log2'
        PlotDataTest = Dataset.SelectedData(:);
        if numel(PlotDataTest(PlotDataTest<=0)) >= 1
            Status{numel(Status)+1} = 'Dataset contained negative values after background subtraction. Negative values have been converted to 1 before Log10 transformation';
            DataX = Dataset.SelectedData;
            DataX(DataX<=0) = 1;
            DataX(isnan(DataX)) = 1;
            DataX(isinf(DataX)) = 1;
            Dataset.SelectedData = log2(DataX);
            return
        else
            Dataset.SelectedData=log2(Dataset.SelectedData);
            Status{numel(Status)+1} = 'Dataset Log2 transformation successful';
        end
         case 'Log'
        PlotDataTest = Dataset.SelectedData(:);
        if numel(PlotDataTest(PlotDataTest<=0)) >= 1
            Status{numel(Status)+1} = 'Dataset contained negative values after background subtraction. Negative values have been converted to 1 before Log10 transformation';
            DataX = Dataset.SelectedData;
            DataX(DataX<=0) = 1;
            DataX(isnan(DataX)) = 1;
            DataX(isinf(DataX)) = 1;
            Dataset.SelectedData = log(DataX);
            return
        else
            Dataset.SelectedData=log(Dataset.SelectedData);
            Status{numel(Status)+1} = 'Dataset Log transformation successful';
        end
        
    case 'Linear'
        
end

end