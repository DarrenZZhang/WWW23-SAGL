function [] = printFinalResult(ACCs,NMIs,Purities,fid)
avg_acc = mean(ACCs);
std_acc = std(ACCs);
avg_nmi = mean(NMIs);
std_nmi = std(NMIs);
avg_Purities = mean(Purities);
std_Purities = std(Purities);
fprintf(fid,'\nACC = %f +- %f\n',avg_acc, std_acc);
fprintf(fid,'NMI = %f +- %f\n',avg_nmi, std_nmi);
fprintf(fid,'Purity = %f +- %f\n',avg_Purities, std_Purities);
fprintf('\nACC = %f +- %f\n',avg_acc, std_acc);
fprintf('NMI = %f +- %f\n',avg_nmi, std_nmi);
fprintf('Purity = %f +- %f\n',avg_Purities, std_Purities);
end