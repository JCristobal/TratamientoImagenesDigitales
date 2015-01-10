%
%% Reducci�n de Ruido en el Dominio Espacial
%

% (para este gui�n necesitar�s los archivos de funciones  atmean.m, geometric.m, harmonic.m y c_aharmonic.m)

% A�adiremos ruido gaussiano a una imagen:

I = imread('eight.tif');
In = imnoise(I,'gaussian',0,0.001);

figure, subplot(1,2,1), imshow(I), title('Imagen Original');
subplot(1,2,2), imshow(In), title('Imagen con ruido');


%% Primeros aplicamos un filtro de medias (3x3)
f1 = fspecial('average');
I_blur1 = imfilter(In,f1);

% Y ahora un filtro de promedio 5x5
f2 = fspecial('average',[5 5]);
I_blur2 = imfilter(In,f2);

subplot(1,2,1), imshow(I_blur1), title('Promedio con tama�o n�cleo por defecto');
subplot(1,2,2), imshow(I_blur2), title('Promedio con tama�o n�cleo 5x5');


%% Usaremos un  fitro contra-arm�nico (con r=-1)
clear all; close all;

I = imread('eight.tif');
I_salt = im2double(imread('eight_salt.tif')); %imagen con ruido de sal (puntos blancos)
I_pepper = im2double(imread('eight_pepper.tif')); %imagen con ruido de pimienta (puntos negros)

figure, subplot(2,3,1), imshow(I), title('Imagen Original');
subplot(2,3,2), imshow(I_salt), title('Imagen con ruido de Sal');
subplot(2,3,3), imshow(I_pepper), title('Imagen con ruido de Pimienta');

% Y filtramos el ruido de sal  en la imagen usando r=-1 en el filtro contra-arm�nico
I_fix1 = nlfilter(I_salt,[3 3],@c_harmonic,-1);
subplot(2,3,5), imshow(I_fix1), title('Sal eliminada, r = -1');

% Y filtramos el ruido  pimienta en la imagen usando r=1 en el filtro contra-arm�nico
I_fix2 = nlfilter(I_pepper,[3 3],@c_harmonic,1);
subplot(2,3,6), imshow(I_fix2), title('Pimienta Eliminada, r = 1');

% Aplicamos un filtro err�neo (r=-1) a la imagen con ruido pimienta 
I_bad = nlfilter(I_pepper,[3 3],@c_harmonic,-1);
subplot(2,3,4), imshow(I_bad), title('Utilizando valor de r incorrecto');






%% Filtramos la imagen con ruido de sal con el filtro arm�nico
% No se podr� ejecutar la funci�n harmonic con MATLAB 8.3 (Versi�n R2014a) ni versiones posteriores, para usarlo necesitas una versi�n anterior

I_fix4 = nlfilter(I_salt,[3 3],@harmonic);
figure
subplot(2,3,1), imshow(I), title('Imagen Original');
subplot(2,3,2), imshow(I_salt), title('Ruido de Sal');
subplot(2,3,3), imshow(I_pepper), title('Ruido de Pimienta');
subplot(2,3,5), imshow(I_fix4), title('Filtrado arm�nico (sal)');


%% Filtramos la imagen con ruido de pimienta con el filtro arm�nico y mu�strala

I_bad2 = nlfilter(I_pepper,[3 3],@harmonic);
subplot(2,3,6), imshow(I_bad2), title('Filtrado Arm�nico (pimienta)')
%%  Filtraremos una imagen con ruido aditivo con la media arm�nica

In = imnoise(I,'gaussian',0,0.001);
In_d = im2double(In);
I_fix5 = nlfilter(In_d,[3 3],@harmonic);

figure, subplot(1,3,1), imshow(I), title('Imagen Original');
subplot(1,3,2), imshow(In_d), title('Imagen + ruido Gaussiano');
subplot(1,3,3), imshow(I_fix5), title('Filtrada con Media Arm�nica');







%% Realizaremos un filtrado con media geom�trica a una imagen  con ruido gaussiano 

I_fix6 = nlfilter(In_d,[3 3],@geometric);

figure, subplot(1,3,1), imshow(I), title('Imagen Original');
subplot(1,3,2), imshow(In_d), title('Ruido Gaussiano');
subplot(1,3,3), imshow(I_fix6), title('Filtrada con media geom�trica');

%% Cargamos una imagen y le a�adimos ruido de sal y pimienta

I = imread('coins.png');
I_snp = imnoise(I,'salt & pepper');

% filtramos la imagen usando la funci�n medilt2
I_filt = medfilt2(I_snp,[3 3]);

figure, subplot(1,3,1), imshow(I), title('Imagen Original');
subplot(1,3,2), imshow(I_snp), title('Ruido de Sal y Pimienta');
subplot(1,3,3), imshow(I_filt), title('Imagen Filtrada');

%% Pero con ruido gaussiano:

I_g = imnoise(I,'gaussian');
I_filt2 = medfilt2(I_g,[3 3]);
figure
subplot(1,3,1), imshow(I), title('Imagen Original');
subplot(1,3,2), imshow(I_g), title('Ruido Gaussiano');
subplot(1,3,3), imshow(I_filt2), title('Filtrada')


%% Usaremos ordfilt2 para eliminar el ruido de sal usando un filtro de m�nimo

I_s = imread('eight_salt.tif');
I2 = ordfilt2(I_s, 1, ones(3,3));

figure, subplot(1,2,1), imshow(I_s), title('Ruido de Sal');
subplot(1,2,2), imshow(I2), title('Filtro de M�nimo');

% El primera par�metro de _ordfilt2_ es la imagen a filtrar, el segundo
% par�metro especifica el �ndice de el valor a usar despu�s de que los
% valores en la ventana hayan sido ordenados. El tercer par�metro es la
% ventana que vamos a utilizar y qu� vecinos (1) tendremos en cuenta y
% cuales no (0).

%% Y ahora usamos ordfilt2 para eliminar el ruido de pimienta usando el m�ximo

I_p = imread('eight_pepper.tif');
I3 = ordfilt2(I_p, 9, ones(3,3));

figure, subplot(1,2,1), imshow(I_p), title('Ruido de Pimienta');
subplot(1,2,2), imshow(I3), title('Filtro de M�ximo');

%% Filtramos una imagen con ruido gaussiano usando el punto medio

I = imread('coins.png');
I_g = imnoise(I,'gaussian',0,0.001);
midpoint = inline('0.5 * (max(x(:)) + min(x(:)))');
I_filt = nlfilter(I_g,[3 3],midpoint);

figure, subplot(1,2,1), imshow(I_g), title('Ruido Gaussiano');
subplot(1,2,2), imshow(I_filt), title('Filtro de Punto Medio');




%% Vamos a eliminar extremos al hacer el promedio

I = imread('cameraman.tif'); % Genera una imagen ruidosa con ruido gaussiano y de sal y pimienta
Id = im2double(I);
In = imnoise(Id,'salt & pepper');
In2 = imnoise(In,'gaussian'); 

%% Filtramos la imagen con un filtro de media alfa-recortado

I_filt = nlfilter(In2,[5 5],@atmean,6);
figure
subplot(1,3,1), imshow(I), title('Original Image');
subplot(1,3,2), imshow(In2), title('Ruido S&P y Gaussiano');
subplot(1,3,3), imshow(I_filt), title('Media Alfa-Recortada');
