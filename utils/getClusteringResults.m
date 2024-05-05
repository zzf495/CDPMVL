function [results,results_iter] = getClusteringResults(i,testY,Ytpseudo,results_iter,supervisedFlag)
    results=MyClusteringMeasure(testY,Ytpseudo,supervisedFlag);%[ACC MIhat Purity]';
    for index=1:4
        results_iter(i,index)=results(index);
    end
end

