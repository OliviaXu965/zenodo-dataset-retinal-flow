function histsAll = chunkedHistCombination(fileList)


% unix('rm chunked_hists/*');
% 
% nChunks = 1000;
% chunkSize = floor(length(fileList)/nChunks);
% %%
% % for chunk_idx = 1:nChunks
% parfor chunk_idx = 1:nChunks
%     disp(chunk_idx);
%     histsAll = initHist();
%     
%     theseFiles = fileList((chunk_idx-1)*chunkSize+1:chunk_idx*chunkSize);
%     
%     % parfor file_idx = 1:length(theseFiles)
%     for file_idx = 1:length(theseFiles)
%         try
%             %     disp(file_idx/length(fileList));
%             histsAll = incrementByStruct(histsAll,load(theseFiles{file_idx}));
%         catch
%         end
%         
%     end
%     
%     parsave(['chunked_hists/' num2str(chunk_idx) '.mat'],histsAll);
%     
% end


%%

fileList = dir('chunked_hists/*.mat');

theseFiles = fileList;
histsAll = initHist();
for file_idx = 1:length(theseFiles)
    try
        disp(file_idx/length(theseFiles));
        histsAll = incrementByStruct(histsAll,load([theseFiles(file_idx).folder '/' theseFiles(file_idx).name]).histsAll);
    catch
        disp('caught exception');
    end
    
end
%














end