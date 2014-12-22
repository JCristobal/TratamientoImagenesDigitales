%
%% Transformaciones a vieles de grises
%
%


%% Introduce la imagen con la que quieres trabajar

imagen=imread('moon.tif');

%% Le aplicamos una transformaci�n negativa

y = uint8(255:-1:0); negativa = intlut(imagen,y); 
figure, subplot(1,3,1), plot(y), title('Funci�n de Transformaci�n negativa'), xlim([0 255]), ylim([0 255]); 
subplot(1,3,2), imshow(imagen), title('Imagen Original'); 
subplot(1,3,3), imshow(negativa), title('Imagen Negativa');

%% Ahora una transformaci�n logar�tmica
clear all; close all;

imagen = imread('pout.tif');

x = 0:255; 
c = 255 / log(256); 
y = c * log(x + 1); 

I_log=intlut(imagen,uint8(y)); 

figure, subplot(2,2,1), plot(y), title('Funci�n de transformaci�n logar�tmica'), axis tight, axis square;
subplot(2,2,2), imshow(imagen), title('Imagen Original'); 
subplot(2,2,3), imshow(I_log), title('Imagen Ajustada');



%% Ahora una transformaci�n inversa logar�tmica

y = exp(x/c) - 1; 
I_invlog = intlut(I_log, uint8(y)); 

figure, subplot(2,1,1), plot(y), title('Funci�n Logaritmo-Inversa'); 
subplot(2,1,2), imshow(I_invlog), title('Imagen Ajustada');


%% Transformaci�n ra�z n-�sima

x = 0:255; 
n = 2; c = 255 / (255 ^ n); 
root = nthroot((x/c), n); 

imagen = imread('pout.tif'); 
I_root=intlut(imagen, uint8(root));

figure, subplot(2,2,1), plot(root), title('Funci�n Ra�z Cuadrada'), axis tight, axis square
subplot(2,2,2), imshow(imagen), title('Imagen Original'); 
subplot(2,2,[3 4]), imshow(I_root), title('Imagen ra�z n-�sima');

%% Transformaci�n n-�sima.


power = c * (x .^ n); 

figure, subplot(1,2,1), plot(power), title('Transformaci�n Cuadr�tica'); axis tight, axis square
I_power = intlut(I_root,uint8(power)); subplot(1,2,2), imshow(I_power), title('Imagen Ajustada');

%% Creamos una funci�n de transformaci�n propia

I = imread('cameraman.tif'); 

y(1:175) = 0:174; 
y(176:200) = 255;
y(201:256) = 200:255;

I2 = intlut(I,uint8(y));

figure, subplot(1,3,1), imshow(I), title('Imagen Original');
subplot(1,3,2), plot(y), axis tight, axis square
subplot(1,3,3), imshow(I2), title('Imagen Ajustada');

%
%
%% Histogramas de una imagen
%
%
I = imread('circuit.tif');

c = imhist(I,32);
c_norm = c / numel(I);

figure,  subplot(2,3,1), imshow(I), title('Imagen')
subplot(2,3,2), imhist(I,256), axis  tight, title('Histograma') 

subplot(2,3,3), bar_1 = bar(c), title('Histograma de 32 bits normalizado con los ejes ajustados');
set(gca, 'XTick', [0:8:32], 'YTick', [linspace(0,7000,8) max(c)]);

subplot(2,3,4), plot(c_norm), axis  tight, title('Histograma con plot') 

subplot(2,3,5), stem(c_norm), axis  tight, title('Histograma con stem') 


%% Ecualizamos un histograma

I = imread('pout.tif');

I_eq = histeq(I,256);

figure, subplot(2,2,1), imshow(I), title('Imagen Original')
subplot(2,2,2), imhist(I), title('Histograma Original')
subplot(2,2,3), imshow(I_eq), title('Imagen Ecualizada')
subplot(2,2,4), imhist(I_eq), title('Histograma Ecualizado')

%% Mostramos la funci�n de distribuci�n de la operaci�n anterior

I_hist = imhist(I); tf = cumsum(I_hist); tf_norm = tf / max(tf);
figure, plot(tf_norm), axis tight

%% Histogramas deseados

img1 = imread('pout.tif'); 


img1_eq = histeq(img1); 
m1 = ones(1,256)*0.5; 

m2 = linspace(0,1,256); 
img2 = histeq(img1,m2); 

figure, subplot(3,3,1), imshow(img1), title('Imagen Original')
subplot(3,3,2), imhist(img1), title('Histograma Original')
subplot(3,3,4), imshow(img1_eq), title('Imagen Ecualizada') 
subplot(3,3,5), imhist(img1_eq), title('Histograma Ecualizado') 
subplot(3,3,6), plot(m1), title('Forma del Histograma Deseado'), ylim([0 1]), xlim([1 256])
subplot(3,3,7), imshow(img2), title('Imagen de segundo histograma') 
subplot(3,3,8), imhist(img2), title('Histograma acoplado') 
subplot(3,3,9), plot(m2), title('Forma del Histograma Deseado'), ylim([0 1]), xlim([1 256])


%
%% Modificar histogramas
%


I = imread('pout.tif');
I = im2double(I);

I_stretch = imadjust(I,stretchlim(I),[]);
I_shrink = imadjust(I,stretchlim(I),[0.7 1]);

figure, subplot(3,2,1), imshow(I), title('Imagen original')
subplot(3,2,2), imhist(I), axis tight, title('Histograma Original')
subplot(3,2,3), imshow(I_stretch), title('Imagen Estirada')
subplot(3,2,4), imhist(I_stretch), axis tight, title('Histograma Estirado')
subplot(3,2,5), imshow(I_shrink), title('Imagen estrechada')
subplot(3,2,6), imhist(I_shrink), axis tight, title('Histograma estrechada')

%% Estrecha el histograma con un valor gamma=2.

I = imread('pout.tif');
I = im2double(I);

I_shrink = imadjust(I,stretchlim(I),[0.7 1],2);

figure, subplot(2,2,1), imshow(I), title('Imagen original')
subplot(2,2,2), imhist(I), axis tight, title('Histograma Original')
subplot(2,2,3), imshow(I_shrink), title('Imagen estrechada')
subplot(2,2,4), imhist(I_shrink), axis tight, title('Histograma estrechada con gamma 2')

%% Guardar una imagen, con el nombre imagendematlab

imwrite(imagen, 'imagendematlab.jpg');

