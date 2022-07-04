clear all
FileName = 'D:/Downloads/Model/Model/o3_surface_20180701000000.nc';
Contents = ncinfo(FileName);
fprintf("testing for memory ")
[AllDataMem] = LoadAllData(FileName,Contents);
[HourMem] = LoadAllHours(FileName,Contents);
[HourDataMem] = LoadHours(FileName,Contents);
Reportresults  (AllDataMem,HourDataMem,HourMem)
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
SizeLoop = 250;

fprintf("testing for sequential")
[tSeq] = SequentialFunction(FileName,Contents,Lat,Lon,RadLat,RadLon,RadO3,StartLat,NumLat,StartLon,NumLon,StartHour,EndHour,SizeLoop);
fprintf("testing for parallel")
NumHours = 25; 
Num2Process = 500; 
for PoolSize = [2]
     [Time]=ParallelFunction(RadLat,RadLon,RadO3,StartLat,NumLat,StartLon,NumLon,PoolSize,StartHour,NumHours,Num2Process,FileName,Contents,Lat,Lon);
end
fprintf("Out put the graphs")
Graphs
fprintf("Testing for text")
TestText(FileName)
fprintf("Testing for Nan")
TestNan(FileName)
fprintf("Out put the log file")
TestSolutionsWithLogFile(FileName)