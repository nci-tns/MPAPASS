function   [Database] = MPA_EV_Bead_v_Control_v3(Database, Norm_Method, Scaling)


% obtain number of colours to import per mix
for i = 1:max(Database.Labelling.Mix_Number)
    Colors(i) = max(Database.Labelling.Import_Column_Number(Database.Labelling.Mix_Number==i,:));
end

nRow = size(Database.SampleDataset,1);
nCol = size(Database.SampleDataset,2);
minV = 0;


DataCheck = [Database.ControlDataset(:); Database.SampleDataset(:)]; % create 1 x n cell array
 a = cellfun(@median, DataCheck, 'UniformOutput', false); % get median values of all columns
 b = cellfun(@min, a, 'UniformOutput', false); % find minimum median value to normalise by
 minV = min(cell2mat(b));

for iy = 1:nRow         % bead index
    for ix = 1:nCol       % filename index
        
        CtrlIndex = Database.Sample.Sample_Control_ID(ix);
        
        CtrlData = Database.ControlDataset{iy, CtrlIndex} + abs(minV);
        EVData = Database.SampleDataset{iy,ix} + abs(minV);
        
        switch Norm_Method
            
            case 'Background Subtraction'
                [CtrlData, EVData] = ScalingType(Scaling, CtrlData, EVData);
                Database.Norm.Cell{iy,ix} = prctile(EVData,50,1) - prctile(CtrlData,50,1);
                
            case 'Stain Index 1' % standard stain index
                [CtrlData, EVData] = ScalingType(Scaling, CtrlData, EVData);
                SD_EV_Bead = prctile(EVData,5,1) + prctile(EVData,50,1);             % interquartile range of EV capture bead
                SD_Ctrl_Bead = prctile(CtrlData,95,1) - prctile(CtrlData,50,1);  % interquartile range of control capture bead
                
                Database.Norm.Cell{iy,ix} = ((prctile(EVData,50,1)-prctile(CtrlData,50,1))) ./ ((SD_EV_Bead + SD_Ctrl_Bead));
                
            case 'Stain Index 2' % Bigos method
                [CtrlData, EVData] = ScalingType(Scaling, CtrlData, EVData);
                Database.Norm.Cell{iy,ix} = ((prctile(EVData,50,1)-prctile(CtrlData,50,1))) ./ prctile(CtrlData,95,1) ;
                
            case 'Fold Change'
                switch Scaling % fold change needs scaling after calculation to avoid logging log values
                    case 'Linear'
                        Database.Norm.Cell{iy,ix} = prctile(EVData,50,1) ./ prctile(CtrlData,50,1);
                    case 'Log10'
                        Database.Norm.Cell{iy,ix} = log10(prctile(EVData,50,1) ./ prctile(CtrlData,50,1));
                    case 'Log2'
                        Database.Norm.Cell{iy,ix} = log2(prctile(EVData,50,1) ./ prctile(CtrlData,50,1));
                    case 'Log'
                        Database.Norm.Cell{iy,ix} = log(prctile(EVData,50,1) ./ prctile(CtrlData,50,1));
                end
        end
        
        Database.Recovery.EV{iy,ix} = size(Database.SampleDataset{iy,ix},1) ;          % bead recovery for samples
        
    end
end

end

function [CtrlData, EVData] = ScalingType(Scaling, CtrlData, EVData)
switch Scaling
    case 'Log10'
        CtrlData = log10(CtrlData);
        EVData = log10(EVData);
    case 'Log2'
        CtrlData = log2(CtrlData);
        EVData = log2(EVData);
    case 'Log'
        CtrlData = log(CtrlData);
        EVData = log(EVData);
    case 'Linear'
end

end
