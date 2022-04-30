function [app] = MPAPASS_FigureProperties(app)

% get all figure handles
figHandles = findall(groot, 'Type', 'figure');
for i = 1:numel(figHandles)
    figvis(i) = figHandles(i).Visible;
end

% if a new figure is being plotted apply to only it, otherwise apply to all
visInd = figvis=='off';
if max(visInd) == 1
    gcfhandles = figHandles(visInd);
else
    gcfhandles = figHandles;
end

% remove the GUI from figures being modified
for i = 1:numel(gcfhandles)
    ind(i) = strcmp(gcfhandles(i).Name,'MPAPASS');
end
gcfhandles = gcfhandles(~ind);

for ii = 1:numel(gcfhandles)
    plot = gcfhandles(ii);
    
    % figure position
    switch getpref('MPAPASS','GlobalFigure_FigureOutputSize')
        case 'Auto'
            switch get(plot,'Tag')
                case 'boxplot'
                    set(plot, 'Units','Normalized','position',[0 0.5 1 0.5]);
                otherwise
                    set(plot, 'Units','Normalized','position',[0 0 1 1]);
            end
        case 'Manual'
            pos = getpref('MPAPASS','GlobalFigure_FigureOutputDim');
            set(gcfhandles(ii), 'Units','pixels','position',[0 0 pos]);
            set(gcfhandles(ii), 'color', getpref('MPAPASS','GlobalFigure_FigureBackground'))
    end
    
    if numel(plot.Children) == 1
        switch plot.Children.Type
            case 'tiledlayout'
                subplots = plot.Children;
                
                % label properties
                subplots.XLabel.FontSize = getpref('MPAPASS','GlobalFigure_LabelFontSize');
                subplots.YLabel.FontSize = getpref('MPAPASS','GlobalFigure_LabelFontSize');
                subplots.XLabel.FontName = getpref('MPAPASS','GlobalFigure_LabelFontStyle');
                subplots.YLabel.FontName = getpref('MPAPASS','GlobalFigure_LabelFontStyle');
                
                switch getpref('MPAPASS','GlobalFigure_LabelFontBold')
                    case 'off'
                        subplots.XLabel.FontWeight = 'normal';
                        subplots.YLabel.FontWeight = 'normal';
                    case 'on'
                        subplots.XLabel.FontWeight = 'bold';
                        subplots.YLabel.FontWeight = 'bold';
                end
                
                % title properties
                subplots.Title.FontSize = getpref('MPAPASS','GlobalFigure_TitleFontSize');
                subplots.Title.FontName = getpref('MPAPASS','GlobalFigure_LabelFontStyle');
                switch getpref('MPAPASS','GlobalFigure_TitleFontBold')
                    case 'off'
                        subplots.Title.FontWeight = 'normal';
                    case 'on'
                        subplots.Title.FontWeight = 'bold';
                end
                
                
            otherwise
                subplots = plot;
        end
    end
    
    for i = 1:numel(subplots.Children)
        try
            Type = subplots.Children(i).Type;
            switch Type
                case 'legend'
                otherwise
                    Fig = subplots.Children(i);
                    % axes properties
                    Fig.FontSize = getpref('MPAPASS','GlobalFigure_AxesFontSize');
                    Fig.FontName = getpref('MPAPASS','GlobalFigure_LabelFontStyle');
                    switch getpref('MPAPASS','GlobalFigure_AxesFontBold')
                        case 'off'
                            Fig.FontWeight = 'normal';
                        case 'on'
                            Fig.FontWeight = 'bold';
                    end
                    
                    % label properties
                    Fig.XLabel.FontSize = getpref('MPAPASS','GlobalFigure_LabelFontSize');
                    Fig.YLabel.FontSize = getpref('MPAPASS','GlobalFigure_LabelFontSize');
                    Fig.XLabel.FontName = getpref('MPAPASS','GlobalFigure_LabelFontStyle');
                    Fig.YLabel.FontName = getpref('MPAPASS','GlobalFigure_LabelFontStyle');
                    
                    switch getpref('MPAPASS','GlobalFigure_LabelFontBold')
                        case 'off'
                            Fig.XLabel.FontWeight = 'normal';
                            Fig.YLabel.FontWeight = 'normal';
                        case 'on'
                            Fig.XLabel.FontWeight = 'bold';
                            Fig.YLabel.FontWeight = 'bold';
                    end
                    
                    % title properties
                    Fig.Title.FontSize = getpref('MPAPASS','GlobalFigure_TitleFontSize');
                    Fig.Title.FontName = getpref('MPAPASS','GlobalFigure_TitleFontStyle');
                    switch getpref('MPAPASS','GlobalFigure_TitleFontBold')
                        case 'off'
                            Fig.Title.FontWeight = 'normal';
                        case 'on'
                            Fig.Title.FontWeight = 'bold';
                    end
            end
        catch
        end
    end
end
end
