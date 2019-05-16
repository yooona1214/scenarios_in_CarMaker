% create the final version of the matrix describing the long. maneuvers
% according to the model
function M=create_long(M,time_thr)


m=0;
ind=0;
indarr=[]; % array containing the indexes of Gear shifting or unknown maneuver

while ind<size(M,2)
    
    ind=ind +1 ;
    k=ind+1;
    if k >=size(M,2)
        break;
    end
    if check_time(M(:,k), time_thr)
        
        % while GS or unknown maneuver add the duration and performed
        % displacement
        while k<= size(M,2) && check_time(M(:,k), time_thr)
            
            m=m+1;
            indarr(m)=k;
            M(3,ind)=M(3,k);
            M(4,ind)=M(4,k)+M(4,ind);
            M(5,ind)=M(5,k)+M(5,ind);
            k=k+1;
            
        end
        % concatenate to the next available defined maneuver (acc or dec or static cruising)
%         M(4,ind)=M(4,k-1)+M(4,ind);
%         M(5,ind)=M(5,k-1)+M(5,ind);
%         M(end,ind)=M(end,k); % label the new curve segment
%         m=m+1;
%         indarr(m)=k;
        
        if ~isempty(indarr)
            
            M(:,indarr)=[]; % remove unknown maneuver segments (columns in the matrix)
        end
        %             j=1;
        m=0; % preallocate for the next iteration
        indarr=[];% preallocate for the next iteration
%         ind = k;
    end
    
end

k=0;
label=M(end,:);
m=0;
ind=0;
indarr=[];
%-------------------
while  ind<length(label) && ~check_adj(label) % &&
    
    ind=ind+1;
    k=ind;
    if label(k)==1
        j=k+1;
        
        while j<=size(M,2) && label(j)==1
            
            m=m+1;
            indarr(m)=j;
            M(3,k)=M(3,j);
            M(4,k)=M(4,k)+M(4,j);
            M(5,k)=M(5,k)+M(5,j);
            j=j+1;
        end
        if ~isempty(indarr)
            
            M(:,indarr)=[];
        end
        j=1;
        m=0;
        indarr=[];
        
    elseif label(k)==-1
        j=k+1;
        
        while j<=size(M,2) && label(j)==-1
            
            m=m+1;
            indarr(m)=j;
            M(3,k)=M(3,j);
            M(4,k)=M(4,k)+M(4,j);
            M(5,k)=M(5,k)+M(5,j);
            j=j+1;
        end
        if ~isempty(indarr)
            
            M(:,indarr)=[];
        end
        
        j=1;
        
        m=0;
        indarr=[];
        
        
    elseif label(k)==0
        j=k+1;
        
        while j<=size(M,2) && label(j)==0
            
            m=m+1;
            indarr(m)=j;
            M(3,k)=M(3,j);
            M(4,k)=M(4,k)+M(4,j);
            M(5,k)=M(5,k)+M(5,j);
            j=j+1;
        end
        if ~isempty(indarr)
            
            M(:,indarr)=[];
            label(:,indarr)=[];
        end
        
        j=1;
        m=0;
        indarr=[];
    elseif label(k)==-99
        j=k+1;
        
        while j<=size(M,2) && label(j)==-99
            
            m=m+1;
            indarr(m)=j;
            M(3,k)=M(3,j);
            M(4,k)=M(4,k)+M(4,j);
            M(5,k)=M(5,k)+M(5,j);
            j=j+1;
        end
        if ~isempty(indarr)
            
            M(:,indarr)=[];
        end
        
        j=1;
        
        m=0;
        indarr=[];
    end
    label=M(end,:);
    
end

end


%--- subfunctions
% this function checks if a certain threshold is exceeded
function b=check_time(vec,time_thr)

b=false;

if  vec(4)<(time_thr)
    b=true;
    
end
end

% this function checks whether two consecutive array elements are duplicate
% and will be needed in the final labeling
function b=check_adj(vec) %
temp=unique(vec,'stable');
b=isequal(temp,vec);
end
