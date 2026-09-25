%% =========================================================================
% PRÁCTICA 2: PROCESADO DE IMÁGENES EN COLOR
% Asignatura: Hardware de Aplicación Específica (HAE)
% Grado en Ingeniería Informática - Universidad de Burgos
% =========================================================================

clear;
close all;
clc;

% Asegurar que la carpeta IMG esté en el path si existe
if exist('IMG', 'dir')
    addpath('IMG');
end

fprintf('=====================================================\n');
fprintf('     PRÁCTICA 2: PROCESADO DE IMÁGENES EN COLOR      \n');
fprintf('=====================================================\n\n');

%% 1. SELECCIÓN Y CARGA DE LA IMAGEN EN COLOR
% Se debe pedir el nombre de una imagen y pedir una nueva si no existe.
% Si la imagen está en escala de grises, debe mostrar un error y pedir otra.
% Imágenes recomendadas: im7.jpg a im9.jpg.

imagenValida = false;
while ~imagenValida
    nombreImg = input('Introduce el nombre de una imagen en color (ej. im7.jpg) [Enter para buscar]: ', 's');
    
    if isempty(nombreImg)
        [fichero, ruta] = uigetfile({'*.jpg;*.png;*.tif;*.bmp', 'Imágenes en color (*.jpg, *.png, *.tif, *.bmp)'}, ...
                                    'Selecciona una imagen en color');
        if isequal(fichero, 0)
            fprintf('No se seleccionó ningún archivo. Inténtalo de nuevo.\n');
            continue;
        end
        rutaCompleta = fullfile(ruta, fichero);
        nombreImg = fichero;
    else
        if exist(nombreImg, 'file')
            rutaCompleta = nombreImg;
        elseif exist(fullfile('IMG', nombreImg), 'file')
            rutaCompleta = fullfile('IMG', nombreImg);
        else
            fprintf('Error: El archivo "%s" no existe. Inténtalo de nuevo.\n', nombreImg);
            continue;
        end
    end
    
    imgColor = imread(rutaCompleta);
    [alto, ancho, canales] = size(imgColor);
    
    if canales ~= 3
        fprintf('Error: La imagen "%s" NO está en color (%d canal/es detectado/s).\n', nombreImg, canales);
        fprintf('Por favor, selecciona una imagen en color (ej. im7.jpg a im9.jpg).\n\n');
    else
        imagenValida = true;
        fprintf('-> Imagen en color "%s" cargada con éxito (%dx%d píxeles, 3 canales).\n\n', nombreImg, alto, ancho);
    end
end

% Mostrar imagen cargada en ventana con el nombre del archivo
figure('Name', ['Práctica 2 - Imagen en Color: ' nombreImg], 'NumberTitle', 'off');
imshow(imgColor);
title(['Imagen Original: ' nombreImg], 'Interpreter', 'none');

%% 2. MOSTRAR CADA CANAL R, G, B JUNTO CON SU HISTOGRAMA
canalR = imgColor(:, :, 1);
canalG = imgColor(:, :, 2);
canalB = imgColor(:, :, 3);

figure('Name', 'Práctica 2 - Canales RGB e Histogramas', 'NumberTitle', 'off');
subplot(2, 3, 1); imshow(canalR); title('Canal Rojo (R)');
subplot(2, 3, 2); imshow(canalG); title('Canal Verde (G)');
subplot(2, 3, 3); imshow(canalB); title('Canal Azul (B)');

subplot(2, 3, 4); imhist(canalR); grid on;
title('Histograma Canal R'); xlabel('Intensidad [0 - 255]'); ylabel('Píxeles');
subplot(2, 3, 5); imhist(canalG); grid on;
title('Histograma Canal G'); xlabel('Intensidad [0 - 255]'); ylabel('Píxeles');
subplot(2, 3, 6); imhist(canalB); grid on;
title('Histograma Canal B'); xlabel('Intensidad [0 - 255]'); ylabel('Píxeles');

