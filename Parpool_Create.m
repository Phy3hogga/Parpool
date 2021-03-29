%% Safely creates parpool by force-limiting the maximum number of cores used
function Current_Pool = Parpool_Create(Num_Cores)
    %Only execute parallel tasks if the toolbox is installed and licenced
    if(Parpool_Toolbox_Usable())
        %Get the maximum number of cores the current machine has access to (physical / logical / cluster)
        Max_Number_Cores = Parpool_Max_Cores();
        if(Max_Number_Cores == 0)
            disp("Parpool_Create Warning: Failed to obtain the number of cores available; unable to validate further checks on number of cores.");
        end
        %If no input supplied, use all cores possible
        if(nargin == 0)
            if(Max_Number_Cores == 0)
                error("Parpool_Create Error: Number of cores not specified and automatic determination for maximum number of cores failed; stopping execution");
            else
                Num_Cores = Max_Number_Cores;
            end
        end
        %Force numeric datatype to uint16
        if(isnumeric(Num_Cores))
            if(~isinteger(Num_Cores))
                Num_Cores = uint16(Num_Cores);
            end
        end
        %Verify input for number of cores / switch to maximum number of cores
        if(isinteger(Num_Cores))
            if(Num_Cores > 0)
                %Ensure the requested core count is lower than required
                if(Max_Number_Cores > 0)
                    if(Num_Cores > Max_Number_Cores)
                        Num_Cores = Max_Number_Cores;
                        disp("Parpool_Create Warning: Specified number of cores larger than maximum number of cores; using maximum number of cores instead.");
                    else
                        %Using manually specified number of cores with validation from Max_Number_Cores
                    end
                else
                    %Using manually specified number of cores without validation from Max_Number_Cores
                end
            else
                if(Max_Number_Cores > 0)
                    Num_Cores = Max_Number_Cores;
                    disp("Parpool_Create Warning: Number of cores required to be an integer greater than 0, using maximum number of cores instead.");
                else
                    error("Parpool_Create Error: Number of cores required to be an integer greater than 0 and invalid maximum number of cores; stopping execution.");
                end
            end
        else
            if(Max_Number_Cores > 0)
                Num_Cores = Max_Number_Cores;
                disp("Parpool_Create Warning: Number of cores required to be an integer, using maximum number of cores instead.");
            else
                error("Parpool_Create Error: Number of cores required to be an integer and invalid maximum number of cores; stopping execution.");
            end
        end
        %Get current parpool (if an instance exists), but don't create a new instance
        Current_Pool = gcp('nocreate');
        %If a parpool already exists
        if(~isempty(Current_Pool))
            %If the requested number of cores is different from the existing pool
            if(Num_Cores == Current_Pool.NumWorkers)
                %Core count is identical, no need to re-create the pool
                Parpool_Creation_Allowed = false;
                disp("Parpool_Create Info: Identical parpool already exists, ignoring creation.");
            else
                %Delete current pool if one already exists, core count is different
                Parpool_Creation_Allowed = Parpool_Delete();
                if(~Parpool_Creation_Allowed)
                    disp("Parpool_Create Warning: Failed to create new parpool due to another pool already existing.");
                end
            end
        else
            %No parpool exists
            Parpool_Creation_Allowed = true;
        end
        %Create pool if one doesn't already exist
        if(Parpool_Creation_Allowed)
            %Create parallel Pool
            Current_Pool = parpool(Num_Cores);
        else
            Current_Pool = gcp('nocreate');
        end
    else
        warning("Parallel Processing Toolbox Required");
    end
    
    %% Safely obtain the maximum number of cores / threads available to matlab.
    function Max_Cores = Parpool_Max_Cores()
        %% Default return value
        Max_Cores = 0;
        %% Query processer settings
        %Get the number of logical threads
        Max_Logical_Threads = Parpool_Max_Cores_Verify(getenv('NUMBER_OF_PROCESSORS'));
        %If Max_Cores is empty (enviroment variable not set)
        if(Max_Logical_Threads == 0)
            %Default to number of physical cores
            disp("Warning: Defaulting to the number of physical cores rather than logical threads.");
            Max_Physical_Cores = Parpool_Max_Cores_Verify(feature('numcores'));
            if(Max_Physical_Cores == 0)
                disp("Warning: Unable to programatically determine the number of cores this machine has.");
            else
                Max_Cores = Max_Physical_Cores;
            end
        else
            Max_Cores = Max_Logical_Threads;
        end

        %% Ensure that the number of cores attempted to be used is valid in the cluster settings
        %Get number of cores MATLAB is allocated to use
        Allocated_Cluster_Settings = parcluster;
        Max_NumWorkers = Parpool_Max_Cores_Verify(Allocated_Cluster_Settings.NumWorkers);
        if(Max_NumWorkers > 0)
            if(Max_Cores > Max_NumWorkers)
                Max_Cores = Max_NumWorkers;
                disp("Warning: MATLAB cluster NumWorkers set to smaller number of CPU cores, this setting needs changing in the IDE to use this many cores. Using the maximum number of numworkers set.");
            end
        else
            disp("Warning: Unable to obtain MATLAB cluster NumWorkers");
        end
    end

    %% Verify if the number of cores is a valid datatype and the value is sensical; return 0 if wrong/unhandled datatype
    function Validated_Num_Cores = Parpool_Max_Cores_Verify(Core_Check)
        %Default value
        Validated_Num_Cores = 0;
        %Convert any character data to numeric datatype
        if(ischar(Core_Check))
            Core_Check = str2num(Core_Check);
        end
        %Expected datatype is numeric by now
        if(isnumeric(Core_Check))
            %Change non-integer datatype to int
            if(~isinteger(Core_Check))
                Core_Check = uint16(Core_Check);
            end
            %Sanity Check just incase of invalid enviroment parameters
            if(Core_Check > 0)
                Validated_Num_Cores = Core_Check;
            end
        else
            disp("Warning: Number of Cores returned an unexpected datatype when validating.");
        end
    end
end