%
%% Umbralización de Imágenes
%

% necesitarás la función umbralizacion_adaptativa (umbralizacion_adaptativa.m)
% y la función umbralizacion_bloques (umbralizacion_bloques.m) de la carpeta Funciones


%% Leemos la imagen y vemos su histograma para determinar el umbral a usar

I = imread('coins.png');

figure, subplot(1,2,1), imshow(I), title('Imagen');
subplot(1,2,2), imhist(I), title('Histograma de la imagen');


%% En mi caso selecciono el umbral 85 y umbralizamos:

T = 85; I_thresh = im2bw(I,( T / 255));

% función graythreshold
T2 = graythresh(I);
I_thresh2 = im2bw(I,T2);

figure, subplot(1,2,1), imshow(I_thresh), title('Imagen Umbralizada (heurístico)');
subplot(1,2,2), imshow(I_thresh2), title('Imagen umbralizada (graythresh)');

%% Umbralizamos una imagen globalmente

I = imread('gradient_with_text.tif');
I_gthresh = im2bw(I,graythresh(I));

figure, subplot(1,3,1), imshow(I), title('Imagen original');
subplot(1,3,2), imshow(I_gthresh), title('Umbralizacion Global');
subplot(1,3,3), imhist(I), title('Histograma de la Imagen Original');


%% Usaremos la umbralización adaptativa llamando a umbralizacion_adaptativa


I_thresh = blkproc(I,[10 10],@umbralizacion_adaptativa);

figure
subplot(1,2,1), imshow(I), title('Imagen Original');
subplot(1,2,2), imshow(I_thresh), title('Umbralizacion Adaptativa');


%% Usaremos la umbralización por bloques llamando a umbralizacion_bloques

%  Calcula la desviación típica de dos bloques 10x10, uno donde hay texto
%  y otro donde no lo hay

std_without_text = std2(I(1:10, 1:10))
std_with_text = std2(I(100:110, 100:110))


I_thresh2 = blkproc(I,[10 10],@umbralizacion_bloques);
figure, subplot(1,2,1), imshow(I), title('Imagen original');
subplot(1,2,2), imshow(I_thresh2), title('Umbralización por bloques');
