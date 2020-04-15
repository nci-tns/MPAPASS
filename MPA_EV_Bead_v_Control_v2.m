function   [Database] = MPA_EV_Bead_v_Control_v2(Database, Norm_Method)


% obtain number of colours to import per mix
for i = 1:max(Database.Labelling.Mix_Number)
    Colors(i) = max(Database.Labelling.Import_Column_Number(Database.Labelling.Mix_Number==i,:));
end

nRow = size(Database.SampleDataset,1);  
nCol = size(Database.SampleDataset,2);

for iy = 1:nRow         % bead index
    for ix = 1:nCol       % filename index
        
        CtrlIndex = Database.Sample.Sample_Control_ID(ix);
        
        Median_Ctrl_Bead = median(Database.ControlDataset{iy, CtrlIndex},1); % median intensity of the control capture bead
        Median_EV_Bead = median(Database.SampleDataset{iy,ix},1);    % median intensity of the EV capture bead
        
        switch Norm_Method
            
            case 'Background Subtraction'
                Database.Norm.Cell{iy,ix} = Median_EV_Bead - Median_Ctrl_Bead;
                
            case 'Stain Index 1'
%                 IQR_EV_Bead = iqr(Database.SampleDataset{iy,ix},1);             % interquartile range of EV capture bead
%                 IQR_Ctrl_Bead = iqr(Database.ControlDataset{iy, CtrlIndex},1);  % interquartile range of control capture bead
                
                SD_EV_Bead = prctile(Database.SampleDataset{iy,ix},5,1) + prctile(Database.SampleDataset{iy,ix},50,1);             % interquartile range of EV capture bead
                SD_Ctrl_Bead = prctile(Database.ControlDataset{iy, CtrlIndex},95,1) - prctile(Database.ControlDataset{iy, CtrlIndex},50,1);  % interquartile range of control capture bead
                
                Database.Norm.Cell{iy,ix} = (Median_EV_Bead-Median_Ctrl_Bead) ./ (SD_EV_Bead + SD_Ctrl_Bead);
             
            case 'Stain Index 2'
                SD_Ctrl_Bead = prctile(Database.ControlDataset{iy, CtrlIndex},95,1) ;  % interquartile range of control capture bead
                Database.Norm.Cell{iy,ix} = (Median_EV_Bead-Median_Ctrl_Bead) ./ (SD_Ctrl_Bead);
                    
            case 'Fold Increase'
                Database.Norm.Cell{iy,ix} = Median_EV_Bead ./ Median_Ctrl_Bead;
                
        end
        
        Database.Recovery.EV{iy,ix} = size(Database.SampleDataset{iy,ix},1) ;          % bead recovery for samples
        
    end
end

end
