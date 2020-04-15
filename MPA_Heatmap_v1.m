function MPA_Heatmap_v1(PlotData, MarkerLabel, SampleLabel, GridLines)

PlotData(end+1,:) = 0;
PlotData(:,end+1) = 0;

X = 1.5:1:size(PlotData,2);
Y = 1.5:1:size(PlotData,1);

SampleLabel = strrep(SampleLabel,'_',' ');
MarkerLabel = strrep(MarkerLabel,'_',' ');

h = pcolor(PlotData);
set(gca,'YTick', Y, 'YTickLabel',SampleLabel,'XTick', X,'XTickLabel',MarkerLabel)

switch GridLines
    case 'off'
set(h,'EdgeColor', 'none')
    otherwise
end
xtickangle(90)

end
