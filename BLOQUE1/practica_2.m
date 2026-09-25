% Practica 2: Procesado de imagenes en color
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

%% Apartado 1: Carga y comprobacion de imagen en color
valida = false;
while ~valida
    nom = input('Nombre de la imagen en color (ej. im7.jpg) [Enter = im7.jpg]: ', 's');
    if isempty(nom)
        nom = 'im7.jpg';
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
    
    if canales ~= 3
        disp('Error: La imagen no es en color, debe tener 3 canales.');
    else
        valida = true;
    end
end

figure;
imshow(img);
title(['Imagen en color: ' nom]);

disp('Pulsa una tecla para continuar...');
pause;

%% Apartado 2: Mostrar canales R, G, B y sus histogramas
canal_r = img(:, :, 1);
canal_g = img(:, :, 2);
canal_b = img(:, :, 3);

figure;
subplot(2, 3, 1); imshow(canal_r); title('Canal R');
subplot(2, 3, 2); imshow(canal_g); title('Canal G');
subplot(2, 3, 3); imshow(canal_b); title('Canal B');

subplot(2, 3, 4); imhist(canal_r); grid on; title('Histograma R'); xlabel('Nivel'); ylabel('Pixeles');
subplot(2, 3, 5); imhist(canal_g); grid on; title('Histograma G'); xlabel('Nivel'); ylabel('Pixeles');
subplot(2, 3, 6); imhist(canal_b); grid on; title('Histograma B'); xlabel('Nivel'); ylabel('Pixeles');

disp('Pulsa una tecla para continuar...');
pause;

%% Apartado 3: Espacio HSV e histogramas
img_d = im2double(img);
img_hsv = rgb2hsv(img_d);

canal_h = img_hsv(:, :, 1);
canal_s = img_hsv(:, :, 2);
canal_v = img_hsv(:, :, 3);

figure;
subplot(2, 3, 1); imshow(canal_h); title('Canal H (Hue)');
subplot(2, 3, 2); imshow(canal_s); title('Canal S (Saturation)');
subplot(2, 3, 3); imshow(canal_v); title('Canal V (Value)');

subplot(2, 3, 4); imhist(canal_h); grid on; title('Histograma H');
subplot(2, 3, 5); imhist(canal_s); grid on; title('Histograma S');
subplot(2, 3, 6); imhist(canal_v); grid on; title('Histograma V');

disp('Pulsa una tecla para continuar...');
pause;

%% Apartado 4: Espacio YCbCr e histogramas
img_ycbcr = rgb2ycbcr(img);

canal_y  = img_ycbcr(:, :, 1);
canal_cb = img_ycbcr(:, :, 2);
canal_cr = img_ycbcr(:, :, 3);

figure;
subplot(2, 3, 1); imshow(canal_y);  title('Canal Y');
subplot(2, 3, 2); imshow(canal_cb); title('Canal Cb');
subplot(2, 3, 3); imshow(canal_cr); title('Canal Cr');

subplot(2, 3, 4); imhist(canal_y);  grid on; title('Histograma Y');
subplot(2, 3, 5); imhist(canal_cb); grid on; title('Histograma Cb');
subplot(2, 3, 6); imhist(canal_cr); grid on; title('Histograma Cr');

disp('Pulsa una tecla para continuar...');
pause;

%% Apartado 5: Seleccionar color con impixel y dejar el resto en gris
disp('Selecciona un color en la imagen haciendo clic y pulsa Enter:');
[cx, cy, p] = impixel(img);

if isempty(p)
    % Si no se selecciona nada, tomar el centro
    color_ref = double(squeeze(img(round(filas / 2), round(cols / 2), :)))';
else
    color_ref = double(p(1, :));
end
fprintf('Color de referencia RGB: [%d, %d, %d]\n', round(color_ref(1)), round(color_ref(2)), round(color_ref(3)));

tol = input('Tolerancia para el color [10 a 150] (por defecto 60): ');
if isempty(tol)
    tol = 60;
end

% Distancia euclidea en RGB
dist = sqrt((double(canal_r) - color_ref(1)).^2 + ...
            (double(canal_g) - color_ref(2)).^2 + ...
            (double(canal_b) - color_ref(3)).^2);

mask = (dist <= tol);

% Fondo en escala de grises
img_gris = rgb2gray(img);
img_salida = cat(3, img_gris, img_gris, img_gris);

for c = 1:3
    orig_c = img(:, :, c);
    dest_c = img_salida(:, :, c);
    dest_c(mask) = orig_c(mask);
    img_salida(:, :, c) = dest_c;
end

figure;
subplot(1, 3, 1); imshow(img); title('Original');
subplot(1, 3, 2); imshow(mask); title(['Mascara (tol = ' num2str(tol) ')']);
subplot(1, 3, 3); imshow(img_salida); title('Color aislado');

disp('Pulsa una tecla para continuar...');
pause;

%% Apartado 6: Cargar imagen en escala de grises
nom_gris = input('Nombre de imagen en escala de grises [Enter = im1.jpg]: ', 's');
if isempty(nom_gris)
    nom_gris = 'im1.jpg';
end

if exist(nom_gris, 'file')
    r_gris = nom_gris;
elseif ~isempty(which(nom_gris))
    r_gris = which(nom_gris);
else
    r_gris = '';
end

if isempty(r_gris)
    img_g2 = rgb2gray(img);
else
    img_g2 = imread(r_gris);
    if size(img_g2, 3) == 3
        img_g2 = rgb2gray(img_g2);
    end
end

