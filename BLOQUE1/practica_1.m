% Practica 1: Procesado basico de imagenes
% Hardware de Aplicacion Especifica

clear;
close all;
clc;

% Cargar carpeta de imagenes si existe
if exist('../imagenes_ejemplo', 'dir') == 7
    addpath('../imagenes_ejemplo');
elseif exist('imagenes_ejemplo', 'dir') == 7
    addpath('imagenes_ejemplo');
end
if exist('IMG', 'dir') == 7
    addpath('IMG');
end

%%
%% Apartado 1: Carga de imagen en escala de grises e histograma
%%
valida = false;
while ~valida
    nom = input('Nombre de la imagen (ej. im1.jpg) [Enter = im1.jpg]: ', 's');
    if isempty(nom)
        nom = 'im1.jpg';
    end
    
    if exist(nom, 'file')
        ruta = nom;
    elseif ~isempty(which(nom))
        ruta = which(nom);
    else
        disp('El archivo no existe, prueba de nuevo.');
        continue;
    end
    
    img = imread(ruta);
    [filas, cols, canales] = size(img);
    
    if canales > 1
        disp('Error: La imagen seleccionada es en color, debe ser en escala de grises.');
    else
        valida = true;
    end
end

figure;
subplot(1, 2, 1);
imshow(img);
title(['Original: ' nom]);

subplot(1, 2, 2);
imhist(img);
grid on;
title('Histograma original');
xlabel('Nivel de gris');
ylabel('Pixeles');

disp('Pulsa una tecla para continuar...');
pause;

%%
%% Apartado 2: Aumentar o disminuir brillo
%%
delta = input('Variacion de brillo [-255 a 255] (por defecto 40): ');
if isempty(delta)
    delta = 40;
end

% Evitar desbordamiento recortando entre 0 y 255
img_brillo = uint8(min(max(double(img) + delta, 0), 255));

figure;
subplot(1, 2, 1);
imshow(img_brillo);
title(['Brillo modificado: ' num2str(delta)]);

subplot(1, 2, 2);
imhist(img_brillo);
grid on;
title('Histograma modificado');
xlabel('Nivel de gris');
ylabel('Pixeles');

disp('Pulsa una tecla para continuar...');
pause;

%%
%% Apartado 3: Ecualizacion de la imagen
%%
img_eq = histeq(img);

figure;
subplot(1, 2, 1);
imshow(img_eq);
title('Imagen ecualizada');

subplot(1, 2, 2);
imhist(img_eq);
grid on;
title('Histograma ecualizado');
xlabel('Nivel de gris');
ylabel('Pixeles');

disp('Pulsa una tecla para continuar...');
pause;

%%
%% Apartado 4: Eliminar pixeles con intensidad menor a un umbral
%%
umbral = input('Umbral de intensidad [0 a 255] (por defecto 100): ');
if isempty(umbral)
    umbral = 100;
end

img_umbral = img;
img_umbral(img_umbral < umbral) = 0;

figure;
subplot(1, 2, 1);
imshow(img);
title('Original');

subplot(1, 2, 2);
imshow(img_umbral);
title(['Pixeles menores a ' num2str(umbral) ' eliminados']);

disp('Pulsa una tecla para continuar...');
pause;

%%
%% Apartado 5: Suavizado con filtro de media y gaussiano
%%
n_med = input('Tamano de filtro de media (por defecto 5): ');
if isempty(n_med)
    n_med = 5;
end
h_med = fspecial('average', [n_med n_med]);
img_med = imfilter(img, h_med, 'replicate');

sigma = input('Sigma para gaussiano (por defecto 2): ');
if isempty(sigma)
    sigma = 2;
end
n_gauss = 2 * ceil(2 * sigma) + 1;
h_gauss = fspecial('gaussian', [n_gauss n_gauss], sigma);
img_gauss = imfilter(img, h_gauss, 'replicate');

figure;
subplot(1, 3, 1);
imshow(img);
title('Original');

subplot(1, 3, 2);
imshow(img_med);
title(['Media ' num2str(n_med) 'x' num2str(n_med)]);

