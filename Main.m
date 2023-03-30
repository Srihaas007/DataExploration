clear all

FileName = 'D:/Downloads/Model/o3_surface_20180701000000.nc';
Contents = ncinfo(FileName);
fprintf("testing for memory ")
fprintf("the client analyis data ")
Lat = ncread(FileName, 'lat'); % load the latitude locations
Lon = ncread(FileName, 'lon'); % loadthe longitude locations
RadLat = 30.2016; % cluster radius value for latitude
RadLon = 24.8032; % cluster radius value for longitude
RadO3 = 4.2653986e-08; % cluster radius value for the ozone data
StartLat = 1; % latitude location to start laoding
NumLat = 400; % number of latitude locations ot load
StartLon = 1; % longitude location to start loading
NumLon = 700; % number of longitude locations ot load
%HourNum = 7;
StartHour =1; 
EndHour = 1;
NumHours = 1; 
Data=[200,500];
%% Before processing
%Create and open log file
LogFileName = './MainFunction.txt';
%Asks if the user wants to delete the previous logs before testing.
if isfile(LogFileName)
    doDelete = input("Delete previous logs? Y/N",'s');
    if doDelete== 'Y' || doDelete == 'y'
        delete (LogFileName)
    end
end    
LogID = fopen(LogFileName, 'a');

%Before processing, test data types in the data file

fprintf("Testing for text ")
[err,msg] = testDataTypes(FileName);
if err == 0 %If there is no error, all data is numeric.
    fprintf(msg);
    fprintf(LogID, msg);
else %Otherwise, stop the execution of the program.
    fprintf(msg);
    fprintf(LogID, msg);
    %Close any open files
    fclose('all');
    return %Stop the function execution.
end 
fprintf("Testing for NaN ")
[NaNErrors] = testForNan(FileName,NumHours,Data);
% Define arrays to store results
x11 = [];
y11 = [];
x21 = [];
y21 = [];
SizeLoop = [200,500];
% Loop through the values in SizeLoop
for i = 1:length(SizeLoop)
    % Call the Sequential_Function with current SizeLoop value
    [tSeq] = Sequential_Function(FileName, SizeLoop(i), Lat, Lon, RadLat, RadLon, RadO3, StartLat, NumLat, StartLon, NumLon, StartHour, EndHour);
    % Store the output in the corresponding arrays based on SizeLoop value
    if SizeLoop(i) == 200
        x11 = [x11 tSeq];
        y11 = [y11 tSeq];
    elseif SizeLoop(i) == 500
        x21 = [x21 tSeq];
        y21 = [y21 tSeq];
    end
end


% Define arrays to store results
x12 = [];
y12 = [];
x13 = [];
y13 = [];
x14 = [];
y14 = [];
x22 = [];
y22 = [];
x23 = [];
y23 = [];
x24 = [];
y24 = [];
Num2ProcessList = [200,500];
% Loop through the values in Num2ProcessList
for i = 1:length(Num2ProcessList)
    % Loop through the poolSize values
    for poolSize = 2:4
        % Call the Parallel_Function with current inputs
        [Time] = Parallel_Function(RadLat,RadLon,RadO3,StartLat,NumLat,StartLon,NumLon,poolSize,StartHour,NumHours,Num2ProcessList(i),FileName,Contents,Lat,Lon);
        % Store the output in the corresponding arrays based on Num2ProcessList and poolSize values
        if Num2ProcessList(i) == 200
            if poolSize == 2
                x12 = [x12 Time];
                y12 = [y12 Num2ProcessList(i)];
            elseif poolSize == 3
                x13 = [x13 Time];
                y13 = [y13 Num2ProcessList(i)];
            elseif poolSize == 4
                x14 = [x14 Time];
                y14 = [y14 Num2ProcessList(i)];
            end
        elseif Num2ProcessList(i) ==500
            if poolSize == 2
                x22 = [x22 Time];
                y22 = [y22 Num2ProcessList(i)];
            elseif poolSize == 3
                x23 = [x23 Time];
                y23 = [y23 Num2ProcessList(i)];
            elseif poolSize == 4
                x24 = [x24 Time];
                y24 = [y24 Num2ProcessList(i)];
            end
        end
    end
end



fprintf("Out put the graphs")
x1Vals = [x11, x12, x13, x14];
y1Vals = [y11, y12, y13, y14];
x2Vals = [x21, x22, x23, x24];
y2Vals = [y21, y22, y23, y24];
legendLabels = "200_data 500_data";
Graphs_function(x1Vals, y1Vals, x2Vals, y2Vals, legendLabels)


fprintf("Out put the log file is created by name MainFunction.txt")
