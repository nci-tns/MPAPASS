function  [EV_Data, Ctrl_Data] = MPA_HistogramSampleSelection(HistogramInput, DatasetIndex, Database)

Sample_Mix = char(strcat(HistogramInput.Sample, {' '}, HistogramInput.Mix));
C_Col = DatasetIndex.Num(find(strcmp(DatasetIndex.Names, Sample_Mix)));
C_Row = HistogramInput.Bead;
Col = Database.Labelling.Import_Column_Number(find(contains(Database.Labelling.Label_Target, SecondaryMarkerDropDown.Items(SecondaryMarkerDropDown.Value))));

EV_Data = Dataset{C_Row, C_Col}(:,Col);
Ctrl_Data = Dataset{C_Row, C_Col+1}(:,Col);
end