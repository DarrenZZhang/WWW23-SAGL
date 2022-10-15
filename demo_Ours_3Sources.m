close all
clear all
clc
addpath(genpath('./files'));
addpath(genpath('./SAGL-data'));
warning('off');


%% Settings and pre-process
load('Data_3Sources.mat')
fname = '3Sources_result.txt';
fid=fopen(fname,'a');
% Each row is an instance. 
% ind: indicate the instance is missing(=0) or not(=1)
% label: cluster label vector (ground truth)
V1 = (normcols(V1'))'; 
V2 = (normcols(V2'))'; 
V3 = (normcols(V3'))';
para.c = length(unique(label)); % K: number of clusters
para.k = 12; % m: number of nearest anchors
alphas = [.001 .01 .1 1 5 10 100 500 1000];


%% subset 1: BBC-Guardian
fprintf(fid,'\n----- subset 1: BBC-Guardian -----\n');
fprintf('\n----- subset 1: BBC-Guardian -----\n');

para.alpha = 1000;
for f = 1:10
    [Xpaired,Ypaired,Xsingle,Ysingle,NEWlabel] = ...
    TwoViewDataAdjust(V1,V2,ind(:,[1 2]),label);
    predLabel = SAGL_2views(Xpaired,Ypaired,Xsingle,Ysingle,para);
    result = ClusteringMeasure(NEWlabel,predLabel);
    ACCs(f)=result(1);
    NMIs(f)=result(2);
    Purities(f)=result(3);
end
fprintf(fid,'alpah = %f',para.alpha);
fprintf('alpah = %f',para.alpha);
printFinalResult(ACCs,NMIs,Purities,fid);




%% subset 2: BBC-Reuters
fprintf(fid,'\n----- subset 2: BBC-Reuters -----\n');
fprintf('\n----- subset 2: BBC-Reuters -----\n');
para.alpha = 1;
for f = 1:10
    [Xpaired,Ypaired,Xsingle,Ysingle,NEWlabel] = ...
    TwoViewDataAdjust(V1,V3,ind(:,[1 3]),label);
    predLabel = SAGL_2views(Xpaired,Ypaired,Xsingle,Ysingle,para);
    result = ClusteringMeasure(NEWlabel,predLabel);
    ACCs(f)=result(1);
    NMIs(f)=result(2);
    Purities(f)=result(3);
end
fprintf(fid,'alpah = %f',para.alpha);
fprintf('alpah = %f',para.alpha);
printFinalResult(ACCs,NMIs,Purities,fid);



%% subset 3: Guardian-Reuters
fprintf(fid,'\n----- subset 3: Guardian-Reuters -----\n');
fprintf('\n----- subset 3: Guardian-Reuters -----\n');
para.alpha = 1000;
for f = 1:10
    [Xpaired,Ypaired,Xsingle,Ysingle,NEWlabel] = ...
    TwoViewDataAdjust(V2,V3,ind(:,[2 3]),label);
    predLabel = SAGL_2views(Xpaired,Ypaired,Xsingle,Ysingle,para);
    result = ClusteringMeasure(NEWlabel,predLabel);
    ACCs(f)=result(1);
    NMIs(f)=result(2);
    Purities(f)=result(3);
end
fprintf(fid,'alpah = %f',para.alpha);
fprintf('alpah = %f',para.alpha);
printFinalResult(ACCs,NMIs,Purities,fid);



%% Utilize all three views
fprintf(fid,'\n----- utilize all three views -----\n');
fprintf('\n----- utilize all three views -----\n');
para.alpha = 100;
for f = 1:10
%         tic;
    [predLabel,NEWlabel] = SAGL_3views(V1,V2,V3,ind,label,para);
    result = ClusteringMeasure(NEWlabel,predLabel);
%         toc;
    ACCs(f)=result(1);
    NMIs(f)=result(2);
    Purities(f)=result(3);
end
fprintf(fid,'alpah = %f',para.alpha);
fprintf('alpah = %f',para.alpha);
printFinalResult(ACCs,NMIs,Purities,fid);

fclose(fid);