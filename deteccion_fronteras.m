%
%% Detección de bordes y técnicas asociadas
%

%% Primero extraemos los bordes de la imagen usando el operador de Prewitt
I = imread('lenna.tif');
[I_prw1,t1] = edge(I,'prewitt');

% Añadimos ruido a la imagen y extrae sus bordes
I_noise = imnoise(I,'gaussian');
[I_prw2,t2] = edge(I_noise,'prewitt');


figure, subplot(2,2,1), imshow(I), title('Imagen Original');
subplot(2,2,2), imshow(I_prw1), title('Prewitt, umbral por defecto');
subplot(2,2,3), imshow(I_noise), title('Image con ruido');
subplot(2,2,4), imshow(I_prw2), title('Prewitt sobre ruido');


%% Pasemos ahora a analizar el operador de Sobel. 
[I_sob1,t1] = edge(I,'sobel');

% Pasamos a hacer erosiones. Su cálculo es un proceso similar a la dilatación. Usaremos los EEs que ya tenemos 
[I_sob2,t2] = edge(I_noise,'sobel');


figure, subplot(2,2,1), imshow(I), title('Imagen original');
subplot(2,2,2), imshow(I_sob1), title('Sobel, umbral por defecto');
subplot(2,2,3), imshow(I_noise), title('Imagen con ruido');
subplot(2,2,4), imshow(I_sob2), title('Sobel con ruido');

%% Operador Sobel en convolución horizontal y convolución vertial

[I_sob4,t,I_sobv,I_sobh] = edge(I,'sobel');
figure
subplot(2,2,1), imshow(I), title('Imagen Original');
subplot(2,2,2), imshow(I_sob4), title('Sobel completo');
subplot(2,2,3), imshow(abs(I_sobv),[]), title('Sobel Vertical');
subplot(2,2,4), imshow(abs(I_sobh),[]), title('Sobel Horizontal');

%% Thinning ( reducción de la anchura de los bordes detectados)
% Por defecto se aplica cundo utilizamos edege, aunque puede deshabilitarse.

I_sob3 = edge(I,'sobel','nothinning');
figure, subplot(1,2,1), imshow(I_sob1), title('Thinning');
subplot(1,2,2), imshow(I_sob3), title('Sin thinning');

%% Detector de Roberts. 

I_rob1 = edge(I,'roberts');
% Operador de Roberts en una imagen ruidosa
[I_rob2,t] = edge(I_noise,'roberts');

figure
subplot(2,2,1), imshow(I), title('Imagen Original');
subplot(2,2,2), imshow(I_rob1), title('Roberts, umbral por defecto');
subplot(2,2,3), imshow(I_noise), title('Imagen con ruido');
subplot(2,2,4), imshow(I_rob2), title('Roberts sobre ruidosa');

%% Uso de LoG para detectar bordes. Está también incluida  en la función edge.

I_log1 = edge(I,'log');

% Aplica ahora el detector LoG a una imagen ruidosa
[I_log2,t] = edge(I_noise,'log');

figure
subplot(2,2,1), imshow(I), title('Original Imagen Original');
subplot(2,2,2), imshow(I_log1), title('LoG, parámetros por defecto');
subplot(2,2,3), imshow(I_noise), title('Imagen con ruido');
subplot(2,2,4), imshow(I_log2), title('LoG sobre ruido');


%% Detector de Canny. 
I_can1 = edge(I,'canny');

% Aplica el filtro a la imagen ruidosa
[I_can2,t] = edge(I_noise,'canny', [], 2.5);


figure
subplot(2,2,1), imshow(I), title('Imagen Original');
subplot(2,2,2), imshow(I_log1), title('Canny, valores por defecto');
subplot(2,2,3), imshow(I_noise), title('Imagen con ruido');
subplot(2,2,4), imshow(I_can2), title('Canny sobre ruido');

%% Aplicamos el detector de canny spbre la imagen ruidosa con sigma=2

[I_can3,t] = edge(I_noise,'canny', [], 2);
figure
subplot(1,2,1), imshow(I_can2), title('Canny, parámetros por defecto');
subplot(1,2,2), imshow(I_can3), title('Canny, sigma = 2');


%%  Otra opción del detector de fronteras de Canny es la modificación del
%  umbral:

close all; clear all;


I = imread('mandrill.tif');
[I_can1,thresh] = edge(I,'canny');


% Y vemos el contenido de la variable thresh

% Utilizamos un umbral mayor que thresh
[I_can2,thresh] = edge(I, 'canny', 0.4);

% Utiliza un umbral menor que thresh
[I_can2,thresh] = edge(I, 'canny', 0.08);


figure
subplot(2,2,1), imshow(I), title('Imagen original');
subplot(2,2,2), imshow(I_can1), title('Canny, parámetros por defecto');
subplot(2,2,3), imshow(I_can2), title('Canny, umbral = 0.4');
subplot(2,2,4), imshow(I_can2), title('Canny, umbral = 0.08');


%% Uso del detector de Kirsch (no está incluido en IPT)
I = imread('mandrill.tif');
I = im2double(I);