figure;
imshow(img_g2);
title(['Escala de grises: ' nom_gris]);

disp('Pulsa una tecla para continuar...');
pause;

%% Apartado 7: Aplicar mapa de color (colormap)
disp('Elige un mapa de color: 1. jet | 2. hot | 3. cool | 4. copper | 5. pink | 6. hsv');
opc_map = input('Opcion [1 a 6] (por defecto 1): ');
if isempty(opc_map) || opc_map < 1 || opc_map > 6
    opc_map = 1;
end

mapas = {'jet', 'hot', 'cool', 'copper', 'pink', 'hsv'};
mapa_sel = mapas{opc_map};
mapa_mat = feval(mapa_sel, 256);

figure;
subplot(1, 2, 1);
imshow(img_g2);
title('Escala de grises');

subplot(1, 2, 2);
imshow(img_g2);
colormap(mapa_mat);
colorbar;
title(['Colormap: ' mapa_sel]);

disp('Pulsa una tecla para continuar...');
pause;

%% Apartado 8: Colorear en HSV con colorWheel.png
if exist('colorWheel.png', 'file')
    r_rueda = 'colorWheel.png';
elseif ~isempty(which('colorWheel.png'))
    r_rueda = which('colorWheel.png');
else
    r_rueda = '';
end

if isempty(r_rueda)
    % Generar rueda si no existe el fichero
    tam_r = 300;
    [xw, yw] = meshgrid(linspace(-1, 1, tam_r), linspace(-1, 1, tam_r));
    rw = sqrt(xw.^2 + yw.^2);
    th = atan2(yw, xw);
    th(th < 0) = th(th < 0) + 2 * pi;
    hw = th / (2 * pi);
    sw = min(rw, 1);
    vw = ones(tam_r, tam_r);
    sw(rw > 1) = 0;
    rueda = hsv2rgb(cat(3, hw, sw, vw));
else
    rueda = imread(r_rueda);
end

disp('Selecciona un tono en la rueda de color haciendo clic y pulsa Enter:');
[rx, ry, pw] = impixel(rueda);

if isempty(pw)
    h_sel = 0.55;
    s_sel = 0.85;
else
    pix_rgb = double(pw(1, :)) / 255;
    pix_hsv = rgb2hsv(reshape(pix_rgb, 1, 1, 3));
    h_sel = pix_hsv(1, 1, 1);
    s_sel = pix_hsv(1, 1, 2);
end
fprintf('Tono H: %.3f, Saturacion S: %.3f\n', h_sel, s_sel);

[fg, cg] = size(img_g2);
v_ch = im2double(img_g2);
h_ch = h_sel * ones(fg, cg);
s_ch = s_sel * ones(fg, cg);

img_tintada = hsv2rgb(cat(3, h_ch, s_ch, v_ch));

figure;
subplot(1, 3, 1);
imshow(rueda);
hold on;
if ~isempty(rx)
    plot(rx(1), ry(1), 'kx', 'MarkerSize', 12, 'LineWidth', 2);
end
title('Rueda de color');
hold off;

subplot(1, 3, 2);
imshow(img_g2);
title('Grises original');

subplot(1, 3, 3);
imshow(img_tintada);
title(['Tintada H=' num2str(h_sel, 2) ' S=' num2str(s_sel, 2)]);

disp('Pulsa una tecla para continuar...');
pause;

%% Apartado 9: Diametro de la moneda en im10.jpg
if exist('im10.jpg', 'file')
    r10 = 'im10.jpg';
elseif ~isempty(which('im10.jpg'))
    r10 = which('im10.jpg');
else
    [f10, p10] = uigetfile('*.jpg;*.png', 'Selecciona im10.jpg');
    r10 = fullfile(p10, f10);
end

im10 = imread(r10);
if size(im10, 3) == 3
    im10_g = rgb2gray(im10);
else
    im10_g = im10;
end
[m10, n10] = size(im10_g);

% La imagen representa una superficie aproximada de 4800 mm2
sup_total = 4800.0;
pix_total = m10 * n10;
area_por_pix = sup_total / pix_total;

% Binarizacion con Otsu
u_otsu = graythresh(im10_g);
bw = imbinarize(im10_g, u_otsu);

% Si las esquinas son blancas, invertir
if bw(1, 1) == 1 && bw(1, end) == 1
    bw = ~bw;
end

bw = imfill(bw, 'holes');
[etiquetas, ~] = bwlabel(bw);
props = regionprops(etiquetas, 'Area', 'BoundingBox', 'Centroid');

if ~isempty(props)
    [~, idx] = max([props.Area]);
    moneda = props(idx);
    
    area_mm2 = moneda.Area * area_por_pix;
    diam_mm = 2 * sqrt(area_mm2 / pi);
    
    fprintf('\nResultados im10.jpg:\n');
    fprintf('Resolucion: %d x %d (%d pixeles)\n', m10, n10, pix_total);
    fprintf('Area de la moneda: %.2f mm2\n', area_mm2);
    fprintf('Diametro estimado: %.2f mm\n', diam_mm);
    
    figure;
    subplot(1, 2, 1);
    imshow(im10);
    hold on;
    rectangle('Position', moneda.BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
    plot(moneda.Centroid(1), moneda.Centroid(2), 'y+', 'LineWidth', 2);
    title(['Diametro: ' num2str(diam_mm, '%.2f') ' mm']);
    hold off;
    
    subplot(1, 2, 2);
    imshow(bw);
    title('Mascara segmentada');
end

disp('Practica 2 terminada.');
