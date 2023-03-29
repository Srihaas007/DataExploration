function [error,msg] = testDataTypes(FileName)
%This function tests the datatypes in the file and returns an appropriate
%message

%Datatypes to test for
DataTypes = {'NC_Byte', 'NC_Char', 'NC_Short', 'NC_Int', 'NC_Float', 'NC_Double'};
Contents = ncinfo(FileName); % Store the file content information in a variable.
FileID = netcdf.open(FileName,'NC_NOWRITE'); % open file read only and create handle

for idx = 0:size(Contents.Variables,2)-1 % loop through each variable
    % read data type for each variable and store
    [~, datatype(idx+1), ~, ~] = netcdf.inqVar(FileID,idx);
end
netcdf.close(FileID) % closes the file after use
%% display data types
DataInFile = DataTypes(datatype)';

%% find character data types
FindText = strcmp('NC_Char', DataInFile);

%% print results
fprintf('Testing file: %s\n', FileName)
if any(FindText)
    msg = 'Error, text variables present in data. \n';
    error = 1;
else
    msg = 'All data is numeric, continue analysis.\n';
    error = 0;
end

end