%% 3. CONVERSIÓN AL ESPACIO HSV Y SUS HISTOGRAMAS
% HSV requiere valores en formato double en el rango [0, 1]
imgColor_dbl = im2double(imgColor);
imgHSV = rgb2hsv(imgColor_dbl);

canalH = imgHSV(:, :, 1); % Tono (Hue) [0, 1]
canalS = imgHSV(:, :, 2); % Saturación [0, 1]
canalV = imgHSV(:, :, 3); % Valor / Brillo [0, 1]

figure('Name', 'Práctica 2 - Espacio HSV e Histogramas', 'NumberTitle', 'off');
subplot(2, 3, 1); imshow(canalH); title('Canal H (Tono / Hue)');
subplot(2, 3, 2); imshow(canalS); title('Canal S (Saturación)');
subplot(2, 3, 3); imshow(canalV); title('Canal V (Brillo / Value)');

subplot(2, 3, 4); imhist(canalH); grid on;
title('Histograma H (Tono)'); xlabel('Valor [0, 1]'); ylabel('Píxeles');
subplot(2, 3, 5); imhist(canalS); grid on;
title('Histograma S (Saturación)'); xlabel('Valor [0, 1]'); ylabel('Píxeles');
subplot(2, 3, 6); imhist(canalV); grid on;
title('Histograma V (Brillo)'); xlabel('Valor [0, 1]'); ylabel('Píxeles');

%% 4. CONVERSIÓN AL ESPACIO YCbCr Y SUS HISTOGRAMAS
imgYCbCr = rgb2ycbcr(imgColor);

canalY  = imgYCbCr(:, :, 1); % Luminancia
canalCb = imgYCbCr(:, :, 2); % Crominancia azul
canalCr = imgYCbCr(:, :, 3); % Crominancia roja

figure('Name', 'Práctica 2 - Espacio YCbCr e Histogramas', 'NumberTitle', 'off');
subplot(2, 3, 1); imshow(canalY);  title('Canal Y (Luminancia)');
subplot(2, 3, 2); imshow(canalCb); title('Canal Cb (Crominancia Azul)');
subplot(2, 3, 3); imshow(canalCr); title('Canal Cr (Crominancia Roja)');

subplot(2, 3, 4); imhist(canalY);  grid on;
title('Histograma Y');  xlabel('Nivel [0 - 255]'); ylabel('Píxeles');
subplot(2, 3, 5); imhist(canalCb); grid on;
title('Histograma Cb'); xlabel('Nivel [0 - 255]'); ylabel('Píxeles');
subplot(2, 3, 6); imhist(canalCr); grid on;
title('Histograma Cr'); xlabel('Nivel [0 - 255]'); ylabel('Píxeles');

%% 5. SELECCIÓN DE COLOR CON IMPIXEL Y AISLAMIENTO DE COLOR
fprintf('\n--- SELECCIÓN DE COLOR CON IMPIXEL ---\n');
fprintf('Se abrirá una ventana para que selecciones el color a aislar.\n');
fprintf('Haz clic sobre el color deseado y confirma con doble clic o pulsa Enter.\n');

[cx, cy, P] = impixel(imgColor);

if isempty(P)
    fprintf('No se seleccionó ningún píxel. Se usará el color del centro de la imagen por defecto.\n');
    filaC = round(alto / 2);
    colC  = round(ancho / 2);
    colorRef = double(squeeze(imgColor(filaC, colC, :)))';
else
    colorRef = double(P(1, :));
end
fprintf('Color de referencia RGB seleccionado: [%d, %d, %d]\n', round(colorRef(1)), round(colorRef(2)), round(colorRef(3)));

tol = input('Introduce la tolerancia/distancia para el color [10 - 150] (por defecto 60): ');
if isempty(tol)
    tol = 60;
end

