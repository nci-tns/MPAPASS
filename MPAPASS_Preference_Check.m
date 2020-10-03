function [app] = MPAPASS_Preference_Check(app)


if ispref('MPAPASS') == 1 % if FCMPASS preferences exist
    
    if ispref('MPAPASS','version') == 1
    else
        setpref('MPAPASS','version', app.version)
    end
    PrefVersionUpdate(app.version)
    
else
    
    PrefVersionUpdate(app.version)
    
 
end


end

function PrefVersionUpdate(Version)
%% additional preferences in release if preferences already exist

% General
setpref('MPAPASS','version', Version);
setpref('MPAPASS','DeveloperAcess', 'off');

Prefs = {...
    'GlobalFigure_LabelFontStyle', 'Helvetica';...
    'GlobalFigure_LabelFontSize', 14;...
    'GlobalFigure_LabelFontBold', 'on';...
    'GlobalFigure_LabelFontItal', 'off';...
    'GlobalFigure_AxesFontSize', 12;...
    'GlobalFigure_AxesFontBold', 'off';...
    'GlobalFigure_AxesFontItal', 'off';...
    'GlobalFigure_TitleFontSize', 14;...
    'GlobalFigure_TitleFontBold', 'on';...
    'GlobalFigure_TitleFontItal', 'off';...
    'GlobalFigure_FigureOutputSize', 'Auto';...
    'GlobalFigure_FigureOutputDim', [1280 720];...
    'GlobalFigure_FigureBackground', 'none'};

for i = 1:size(Prefs,1)
    if ispref('MPAPASS',Prefs{i,1})
        
    else
        setpref('MPAPASS',Prefs{i,1}, Prefs{i,2})
    end
end

end
