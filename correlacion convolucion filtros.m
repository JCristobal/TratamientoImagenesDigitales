%
%% Convolución y Correlación
%

a = [0 0 0 1 0 0 0];
f = [1 2 3 4 5];

%Convolución
g = imfilter(a,f,'full','conv')

% correlación
h = imfilter(a,f,'full','corr')

%  correlación entre dos matrices.
x = [140 108 94;89 99 125;121 134 221]
y = [-1 0 1;-2 0 2;-1 0 1]
z = imfilter(x,y,'corr')

% convolución entre dos matrices
z2 = imfilter(x,y,'conv')

%
%% Uso de filtros
%

I = imread('cameraman.tif');

fn = fspecial('average');
I_new = imfilter(I,fn);

fn_gau = fspecial('gaussian',9,1.5);
I_new3 = imfilter(I,fn_gau);

figure, subplot(2,2,1), imshow(I), title('Imagen Original');
subplot(2,2,2), imshow(I_new), title('Image con filtro average');
subplot(2,2,3), bar3(fn_gau,'b'), title('Filtro Gaussiano como gráfico 3D');
subplot(2,2,4), imshow(I_new3), title('Filtro Gaussiano');


%% Uso de imfilter

% Aplicamos el filtro laplaciano
I = imread('moon.tif');
Id = im2double(I);

f = fspecial('laplacian',0);
I_filt = imfilter(Id,f);
I_sharp = imsubtract(Id,I_filt);

figure, subplot(2,2,1), imshow(Id), title('Imagen Original');
subplot(2,2,2), imshow(I_filt), title('Laplaciano del Original');
subplot(2,2,3), imshow(I_filt,[]), title('Laplaciano Escalado');
subplot(2,2,4), imshow(I_sharp), title('Imagen Realzada');

%% máscara laplaciana en un solo paso

f2 = [0 -1 0; -1 5 -1; 0 -1 0];
I_sharp2 = imfilter(Id,f2);
figure, subplot(1,2,1), imshow(Id), title('Imagen Original');
subplot(1,2,2), imshow(I_sharp2), title('Laplaciano Compuesto');


