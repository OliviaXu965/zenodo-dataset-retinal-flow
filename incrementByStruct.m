function      [histograms_Out] = incrementByStruct(histograms_Out,loadStruct)

% [~,argmax] = max(loadStruct.downquad_mag);
% 
% if argmax>10
    
histograms_Out.downquad_mag = histograms_Out.downquad_mag + loadStruct.downquad_mag;
histograms_Out.upquad_mag = histograms_Out.upquad_mag + loadStruct.upquad_mag;
histograms_Out.leftquad_mag = histograms_Out.leftquad_mag + loadStruct.leftquad_mag;
histograms_Out.rightquad_mag = histograms_Out.rightquad_mag + loadStruct.rightquad_mag;

histograms_Out.downquad_ori = histograms_Out.downquad_ori + loadStruct.downquad_ori;
histograms_Out.upquad_ori =histograms_Out.upquad_ori + loadStruct.upquad_ori;
histograms_Out.leftquad_ori = histograms_Out.leftquad_ori + loadStruct.leftquad_ori;
histograms_Out.rightquad_ori = histograms_Out.rightquad_ori + loadStruct.rightquad_ori;

for aa = 1:17
    for bb = 1:32

        histograms_Out.reg_mag{aa,bb} =  histograms_Out.reg_mag{aa,bb} + loadStruct.reg_mag{aa,bb};
        histograms_Out.reg_ori{aa,bb} = histograms_Out.reg_ori{aa,bb} + loadStruct.reg_ori{aa,bb};
    end
end

for aa = 1:16
    for bb = 1:10

        histograms_Out.v5_mag{aa,bb} = histograms_Out.v5_mag{aa,bb} + loadStruct.v5_mag{aa,bb};
        histograms_Out.v5_ori{aa,bb} = histograms_Out.v5_ori{aa,bb} + loadStruct.v5_ori{aa,bb};
    end
end
    
% end


end