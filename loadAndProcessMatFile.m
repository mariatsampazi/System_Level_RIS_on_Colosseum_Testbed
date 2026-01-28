function [data, stats] = loadAndProcessMatFile(filename, varargin)
    % LOADANDPROCESSMATFILE - Efficiently load and process .mat files containing structs
    %
    % Syntax:
    %   [data, stats] = loadAndProcessMatFile(filename)
    %   [data, stats] = loadAndProcessMatFile(filename, 'VariableName', varname)
    %   [data, stats] = loadAndProcessMatFile(filename, 'Filter', filterFunc)
    %   [data, stats] = loadAndProcessMatFile(filename, 'Fields', fieldList)
    %
    % Inputs:
    %   filename    - Path to .mat file
    %   'VariableName' - Specific variable to load (optional)
    %   'Filter'    - Function handle for filtering data
    %   'Fields'    - Cell array of field names to extract
    %
    % Outputs:
    %   data        - Processed struct or table
    %   stats       - Statistics about the loaded data
    %
    % Example:
    %   [eNBs, info] = loadAndProcessMatFile('eNBs_with_statllm_flag.mat');
    %   [filtered, ~] = loadAndProcessMatFile('eNBs_with_statllm_flag.mat', ...
    %                                        'Filter', @(x) x.height > 10);

    % Parse input arguments
    p = inputParser;
    addRequired(p, 'filename', @ischar);
    addParameter(p, 'VariableName', '', @ischar);
    addParameter(p, 'Filter', [], @(x) isa(x, 'function_handle'));
    addParameter(p, 'Fields', {}, @iscell);
    addParameter(p, 'OutputFormat', 'struct', @(x) ismember(x, {'struct', 'table'}));
    parse(p, filename, varargin{:});
    
    % Check if file exists
    if ~exist(filename, 'file')
        error('File %s does not exist', filename);
    end
    
    % Load the .mat file
    fprintf('Loading %s...\n', filename);
    tic;
    
    if isempty(p.Results.VariableName)
        loadedData = load(filename);
        % Get the first variable if multiple exist
        varNames = fieldnames(loadedData);
        if length(varNames) > 1
            fprintf('Multiple variables found: %s\n', strjoin(varNames, ', '));
            fprintf('Using first variable: %s\n', varNames{1});
        end
        data = loadedData.(varNames{1});
    else
        data = load(filename, p.Results.VariableName);
        data = data.(p.Results.VariableName);
    end
    
    loadTime = toc;
    fprintf('Loaded in %.2f seconds\n', loadTime);
    
    % Initialize stats
    stats = struct();
    stats.filename = filename;
    stats.loadTime = loadTime;
    stats.originalSize = length(data);
    
    % Get field information
    if isstruct(data)
        if length(data) > 1
            % Array of structs
            allFields = fieldnames(data);
            stats.fields = allFields;
            stats.numFields = length(allFields);
            
            % Show field types and sample values
            fprintf('\nStruct array with %d elements and %d fields:\n', length(data), length(allFields));
            for i = 1:min(5, length(allFields)) % Show first 5 fields
                fieldName = allFields{i};
                sampleVal = data(1).(fieldName);
                if isnumeric(sampleVal)
                    fprintf('  %s: %s (e.g., %.2f)\n', fieldName, class(sampleVal), sampleVal);
                elseif ischar(sampleVal) || isstring(sampleVal)
                    fprintf('  %s: %s (e.g., "%s")\n', fieldName, class(sampleVal), string(sampleVal));
                else
                    fprintf('  %s: %s\n', fieldName, class(sampleVal));
                end
            end
            if length(allFields) > 5
                fprintf('  ... and %d more fields\n', length(allFields) - 5);
            end
        else
            % Single struct
            allFields = fieldnames(data);
            stats.fields = allFields;
            stats.numFields = length(allFields);
            fprintf('\nSingle struct with %d fields\n', length(allFields));
        end
    end
    
    % Apply field filtering if requested
    if ~isempty(p.Results.Fields)
        if isstruct(data)
            validFields = intersect(p.Results.Fields, fieldnames(data));
            if length(validFields) < length(p.Results.Fields)
                missingFields = setdiff(p.Results.Fields, validFields);
                warning('Fields not found: %s', strjoin(missingFields, ', '));
            end
            
            % Extract only requested fields
            newData = struct();
            for i = 1:length(data)
                for j = 1:length(validFields)
                    newData(i).(validFields{j}) = data(i).(validFields{j});
                end
            end
            data = newData;
            stats.fieldsExtracted = validFields;
        end
    end
    
    % Apply custom filter if provided
    if ~isempty(p.Results.Filter)
        if isstruct(data) && length(data) > 1
            try
                filterMask = arrayfun(p.Results.Filter, data);
                data = data(filterMask);
                stats.filteredSize = length(data);
                fprintf('Applied filter: %d/%d elements retained\n', stats.filteredSize, stats.originalSize);
            catch ME
                warning('Filter function failed: %s', ME.message);
            end
        end
    end
    
    % Convert to table if requested
    if strcmp(p.Results.OutputFormat, 'table') && isstruct(data) && length(data) > 1
        try
            data = struct2table(data);
            fprintf('Converted to table format\n');
        catch ME
            warning('Could not convert to table: %s', ME.message);
        end
    end
    
    % Final statistics
    stats.finalSize = length(data);
    stats.memoryUsage = whos('data').bytes;
    
    fprintf('\nProcessing complete:\n');
    fprintf('  Final size: %d elements\n', stats.finalSize);
    fprintf('  Memory usage: %.2f MB\n', stats.memoryUsage / 1024^2);
