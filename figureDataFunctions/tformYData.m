function dataOut = tformYData(data_in,low,mid,high,proportion_low)



data_low_idx = data_in>low&data_in<=mid;
data_high_idx = data_in>mid&data_in<=high;

low_data = data_in(data_low_idx);
low_data = (low_data-low)/(mid-low);

high_data = data_in(data_high_idx);
high_data = (high_data-mid)/(high-mid);

low_data = low_data*proportion_low;
high_data = high_data*(1-proportion_low);
high_data = high_data+proportion_low;

dataOut = data_in;
dataOut(data_low_idx) = low_data;
dataOut(data_high_idx) = high_data;