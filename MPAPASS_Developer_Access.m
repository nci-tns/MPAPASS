function [app] = MPAPASS_Developer_Access(app)

Selection = getpref('MPAPASS','DeveloperAcess');

app.TestMenu.Visible = Selection;
app.PreferencesMenu.Visible = 'on';
app.MergeMenu.Visible = Selection;

app.ThresholdDropDown.Visible = Selection;
app.ThresholdDropDownLabel.Visible = Selection;

app.ThresholdStatisticDropDown.Visible = Selection;
app.ThresholdStatisticDropDownLabel.Visible = Selection;

app.ThresholdEditField.Visible = Selection;
app.ThresholdEditFieldLabel.Visible = Selection;


switch Selection
    case 'on'
        app.HeatmapStyleDropDown.Items = {'Classic','Circular'};
        app.PlotTypeDropDown.Items = {'2D Scatter', '2D Biplot', '3D Scatter', '3D Biplot'};
    case 'off'
        app.HeatmapStyleDropDown.Items = {'Classic'};
        app.PlotTypeDropDown.Items = {'2D Scatter', '3D Scatter'};
end

end