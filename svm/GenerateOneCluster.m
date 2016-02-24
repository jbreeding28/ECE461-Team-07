function [fv, label] = GenerateOneCluster(nPts, cls, xmu, ymu, xsigma, ysigma)

x = normrnd(xmu, xsigma,[nPts,1]);
%x = xsigma*randn(nPts,1)+xmu;
y = normrnd(ymu, ysigma,[nPts,1]);
%y = ysigma*randn(nPts,1)+ymu;
fv = [x, y];
label = ones(nPts, 1)*cls;






