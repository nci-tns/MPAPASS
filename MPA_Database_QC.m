function [msg, fail] = MPA_Database_QC(Database)

flag = 0;
Low_pass = 0;

%% Check Dataset Headings Exist
Sample_Headings = {'Sample_Filename_Prefix','Sample_Set_ID', 'Sample_ID','Sample_Grouping_ID', 'Sample_Control_ID', 'Sample_Label_Mix_No'};

for i = 1:numel(Sample_Headings)
    pres = any(strcmp(Sample_Headings{i}, Database.Sample.Properties.VariableNames));
    if pres == 1
    else
        flag = flag + 1;
        Low_pass = 1;
        fail = 1;
        msg{flag} = [' | Error: Heading ',Sample_Headings{i},' does not exist in database' ];
    end
end

BeadAssay_Headings = {'Bead_Identifier','Bead_CaptureAntibody_Target'};

for i = 1:numel(BeadAssay_Headings)
    pres = any(strcmp(BeadAssay_Headings{i}, Database.Beads.Properties.VariableNames));
    if pres == 1
    else
        flag = flag + 1;
        Low_pass = 1;
        fail = 1;
        msg{flag} = [' | Error: Heading ',BeadAssay_Headings{i},' does not exist in database' ];
    end
end

Labelling_Headings = {'Mix_Number','Import_Column_Number','Label_Target'};

for i = 1:numel(Labelling_Headings)
    pres = any(strcmp(Labelling_Headings{i}, Database.Labelling.Properties.VariableNames));
    if pres == 1
    else
        flag = flag + 1;
        Low_pass = 1;
        fail = 1;
        msg{flag} = [' | Error: Heading ',Labelling_Headings{i},' does not exist in database' ];
    end
end

General_Headings = {'CSV_Directory'};

for i = 1:numel(General_Headings)
    pres = any(strcmp(General_Headings{i}, Database.General.Properties.VariableNames));
    if pres == 1
    else
        flag = flag + 1;
        Low_pass = 1;
        fail = 1;
        msg{flag} = [' | Error: Heading ',General_Headings{i},' does not exist in database' ];
    end
end

Control_Headings = {'Control_Filename_Prefix','Sample_Label_Mix_No','Control_Name'};

for i = 1:numel(General_Headings)
    pres = any(strcmp(Control_Headings{i}, Database.Controls.Properties.VariableNames));
    if pres == 1
    else
        flag = flag + 1;
        Low_pass = 1;
        fail = 1;
        msg{flag} = [' | Error: Heading ',Control_Headings{i},' does not exist in database' ];
    end
end

if Low_pass == 1 % if essential worksheet headings do not exist stop
    
else    % if essential worksheet headings exist perform high level checks
    
    %% Check files for filenames exist or are in the specified directory
    Filenames = vertcat(Database.Sample.Sample_Filename_Prefix, Database.Controls.Control_Filename_Prefix);
    path = [char(Database.General.CSV_Directory),char('/')];
    ext = '.csv';
    
    for i = 1:numel(Database.Beads.Bead_Identifier) % cycle capture bead suffixes to filenames
        beadnum = char(Database.Beads.Bead_Identifier{i});
        for ii = 1:numel(Filenames) % cycle filenames
            
            name = [path,char(Filenames{ii}), beadnum, ext]; % construct file names
            if isfile(name)  % File exists.
            else  % File does not exist.
                flag = flag + 1;
                fail = 1;
                msg{flag} = [' | Error: File does not exist in directory: ', char(Filenames{ii}), beadnum, ext];
            end
            
        end
    end
    
    %% Check for Continuity in Dataset
    if isa(Database.Sample.Sample_Set_ID,'double') == 1
        Sample = Database.Sample.Sample_Set_ID;
    else
        Sample = str2double(Database.Sample.Sample_Set_ID);
    end
    
    Sample_Mix_ID = Database.Sample.Sample_Label_Mix_No;
    Mix_No = max(Database.Labelling.Mix_Number);
    str = unique(Sample);
    
    if numel(str) < max(str)
        flag = flag + 1;
        fail = 1;
        msg{flag} = [' | Error: Sample_Set_ID has missing numbers in the sequence'];
    else
    end
    
    for ii = 1:numel(str)   % Check that the number of sample referenced is repeated the same number of times at the the number of labelling mixes.
        
        C =  sum(Sample==ii);
        
        if C == Mix_No
        else
            flag = flag + 1;
            msg{flag} = [' | Error: Sample_ID: ', num2str(ii),' does not have ', num2str(Mix_No), ' Sample_ID''s associated'];
        end
        
        D =  Sample_Mix_ID(Sample==ii);
        
        for i = 1:D
            
            E = sum(D==i);
            
            if E == 1
            elseif E == 0
                flag = flag + 1;
                msg{flag} = [' | Error: ''Sample_ID'': ', num2str(ii),' does not have ''Sample_Label_Mix_No'' == ', num2str(i), ' associated'];
            elseif E > 1
                flag = flag + 1;
                msg{flag} = [' | Error: ''Sample_ID'': ', num2str(ii),' has more than one Sample_Label_Mix_No'' == ', num2str(i), ' associated'];
            end
            
        end
        
        CriteriaCheck = Database.Sample(Sample == ii,:);
        
        if numel(unique(CriteriaCheck.Sample_ID)) > 1
            flag = flag + 1;
            msg{flag} = [' | Error: Mismatch between number of ''Sample_Set_IDs'': ', num2str(ii),' and associated Sample_ID'];
        elseif numel(unique(CriteriaCheck.Sample_Grouping_ID)) > 1
            flag = flag + 1;
            msg{flag} = [' | Error: Mismatch between number of ''Sample_Set_IDs'': ', num2str(ii),' and associated Sample_Grouping_ID'];
        elseif numel(unique(CriteriaCheck.Sample_Grouping_ID)) > 1
            flag = flag + 1;
            msg{flag} = [' | Error: Mismatch between number of ''Sample_Set_IDs'': ', num2str(ii),' and associated Incubated_Sample_Volume'];
        elseif numel(unique(CriteriaCheck.Sample_Grouping_ID)) > 1
            flag = flag + 1;
            msg{flag} = [' | Error: Mismatch between number of ''Sample_Set_IDs'': ', num2str(ii),' and associated Sample_Source'];
            
        end
    end
end

if flag == 0
    msg{1} = ' | Database QC Successful';
    fail = 0;
else
    fail = 1;
end


end