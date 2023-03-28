function [PoolSize , Num2ProcessList, T3] = Parallel_Function(RadLat,RadLon,RadO3,StartLat,NumLat,StartLon,NumLon,PoolSize,StartHour,NumHours,Num2ProcessList,FileName,Contents,Lat,Lon)

Contents = ncinfo(FileName);
Lat = ncread(FileName, 'lat');
Lon = ncread(FileName, 'lon');
NumHours = 1;

RadLat = 30.2016;
RadLon = 24.8032;
RadO3 = 4.2653986e-08;
StartLat = 1;
NumLat = 400;
StartLon = 1;
NumLon = 700;

NumLocations = (NumLon - 4) * (NumLat - 4);
EnsembleVectorPar = zeros(NumLocations, NumHours);

Steps = 100;
tic

Num2ProcessList = [Num2ProcessList]; % List of values to test

for n = 1:length(Num2ProcessList)
    Num2Process = Num2ProcessList(n);
    for idxTime = 1:NumHours
        DataLayer = 1;
        for idx = [1, 2, 4, 5, 6, 7, 8]
            HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
                [StartLon, StartLat, idxTime], [NumLon, NumLat, 1]);
            DataLayer = DataLayer + 1;
        end

        [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);

        for PoolSize = PoolSize
            if isempty(gcp('nocreate'))
                parpool('local',PoolSize);
            end
            poolobj = gcp;
            addAttachedFiles(poolobj,{'EnsembleValue'});

            DataQ = parallel.pool.DataQueue;
            hWaitBar = waitbar(0, sprintf('Time period %i, Please wait ...', idxTime));
            afterEach(DataQ, @nUpdateWaitbar);
            N = Num2Process/Steps;
            p = 1;

            T4 = toc;
            parfor idx = 1:length(Num2Process) % size(Data2Process,1)
                [EnsembleVectorPar(idx, idxTime)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);

            end


            T3(idxTime) = toc - T4; % record the parallel processing time for this hour of data
            fprintf('Parallel processing time for hour %i : %.1f s\n', idxTime, T3(idxTime))


            T2 = toc;
            delete(gcp);

            %% 10: Reshape ensemble values to Lat, lon, hour format
           fprintf('Total processing time for %i workers with %i data = %.2f s\n', PoolSize, Num2Process, T3);
        end
    end
end

function nUpdateWaitbar(~) % nested function
    waitbar(p/N, hWaitBar,  sprintf('Hour %i, %.3f complete, %i out of %i', idxTime, p/N, p, N));
    p = p + 1;
end
end