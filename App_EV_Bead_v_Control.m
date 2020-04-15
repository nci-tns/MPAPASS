function    App_EV_Bead_v_Control(app)

Odd_i=1:2:((size(app.Dataset,2)*2)-1); % index for odd columns which are all EV capture beads
Even_i=2:2:(size(app.Dataset,2)*2);    % index for even columns which are all control beads

app.Column_No = contains(app.MixTable.Mix, app.Database.Loaded_Samples_Listbox.Ab_Mix_No(1));
app.Column_No(app.Column_No==0)=[];
app.Column_No = numel(app.Column_No);

for iy = 1:size(app.Dataset,1)         % row index
    for ix = 1:(size(app.Dataset,2)/2) % column index
        
        Median_EV_Bead = median(app.Dataset{iy,Odd_i(ix)},1);    % median intensity of the EV capture bead
        Median_Ctrl_Bead = median(app.Dataset{iy,Even_i(ix)},1); % median intensity of the control capture bead
        IQR_EV_Bead = iqr(app.Dataset{iy,Odd_i(ix)},1);          % interquartile range of EV capture bead
        IQR_Ctrl_Bead = iqr(app.Dataset{iy,Even_i(ix)},1);       % interquartile range of control capture bead
        
        switch app.MPA_Parameter.Norm
            
            case 1  % background subtraction
                
                app.Norm_Dataset.Cell{iy,ix} = Median_EV_Bead - Median_Ctrl_Bead;
                
            case 2  % background subtraction over sum of interquartile range
                
                app.Norm_Dataset.Cell{iy,ix} = (Median_EV_Bead-Median_Ctrl_Bead) ./ (IQR_EV_Bead + IQR_Ctrl_Bead);
                
            case 3   % fold increase over control bead
                
                app.Norm_Dataset.Cell{iy,ix} = Median_EV_Bead ./ Median_Ctrl_Bead;
                
        end
        
        app.Norm_Dataset.Length.EV{iy,ix} = numel(app.Dataset{iy,Odd_i(ix)}) / app.Column_No;          % bead recovery for samples
        app.Norm_Dataset.Length.Control{iy,ix} = numel(app.Dataset{iy,Even_i(ix)}) / app.Column_No;    % bead recovery for controls
        
    end
end

Norm_Dataset_Restructure(app)

end