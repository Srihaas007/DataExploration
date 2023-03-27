function Graphs_function(x1Vals, y1Vals, x2Vals, y2Vals, legendLabels)
% Show two plots on different y-axes
figure(1)
yyaxis left
plot(x1Vals, y1Vals, '-bd')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')

yyaxis right
plot(x2Vals, y2Vals, '-rx')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')

legendLabels = split(legendLabels, ' ');
legend(legendLabels{1}, legendLabels{2})

% Show two plots on same y-axis
% Mean processing time
y1MeanVals = y1Vals / input("Enter the divisor for the first data set: ");
y2MeanVals = y2Vals / input("Enter the divisor for the second data set: ");

figure(2)
plot(x1Vals, y1MeanVals, '-bd')
hold on
plot(x2Vals, y2MeanVals, '-rx')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')

legend(legendLabels{1}, legendLabels{2})

end
