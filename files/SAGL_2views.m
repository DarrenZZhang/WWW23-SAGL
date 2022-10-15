function scLabel = SAGL_2views(Xpaired,Ypaired,Xsingle,Ysingle,para) 
    [Z, S] = getSim(Xpaired,Ypaired,Xsingle,Ysingle,para);

    para.type = 'fastEIG'; % 3 types: 'regular','fastSVD','fastEIG'
    scLabel = SpectralClustering(Z,S,para);
end

function [Z,S] = getSim(Xpaired,Ypaired,Xsingle,Ysingle,para) 
    %% Settings
    [nPaired, ~] = size(Xpaired);

%     fprintf("Z1\n");
    Z1 = withinSim([Xpaired;Xsingle],Xpaired,para); 
%     fprintf("Z2\n");
    Z2 = withinSim([Ypaired;Ysingle],Ypaired,para); 

    Z = [0.5*(Z1(1:nPaired,:)+Z2(1:nPaired,:)); ...
        Z1(nPaired+1:end,:); Z2(nPaired+1:end,:)];
    S = Z*diag(1./sum(Z,1))*Z';
    S = full(max(S,S')); 
end

%% compute within-view similarity
function [Z] = withinSim(allSmp,anchor,para) 
    [k, d] = size(anchor);
    [n, ~] = size(allSmp);
    dK = ones(d,1);
    dE = ones(k,1);
    Z  = rand(n,k);
    for iter = 1:10
%         fprintf("iter:%d\n",iter);
        Z0 = Z;
        K = spdiags(dK,0,d,d);
        E = spdiags(dE,0,k,k);
        Z = (allSmp*K*anchor')/(anchor*K*anchor' + para.alpha*E);
        dE = sqrt(sum(Z.*Z,1))';
        
        if ( trace ((Z-Z0)'*(Z-Z0)) < 1e-5)  
            break;
        end
    end
    Z = bsxfun(@rdivide,Z,sum(Z,2));
    Z(Z<1e-10) = 0;%force values < 0 to be 0
end