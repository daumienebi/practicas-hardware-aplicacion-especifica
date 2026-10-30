% Práctica 1: Procesado básico de imágenes
clear; close all; clc;

%% Pedir la imagen (que exista y sea en escala de grises)
nombre = input('Nombre de la imagen: ', 's');
while ~exist(nombre, 'file') || size(imread(nombre), 3) ~= 1
    disp('El fichero no existe o la imagen es en color');
    nombre = input('Nombre de la imagen: ', 's');
end
A = im2double(imread(nombre));

%% Imagen e histograma
figure
subplot(1,2,1), imshow(A), title('Imagen original')
subplot(1,2,2), imhist(A), title('Histograma')

%% Brillo
brillo = input('Brillo (-255 a 255): ');
B = max(min(A + brillo/255, 1), 0);
figure
subplot(1,2,1), imshow(B), title('Imagen con brillo')
subplot(1,2,2), imhist(B), title('Histograma')

%% Ecualización
C = histeq(A);
figure
subplot(1,2,1), imshow(C), title('Imagen ecualizada')
subplot(1,2,2), imhist(C), title('Histograma')

%% Umbral
umbral = input('Umbral (0-255): ');
D = A;
D(A < umbral/255) = 0;
figure
subplot(1,2,1), imshow(A), title('Imagen original')
subplot(1,2,2), imshow(D), title('Imagen con umbral')

%% Suavizado
tam = input('Tamaño del filtro: ');
sigma = input('Sigma del filtro gaussiano: ');
Media = imfilter(A, fspecial('average', [tam tam]));
Gauss = imfilter(A, fspecial('gaussian', [tam tam], sigma));
figure
subplot(1,3,1), imshow(A), title('Original')
subplot(1,3,2), imshow(Media), title('Suavizado de media')
subplot(1,3,3), imshow(Gauss), title('Suavizado gaussiano')

%% Gradiente
Hx = fspecial('prewitt');
Hy = Hx';
Gx = imfilter(A, Hx);
Gy = imfilter(A, Hy);
G = 0.5 * (abs(Gx) + abs(Gy));
figure
subplot(1,3,1), imshow(G), title('Módulo')
subplot(1,3,2), imshow(Gx), title('Componente X')
subplot(1,3,3), imshow(Gy), title('Componente Y')

%% Realce con gradiente y laplaciano
L = imfilter(A, fspecial('laplacian'));
R1 = A + G;
R2 = A - L;
figure
subplot(1,3,1), imshow(A), title('Original')
subplot(1,3,2), imshow(R1), title('Realce con gradiente')
subplot(1,3,3), imshow(R2), title('Realce con laplaciano')

%% Botellas (im4.jpg)
I = im2double(imread('im4.jpg'));
Gx = imfilter(I, Hx);
Gy = imfilter(I, Hy);
G = 0.5 * (abs(Gx) + abs(Gy));

[filas, columnas] = size(I);
fila = G(ceil(filas/2), :);
figure
plot(fila), title('Gradiente de la fila central')

% Posiciones de los picos (valores altos del gradiente)
pos = find(fila > 0.4);
% Distancia entre picos consecutivos (se descartan los pegados)
dist = diff(pos);
dist = dist(dist > 3);

% La imagen son 90 cm: pasamos de píxeles a cm
ancho = max(dist) * 90 / columnas
separacion = min(dist) * 90 / columnas
