% V1.0.4
% update in V1.0.4  add noise integer in line 45

% update in V1.0.3 : delete the 16PSK to avoid complexity
%                    make no. of weight on each point
%                    in BPSK, QPSK, and 8PSK is 10:5:3
%                    therefore, the no. of total sample ratio will be
%                    10:10:12
%                    Actually, the ratio on each point should follow
%                    BPSK_W>8PSK_W, QPSK_W>8PSK_W, 4*8PSK_W>BPSK_W
%                    2*8PSK_W>QPSK_W

% update in V1.0.2 : use matlab max function to reduce codes
% directly generate 5 modulation methods constellation and weight
% chessboard (2PSK, 4PSK, 8PSK, 16PSK and 16QAM)
% problem: chessboard weight is 90 degree rotate, details in line 177

% update in V1.0.1 : add the no. of sample in line 20

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
grid_scale=1/4;

sample_no=1000;
noise=20;



%BPSK, QPSK, 8PSK and 16PSK constellation
for i=1:4

    M=2^i;

% Generate random data symbols, and then apply QPSK modulation.


    if (M==2)
       
        data = randi([0 M-1],10*sample_no,1);
        txSig = pskmod(data,M,0);

    elseif (M==4)
       
        data = randi([0 M-1],10*sample_no,1);
        txSig = pskmod(data,M,pi/M);
    elseif (M==8)
        
        data = randi([0 M-1],12*sample_no,1);
        txSig = pskmod(data,M,0);

    end
    
    
    %Pass the signal through white noise and plot its constellation.
    
    

    if i==1
        rxSig_2PSK = awgn(txSig,noise);
        scatterplot(rxSig_2PSK)
    elseif i==2
        rxSig_4PSK = awgn(txSig,noise);
        scatterplot(rxSig_4PSK)
    elseif i==3
        rxSig_8PSK = awgn(txSig,noise);
        scatterplot(rxSig_8PSK)        
    end
    

end


%16QAM constellation
M = 16;
refC = qammod(0:M-1,M);
data = randi([0 M-1],M*sample_no,1);
sym = qammod(data,M);
rxSig_16QAM = awgn(sym,noise);
scatterplot(rxSig_16QAM)

%above completed at 9:47 18/10/2022




%get the largest imaginary part and real part of the signal

tmp_large=[
    max(abs(real(rxSig_2PSK)))
    max(abs(real(rxSig_4PSK)))
    max(abs(real(rxSig_8PSK)))
    max(abs(real(rxSig_16QAM)))
    max(abs(imag(rxSig_2PSK)))
    max(abs(imag(rxSig_4PSK)))
    max(abs(imag(rxSig_8PSK)))
    max(abs(imag(rxSig_16QAM)))
];

XY_scale=round(max(tmp_large))+2;





%get the no. of grid in horizental and vertical
XY_length=XY_scale/grid_scale;

%array does not accept 0 or negatives, so we have to get all parts in
%positive
rxSig_2PSK_tmp=rxSig_2PSK+XY_scale+XY_scale*1i;
rxSig_4PSK_tmp=rxSig_4PSK+XY_scale+XY_scale*1i;
rxSig_8PSK_tmp=rxSig_8PSK+XY_scale+XY_scale*1i;
rxSig_16QAM_tmp=rxSig_16QAM+XY_scale+XY_scale*1i;


%set the weights arry
weights_2PSK=zeros(2*XY_length);
weights_4PSK=zeros(2*XY_length);
weights_8PSK=zeros(2*XY_length);
weights_16QAM=zeros(2*XY_length);


%Noted! X and Y in coordinates are different from C++


%use a*sample number, a is needed figure calculated
for b=1:10*sample_no 
    
    %if there is an point in the grid, then weight of this grade will +1
    weights_2PSK(round(real(rxSig_2PSK_tmp(b))/grid_scale),round(imag(rxSig_2PSK_tmp(b))/grid_scale))=weights_2PSK(round(real(rxSig_2PSK_tmp(b))/grid_scale),round(imag(rxSig_2PSK_tmp(b))/grid_scale))+1;
 
end

for b=1:10*sample_no 
    
    %if there is an point in the grid, then weight of this grade will +1
    weights_4PSK(round(real(rxSig_4PSK_tmp(b))/grid_scale),round(imag(rxSig_4PSK_tmp(b))/grid_scale))=weights_4PSK(round(real(rxSig_4PSK_tmp(b))/grid_scale),round(imag(rxSig_4PSK_tmp(b))/grid_scale))+1;
 
end

for b=1:12*sample_no 
    
    %if there is an point in the grid, then weight of this grade will +1
    weights_8PSK(round(real(rxSig_8PSK_tmp(b))/grid_scale),round(imag(rxSig_8PSK_tmp(b))/grid_scale))=weights_8PSK(round(real(rxSig_8PSK_tmp(b))/grid_scale),round(imag(rxSig_8PSK_tmp(b))/grid_scale))+1;
 
end

for b=1:16*sample_no 
    
    %if there is an point in the grid, then weight of this grade will +1
    weights_16QAM(round(real(rxSig_16QAM_tmp(b))/grid_scale),round(imag(rxSig_16QAM_tmp(b))/grid_scale))=weights_16QAM(round(real(rxSig_16QAM_tmp(b))/grid_scale),round(imag(rxSig_16QAM_tmp(b))/grid_scale))+1;
 
end



