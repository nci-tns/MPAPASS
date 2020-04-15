function [] = MPA_boxplot(Dataset, BPInfo)

if BPInfo.MarkerNumber ==0
    Select = size(Dataset.SelectedData,1);
else
    Select = BPInfo.MarkerNumber;
    
end

Select = min([Select, size(Dataset.SelectedData,1)]);

[i1, ~, i3] = unique(Dataset.SelectedInfo.(BPInfo.Criteria), 'stable');
[i5, i4] = sort(i3);

PlotData = Dataset.SelectedData(:,i4);
PlotInfo = Dataset.SelectedInfo(i4,:);

for i = 1:numel(i1)
    Y{i}(:,1) = min(PlotData(:,i5==i),[],2);
    Y{i}(:,2:4) = prctile(PlotData(:,i5==i),[25 50 75], 2);
    Y{i}(:,5) =  max(PlotData(:,i5==i),[],2);
    RawGroup{i} = PlotData(:,i5==i);
end

switch BPInfo.Ranking
    case 'on'
        switch BPInfo.RankingType
            case 'range'
                
                for i = 1:numel(i1)
                    Medians(:,i) = Y{i}(:,3);
                end
                Rs = range(Medians,2);
                [~, ord2] = sort(Rs, 'descend');
                
            case 'significance'
                for i = 1:size(PlotData,1)
                    p(i) = kruskalwallis(PlotData(i,:),i3,'off');
                end
                [~, ord2] = sort(p);
            case 'expression'
                [~, ord2] = sort(sum(cell2mat(Y),2), 'descend');
                
        end
    case 'off'
        ord2 = 1:size(PlotData,1);
end

col = lines(numel(i1));
col = [col repmat(BPInfo.FaceAlpha,size(col,1),1)];
Space = 0.4/1+numel(i1);
Gap = BPInfo.Spacing/2;

fig = figure;
ax = axes;
maxY = 0;

for i = 1:Select
    FactorGap = linspace(i-Gap, i+Gap, 1+numel(i1));
    
    for ii = 1:numel(i1)
        Data = RawGroup{ii}(ord2,:);
        switch BPInfo.Style
            case {'Box','Box & Whisker'}
                
                R_B = FactorGap(ii); % bottom
                R_L = Y{ii}(ord2(i),2);   % left
                R_R = FactorGap(ii+1)-FactorGap(ii); % top
                R_T = Y{ii}(ord2(i),4)-Y{ii}(ord2(i),2);    % right
                
                if  Y{ii}(ord2(i),5) > maxY
                    maxY = Y{ii}(ord2(i),5);
                else
                end
                rectangle('Position',[R_B R_L R_R R_T], 'FaceColor',col(ii,:), 'EdgeColor','k','LineWidth',0.75);
                hold on
                line([FactorGap(ii) FactorGap(ii+1)], [Y{ii}(ord2(i),3) Y{ii}(ord2(i),3)], 'LineWidth',1, 'Color','k')
                
                switch BPInfo.Style
                    case 'Box & Whisker'
                        
                        center = R_B + (R_R/2);
                        line([FactorGap(ii) FactorGap(ii+1)], [Y{ii}(ord2(i),1) Y{ii}(ord2(i),1)], 'LineWidth',1, 'Color','k')
                        line([FactorGap(ii) FactorGap(ii+1)], [Y{ii}(ord2(i),5) Y{ii}(ord2(i),5)], 'LineWidth',1, 'Color','k')
                        line([center center], [Y{ii}(ord2(i),1) Y{ii}(ord2(i),2)], 'LineWidth',1, 'Color','k')
                        line([center center], [Y{ii}(ord2(i),5) Y{ii}(ord2(i),4)], 'LineWidth',1, 'Color','k')

                    otherwise
                end
            case 'Scatter'
                
                R_B = FactorGap(ii); % bottom
                R_L = Y{ii}(ord2(i),2);   % left
                R_R = FactorGap(ii+1)-FactorGap(ii); % top
                R_T = Y{ii}(ord2(i),4)-Y{ii}(ord2(i),2);    % right
                center = (R_B+(R_R/2));
                
                xData = normrnd(center,0.025,[1 size(Data,2)]);
                yData = sort(Data(i,:));
                scatter(xData, yData, 20, 'filled', 'MarkerFaceColor',col(ii,1:3),'MarkerEdgeColor','k')
                hold on
                                line([FactorGap(ii) FactorGap(ii+1)], [Y{ii}(ord2(i),3) Y{ii}(ord2(i),3)], 'LineWidth',2, 'Color','k')

            case 'Box + Scatter'
                
                R_B = FactorGap(ii); % bottom
                R_L = Y{ii}(ord2(i),2);   % left
                R_R = FactorGap(ii+1)-FactorGap(ii); % top
                R_T = Y{ii}(ord2(i),4)-Y{ii}(ord2(i),2);    % right
                
                if  Y{ii}(ord2(i),5) > maxY
                    maxY = Y{ii}(ord2(i),5);
                else
                end
                rectangle('Position',[R_B R_L R_R R_T], 'FaceColor','none', 'EdgeColor','k','LineWidth',0.75);
                hold on
                line([FactorGap(ii) FactorGap(ii+1)], [Y{ii}(ord2(i),3) Y{ii}(ord2(i),3)], 'LineWidth',1, 'Color','k')

                center = (R_B+(R_R/2));
                
                xData = normrnd(center,0.025,[1 size(Data,2)]);
                yData = sort(Data(i,:));
                scatter(xData, yData, 40, 'filled', 'MarkerFaceColor',col(ii,1:3),'MarkerEdgeColor','k','LineWidth',0.1,'MarkerEdgeAlpha',0.5)
                hold on
                
                %                 xdata = repmat(FactorGap(ii)+0.5, size(RawGroup{ii}, ))
                
                %                 scatter()
        end
        
    end
end

fig.Tag = 'boxplot';
ax.TickDir = 'out';
ax.TickLength = [0.005 0.005];
% ax.FontWeight = 'bold';
ax.FontSize = 12;
ylabel('Normalized Staining Intensity')
ax.LineWidth = 0.75;
box on


maxY = round((maxY*1.05),1);

% ylim([0 maxY])

xlim([0.5 Select+0.5])
xticks(1:Select)

switch BPInfo.Dividers
    case 'On'
        for i = 1:Select
            if i == Select
            else
                line([i+0.5 i+0.5], ylim,'Color','k')
            end
        end
    case 'Off'
end

for ii = 1:numel(i1)
    hline(ii) = patch([NaN,NaN NaN NaN],[NaN NaN NaN NaN],col(ii,:),'LineWidth',1,'LineStyle','-');
    hline(ii).FaceColor = col(ii,1:3);
    hline(ii).FaceAlpha = 0.5;
end

switch BPInfo.Orientation
    case 'Portrait'
        camroll(270)
        legend(hline, i1, 'Orientation','horizontal','Location','southoutside', 'FontSize', 12, 'NumColumns', 5)
    case 'Landscape'
        xtickangle(90)
        legend(hline, i1, 'Orientation','horizontal','Location','northoutside', 'FontSize', 12, 'NumColumns', 5)
        
end
MarkerLabels = BPInfo.MarkerLabels(ord2);
MarkerLabels = MarkerLabels(1:Select);
xticklabels(MarkerLabels)




end