end

%% Helper functions for common operations

function summaryStats = analyzeStructFields(structData)
    % ANALYZESTRUCTFIELDS - Analyze numeric fields in struct array
    
    if ~isstruct(structData) || isempty(structData)
        summaryStats = [];
        return;
    end
    
    fieldNames = fieldnames(structData);
    summaryStats = struct();
    
    for i = 1:length(fieldNames)
        fieldName = fieldNames{i};
        values = [structData.(fieldName)];
        
        if isnumeric(values) && ~isempty(values)
            summaryStats.(fieldName) = struct(...
                'min', min(values), ...
                'max', max(values), ...
                'mean', mean(values), ...
                'std', std(values), ...
                'unique_count', length(unique(values)));
        elseif ischar(values(1)) || isstring(values(1))
            uniqueVals = unique({structData.(fieldName)});
            summaryStats.(fieldName) = struct(...
                'unique_values', {uniqueVals}, ...
                'unique_count', length(uniqueVals));
        end
    end
end

function exportToCSV(structData, filename)
    % EXPORTTOCSV - Export struct array to CSV file
    
    if isstruct(structData) && length(structData) > 1
        T = struct2table(structData);
        writetable(T, filename);
        fprintf('Exported to %s\n', filename);
    else
        error('Data must be a struct array to export to CSV');
    end
end

%% Usage examples:

% % Basic usage:
% [eNBs, info] = loadAndProcessMatFile('eNBs_with_statllm_flag.mat');
% 
% % Load specific fields only:
% [eNBs_subset, ~] = loadAndProcessMatFile('eNBs_with_statllm_flag.mat', ...
%                                         'Fields', {'height', 'sector_name', 'site_id'});
% 
% % Filter data:
% [tall_eNBs, ~] = loadAndProcessMatFile('eNBs_with_statllm_flag.mat', ...
%                                       'Filter', @(x) x.height > 20);
% 
% % Get as table:
% [eNBs_table, ~] = loadAndProcessMatFile('eNBs_with_statllm_flag.mat', ...
%                                        'OutputFormat', 'table');
% 
% % Analyze the data:
% stats = analyzeStructFields(eNBs);
% disp(stats);
% 
% % Export to CSV:
% exportToCSV(eNBs, 'eNBs_data.csv');