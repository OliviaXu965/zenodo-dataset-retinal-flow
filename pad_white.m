function padded_img = pad_white(input_img,num_pix,side)

    
switch side
    case 'top'
        padder = 255*ones(num_pix,size(input_img,2),3);
        padded_img = [padder;input_img];
    case 'left'
        padder = 255*ones(size(input_img,1),num_pix,3);
        padded_img = [padder input_img];
    case 'right'
        padder = 255*ones(size(input_img,1),num_pix,3);
        padded_img = [input_img padder];
    case 'bottom'
        padder = 255*ones(num_pix,size(input_img,2),3);
        padded_img = [input_img;padder];


end
    
    
    
    
    
    
    
    
    