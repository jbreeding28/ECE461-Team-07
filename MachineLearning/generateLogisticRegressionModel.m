clear all;
load fisheriris;
meas1 = meas(51:100,:);
meas0 = meas(101:150,:);
accuracy = testLogisticRegressionModel(meas1,meas0,0.1);
