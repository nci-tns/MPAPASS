function [PlotData, MarkerLabel, SampleLabel, RowLeafOrder, ColumnLeafOrder, Z1, Z2] = MPA_Database_Clustering_Grouping_v1(Dataset, PlotData, MarkerLabel, SampleLabel, MarkerOrderDropDown, SampleOrderDropDown, ClusteringDropDown, LinkageDropDown, GroupMarkersbyDropDown, GroupSamplesbyDropDown)



switch ClusteringDropDown.Value
    case 'No Clustering'
        Z1 = [];
        Z2 = [];
        RowLeafOrder = [];
        ColumnLeafOrder = [];

    otherwise
        [Z1, Z2, RowLeafOrder, ColumnLeafOrder] = SampleLinkage(PlotData, ClusteringDropDown, LinkageDropDown);
        
        if isempty(ColumnLeafOrder) == 1
        else
            SampleLabel = SampleLabel(ColumnLeafOrder);
            PlotData = PlotData(:,ColumnLeafOrder);
        end
        
        if isempty(RowLeafOrder) == 1
        else
            MarkerLabel = MarkerLabel(RowLeafOrder);
            PlotData = PlotData(RowLeafOrder,:);
        end
end

switch MarkerOrderDropDown.Value
    case 'Default'
        
    case 'Group' % Marker Grouping
        switch ClusteringDropDown.Value
            case 'Both' % stop grouping and clustering simultaneously
            case 'Marker Clustering' % stop grouping and clustering simultaneously
            otherwise
                [~, ~, i3] = unique(Dataset.SelectedLabelInfo.(GroupMarkersbyDropDown.Items{GroupMarkersbyDropDown.Value}), 'stable');
                [~, i4] = sort(i3);
                
                PlotData = PlotData(i4,:);
                MarkerLabel = MarkerLabel(i4);
        end
end

switch SampleOrderDropDown.Value
    case 'Default'
        
    case 'Group' % Sample Grouping
        switch ClusteringDropDown.Value
            case 'Both' % stop grouping and clustering simultaneously
            case 'Sample Clustering' % stop grouping and clustering simultaneously
            otherwise
                [~, ~, i1] = unique(Dataset.SelectedInfo.(GroupSamplesbyDropDown.Items{GroupSamplesbyDropDown.Value}), 'stable');
                [~, i2] = sort(i1);
                
                PlotData = PlotData(:,i2);
                SampleLabel = SampleLabel(i2);
        end
end



end

function [Z1, Z2, RowLeafOrder, ColumnLeafOrder] = SampleLinkage(PlotData, ClusteringDropDown, LinkageDropDown)

switch LinkageDropDown.Value
    case 'Average';          type = 'average';
    case 'Complete';         type = 'complete';
    case 'Centroid';         type = 'centroid';
    case 'Median';           type = 'median';
    case 'Weighted Average'; type = 'weighted';
    case 'Ward';             type = 'ward';
end

Z1 = [];
Z2 = [];

switch ClusteringDropDown.Value
    case 'Sample Clustering'
        Y2 = pdist(PlotData'); 
        Z2 = linkage(Y2, type);
        leafOrder2 = optimalleaforder(Z2,Y2); % hierachical clustering of markers
        ColumnLeafOrder = leafOrder2;
        RowLeafOrder = [];
        
    case 'Marker Clustering'
        Y1 = pdist(PlotData); 
        Z1 = linkage(Y1, type);
        leafOrder = optimalleaforder(Z1,Y1); % hierachical clustering of markers
        RowLeafOrder = leafOrder;
        ColumnLeafOrder = [];
        
    case 'Both'
        Y1 = pdist(PlotData); Z1 = linkage(Y1, type);
        leafOrder = optimalleaforder(Z1,Y1); % hierachical clustering of markers
        
        Y2 = pdist(PlotData'); Z2 = linkage(Y2, type);
        leafOrder2 = optimalleaforder(Z2,Y2); % hierachical clustering of markers
        
        ColumnLeafOrder = leafOrder2;
        RowLeafOrder = leafOrder;
end

end