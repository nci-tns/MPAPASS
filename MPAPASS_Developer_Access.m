function [app] = MPAPASS_Developer_Access(app)

Selection = getpref('MPAPASS','DeveloperAcess');

% app.TestMenu.Visible = Selection;

app.ThresholdDropDown.Visible = Selection;
app.ThresholdDropDownLabel.Visible = Selection;

app.ThresholdStatisticDropDown.Visible = Selection;
app.ThresholdStatisticDropDownLabel.Visible = Selection;

app.ThresholdEditField.Visible = Selection;
app.ThresholdEditFieldLabel.Visible = Selection;

app.MergeDatasetsMenu.Visible = Selection;

end