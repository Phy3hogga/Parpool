%% Checks and validates the install of the parallel processing toolbox
function Toolbox_Usable = Parpool_Toolbox_Usable()
    %Check the toolbox is installed
    Toolboxes = ver;
    Installed = contains([Toolboxes.Name], 'Parallel Computing Toolbox');
    %Check the toolbox is licenced
    Licenced = license('test','Distrib_Computing_Toolbox');
    %Distributed_Computation_Version = ver('distcomp');
    Toolbox_Usable = Installed & Licenced;
end