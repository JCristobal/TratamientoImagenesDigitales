%
%% Transformada de fourier bidimensional
%

% (para este guión necesitarás el archivo distmatrix.m, con copyright del libro "Practical Image and Video Processing Using MATLAB, Wiley-IEEE, 2011.")

I = imread('cameraman.tif');

Id = im2double(I);
ft = fft2(Id);

ft_shift = fftshift(ft); % Desplazamos la matriz resultante de la FFT

figure, subplot(1,2,1), imshow(abs(ft_shift),[]), title('mapeado directo');
subplot(1,2,2), imshow(log(1 + abs(ft_shift)), []), title('Remap logarítmico') 

%%
[M, N] = size(I);%Genera una matriz de distancias del mismo tamaño que la imagen 
D = distmatrix(M, N);

D_shift = fftshift(D); %Creamos una malla 3D de la imagen de distancias
figure, mesh(D_shift) 


%
%
%% Filtro paso bajo frecuencias
%
%

I = imread('eight.tif');
Id = im2double(I);
I_dft = fft2(Id);

[M, N] = size(I);
dist = distmatrix(M, N);

figure, subplot(1,3,1), imshow(Id), title('Imagen Original');
subplot(1,3,2), imshow(log(1 + abs(fftshift(I_dft))),[]), title('FT de la imagen original');
subplot(1,3,3), mesh(fftshift(dist)), title('Matriz de distancias');

%%
H = zeros(M, N); % Creamos el filtro inicial con todos los valores a cero
radius = 35; %Define el radio del filtro ideal
ind = dist <= radius;
H(ind) = 1;
Hd = double(H);

figure, imshow(fftshift(H)), title('Filtro paso bajo ideal'); % mostramos la función de respuesta del filtro

%% Aplicamos el filtro a la imagen FT

DFT_filt = Hd .* I_dft;
I2 = real(ifft2(DFT_filt));

%% Mostramos la imagen FT filtrada y la imagen final filtrada

figure, subplot(1,2,1), imshow(log(1 + abs(fftshift(DFT_filt))),[]), title('FT filtrada');
subplot(1,2,2), imshow(I2), title('Imagen Filtrada');


%% Creamos un filtro paso bajo gaussiano con sigma=30.

sigma = 30;
H_gau = exp(-(dist .^ 2) / (2 * (sigma ^ 2)));
figure, subplot(2,2,1), imshow(Id), title('Imagen original');
subplot(2,2,2), imshow(log(1 + abs(fftshift(I_dft))),[]), title('DFT de la imagen original');
subplot(2,2,3), mesh(fftshift(dist)), title('Matriz de distancias');
subplot(2,2,4), imshow(fftshift(H_gau)), title('Filtro paso bajo gaussiano');

%% Filtramos la imagen FT con un filtro gaussiano de paso bajo

DFT_filt_gau = H_gau .* I_dft;
I3 = real(ifft2(DFT_filt_gau));
figure,subplot(1,2,1), imshow(log(1 + abs(fftshift(DFT_filt_gau))),[]), title('FT Filtrada');
subplot(1,2,2), imshow(I3), title('Imagen Filtrada');


%% Generamos un filtro de tercer orden de Butterworth, con un valor de corte 35

D0 = 35; n = 3;
H_but = 1 ./ (1 + (dist ./ D0) .^ (2 * n));
figure,subplot(2,2,1), imshow(Id), title('Imagen Original');
subplot(2,2,2), imshow(log(1 + abs(fftshift(I_dft))),[]), title('FT de imagen original');
subplot(2,2,3), mesh(fftshift(dist)), title('Matriz de distancias');
subplot(2,2,4), imshow(fftshift(H_but)), title('Paso Bajo Butterworth');

%% Filtramos la imagen con el filtro paso bajo de Butterworth 

DFT_filt_but = H_but .* I_dft;
I4 = real(ifft2(DFT_filt_but));
figure,subplot(1,2,1), imshow(log(1 + abs(fftshift(DFT_filt_but))),[]), title('FT filtrada');
subplot(1,2,2), imshow(I4), title('Imagen Filtrada');


%
%
%% Filtros de paso alto en el dominio de las frecuencias
%
%


I = im2double(imread('eight.tif'));
I_dft = fft2(I);
figure, subplot(1,2,1),  imshow(I), title('Imagen Original');
subplot(1,2,2), imshow(log(1  + abs(fftshift(I_dft))),[]), title('FT de la imagen original');


%% 
[M, N] = size(I);
dist = distmatrix(M, N);

H  = ones(M, N);
radius = 30;
ind  = dist <= radius;
H(ind) = 0;

%% Aplicamos filtrado de énfasis de frecuencias altas al filtro de paso alto 

a = 1; b = 1;
Hd = double(a + (b .* H));

%% Aplicamos el filtro a la imagen FT 

DFT_filt = Hd .* I_dft;
I2 = real(ifft2(DFT_filt));

figure, subplot(2,2,1), imshow(fftshift(Hd),[]), title('Filtro como imagen');
subplot(2,2,2), mesh(fftshift(Hd)), zlim([0 2]), title('Filtro como malla');
subplot(2,2,3), imshow(log(1 + abs(fftshift(DFT_filt))),[]), title(' FT Filtrada');
subplot(2,2,4), imshow(I2), title('Imagen filtrada');


