% V1.0.4
% This coding is for finding common location elements of QPSK and 8PSK
% under 0dB

clear;
clc;


int8 tmp_comp_R;
int8 tmp_comp_I;
int8 tmp_large_R;
int8 tmp_large_I;
int8 tmp_large;
%this 4 integers are for scales of constellation

int8 XY_scale;
%declare larger one between X and Y to decide the scale of constellation

double grid_scale;
%declare grid scare to measure the weights square

int8 XY_length;
%declare the length of X&Y, XY_length = XY_scale / grid_scale

int8 sample_no;
%declare the number of samples

%set the accuracy
grid_scale=1/10;

sample_no=1000;
noise=0;



%BPSK, QPSK, 8PSK and 16PSK constellation
for i=1:4

    M=2^i;

% Generate random data symbols, and then apply QPSK modulation.


    if (M==2)
       

    elseif (M==4)
       
        data = randi([0 M-1],10*sample_no,1);
        txSig = pskmod(data,M,pi/M);
    elseif (M==8)
        
        data = randi([0 M-1],12*sample_no,1);
        txSig = pskmod(data,M,0);

    end
    
    
    %Pass the signal through white noise and plot its constellation.
    
    

    if i==1
    elseif i==2
        rxSig_4PSK = awgn(txSig,noise);
        scatterplot(rxSig_4PSK)
    elseif i==3
        rxSig_8PSK = awgn(txSig,noise);
        scatterplot(rxSig_8PSK)        
    end
    

end





%get the largest imaginary part and real part of the signal
XY_scale=5;




%get the no. of grid in horizental and vertical
XY_length=XY_scale/grid_scale;

%array does not accept 0 or negatives, so we have to get all parts in
%positive
rxSig_4PSK_tmp=rxSig_4PSK+XY_scale+XY_scale*1i;
rxSig_8PSK_tmp=rxSig_8PSK+XY_scale+XY_scale*1i;


%set the weights arry
weights_4PSK=zeros(2*XY_length);
weights_8PSK=zeros(2*XY_length);



%Noted! X and Y in coordinates are different from C++


%use a*sample number, a is needed figure calculated


for b=1:10*sample_no 
    
    %if there is an point in the grid, then weight of this grade will +1
    if ((real(rxSig_4PSK_tmp(b))<=2*XY_scale) && (imag(rxSig_4PSK_tmp(b))<=2*XY_scale) && (real(rxSig_4PSK_tmp(b))>0) && (imag(rxSig_4PSK_tmp(b))>0))
        weights_4PSK(round(real(rxSig_4PSK_tmp(b))/grid_scale),round(imag(rxSig_4PSK_tmp(b))/grid_scale))=weights_4PSK(round(real(rxSig_4PSK_tmp(b))/grid_scale),round(imag(rxSig_4PSK_tmp(b))/grid_scale))+1;
    end
end

for b=1:12*sample_no 
    
    %if there is an point in the grid, then weight of this grade will +1
    if ((real(rxSig_8PSK_tmp(b))<=2*XY_scale) && (imag(rxSig_8PSK_tmp(b))<=2*XY_scale) && (real(rxSig_8PSK_tmp(b))>0) && (imag(rxSig_8PSK_tmp(b))>0))
        weights_8PSK(round(real(rxSig_8PSK_tmp(b))/grid_scale),round(imag(rxSig_8PSK_tmp(b))/grid_scale))=weights_8PSK(round(real(rxSig_8PSK_tmp(b))/grid_scale),round(imag(rxSig_8PSK_tmp(b))/grid_scale))+1;
    end
end







%BPSK, QPSK, 8PSK and 16PSK constellation
for i=1:4

    M=2^i;

% Generate random data symbols, and then apply QPSK modulation.


    if (M==2)


    elseif (M==4)
       
        data = randi([0 M-1],10*sample_no,1);
        txSig = pskmod(data,M,pi/M);
    elseif (M==8)
        
        data = randi([0 M-1],12*sample_no,1);
        txSig = pskmod(data,M,0);

    end
    
    
    %Pass the signal through white noise and plot its constellation.
    
    

    if i==1
    elseif i==2
        rxSig_4PSK = awgn(txSig,20);
        scatterplot(rxSig_4PSK)
    elseif i==3
        rxSig_8PSK = awgn(txSig,20);
        scatterplot(rxSig_8PSK)        
    end
    

