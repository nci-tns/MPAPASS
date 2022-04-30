function   [Database] = MPA_EV_Bead_v_Control(Database, Norm_Method, Scaling)


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
                Database.Norm.Cell{iy,ix} = prctile(EVData,50,1) - prctile(CtrlData,50,1);
                Database.Norm.Cell{iy,ix} = ScalingType(Scaling, Database.Norm.Cell{iy,ix});
                
            case 'Stain Index 1' % standard stain index
                SD_EV_Bead = prctile(EVData,5,1) + prctile(EVData,50,1);             % interquartile range of EV capture bead
                SD_Ctrl_Bead = prctile(CtrlData,95,1) - prctile(CtrlData,50,1);  % interquartile range of control capture bead
                
                Database.Norm.Cell{iy,ix} = ((prctile(EVData,50,1)-prctile(CtrlData,50,1))) ./ ((SD_EV_Bead + SD_Ctrl_Bead));
                Database.Norm.Cell{iy,ix} = ScalingType(Scaling, Database.Norm.Cell{iy,ix});
                
            case 'Stain Index 2' % Bigos method
                Database.Norm.Cell{iy,ix} = ((prctile(EVData,50,1)-prctile(CtrlData,50,1))) ./ prctile(CtrlData,95,1) ;
                Database.Norm.Cell{iy,ix} = ScalingType(Scaling, Database.Norm.Cell{iy,ix});
                
            case 'Fold Change'
                Database.Norm.Cell{iy,ix} = prctile(EVData,50,1) ./ prctile(CtrlData,50,1);
                Database.Norm.Cell{iy,ix} = ScalingType(Scaling, Database.Norm.Cell{iy,ix});
                
        end
        Database.Recovery.EV{iy,ix} = size(Database.SampleDataset{iy,ix},1) ;          % bead recovery for samples
        
    end
    
end
end
function [NormData] = ScalingType(Scaling, NormData)
switch Scaling
    case 'Log10'
        NormData(NormData<0) = NaN;
        NormData = log10(NormData);
        
    case 'Log2'
        NormData(NormData<0) = NaN;
        
        NormData = log2(NormData);
    case 'Log'
        NormData(NormData<0) = NaN;
        NormData = log(NormData);
    case 'Linear'
end

end
