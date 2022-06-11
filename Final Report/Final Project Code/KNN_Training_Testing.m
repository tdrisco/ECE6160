clear
clc

% Index and Weight Matrices
BR2IW = [17 18 33 34 1 2 9 10;
    2 2 2 2 1 1 1 1];
BR4IW = [21 22 37 38 3 4 11 12;
    2 2 2 2 1 1 1 1];
BR5IW = [25 26 41 42 5 6 13 14;
    2 2 2 2 1 1 1 1];
BR7IW = [29 30 45 46 5 8 13 16;
    2 2 2 2 1 1 1 1];
BR8IW = [31 32 47 48 5 8 13 16;
    2 2 2 2 1 1 1 1];
BR9IW = [75 76 91 92 8 53 16 60;
    2 2 2 2 1 1 1 1];
BR10IW = [77 78 93 94 8 53 16 60;
    2 2 2 2 1 1 1 1];

%<<<<KNN TRAINING>>>>>>
input = csvread("train_input.csv");
output = csvread("train_output.csv");
mlpData = csvread("MLP_output.csv");
[rw,clm] = size(output);

for j=1:rw                  %Rectifying the issue of getting non-binary value for the switching status
    for k=1:clm
        output(j,k) = output(j,k) /1.4013e-45; %1.4013e-45          % Check this value in the output file and replace the correct value to conver into binary output file, this value might change
        if(output(j,k)>0)
                output(j,k)=1;
        end
    end
end

norms = getNorms(input,output);
norm_input = normalizeInput(norms,input);

BR2input = getBRinput(norm_input,BR2IW);
mod2 = fitcknn(BR2input', output(2,:)',...
    'NumNeighbors', 7, 'DistanceWeight', 'inverse');
BR4input = getBRinput(norm_input,BR4IW);
mod4 = fitcknn(BR4input', output(4,:)',...
    'NumNeighbors', 7, 'DistanceWeight', 'inverse');
BR5input = getBRinput(norm_input,BR5IW);
mod5 = fitcknn(BR5input', output(5,:)',...
    'NumNeighbors', 7, 'DistanceWeight', 'inverse');
BR7input = getBRinput(norm_input,BR7IW);
mod7 = fitcknn(BR7input', output(7,:)',...
    'NumNeighbors', 7, 'DistanceWeight', 'inverse');
BR8input = getBRinput(norm_input,BR8IW);
mod8 = fitcknn(BR8input', output(8,:)',...
    'NumNeighbors', 7, 'DistanceWeight', 'inverse');
BR9input = getBRinput(norm_input,BR9IW);
mod9 = fitcknn(BR9input', output(9,:)',...
    'NumNeighbors', 7, 'DistanceWeight', 'inverse');
BR10input = getBRinput(norm_input,BR10IW);
mod10 = fitcknn(BR10input', output(10,:)',...
    'NumNeighbors', 7, 'DistanceWeight', 'inverse');

%<<<<TESTING>>>>>>
test_input = csvread("test_input.csv");
test_output = csvread("test_output.csv");
[rrw,rclm] = size(test_output);
est_output=zeros(rrw,rclm);

for j=1:rrw                                 %Rectifying the issue of getting non-binary value for the switching status
    for k=1:rclm
        test_output(j,k) = test_output(j,k) /1.4013e-45; %1.4013e-45          % Check this value in the random_output file and replace the correct value to conver into binary output file, this value might change
        if(test_output(j,k)>0)
                test_output(j,k)=1;
        end
    end
end

norm_test_input = normalizeInput(norms,test_input);
BR2_test_input = getBRinput(norm_test_input,BR2IW);
BR4_test_input = getBRinput(norm_test_input,BR4IW);
BR5_test_input = getBRinput(norm_test_input,BR5IW);
BR7_test_input = getBRinput(norm_test_input,BR7IW);
BR8_test_input = getBRinput(norm_test_input,BR8IW);
BR9_test_input = getBRinput(norm_test_input,BR9IW);
BR10_test_input = getBRinput(norm_test_input,BR10IW);

est_output(1,:) = ones(1,rclm);
est_output(2,:) = predict(mod2,BR2_test_input');
est_output(3,:) = ones(1,rclm);
est_output(4,:) = predict(mod4,BR4_test_input');
est_output(5,:) = predict(mod5,BR5_test_input');
est_output(6,:) = ones(1,rclm);
est_output(7,:) = predict(mod7,BR7_test_input');
est_output(8,:) = predict(mod8,BR8_test_input');
est_output(9,:) = predict(mod9,BR9_test_input');
est_output(10,:) = predict(mod10,BR10_test_input');
est_output(11:rrw,:) = ones(rrw-11+1,rclm);

%-----------------------PLOTTING THE RESULTS------------------------    
graphTitles = {'TL1','TL21','TL2','TL22','TL23','TL123','TL3','TL4','TL5','TL6','TL23','TL123','TL3','TL4','TL5','TL6'};
legendTitles = {'KNN','MLP','Actual'};

for i = 1:1:size(test_output,1)             %Check the actual testing output vs estimated testing output
figure;

xlabel('Time(s)');
ylabel('Line Status');
hold on

plot(est_output(i,:),'r-');

plot(mlpData(i,:),'g-');
plot(test_output(i,:),'k-.');
%t = sprintf('%d output', i);
axis([0,8500,-0.5,2]);
title(graphTitles{i});
legend(legendTitles,'Location','Best')
end
%------------------------------------------------------------------

acc = GetAccuracy(est_output, test_output);
acc2 = GetAccuracy(mlpData, test_output);
t = sprintf('KNN %0.2f % accuracy\n', 100*acc);
t2 = sprintf('MLP %0.2f % accuracy\n', 100*acc2);
disp(t);
disp(t2);