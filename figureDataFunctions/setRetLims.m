function setRetLims(ca)

ret_lim = 45;

ca.XTick = linspace(0,250,7);

for aa = 1:length(ca.XTick)
   
    ca.XTickLabel{aa} = (ca.XTick(aa)-125)/125*ret_lim;
    
end
ca.YTick = ca.XTick;
ca.YTickLabel = ca.XTickLabel;

axis equal
xlim([0 250]);
ylim([0 250]);
xlabel('Horizontal Position (deg)');
ylabel('Vertical Position (deg)');
ca.FontSize=16;