% Distancia euclídea tridimensional en el espacio RGB
distColor = sqrt((double(canalR) - colorRef(1)).^2 + ...
                 (double(canalG) - colorRef(2)).^2 + ...
                 (double(canalB) - colorRef(3)).^2);

mascaraColor = (distColor <= tol);

% Imagen en escala de grises con 3 canales idénticos para el fondo
imgGrisFondo = rgb2gray(imgColor);
imgAislada = cat(3, imgGrisFondo, imgGrisFondo, imgGrisFondo);

% Mantener el color original solo donde la máscara sea verdadera
for ch = 1:3
    canalOrig = imgColor(:, :, ch);
    canalDest = imgAislada(:, :, ch);
    canalDest(mascaraColor) = canalOrig(mascaraColor);
    imgAislada(:, :, ch) = canalDest;
end

figure('Name', 'Práctica 2 - Aislamiento de Color', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(imgColor);
title('Original en Color');

subplot(1, 3, 2);
imshow(mascaraColor);
title(['Máscara Binaria (Tolerancia = ' num2str(tol) ')']);

subplot(1, 3, 3);
imshow(imgAislada);
title('Color Seleccionado Aislado (Fondo en Grises)');

%% 6. CARGAR UNA IMAGEN EN ESCALA DE GRISES (im1.jpg a im6.jpg)
fprintf('\n--- CARGA DE IMAGEN EN ESCALA DE GRISES ---\n');
rutaGris = '';
nombreGris = input('Introduce el nombre de la imagen en escala de grises (ej. im1.jpg) [Enter para buscar]: ', 's');

if isempty(nombreGris)
    [fGris, rGris] = uigetfile({'*.jpg;*.png;*.tif;*.bmp', 'Imágenes en escala de grises'}, ...
                               'Selecciona una imagen en escala de grises (ej. im1.jpg)');
    if ~isequal(fGris, 0)
        rutaGris = fullfile(rGris, fGris);
        nombreGris = fGris;
    end
else
    if exist(nombreGris, 'file')
        rutaGris = nombreGris;
    elseif exist(fullfile('IMG', nombreGris), 'file')
        rutaGris = fullfile('IMG', nombreGris);
    end
end

% Fallback si no existe la imagen introducida
if isempty(rutaGris) || ~exist(rutaGris, 'file')
    fprintf('No se pudo encontrar la imagen indicada. Se usará una conversión a grises de la imagen anterior.\n');
    imgGrisExp = rgb2gray(imgColor);
    nombreGris = 'imagen_grises_referencia';
else
    imgGrisExp = imread(rutaGris);
    if size(imgGrisExp, 3) == 3
        imgGrisExp = rgb2gray(imgGrisExp);
    end
end

%% 7. FALSO COLOR CON COLORMAP
fprintf('\n--- CONVERSIÓN A COLOR MEDIANTE COLORMAP ---\n');
fprintf('Mapas de color disponibles: 1. jet | 2. hot | 3. cool | 4. copper | 5. pink | 6. hsv\n');
opcionMap = input('Elige una opción [1-6] (por defecto 1 - jet): ');
if isempty(opcionMap) || opcionMap < 1 || opcionMap > 6
    opcionMap = 1;
end

mapasNombres = {'jet', 'hot', 'cool', 'copper', 'pink', 'hsv'};
mapaElegido = mapasNombres{opcionMap};

% Crear imagen en color indexada mediante ind2rgb y el mapa de color seleccionado
mapaMat = feval(mapaElegido, 256);
imgColoreadaMap = ind2rgb(imgGrisExp, mapaMat);

figure('Name', ['Práctica 2 - Falso Color con Colormap (' mapaElegido ')'], 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(imgGrisExp);
title(['Imagen en Escala de Grises (' nombreGris ')'], 'Interpreter', 'none');

subplot(1, 2, 2);
imshow(imgGrisExp);
colormap(mapaMat);
colorbar;
title(['Falso Color con Colormap "' mapaElegido '"']);

%% 8. COLOREADO EN EL ESPACIO HSV CON 'colorWheel.png'
fprintf('\n--- COLOREADO HSV CON RUEDA DE COLOR ---\n');
rutaRueda = '';
if exist('colorWheel.png', 'file')
    rutaRueda = 'colorWheel.png';
elseif exist(fullfile('IMG', 'colorWheel.png'), 'file')
    rutaRueda = fullfile('IMG', 'colorWheel.png');
end

% Si no existe colorWheel.png en disco, generamos una rueda HSV sintética para que nunca falle
if isempty(rutaRueda)
    fprintf('Generando rueda de color HSV de referencia...\n');
    tamRueda = 300;
    [Xw, Yw] = meshgrid(linspace(-1, 1, tamRueda), linspace(-1, 1, tamRueda));
    Rw = sqrt(Xw.^2 + Yw.^2);
    Thew = atan2(Yw, Xw);
    Thew(Thew < 0) = Thew(Thew < 0) + 2*pi;
    
    H_wheel = Thew / (2*pi);
    S_wheel = min(Rw, 1);
    V_wheel = ones(tamRueda, tamRueda);
    V_wheel(Rw > 1) = 1; % fondo blanco fuera de la rueda
    S_wheel(Rw > 1) = 0;
    
    ruedaColor = hsv2rgb(cat(3, H_wheel, S_wheel, V_wheel));
else
    ruedaColor = imread(rutaRueda);
end

fprintf('Selecciona un tono y saturación haciendo clic sobre la rueda de color (Enter o doble clic para confirmar):\n');
[rX, rY, Pw] = impixel(ruedaColor);

if isempty(Pw)
    % Fallback: color azul cielo / cian vivo
    H_sel = 0.55;
    S_sel = 0.85;
    fprintf('Sin selección. Usando valores por defecto: Tono=%.2f, Saturación=%.2f\n', H_sel, S_sel);
else
    pixRGB_dbl = double(Pw(1, :)) / 255;
    pixHSV = rgb2hsv(reshape(pixRGB_dbl, 1, 1, 3));
    H_sel = pixHSV(1, 1, 1);
    S_sel = pixHSV(1, 1, 2);
    fprintf('Punto seleccionado en la rueda -> Tono H = %.3f, Saturación S = %.3f\n', H_sel, S_sel);
end

% Construir nueva imagen en espacio HSV usando el brillo original (V)
[filasG, colsG] = size(imgGrisExp);
V_canal = im2double(imgGrisExp);
H_canal = H_sel * ones(filasG, colsG);
S_canal = S_sel * ones(filasG, colsG);

imgHSV_tintada = cat(3, H_canal, S_canal, V_canal);
imgRGB_tintada = hsv2rgb(imgHSV_tintada);

figure('Name', 'Práctica 2 - Coloreado en Espacio HSV', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(ruedaColor);
hold on;
if ~isempty(rX)
    plot(rX(1), rY(1), 'kx', 'MarkerSize', 14, 'LineWidth', 3);
    plot(rX(1), rY(1), 'wo', 'MarkerSize', 12, 'LineWidth', 2);
end
title('Rueda de Color (colorWheel)');
hold off;

subplot(1, 3, 2);
imshow(imgGrisExp);
title('Original en Escala de Grises');

subplot(1, 3, 3);
imshow(imgRGB_tintada);
title(sprintf('Coloreada en HSV (H=%.2f, S=%.2f)', H_sel, S_sel));

%% 9. ANÁLISIS DE LA IMAGEN im10.jpg: DIÁMETRO DE LA MONEDA
fprintf('\n--- ANÁLISIS DE LA IMAGEN im10.jpg (Diámetro de la Moneda) ---\n');
rutaIm10 = '';
if exist('im10.jpg', 'file')
    rutaIm10 = 'im10.jpg';
elseif exist(fullfile('IMG', 'im10.jpg'), 'file')
    rutaIm10 = fullfile('IMG', 'im10.jpg');
else
    fprintf('No se encontró "im10.jpg" en el directorio actual ni en "IMG/".\n');
    [f10, r10] = uigetfile({'*.jpg;*.png;*.tif', 'Imagen im10.jpg'}, 'Selecciona im10.jpg para estimar el diámetro');
    if ~isequal(f10, 0)
        rutaIm10 = fullfile(r10, f10);
    end
end

if ~isempty(rutaIm10)
    im10 = imread(rutaIm10);
    if size(im10, 3) == 3
        im10_gris = rgb2gray(im10);
    else
        im10_gris = im10;
    end
    [M10, N10] = size(im10_gris);
    
    % Superficie total conocida: 4800 mm²
    superficieTotalMm2 = 4800.0;
    totalPixeles = M10 * N10;
    areaPorPixelMm2 = superficieTotalMm2 / totalPixeles;
    factorEscalaLinealMmPorPix = sqrt(areaPorPixelMm2);
    
    % Segmentación de la moneda:
    % Calculamos el umbral óptimo mediante el método de Otsu (graythresh)
    umbralOtsu = graythresh(im10_gris);
    bwMoneda = imbinarize(im10_gris, umbralOtsu);
    
    % Si las esquinas son blancas, el fondo es blanco y debemos invertir
    if bwMoneda(1, 1) == 1 && bwMoneda(1, end) == 1
        bwMoneda = ~bwMoneda;
    end
    
    % Rellenar agujeros y conservar únicamente el objeto de mayor área (la moneda)
    bwMoneda = imfill(bwMoneda, 'holes');
    
    % Etiquetar componentes conexas
    [L10, numObj] = bwlabel(bwMoneda);
    stats = regionprops(L10, 'Area', 'EquivDiameter', 'BoundingBox', 'Centroid');
    
    if ~isempty(stats)
        % Seleccionar la región más grande
        [~, idxMax] = max([stats.Area]);
        propMoneda = stats(idxMax);
        
        areaMonedaPix = propMoneda.Area;
        diametroEquivPix = propMoneda.EquivDiameter;
        
        % Cálculo del área y diámetro en milímetros:
        areaMonedaMm2 = areaMonedaPix * areaPorPixelMm2;
        diametroMm = 2 * sqrt(areaMonedaMm2 / pi);
        
        fprintf('Resultados del análisis geométrico de im10.jpg:\n');
        fprintf(' - Dimensiones de la imagen: %d x %d (%d píxeles)\n', M10, N10, totalPixeles);
        fprintf(' - Superficie total de la escena: %.1f mm²\n', superficieTotalMm2);
        fprintf(' - Área por píxel: %.6f mm²/píxel (Escala lineal: %.4f mm/píxel)\n', areaPorPixelMm2, factorEscalaLinealMmPorPix);
        fprintf(' - Área de la moneda en píxeles: %d px (%.2f%% de la imagen)\n', areaMonedaPix, (areaMonedaPix / totalPixeles) * 100);
        fprintf(' - Área de la moneda: %.2f mm²\n', areaMonedaMm2);
        fprintf(' -> Diámetro estimado de la moneda: %.2f mm\n', diametroMm);
        
        % Visualización de la detección
        figure('Name', 'Práctica 2 - Detección y Estimación de Diámetro (im10.jpg)', 'NumberTitle', 'off');
        subplot(1, 2, 1);
        imshow(im10);
        hold on;
        rectangle('Position', propMoneda.BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
        plot(propMoneda.Centroid(1), propMoneda.Centroid(2), 'y+', 'MarkerSize', 12, 'LineWidth', 2);
        title(sprintf('Moneda detectada (Diámetro \\approx %.2f mm)', diametroMm));
        hold off;
        
        subplot(1, 2, 2);
        imshow(bwMoneda);
        title('Máscara Binaria Segmentada (imfill)');
    end
end

fprintf('\nPráctica 2 completada correctamente.\n');
