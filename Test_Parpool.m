%% Test function for Parpool functions

%Attempt to create a parallel pool with
Current_Parpool = Parpool_Create(4);
Test_Data(8).i = 0;
Test_Data(8).j = 0;
%Do some stuff in parallel
parfor i = 1:8
    %Create file path
    File_Out = strcat("Loop 1 - ", num2str(i),'.mat');
    if(~exist(File_Out, 'file'))
        %Create some arbitrary data
        Test_Data(i).i = i;
        Test_Data(i).j = i * 2;
        %Dump single index of structure to disk from within the parallel loop
        %Variables will be named as the fields of the structure are
        Parpool_Save(File_Out, Test_Data(i));
    end
end

%Resize parallel pool without having to also close the previous parpool
New_Parpool = Parpool_Create(2);
%Do some stuff with different parallel pool conditions
parfor i = 1:4
    %Create file path
    File_In = strcat("Loop 1 - ", num2str(i),'.mat');
    Test_Data(i) = load(File_In);
    File_Out = strcat("Loop 2 - ", num2str(i),'.mat');
    if(~exist(File_Out, 'file'))
        %Create some arbitrary data
        Final_Value = Test_Data(i).j + 10;
        %Dump single created to disk from within the parallel loop
        %Variable will be named in the mat file as "Variable"
        %Due to limitations of not knowing the name in the parent function
        Parpool_Save(File_Out, Final_Value);
    end
end
%Delete currently active parallel pool
%Note; only required at the end of parallel processing. Resizing the pool will close the previous pool
Parpool_Delete();