subplot(1, 3, 3);
imshow(img_gauss);
title(['Gaussiano sigma=' num2str(sigma)]);

disp('Pulsa una tecla para continuar...');
pause;

%%
%% Apartado 6: Gradiente de la imagen con operador Prewitt
%%
img_d = im2double(img);

hx = fspecial('prewitt');
hy = hx';

gx = imfilter(img_d, hx, 'replicate');
gy = imfilter(img_d, hy, 'replicate');
g_mod = abs(gx) + abs(gy);

figure;
subplot(1, 3, 1);
imshow(mat2gray(abs(gx)));
title('Gradiente horizontal Gx');

subplot(1, 3, 2);
imshow(mat2gray(abs(gy)));
title('Gradiente vertical Gy');

subplot(1, 3, 3);
imshow(mat2gray(g_mod));
title('Modulo gradiente G');

disp('Pulsa una tecla para continuar...');
pause;

%%
%% Apartado 7: Realzado con gradiente y laplaciano
%%
% Realzado con gradiente
img_realz_g = img_d + 0.5 * (gx + gy);
img_realz_g = min(max(img_realz_g, 0), 1);

% Realzado con laplaciano
h_lap = fspecial('laplacian', 0.2);
lap = imfilter(img_d, h_lap, 'replicate');
img_realz_l = img_d - lap;
img_realz_l = min(max(img_realz_l, 0), 1);

figure;
subplot(1, 3, 1);
imshow(img_d);
title('Original');

subplot(1, 3, 2);
imshow(img_realz_g);
title('Realzado gradiente');

subplot(1, 3, 3);
imshow(img_realz_l);
title('Realzado laplaciano');

disp('Pulsa una tecla para continuar...');
pause;

%%
%% Apartado 8: Analisis de cinta transportadora y botellas en im4.jpg
%%
if exist('im4.jpg', 'file')
    r4 = 'im4.jpg';
elseif ~isempty(which('im4.jpg'))
    r4 = which('im4.jpg');
else
    [f4, p4] = uigetfile('*.jpg;*.png', 'Selecciona im4.jpg');
    r4 = fullfile(p4, f4);
end

im4 = imread(r4);
if size(im4, 3) == 3
    im4 = rgb2gray(im4);
end
[m4, n4] = size(im4);
im4_d = im2double(im4);

gx4 = imfilter(im4_d, hx, 'replicate');
gy4 = imfilter(im4_d, hy, 'replicate');
g4 = abs(gx4) + abs(gy4);

fila_c = round(m4 / 2);
perfil = g4(fila_c, :);

figure;
subplot(2, 1, 1);
imshow(im4);
hold on;
plot([1 n4], [fila_c fila_c], 'r-', 'LineWidth', 2);
title(['im4.jpg con fila central ' num2str(fila_c)]);
hold off;

subplot(2, 1, 2);
plot(1:n4, perfil, 'b');
grid on;
title(['Perfil del gradiente en fila ' num2str(fila_c)]);
xlabel('Columna (pixeles)');
ylabel('Gradiente');
xlim([1 n4]);

% La cinta mide 90 cm en horizontal
escala = 90 / n4; % cm por pixel
[picos, locs] = findpeaks(perfil, 'MinPeakHeight', 0.25 * max(perfil), 'MinPeakDistance', round(n4 * 0.03));

hold on;
plot(locs, picos, 'ro');
legend('Gradiente', 'Bordes');
hold off;

if length(locs) >= 4
    anchos = [];
    seps = [];
    for i = 1:2:(length(locs) - 1)
        anchos = [anchos, (locs(i + 1) - locs(i)) * escala];
        if (i + 2) <= length(locs)
            seps = [seps, (locs(i + 2) - locs(i + 1)) * escala];
        end
    end
    fprintf('\nResultados im4.jpg:\n');
    fprintf('Ancho medio de botella: %.2f cm\n', mean(anchos));
    fprintf('Separacion media entre botellas: %.2f cm\n', mean(seps));
end

disp('Practica 1 terminada.');