% V1.0.5   !! PSK Modulation Change in line 66(M), line 87-95 is for 16QAM
% update in V1.0.5 : add import signal no. to test correct rate line 55
%                    calculate guess output in line 187-212 fix out of 
%                    region bug in line 161-165, input noiseinclude

% update in V1.0.4 : eliminate input signal sample multiplication in line
%                    52, which means no pre-processing needed


% update in V1.0.3 : use same no. of point to avoid scatering
%                    no. of BPSK, QPSK, 8PSK, and 16QAM will be
%                    1:2:4:8 to make sure each constellation point has 
%                    same amount of signal points

% update in V1.0.2 : add test signal for 2PSK, 4PSK, 8PSK, 16PSK, 16QAM
% update in V1.0.1 : add test function of 2PSK, 4PSK, 8PSK, 16PSK, 16QAM


clc;
int8 tmp_comp_R;
int8 tmp_comp_I;
int8 tmp_large_R;
int8 tmp_large_I;
%this 4 integers are for scales of constellation

int8 XY_scale;
%declare larger one between X and Y to decide the scale of constellation

double grid_scale;
%declare grid scare to measure the weights square

int8 XY_length;
%declare the length of X&Y, XY_length = XY_scale / grid_scale

int8 sample_no;
%declare the number of samples


%Input from device or Matlab for testing


sample_no1=1000;
sample_count_2PSK=0;
sample_count_4PSK=0;
sample_count_8PSK=0;
sample_count_16QAM=0;


import_signal_no=100;

%for noise_input=0:20

noise_input=10;


% import/generate signals

for i=1:import_signal_no



% BPSK QPSK 8PSK

% Generate random data symbols, and then apply QPSK modulation.

    M=8;
    refC1 = randi([0 M-1],sample_no1,1);


    if (M==2)||(M==8)
        phase_t=0;
    else
        phase_t=pi/M;
    end

    tx_t = pskmod(refC1,M,phase_t);
    rcv1 = awgn(tx_t,noise_input);
    %scatterplot(rcv1)

% end






% % 16QAM
% 
% M = 16;
% refC1 = qammod(0:M-1,M);
% constDiagram = comm.ConstellationDiagram('ReferenceConstellation',refC1, ...
%     'XLimits',[-4 4],'YLimits',[-4 4]);
% data1 = randi([0 M-1],sample_no1,1);
% sym1 = qammod(data1,M);
% rcv1 = awgn(sym1,0);

%constDiagram(rcv1)
% % 
% 





%array does not accept 0 or negatives, so we have to get all parts in
%positive
rcv_tmp=rcv1+XY_scale+XY_scale*1i;

%set the weights arry
weights_test=zeros(2*XY_length);




for b=1:sample_no1  %1000 is no. of sample
    x_point=round(real(rcv_tmp(b))/grid_scale);
    y_point=round(imag(rcv_tmp(b))/grid_scale);
    if (x_point>0)&&(y_point>0)&&(x_point<2*XY_scale/grid_scale)&&(y_point<2*XY_scale/grid_scale)
        %if there is an point in the grid, then weight of this grade will +1
        weights_test(x_point,y_point)=weights_test(x_point,y_point)+1;
        
    end
end





results_2PSK=weights_test.*weights_2PSK;
sum_2PSK=sum(results_2PSK,'all');


results_4PSK=weights_test.*weights_4PSK;
sum_4PSK=sum(results_4PSK,'all');


results_8PSK=weights_test.*weights_8PSK;
sum_8PSK=sum(results_8PSK,'all');


% results_16PSK=weights_test.*weights_16PSK;
% sum(results_16PSK,'all')


results_16QAM=weights_test.*weights_16QAM;
sum_16QAM=sum(results_16QAM,'all');

sum_matrix=[sum_16QAM,sum_8PSK,sum_4PSK,sum_2PSK];

results_max=max(sum_matrix);

if (results_max==sum_2PSK)
    sample_count_2PSK=sample_count_2PSK+1;
elseif (results_max==sum_4PSK)
    sample_count_4PSK=sample_count_4PSK+1;
elseif (results_max==sum_8PSK)
    sample_count_8PSK=sample_count_8PSK+1;
elseif (results_max==sum_16QAM)
    sample_count_16QAM=sample_count_16QAM+1;
end

end

sample_count_2PSK
sample_count_4PSK
sample_count_8PSK
sample_count_16QAM

sample_count_2PSK=0;
sample_count_4PSK=0;
sample_count_8PSK=0;
sample_count_16QAM=0;


%end