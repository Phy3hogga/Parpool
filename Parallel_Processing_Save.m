function Parallel_Processing_Save(File_Path, Variables)
    Attempt_Directory_Creation(fileparts(File_Path));
    %Attempt to save structure if the structure is scalar
    if(isstruct(Variables))
        if(isscalar(Variables))
            save(File_Path, '-struct', 'Variables');
        else
            save(File_Path, 'Variables');
        end
    else
        save(File_Path, 'Variables');
    end
end