function [histograms_Out] = initHist(~)



histograms_Out.downquad_mag = zeros(1,500);
        histograms_Out.upquad_mag = zeros(1,500);
        histograms_Out.leftquad_mag = zeros(1,500);
        histograms_Out.rightquad_mag = zeros(1,500);
        
        histograms_Out.downquad_ori = zeros(1,512);
        histograms_Out.upquad_ori = zeros(1,512);
        histograms_Out.leftquad_ori = zeros(1,512);
        histograms_Out.rightquad_ori = zeros(1,512);
        
        for aa = 1:17
            for bb = 1:32
                
                histograms_Out.reg_mag{aa,bb} = zeros(1,500);
                histograms_Out.reg_ori{aa,bb} = zeros(1,512);
            end
        end
        
        for aa = 1:16
            for bb = 1:10
                
                histograms_Out.v5_mag{aa,bb} = zeros(1,500);
                histograms_Out.v5_ori{aa,bb} = zeros(1,512);
            end
        end







end

