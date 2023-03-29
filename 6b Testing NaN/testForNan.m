function [NaNErrors] = testForNan(FileName,NumHours,Data)
%Function tests each hour of data given to it for NaN values.

%% Test File with Errors
NaNErrors = 0;

Contents = ncinfo(FileName); % Store the file content information in a variable.

fprintf('%s: Starting analysis of %s, hour %d\n', datestr(now, 0), FileName, NumHours);

fprintf('Testing files: %s\n', FileName)

    % check for NaNs
    if any(isnan(Data), 'All')
        NaNErrors = 1;
        %% display warning
        fprintf('NaNs present\n')
        ErrorModel = find(isnan(Data), 1, 'first');
        %% find first error:
        fprintf('Analysis for hour %i is invalid, NaN errors recorded in model %s\n',...
            NumHours, Contents.Variables(ErrorModel).Name)
        % Write to log file
        fprintf('%s: %s processing data hour %i\n', datestr(now, 0), 'NaN Error', NumHours);
    end
    


end

