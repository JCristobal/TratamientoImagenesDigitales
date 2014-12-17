%% Operaciones aritméticas y lógicas básicas
%
%
%% Introduce la imagen con la que quieres trabajar

imagen=imread('pout.tif');

%% Abrimos la aplicación de visor de imagen

imtool(imagen)


%% Sección para mezclar 2 imágenes

close all; clear all;

Ia = imread('rice.png');
Ib = imread('cameraman.tif');
Ic = imadd(Ia, Ib);
figure
imshow(Ic);


%% Sección para ver las diferencias entre 2 imágenes

close all; clear all;

I = imread('cameraman.tif');
J = imread('cameraman2.jpeg');

diffim = imsubtract(I,J);
diffim2 = imabsdiff(I,J);

subplot(2,2,1), imshow(diffim), title('Imagen Diferencia');
subplot(2,2,2), imshow(diffim2), title('Imagen Diferencia en Valor Absoluto');
subplot(2,2,3), imshow(diffim,[]), title('Diferencia escalada');
subplot(2,2,4), imshow(diffim2,[]), title('Diferencia en valor absoluto escalada');

%% Eliminar un "fondo" de una imagen

close all; clear all;

notext = imread('gradient.tif');
text = imread('gradient_with_text.tif');

fixed = imdivide(text,notext); % Divide la imagen por el fondo para librarte de él
figure
subplot(1,3,1), imshow(text), title('Imagen Original');
subplot(1,3,2), imshow(notext), title('Fondo solamente');
subplot(1,3,3), imshow(fixed,[]), title('División');


%% Selección de máscaras, usando roipoly

close all; clear all;

I = imread('pout.tif');
mascara = roipoly(I)

mascara2 = im2uint8(mascara);

solomascara = bitand(I,mascara2);

figure
subplot(1,2,1), imshow(I), title('Imagen Original');
subplot(1,2,2), imshow(solomascara), title('Mascara seleccionada');

%% Oscurece una sección

close all; clear all;

I = imread('lindsay.tif');

I_adj = imdivide(I,1.5); %oscurecemos la imagen

mascara = im2uint8(roipoly(I));

mascara_cmp = bitcmp(mascara); %máscara complementaria
roi = bitor(I_adj,mascara_cmp); %roi
not_roi = bitor(I,mascara); %non_roi
new_img = bitand(roi,not_roi); %genera la imagen nueva

imshow(new_img) %muestra la nueva imagen

%% Guardar una imagen, con el nombre imagendematlab

imwrite(imagen, 'imagendematlab.jpg');
