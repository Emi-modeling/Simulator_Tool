clear all
%% CALIBRATION

opts = delimitedTextImportOptions("NumVariables", 18);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "B", "PNB", "NE", "EE", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18"];
opts.SelectedVariableNames = ["B", "PNB", "NE", "EE"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18"], "EmptyFieldRule", "auto");

% Import the data
AllData = readtable("AllData.csv", opts);


%% Clear temporary variables
clear opts

B=table2array(AllData(2:end,1));
PNB=table2array(AllData(2:end,2));
NE=table2array(AllData(2:end,3));
clear AllData

PNB=(PNB-1)/5;
B=(B-1)/6;
NE=(NE-1)/5;
data=[B PNB NE];
mu=mean(data);
Sigma=cov(data);