end




%get the largest imaginary part and real part of the signal

tmp_large=[
    max(abs(real(rxSig_4PSK)))
    max(abs(real(rxSig_8PSK)))
    max(abs(imag(rxSig_4PSK)))
    max(abs(imag(rxSig_8PSK)))

];



%array does not accept 0 or negatives, so we have to get all parts in
%positive
rxSig_4PSK_tmp=rxSig_4PSK+XY_scale+XY_scale*1i;
rxSig_8PSK_tmp=rxSig_8PSK+XY_scale+XY_scale*1i;


%set the weights arry
weights_4PSK_20=zeros(2*XY_length);
weights_8PSK_20=zeros(2*XY_length);


%Noted! X and Y in coordinates are different from C++


%use a*sample number, a is needed figure calculated
for b=1:10*sample_no 
    
    %if there is an point in the grid, then weight of this grade will +1
    if ((real(rxSig_4PSK_tmp(b))<=2*XY_scale) && (imag(rxSig_4PSK_tmp(b))<=2*XY_scale) && (real(rxSig_4PSK_tmp(b))>0) && (imag(rxSig_4PSK_tmp(b))>0))
        weights_4PSK_20(round(real(rxSig_4PSK_tmp(b))/grid_scale),round(imag(rxSig_4PSK_tmp(b))/grid_scale))=weights_4PSK_20(round(real(rxSig_4PSK_tmp(b))/grid_scale),round(imag(rxSig_4PSK_tmp(b))/grid_scale))+1;
    end
end

for b=1:12*sample_no 
    
    %if there is an point in the grid, then weight of this grade will +1
    if ((real(rxSig_8PSK_tmp(b))<=2*XY_scale) && (imag(rxSig_8PSK_tmp(b))<=2*XY_scale) && (real(rxSig_8PSK_tmp(b))>0) && (imag(rxSig_8PSK_tmp(b))>0))
        weights_8PSK_20(round(real(rxSig_8PSK_tmp(b))/grid_scale),round(imag(rxSig_8PSK_tmp(b))/grid_scale))=weights_8PSK_20(round(real(rxSig_8PSK_tmp(b))/grid_scale),round(imag(rxSig_8PSK_tmp(b))/grid_scale))+1;
    end
end







clc;
count_8=0;
count_4=0;
count_4_8=0;
count_4_8_T_I_combine=0;

weights_4_8_Combined=zeros(100,100);
weights_4_8_T_I_combine=zeros(100,100);
z=1;
for x=1:100
    for y=1:100
        if (weights_8PSK(x,y)~=0)
            count_8=count_8+1;
            rf_8(count_8)=(x-50)/10+(y-50)/10*j;
        end
        if (weights_4PSK(x,y)~=0)
            count_4=count_4+1;
            rf_4(count_4)=(x-50)/10+(y-50)/10*j;
        end
        

        if (weights_8PSK(x,y)~=0  && weights_4PSK(x,y)~=0 )
            
            count_4_8=count_4_8+1;
            weights_4_8_Combined(x,y)=weights_4PSK(x,y)-weights_8PSK(x,y);
            rf_combined(count_4_8) = (x-50)/10+(y-50)/10*j;
            
            
        end
        

    
    
    end
end
scatterplot(rf_4);
axis([-3 3 -3 3]);
title("QPSK Matrix Scatter Plot");
scatterplot(rf_8);
axis([-3 3 -3 3]);
title("8PSK Matrix Scatter Plot");
scatterplot(rf_combined);
axis([-3 3 -3 3]);
title("QPSK&8PSK Common Points Matrix Scatter Plot");

count_4
count_8
count_4_8
sum_of_0dB_common_elements=sum(weights_4_8_Combined,"all")

