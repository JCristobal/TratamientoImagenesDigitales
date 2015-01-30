%% Operaciones geométricas: cortar, cambio y rotación y transformaciones espaciales y registrado

%   Aprenderemos a cortar, cambiar el tamaño y rotar imágenes digitales


imagen=imread('cameraman.tif');

%% Primero cortaremos una imagen usando la pestaña cropp de imtool y la guardaremos con cropped.png
imtool(imagen)


recortada = imread('cropped.png');

% la podemos mostrar:
% imshow(recortada)


%% Para recortar podemos usar la función imcrop
%Para ello anotamos las variables que usará: [xmin ymin anchura altura]
imagen=imread('cameraman.tif');

x1 = 179; x2 = 219; y1 = 80; y2 = 181;

xmin = x1; ymin = y1; anchura = x2-x1; altura = y2-y1;

imagenrecortada = imcrop(imagen, [xmin ymin anchura altura]);
imshow(imagenrecortada)


%% Agranda una imagen
close all; clear all

imagen=imread('cameraman.tif');

I_big2 = imresize(imagen,3,'nearest');
I_big3 = imresize(imagen,3,'bilinear');
figure, imshow(I_big2), title('x3 con vecino más próximo');
figure, imshow(I_big3), title('x3 con interpolación bilineal');

%% Reduce una imagen (con factor 0.5 en ambas direcciones)
close all; clear all

imagen=imread('cameraman.tif');

I_sm2 = imresize(imagen,0.5,'nearest');
I_sm3 = imresize(imagen,0.5,'bilinear');
I_sm4 = imresize(imagen,0.5,'bicubic');
figure, subplot(1,3,1), imshow(I_sm2), title('Vecino más próximo');
subplot(1,3,2), imshow(I_sm3), title('Bilineal');
subplot(1,3,3), imshow(I_sm4), title('Bicubica');



%% Aquí rotaremos la imagen de arriba a abajo y otra de izquierda a derecha

close all; clear all

I =  imread('cameraman.tif');
J = flipud(I);
K = fliplr(I);
subplot(1,3,1), imshow(I), title('Imagen Original')
subplot(1,3,2), imshow(J), title('Arriba-Abajo')
subplot(1,3,3), imshow(K), title('Izquierda-derecha')



%% Y ahora rotaremos la imagen según la variable gradros

close all; clear all

grados=35;
I = imread('eight.tif');

I_rot = imrotate(I,grados,'bilinear');
I_rot_cortada = imrotate(I,grados,'bilinear','crop');


figure
subplot(1,3,1), imshow(I), title('Imagen Original');
subplot(1,3,2), imshow(I_rot), title('Rotada');
subplot(1,3,3), imshow(I_rot_cortada), title('Rotada y recortada');



%% Guardar una imagen, con el nombre imagendematlab

imwrite(imagen, 'imagendematlab.jpg');

%%
%
% Transformaciones espaciales y registrado
%


%% realizaremos una transformación afín que cambia el tamaño de la imagen por un factor [sx , sy].
close all; clear all

imagen = imread('cameraman.tif');
sx = 2; sy = 2;
T = maketform('affine',[sx 0 0; 0 sy 0; 0 0 1]');

I2 = imtransform(imagen,T);

imshow(I2), title('Usando transformación afín')




%% Usaremos cpslect, herramienta de selección del punto de control

close all; clear all

base = imread('klcc_a.png');
unregistered = imread('klcc_b.png');

cpselect(unregistered, base);


%% Podemos ver los puntos guardados:
%movingPoints
%fixedPoints

%% Usamos cpcorr para ajustar los puntos de control seleccionados

input_points_adj = cpcorr(movingPoints,fixedPoints,...
    unregistered(:,:,1),base(:,:,1))
                      
%% Ahora necesitamos especificar el tipo de transformación a aplicar que queremos aplicar a la imagen no registrada basada en el tipo de
% En este caso usamos una combinación de traslación, rotación y escalado: 'nonreflective similarity' como tipo de transformación



%% estimamos los parámetros de la transformación  usando "cp2tform"

mytform1 = cp2tform(fixedPoints,movingPoints,'nonreflective similarity');
info = imfinfo('klcc_a.png');
registered = imtransform(unregistered,mytform1,...
               'XData',[1 info.Width], 'YData',[1 info.Height]);
           
%% Muestra la imagen registrada sobre la imagen base.

figure, imshow(registered);
hold on
h = imshow(base);
h2=set(h, 'AlphaData', 0.6)


