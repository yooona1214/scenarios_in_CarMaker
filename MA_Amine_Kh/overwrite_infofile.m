% function overwrite the CM TR infofile
% input param: Tensor of the model

function overwrite_infofile(S)

cd ('F:\Highway_scenarios_overwrite\Data\TestRun');

handle=ifile_new();

% Filename= 'ChangingLanes';
Filename= 'Highway_with_data_export_ov';
% Filename= 'ChangingLanes_ov';
ifile_read(handle,Filename);

% time
% if isfield(S,'Time')
%     Time = S.Time;
%     
% end

% overwrite the man 
% of ego
if isfield(S,'Ego')
    
    % prepare Data of Ego from the Tensor
    
    vec_overwrite_ego=S.Ego;
    
    
    % initial lat offset &  velocity + maneuver number
    ifile_setstr(handle,strcat('DrivMan.Init.Velocity'),num2str(vec_overwrite_ego(2,1)));
    ifile_setstr(handle,strcat('DrivMan.Init.LaneOffset'), num2str(vec_overwrite_ego(3,1)));
    ifile_setstr(handle,strcat('DrivMan.nDMan'),num2str(size(vec_overwrite_ego,2)-1));% ifile_movekeybehind(handle,'DrivMan.Init.Velocity','DrivMan.nDMan');
    
    nD_man=eval(ifile_getstr(handle,'DrivMan.nDMan'));
    
    % ignore traffic ( for ego)
    ifile_setstr(handle,strcat('Driver.ConsiderTraffic'),num2str(0));
    
    % if necessary delete keyvalue of distlimit or Timelimmit
    for n=1:nD_man
        
        if ~strcmp(ifile_getstr(handle,strcat('DrivMan.',num2str(n-1),'.DistLimit')),'')
            
            ifile_setstr(handle,strcat('DrivMan.',num2str(n-1),'.DistLimit'),'');
            
        end
        
    end
    
    % overwrite lat and long maneuver
    for i =2:size(vec_overwrite_ego,2)
        ifile_setstr(handle,strcat('DrivMan.',num2str(i-2),'.TimeLimit'),strcat(num2str(vec_overwrite_ego(1,i))));
        %     ifile_setstr(handle,strcat('DrivMan.',num2str(i-2),'.DistLimit'),strcat(num2str(vec_overwrite_ego(4,i))));
        
        ifile_setstr(handle,strcat('DrivMan.',num2str(i-2),'.LongDyn'), strcat('Driver 1 0',32,num2str(vec_overwrite_ego(2,i))));
        ifile_setstr(handle,strcat('DrivMan.',num2str(i-2),'.LatDyn'), strcat('Driver',32, num2str(vec_overwrite_ego(3,i))));
        
    end
    % set the limit of long. acc and dec for CM Resimulation
    ifile_setstr(handle,strcat('Driver.Long.axMin'),strcat(num2str(10)));
    ifile_setstr(handle,strcat('Driver.Long.axMax'),strcat(num2str(10)));
    
    % set duration of Gear shifting
    ifile_setstr(handle,strcat('Driver.DecShift.tSwitchGear'),strcat(num2str(1))); % to be changed
    
    % set Time limit
%     ifile_setstr(handle,strcat('DrivMan.',num2str(nD_man-1),'.EndCondition'),strcat(num2str('Time>=50'))); % to be changed
    
end



for index=0:numel(S.TObj)-1
    
    if ~isempty(S.TObj(index+1).data)
        
        index_str=num2str(index);
        vec_overwrite_TObj=S.TObj(index+1).data;
        
        ifile_setstr(handle,strcat('Traffic.',index_str,'.Man.N '),num2str(size(vec_overwrite_TObj,2)-1));
        nD_man=eval(ifile_getstr(handle,strcat('Traffic.',index_str,'.Man.N')));
        
        ifile_setstr(handle,strcat('Traffic.',index_str,'.Man.',num2str(nD_man-1),'.EndCondition'),strcat('Time>=',num2str(50)));
        
        
        for i =2:size(vec_overwrite_TObj,2) % consider abs. velocity or avg. acc
            
            
            ifile_setstr(handle,strcat('Traffic.',index_str,'.Man.',num2str(i-2),'.Limit'),strcat('t',32,num2str(vec_overwrite_TObj(1,i))));
            %     ifile_setstr(handle,strcat('Traffic.1.Man.',num2str(i-2),'.LongDyn'), strcat('v',32, num2str(vec_overwrite_TObj(2,i))));
            ifile_setstr(handle,strcat('Traffic.',index_str,'.Man.',num2str(i-2),'.LongDyn'), strcat('a',32, num2str(vec_overwrite_TObj(4,i))));
            
            ifile_setstr(handle,strcat('Traffic.',index_str,'.Man.',num2str(i-2),'.LatDyn'), strcat('y_abs',32, num2str(vec_overwrite_TObj(3,i))));
            
        end
    end
end


%% apply the changes to the infofile and delete the handle instance
ifile_write(handle,Filename);
ifile_delete(handle);


end















