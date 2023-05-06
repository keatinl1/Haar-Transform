# Haar-Transform

## 1 - Introduction
For this project, an image was taken and was compressed using two different methods. Quantisation alone and Haar transformation followed by quantisation. The results were then compared and conclusions were made. 

This project was done in MATLAB.

$~~~~~~~~~~~$

## 2 - Methodology
### 2.1 - Setup
Firstly, the workspace was cleared and the image imported. It is a test image of Lena Forsén, it is shown in figure 1.

```matlab
%% Setup and import image

clc; clear; close all;

H = double(imread('lena512.png')) ;

figure(1)
imshow(H, [])
title('Image before compression')
```

<p align="center">
  <img width="512" height="512" src="https://raw.githubusercontent.com/keatinl1/image-processing/main/figures/lena512.png">
</p>
<div align="center">
  Figure 1: Image before compression
</div>

### 2.2 - Quantisation alone

Quantisation is a method of lossy compression. The aim is to make a greater number of pixels have the same value so the values can be stored more compactly. The equation to quantise an image is:

$$
I_{quantised}=Q_{step} \cdot round(I_{original} / Q_{step})
$$

It is implemented using the following lines of code:

```Matlab
%% Just quantisation

Q_step = 15 ;

Q_no_Haar = Q_step * round( H ./ Q_step ) ;

figure(2)
imshow(Q_no_Haar, [])
title('Image compressed with just quantisation')
```

The resulting image is shown in figure 2 in the results section.

<p align="center">
  <img width="512" height="512" src="https://raw.githubusercontent.com/keatinl1/image-processing/main/figures/lena512Q.png">
</p>
<div align="center">
  Figure 2: Quantised image
</div>

$~~~~~~~~~~~$

### 2.3 - Quantised Haar transform

The Haar transform is a simple wavelet transform. A wavelet transform is a representation of a square-integrable function by a certain orthonormal series generated by a wavelet. A wavelet is a wave-like oscillation with an amplitude that begins at zero, increases or decreases, and then returns to zero one or more times.

It is calculated using the following equations:

```math
x=
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
; \quad

y=\frac{1}{2}
\begin{bmatrix}
LoLo & HiLo \\
LoHi & HiHi
\end{bmatrix}\\
```

where,

```math
LoLo = 𝑎 + 𝑏 + 𝑐 + d \\
```
```math
HiLo = 𝑎 − 𝑏 + 𝑐 − d \\
```
```math
LoHi = 𝑎 + 𝑏 − 𝑐 − d \\
```
```math
HiHi = 𝑎 − 𝑏 − 𝑐 + d\\
```

These equations are implemented using the following lines of code:

```matlab
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
title('Image quantisatised Haar')
```

The result of this transformation is shown in figure 3 in the results section.

<p align="center">
  <img width="512" height="512" src="https://raw.githubusercontent.com/keatinl1/image-processing/main/figures/Lena512T.png">
</p>
<div align="center">
  Figure 3: Result of Haar Transform
</div>

$~~~~~~~~~~~$

The resulting image is then quantised:

```matlab
%% Quantising the Haar

Q_Haar = Q_step * round( Y ./ Q_step ) ;
```

Then finally, the inverse Haar is found to reconstruct the image:

```matlab
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
```

The resulting image is shown in figure 4 in the results section.

<p align="center">
  <img width="512" height="512" src="https://raw.githubusercontent.com/keatinl1/image-processing/main/figures/lena512QH.png">
</p>
<div align="center">
  Figure 4: Reconstructed Quantised Haar
</div>

$~~~~~~~~~~~$

## 3 - Comparisons

The entropy of an image is a measure of the degree of randomness in the image [1]. The equation for calculating entropy is shown below, and the code implementation is shown after. Higher entropy means a more detailed image.

$$
H(X)=-\sum_{x}p(x)\cdot \log_{2}p(x)
$$

```matlab
p = histcounts(I, 2048, 'Normalization', 'probability');

entropy = -sum(p.*log2(p + eps)) ;
```

PSNR is the peak signal-to-noise ratio. PSNR is a well-known method of gauging the quality of an image [2]. It is a ratio between the maximum possible power of a signal and the power of corrupting noise that affects the fidelity of its representation. A greater PSNR is better. 

MATLAB has an inbuilt function to calculate PSNR, so this was used.

```matlab
PSNR = psnr(A, ref, peakval) ;
```

<h5 align="center">Table 1: Evaluations</h5>

<div align="center">

|  | Entropy | PSNR | File size (kB) |
| --- | --- | --- | --- |
| Original | 7.4474 | ∞ | 151 |
| Quantised | 3.5798 | 35.3470 | 95 |
| Quantised Haar | 6.3692 | 37.1465 | 93 |

</div>


$~~~~~~~~~~~$


## 4 - Discussion and conclusions

After just quantisation, there are clear artefacts (distortion of media) in the image on Lena’s shoulder and on the arch behind her (figure 2). While the file size is now smaller, it does not look as good as the original and is a poor compression because of this. The entropy is much lower and this reinforces the point that the image has significantly less detail.

When the image is Haar transformed and then quantised, the file size is smaller and also has no artefacts unlike figure 2. The entropy is much closer to the original image's entropy when Haar is applied meaning there is a similar level of detail in the image.

In conclusion, applying the Haar transform allows the user to quantise an image to reduce its size while avoiding obvious artefacts in the final image. 


$~~~~~~~~~~~$


## References

[1] - Thum, C. (1984). Measurement of the Entropy of an Image with Application to Image
Focusing. Optica Acta: International Journal Of Optics, 31(2), 203-211. doi:
10.1080/713821475

[2] - A. Horé and D. Ziou, "Image Quality Metrics: PSNR vs. SSIM," 2010 20th International
Conference on Pattern Recognition, 2010, pp. 2366-2369, doi: 10.1109/ICPR.2010.579.
