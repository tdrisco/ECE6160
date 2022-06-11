%<<<<PARAMETERS>>>>>>
function [input] = PMU_Data_Collecting()
no_sample = 1;                % Number of data points expected to collect
data_points = 110;                % Number of data variables expecting in one frame
averg_number = 1;                 % If required averaging - the number of data frames required averaging
% 
% tic;
% for i=1:105
%     pause(5.0);
% end
% t_test = toc


%<<<<<PMU DATA COLLECTING>>>
for j=1:no_sample
    %---------------------------------------------------------------------------------
    ServerIP='130.127.88.141';      % If Rack no3 : 130.127.88.141  
    Port = 5892;                    % This value is set in the GTNET-SKT module in the RSCAD model (Check in there if differ use that port here)

    f_rData_all(1, 1:data_points) = 0.0;
    client_data(1, 1:data_points) = 0.0;

    Skt_Dev = tcpclient(ServerIP, Port);
    pause(0.1);

    for i=1:averg_number

        rData = read(Skt_Dev, 4*data_points, 'uint8');
        f_rData_all(1,:) = f_rData_all(1,:)+ swapbytes(typecast(rData, 'single'));
    end

    for i=1:data_points
        client_data(1,i) = f_rData_all(1,i)/averg_number;
    end
    pause(0.1);
%         clear Skt_Dev;
    %---------------------------------------------------------------------------------

    in = client_data(:,1:94);
    input(:,j) = transpose(in);
    out = client_data(:,95:110);
    output(:,j) = transpose(out);
%     if j == 500 || j == 5000 || j == 8000
%         fprintf("Milestone")            % This is to make sure continuos data cmmunication (if the milstone is passed no_sample can be collected) between RTDS and MATLAB (This connection is very unstable)
%         t_mile = toc                    % The total time the MATLAB runs at the Milestone
%     end
end
end
% csvwrite("train_input.csv",input);      %"test_input.csv"       %Change according to which set of data are you collecting/ Training or Testing
% csvwrite("train_output.csv",output);    %"test_output.csv"      %Change according to which set of data are you collecting/ Training or Testing
% 
% 
% fprintf("Completed!!!!!!!!!!!!!!!!!!!!!")            % This is to make sure continuos data cmmunication (if the milstone is passed no_sample can be collected) between RTDS and MATLAB (This connection is very unstable)
%         
%     
%     









