clear 

Files{1} = '/Users/welshjoa/OneDrive - National Institutes of Health/Research/NIH/Papers/2020/Incomplete/Multiplex/Figures/Cell Line Database Merges/Export1.mat';
Files{2} = '/Users/welshjoa/OneDrive - National Institutes of Health/Research/NIH/Papers/2020/Incomplete/Multiplex/Figures/Cell Line Database Merges/Database2_CellLineMegaplex.mat';
Files{3} = '/Users/welshjoa/OneDrive - National Institutes of Health/Research/NIH/Papers/2020/Incomplete/Multiplex/Figures/Cell Line Database Merges/Database 1.mat';

Data{1} = load(Files{1});
SampleFields = fieldnames(Data{1}.Database.Sample);
LabelFields = fieldnames(Data{1}.Database.Labelling);
ControlFields = fieldnames(Data{1}.Database.Controls);

for i = 1:numel(Files)-1
    ind = i +1;
Data{ind} = load(Files{ind});
SampleFields = SampleFields(contains(SampleFields, fieldnames(Data{ind}.Database.Sample)));
LabelFields = LabelFields(contains(LabelFields, fieldnames(Data{ind}.Database.Labelling)));
ControlFields = ControlFields(contains(ControlFields, fieldnames(Data{ind}.Database.Controls)));
end

SampleT = Data{1}.Database.Sample(:, contains(Data{1}.Database.Sample.Properties.VariableNames, SampleFields));
SampleT = convertvars(SampleT,@iscell,'categorical');
SampleT = convertvars(SampleT,@isnumeric,'categorical');

T_s = double(SampleT.Sample_Set_ID);
T_smax = max(T_s);

for i = 1:numel(Data)-1
    ind = i+1;
    T2 = Data{ind}.Database.Sample(:, contains(Data{ind}.Database.Sample.Properties.VariableNames, SampleFields));
    T2 = convertvars(T2,@iscell,'categorical');
    T_s = double(T2.Sample_Set_ID);
    
    T2.Sample_Set_ID = T_s+T_smax;
    T2 = convertvars(T2,@isnumeric,'categorical');
    SampleT = vertcat(SampleT,T2);
    
    T_s = double(T2.Sample_Set_ID);
    Tmax = max(T_s);
end

