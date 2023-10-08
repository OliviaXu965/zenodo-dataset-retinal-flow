function remapYAxis(ca,low,mid,high,proportion_lower)

%% params

gap_lims = [proportion_lower*0.95 proportion_lower*1.05];

n_lower_ticks = 5;
n_upper_ticks = 2;

%%
line_handles = ca.Children;

for idx = 1:length(line_handles)
    
    this_line = line_handles(idx);
    
    this_ydata = this_line.YData;
    
    this_ydata = tformYData(this_ydata,low,mid,high,proportion_lower);
    
    this_line.YData = this_ydata;
end

yline(gap_lims(1),'linestyle','--','linewidth',2);
yline(gap_lims(2),'linestyle','--','linewidth',2);

patch([ca.XLim(1) ca.XLim(1) ca.XLim(2) ca.XLim(2)],...
    [gap_lims(1) gap_lims(2) gap_lims(2) gap_lims(1)],'w','EdgeColor','None');


ca.YTick = [linspace(0,gap_lims(1),n_lower_ticks) linspace(gap_lims(2),1,n_upper_ticks)];

for idx = 1:n_lower_ticks
    
    ca.YTickLabel{idx} = num2str(round(ca.YTick(idx)/proportion_lower*(mid-low),3));

end

for idx = n_lower_ticks+1:n_lower_ticks+n_upper_ticks
    
    this_val = (ca.YTick(idx)-proportion_lower)/(1-proportion_lower);
    this_val = this_val*(high-mid)+mid;
    
    ca.YTickLabel{idx} = num2str(round(this_val,3));

end

