%Deletes the current parpool
function Success = Parpool_Delete()
    %Get current parpool
    Current_Pool = gcp('nocreate');
    %If parpool is present
    Current_Pool_Size_Before = size(Current_Pool);
    %Attempt to delete the parpool
    if(~isempty(Current_Pool))
        delete(Current_Pool);
        %Get current parpool
        Current_Pool = gcp('nocreate');
        %If parpool is present
        Current_Pool_Size_After = size(Current_Pool);
        %Compare pool sizes before and after
        if(all(Current_Pool_Size_Before == Current_Pool_Size_After))
            Success = false;
        else
            Success = true;
        end
    else
        Success = true;
    end
end