clc; clear; close all

%% Import image

H = double(imread('lena512.png')) ;

figure(1)
imshow(H, [])
title('Image before compression')


%% Quantised

Q_step = 10 ;

Q_no_Haar = Q_step * round( H ./ Q_step ) ;

figure(2)
imshow(Q_no_Haar, [])
title('Image compressed with just quantisation')

%% Haar transform quantised, then inverse Haar

a = H(1:2:end, 1:2:end);
b = H(1:2:end, 2:2:end);
c = H(2:2:end, 1:2:end);
d = H(2:2:end, 2:2:end);

lolo = (a+b+c+d)/2 ;
hilo = (a-b+c-d)/2 ;
lohi = (a+b-c-d)/2 ;
hihi = (a-b-c+d)/2 ;


Y = zeros(size(H));

Y(1:end/2,1:end/2) = lolo ;
Y(1:end/2,end/2+1:end) = hilo ;
Y(end/2+1:end,1:end/2) = lohi ;
Y(end/2+1:end,end/2+1:end) = hihi ;

Lena_haar_2 = Y ;

figure(3)
imshow(Lena_haar_2, [])
title('Image Haar Transformed')

%% Quantising the Haar

Q_Haar = Q_step * round( Y ./ Q_step ) ;

% figure(4)
% imshow(Q_Haar, [])

%% Inverse the haar

hx = size(H,2)/2;
hy = size(H,1)/2;

loloQH = Q_Haar(1:hy, 1:hx);
hiloQH = Q_Haar(1:hy, hx + (1:hx));
lohiQH = Q_Haar(hy + (1:hy), 1:hx);
hihiQH = Q_Haar(hy + (1:hy), hx + (1:hx));

aQH = (loloQH+hiloQH+lohiQH+hihiQH)/2;
bQH = (loloQH-hiloQH+lohiQH-hihiQH)/2;
cQH = (loloQH+hiloQH-lohiQH-hihiQH)/2;
dQH = (loloQH-hiloQH-lohiQH+hihiQH)/2;

R = zeros(size(H));

R(1:2:end, 1:2:end) = aQH;
R(1:2:end, 2:2:end) = bQH;
R(2:2:end, 1:2:end) = cQH;
R(2:2:end, 2:2:end) = dQH;

figure(5)
imshow(R, [])
title('Quantised Haar image')


%%  Evaluation orginal

p_o = histcounts(H, 2048, 'Normalization', 'probability');

entropy_o = -sum(p_o.*log2(p_o + eps)) 

PSNR_o = psnr(H, H, 255)

%%  Evaluation quantised

p_q = histcounts(Q_no_Haar, 2048, 'Normalization', 'probability');

entropy_q = -sum(p_q.*log2(p_q + eps)) 

PSNR_q = psnr(H, Q_no_Haar, 255)

%%  Evaluation quantised Haar

p_lolo = histcounts(lolo, 2048, 'Normalization', 'probability');
p_hilo = histcounts(hilo, 2048, 'Normalization', 'probability');
p_lohi = histcounts(lohi, 2048, 'Normalization', 'probability');
p_hihi = histcounts(hihi, 2048, 'Normalization', 'probability');

entropy_lolo = -sum(p_lolo.*log2(p_lolo + eps)) ;
entropy_hilo = -sum(p_hilo.*log2(p_hilo + eps)) ;
entropy_lohi = -sum(p_lohi.*log2(p_lohi + eps)) ;
entropy_hihi = -sum(p_hihi.*log2(p_hihi + eps)) ;

entropy_haar = (entropy_lolo + entropy_hilo + entropy_lohi + entropy_hihi)/4


PSNR_haar = psnr(H, R, 255)
