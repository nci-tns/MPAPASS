function [] = BeadtemplateImport(app)

SetNames = sheetnames('BeadTemplate.xlsx');

app.PresetBeadsDropDown.Items = replace(SetNames,'_',' ');

ImportedData = table2cell(readtable('BeadTemplate.xlsx','Sheet',SetNames{1}));

app.BeadTable.Data = false(size(ImportedData,1),1)

end