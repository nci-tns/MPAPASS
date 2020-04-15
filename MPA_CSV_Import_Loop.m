function [Database]=MPA_CSV_Import_Loop(Database)

Sample_L = numel(Database.Sample.Sample_Filename_Prefix);
Control_L = numel(Database.Controls.Control_Filename_Prefix);
Total_L = Sample_L + Control_L;

Filenames(1:Sample_L) = Database.Sample.Sample_Filename_Prefix;
Filenames(Sample_L+1:Total_L) = Database.Controls.Control_Filename_Prefix; % interleaf so Databaseset is sample, control, sample, control, etc

Group_No = length((Filenames));     % Number of groups that are going to be imported

Set_No = 1;   % Starting set import number for the loop
prog = 0;     % waitbar prog counter 1
prog2 = 0;    % waitbar prog counter 2

[f]=waitbaron();

for string = 1:Group_No
    
    for x = 1:numel(Database.Beads.Bead_Identifier)
        
        Name = cellstr(strcat({char(Filenames{string})}, strcat((Database.Beads.Bead_Identifier(x)),'.csv')));          % concatenates above strings
        
        if string <= Sample_L % sample import loop
            
            % reads constructed string and attempts to import as csv. Ignores error message if file is empty.
            try
                Database.SampleDataset{x,Set_No} = csvread(Name{1});
                Database.SampleRecovery{x,Set_No} = numel(Database.SampleDataset{x,Set_No});
            catch
                Database.SampleDataset{x,Set_No} = 0;
                Database.SampleRecovery{x,Set_No} = 0;
                
            end
            
        else % control import loop
            
            if string == Sample_L+1     % reset loops for the control database
                Set_No = 1;             % Starting set import number for the loop
            else
            end
            
            % reads constructed string and attempts to import as csv. Ignores error message if file is empty.
            try  Database.ControlDataset{x,Set_No} = csvread(Name{1});
                Database.ControlRecovery{x,Set_No} = numel(Database.SampleDataset{x,Set_No});
                
            catch
                Database.ControlDataset{x,Set_No} = 0;
                Database.ControlRecovery{x,Set_No} = 0;
                
            end
            
        end
    end
    
    if string <= Sample_L % sample import loop
        Set_No=size(Database.SampleDataset,2)+1;     % calculates the length of the Databaseset and adds one for the next file import
    else
        Set_No=size(Database.ControlDataset,2)+1;     % calculates the length of the Databaseset and adds one for the next file import
    end
    
    [prog2] = waitbarprogress(string, Group_No, prog2, f); % update progress bar
    
end

close(f)    % close progress bar

end

function [f]=waitbaron()
f = waitbar(0,'Constructing Dataset... (0%)');
f.CurrentAxes.Title.FontSize = 14;
end

function [prog2] = waitbarprogress(string, Group_No, prog2, f)
prog = round(100*((string/Group_No)));

if prog > prog2+3
    f = waitbar((string/Group_No), f,['Constructing Dataset... (',num2str(round(100*((string/Group_No)))),'%)']);  % show progress
    prog2 = prog;
else
end

end