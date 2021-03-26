function Debug_Log = Parpool_Debug_Logs(Directory)
    Directory = {Directory};
    File_List = Search_Files(Directory, '.mat');
    for Current_Directory = 1:length(File_List)
        Data = load(strcat(File_List(Current_Directory).folder, filesep, File_List(Current_Directory).name));
        Debug_Log(Current_Directory).File = File_List(Current_Directory).name;
        Debug_Log(Current_Directory).Log = Data.Variables;
        Debug_Log(Current_Directory).Timestamp = File_List(Current_Directory).date;
        Debug_Log(Current_Directory).Datenum = File_List(Current_Directory).datenum;
    end
    Timestamps = [Debug_Log(:).Datenum];
    Latest_Update = min(Timestamps);
    for Current_Directory = 1:length(File_List)
        Debug_Log(Current_Directory).Datenum = Debug_Log(Current_Directory).Datenum - Latest_Update;
    end
    [~, ind] =sort([Debug_Log(:).Datenum]);
    Debug_Log = Debug_Log(ind);
end