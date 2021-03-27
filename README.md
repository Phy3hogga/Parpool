# Parallel Processing Tools

Matlab scripts that deal with easy error validation and re-scaling of parallel pools. Provides simple functions that augment the parallel processing toolbox and provide some degree of error checking of inputs. 

### Prerequisites
* Parallel Processing Toolbox installed within Matlab.

### Example

Example use of Parpool_Create.m, Parpool_Save.m and Parpool_Delete.m to easily work in the same script.

Parpool_Create creates a parallel pool while error-checking the number of threads requested. If no input is supplied, the maximum number of parallel processors will be used limited by system threads, followed by physical cores and the parallel computer cluster settings to ensure the settings are valid for the machine executing the code. Parpool_Create allows the re-sizing of existing parallel pools automatically if a particular section of the processing pipeline is more memory intensive.

Parpool_Delete deletes the currently active parallel pool (only required at the end of a script).

Parpool_Save saves a variable to a file while in the parallel iteration. This allows per-core inspection of variable values for debugging whilst retaining parallel processing or saving and re-loading data later in the processing pipeline if memory issues will likely become problematic holding all data in memory.

```matlab
%% Test function for Parpool functions

%Create parallel pool with the maximum possible number of processes
%This can be limited by threads, physical cores and the parallel computing cluster settings
%all of which are machine-specific (in the case of portable code)
Current_Parpool = Parpool_Create();

%Attempt to create a parallel pool with 4 simultaneous processes
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
```

## Built With

* [Matlab R2018A](https://www.mathworks.com/products/matlab.html)
* [Parallel Processing Toolbox](https://uk.mathworks.com/products/parallel-computing.html)
* [Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)

## Contributing

Contributions towards this code will only be accepted under the following conditions:
* Provide new features introduced that do not break current implementations (must be backwards compatible).

## Authors
* **Alex Hogg** - *Initial work* - [Phy3hogga](https://github.com/Phy3hogga)