% Creamos las máscaras de Kirsch y las almacénamos

k = zeros(3,3,8);
k(:,:,1) = [-3 -3 5; -3 0 5; -3 -3 5];
k(:,:,2) = [-3 5 5; -3 0 5; -3 -3 -3];
k(:,:,3) = [5 5 5; -3 0 -3; -3 -3 -3];
k(:,:,4) = [5 5 -3; 5 0 -3; -3 -3 -3];
k(:,:,5) = [5 -3 -3; 5 0 -3; 5 -3 -3];
k(:,:,6) = [-3 -3 -3; 5 0 -3; 5 5 -3];
k(:,:,7) = [-3 -3 -3; -3 0 -3; 5 5 5];
k(:,:,8) = [-3 -3 -3; -3 0 5; -3 5 5];

% Convolucionamos cada máscara con la imagen utilizando un for

I_k = zeros(size(I,1), size(I,2), 8);
for i = 1:8
I_k(:,:,i) = imfilter(I,k(:,:,i));
end;

% Y mostramos las imágenes resultantes
figure
for j = 1:8
subplot(2,4,j), imshow(abs(I_k(:,:,j)),[]), ...
title(['Máscara de Kirsch ', num2str(j)]);
end


%% Ahora vemos los valores máximos

I_kir = max(I_k,[],3);

% Y umbralizamos la imagen (con una transformación lineal que transforma la imagena una en niveles de grises y hace la transformación)
minimo= min(I_kir(:)); 
m = 255 / (max(I_kir(:)) - minimo);
I_kir_adj = uint8(m * (I_kir-minimo));

figure
subplot(1,2,1), imshow(I_kir,[]), title('Con los valores máximos');
subplot(1,2,2), imshow(I_kir_adj), title('Umbralizada');


%% Generamos las máscaras de Robinson

r = zeros(3,3,8);
r(:,:,1) = [-1 0 1; -2 0 2; -1 0 1];
r(:,:,2) = [0 1 2; -1 0 1; -2 -1 0];
r(:,:,3) = [1 2 1; 0 0 0; -1 -2 -1];
r(:,:,4) = [2 1 0; 1 0 -1; 0 -1 -2];
r(:,:,5) = [1 0 -1; 2 0 -2; 1 0 -1];
r(:,:,6) = [0 -1 -2; 1 0 -1; 2 1 0];
r(:,:,7) = [-1 -2 -1; 0 0 0; 1 2 1];
r(:,:,8) = [-2 -1 0; -1 0 1; 0 1 2];


%Y filtramos la imagen con las ocho máscaras de Robinson:

I_r = zeros(size(I,1), size(I,2), 8);
for i = 1:8
I_r(:,:,i) = imfilter(I,r(:,:,i));
end
figure
for j = 1:8
subplot(2,4,j), imshow(abs(I_r(:,:,j)),[]), ...
title(['Máscara de Robinson ', num2str(j)]);
end


%% El máximo de las ocho imágenes:
I_rob = max(I_r,[],3);
figure, imshow(I_kir,[]);


%
%% Ejemplo de detección de esquinas
%

close all; clear all;

% Lo haremos con una imagen de reales de un cuadrado blanco sobre fondo negro:
 
I=zeros(256);
I(80:170,80:170)=1;
imshow(I), title('Imagen original')

%% Ahora calculamos sus fronteras y las imágenes de derivadas horizontales y verticales:
 
[I_sob4,t,I_sobv,I_sobh] = edge(I,'sobel');
figure
subplot(2,2,1), imshow(I), title('Imagen original')
subplot(2,2,2), imshow(I_sob4), title('Sobel, Umbral automático')
subplot(2,2,3), imshow(abs(I_sobv),[]), title('Sobel, derivadas verticales')
subplot(2,2,4), imshow(abs(I_sobh),[]), title('Sobel, derivadas horizontales')


%%  Empecemos a calcular la matriz de Harris para detectar esquinas en cada píxel. 
% Calculamos para cada píxel el mínimo valor de la matriz de Harris para detectar esquinas
 
I_sobv2=I_sobv.*I_sobv;
I_sobh2=I_sobh.*I_sobh;
I_sobvh=I_sobv.*I_sobh;

%Filtramos cada una de estas tres imágenes con un filtro de unos de tamaño 3x3
I_sobv2m=imfilter(I_sobv2,ones(3));
I_sobh2m= imfilter(I_sobh2,ones(3));
I_sobvhm= imfilter(I_sobvh,ones(3));


% Y calculamos para cada píxel el mínimo valor de la matriz de Harris para detectar esquinas:
 
I_esq=zeros(size(I)); 
[M,N]=size(I); 
for i=1:M 
    for j=1:N esq= [I_sobv2m(i,j) I_sobvhm(i,j); 
        I_sobvhm(i,j) I_sobh2(i,j)]; 
        I_esq(i,j)=min(eig(esq)); 
    end
end


%% Y esta es la imagen con la esquinas detectadas

figure; imshow(I_esq,[]); impixelinfo
