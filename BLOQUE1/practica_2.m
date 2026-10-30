% Práctica 2: Procesado de imágenes en color
clear; close all; clc;

%% Pedir la imagen (que exista y sea en color)
nombre = input('Nombre de la imagen (im7.jpg a im9.jpg): ', 's');
while ~exist(nombre, 'file') || size(imread(nombre), 3) ~= 3
    disp('El fichero no existe o la imagen es en escala de grises');
    nombre = input('Nombre de la imagen: ', 's');
end
A = im2double(imread(nombre));

figure
imshow(A), title(nombre)

%% Canales RGB
R = A(:,:,1);
G = A(:,:,2);
B = A(:,:,3);
figure
subplot(2,3,1), imshow(R), title('Canal R')
subplot(2,3,2), imshow(G), title('Canal G')
subplot(2,3,3), imshow(B), title('Canal B')
subplot(2,3,4), imhist(R)
subplot(2,3,5), imhist(G)
subplot(2,3,6), imhist(B)

%% Canales HSV
HSV = rgb2hsv(A);
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);
figure
subplot(2,3,1), imshow(H), title('Canal H')
subplot(2,3,2), imshow(S), title('Canal S')
subplot(2,3,3), imshow(V), title('Canal V')
subplot(2,3,4), imhist(H)
subplot(2,3,5), imhist(S)
subplot(2,3,6), imhist(V)

%% Canales YCbCr
YCC = rgb2ycbcr(A);
Y = YCC(:,:,1);
Cb = YCC(:,:,2);
Cr = YCC(:,:,3);
figure
subplot(2,3,1), imshow(Y), title('Canal Y')
subplot(2,3,2), imshow(Cb), title('Canal Cb')
subplot(2,3,3), imshow(Cr), title('Canal Cr')
subplot(2,3,4), imhist(Y)
subplot(2,3,5), imhist(Cb)
subplot(2,3,6), imhist(Cr)

%% Dejar un solo color y el resto en gris
figure
imshow(A), title('Elige el color con impixel')
[x, y, P] = impixel;
hsv_p = rgb2hsv(P);
h = hsv_p(1);
% Máscara: píxeles con un tono parecido al elegido
d = abs(H - h);
M = min(d, 1 - d) < 0.02;   % el tono es circular (el rojo está en 0 y en 1)
% Donde no hay máscara la saturación es 0, es decir, gris
Res = hsv2rgb(cat(3, H, S .* M, V));
figure
subplot(1,2,1), imshow(A), title('Imagen original')
subplot(1,2,2), imshow(Res), title('Solo el color elegido')

%% Gris a color con un mapa de color
Gris = imread('im1.jpg');
mapa = input('Mapa de color (jet, hot, bone, ...): ', 's');
m = feval(mapa, 256);
Color = ind2rgb(Gris, m);
figure
subplot(1,2,1), imshow(Gris), title('Escala de grises')
subplot(1,2,2), imshow(Color), title('Con mapa de color')
colormap(gca, m), colorbar

%% Gris a color con HSV (tono y saturación de la rueda de color)
Rueda = im2double(imread('colorWheel.png'));
figure
imshow(Rueda), title('Elige tono y saturación')
[x, y, P] = impixel;
hsv_p = rgb2hsv(P);
Gd = im2double(Gris);
Hh = ones(size(Gd)) * hsv_p(1);
Ss = ones(size(Gd)) * hsv_p(2);
% El gris hace de intensidad (V)
Color2 = hsv2rgb(cat(3, Hh, Ss, Gd));
figure
subplot(1,2,1), imshow(Gris), title('Escala de grises')
subplot(1,2,2), imshow(Color2), title('Color con HSV')

%% Diámetro de la moneda (im10.jpg, imagen de 4800 mm2)
M10 = im2double(imread('im10.jpg'));
Gm = rgb2gray(M10);
% Todo lo que no es blanco es moneda
L = (Gm < 0.9);
pixeles_moneda = sum(sum(L));
[filas, columnas, z] = size(M10);

% Regla de tres para el área (entre 2 por las dos caras)
area = pixeles_moneda / (filas * columnas) * 4800 / 2;
diametro = 2 * sqrt(area / pi)
