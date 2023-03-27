function [tSeq] = Sequential_Function(FileName, SizeLoop, Lat, Lon, RadLat, RadLon, RadO3, StartLat, NumLat, StartLon, NumLon, StartHour, EndHour)
    % This script allows you to open and explore the data in a *.nc file
    % clear all
    % close all

    % Load netcdf file information
    Contents = ncinfo(FileName);

    %% Cycle through the hours and load all the models for each hour and record memory use
    % We use an index named 'NumHour' in our loop
    % The section 'sequential processing' will process the data location one
    % after the other, reporting on the time involved.
    tSeq = tic;
    for NumHour = StartHour:EndHour % loop through each hour
        fprintf('Processing hour %i\n', NumHour)
        DataLayer = 1; % which 'layer' of the array to load the model data into
        for idx = [1, 2, 4, 5, 6, 7, 8] % model data to load
            % load the model data
            HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
                [StartLon, StartLat, NumHour], [NumLon, NumLat, 1]);
            DataLayer = DataLayer + 1; % step to the next 'layer'
        end

        % We need to prepare our data for processing. This method is defined by
        % our customer. You are not required to understand this method, but you
        % can ask your module leader for more information if you wish.
        [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);

        %% Sequential analysis
        for loopIndex = 1:length(SizeLoop)
            t1 = toc;
            t2 = t1;
            fprintf('Running sequential analysis with SizeLoop = %d\n', SizeLoop(loopIndex));
            for idx = 1:SizeLoop(loopIndex) % step through each data location to process the data

                % The analysis of the data creates an 'ensemble value' for each
                % location. This method is defined by
                % our customer. You are not required to understand this method, but you
                % can ask your module leader for more information if you wish.
                [EnsembleVector(idx, NumHour)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);

                % To monitor the progress we will print out the status after every
                % 50 processes.
                if idx/50 == ceil(idx/50)
                    tt = toc-t2;
                    fprintf('Total %i of %i, last 50 in %.2f s  predicted time for all data %.1f s\n',...
                        idx, size(Data2Process,1), tt, size(Data2Process,1)/50*25*tt)
                    t2 = toc;
                end
            end
            T2(loopIndex, NumHour) = toc - t1; % record the total processing time for this hour and SizeLoop value
            fprintf('Processing hour %i with SizeLoop = %d - %.2f s\n\n', NumHour, SizeLoop(loopIndex), T2(loopIndex, NumHour));
        end
    end
    tSeq = toc(tSeq);
    fprintf('Total time for sequential processing = %.2f s\n\n', tSeq);
