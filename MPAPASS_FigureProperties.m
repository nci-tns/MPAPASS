function [app] = MPAPASS_FigureProperties(app)

% figure position
switch getpref('MPAPASS','GlobalFigure_FigureOutputSize')
    case 'Auto'
        switch get(gcf,'Tag')
            case 'boxplot'
                set(gcf, 'Units','Normalized','position',[0 0.5 1 0.5]);
            otherwise
                set(gcf, 'Units','Normalized','position',[0 0 1 1]);
        end
    case 'Manual'
        pos = getpref('MPAPASS','GlobalFigure_FigureOutputDim');
        set(gcf, 'Units','pixels','position',[0 0 pos]);
        set(gcf, 'color', getpref('MPAPASS','GlobalFigure_FigureBackground'))
end

plot = gcf;

if numel(plot.Children) == 1
    switch plot.Children.Type
        case 'tiledlayout'
            subplots = plot.Children;
        otherwise
            subplots = plot;
    end
end

for i = 1:numel(plot.Children)
    try
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
        Fig.Title.FontSize = getpref('MPAPASS','GlobalFigure_LabelFontSize');
        Fig.Title.FontName = getpref('MPAPASS','GlobalFigure_LabelFontStyle');
        switch getpref('MPAPASS','GlobalFigure_LabelFontBold')
            case 'off'
                Fig.Title.FontWeight = 'normal';
            case 'on'
                Fig.Title.FontWeight = 'bold';
        end
    catch
    end
end
end
