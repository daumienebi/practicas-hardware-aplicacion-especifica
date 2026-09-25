%% =========================================================================
% PRÁCTICA 1: PROCESADO BÁSICO DE IMÁGENES
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
fprintf('       PRÁCTICA 1: PROCESADO BÁSICO DE IMÁGENES      \n');
fprintf('=====================================================\n\n');

%% 1. SELECCIÓN Y CARGA DE LA IMAGEN EN ESCALA DE GRISES
% Se debe pedir el nombre de una imagen y pedir una nueva si no existe.
% Además, si la imagen está en color, debe dar error y pedir otra.
% Imágenes recomendadas: im1.jpg a im6.jpg.

imagenValida = false;
while ~imagenValida
    nombreImg = input('Introduce el nombre de la imagen en escala de grises (ej. im1.jpg) [Enter para buscar]: ', 's');
    
    if isempty(nombreImg)
        [fichero, ruta] = uigetfile({'*.jpg;*.png;*.tif;*.bmp', 'Imágenes (*.jpg, *.png, *.tif, *.bmp)'}, ...
                                    'Selecciona una imagen en escala de grises');
        if isequal(fichero, 0)
            fprintf('No se seleccionó ningún archivo. Inténtalo de nuevo.\n');
            continue;
        end
        rutaCompleta = fullfile(ruta, fichero);
        nombreImg = fichero;
    else
        % Comprobar en directorio actual o dentro de IMG
        if exist(nombreImg, 'file')
            rutaCompleta = nombreImg;
        elseif exist(fullfile('IMG', nombreImg), 'file')
            rutaCompleta = fullfile('IMG', nombreImg);
        else
            fprintf('Error: El archivo "%s" no existe. Inténtalo de nuevo.\n', nombreImg);
            continue;
        end
    end
    
    % Leer imagen y verificar número de canales
    img = imread(rutaCompleta);
    [alto, ancho, canales] = size(img);
    
    if canales > 1
        fprintf('Error: La imagen "%s" está en COLOR (%d canales).\n', nombreImg, canales);
        fprintf('Por favor, selecciona una imagen en escala de grises (ej. im1.jpg a im6.jpg).\n\n');
    else
        imagenValida = true;
        fprintf('-> Imagen "%s" cargada con éxito (%dx%d píxeles, escala de grises).\n\n', nombreImg, alto, ancho);
    end
end

%% 2. MOSTRAR IMAGEN ORIGINAL Y SU HISTOGRAMA
figure('Name', ['Práctica 1 - ' nombreImg ' (Original e Histograma)'], 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(img);
title(['Imagen Original: ' nombreImg], 'Interpreter', 'none');

subplot(1, 2, 2);
imhist(img);
grid on;
title('Histograma de la Imagen Original');
xlabel('Nivel de Gris (0 - 255)');
ylabel('Número de Píxeles');

%% 3. AUMENTAR O DISMINUIR EL BRILLO A PETICIÓN DEL USUARIO
fprintf('--- AJUSTE DE BRILLO ---\n');
deltaBrillo = input('Introduce el cambio de brillo (-255 a +255, por defecto +40): ');
if isempty(deltaBrillo)
    deltaBrillo = 40;
end

% Ajuste de brillo controlando el desbordamiento (clipping entre 0 y 255)
imgBrillo = uint8(min(max(double(img) + deltaBrillo, 0), 255));

figure('Name', 'Práctica 1 - Modificación de Brillo', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(imgBrillo);
if deltaBrillo >= 0
    title(['Brillo aumentado (+' num2str(deltaBrillo) ')']);
else
    title(['Brillo disminuido (' num2str(deltaBrillo) ')']);
end

subplot(1, 2, 2);
imhist(imgBrillo);
grid on;
title(['Histograma tras ajuste de brillo (' num2str(deltaBrillo) ')']);
xlabel('Nivel de Gris (0 - 255)');
ylabel('Número de Píxeles');

%% 4. ECUALIZACIÓN DE LA IMAGEN
% Mejora del contraste distribuyendo uniformemente los niveles de gris
imgEcualizada = histeq(img);

figure('Name', 'Práctica 1 - Ecualización de Histograma', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(imgEcualizada);
title('Imagen Ecualizada (histeq)');

subplot(1, 2, 2);
imhist(imgEcualizada);
grid on;
title('Histograma Ecualizado');
xlabel('Nivel de Gris (0 - 255)');
ylabel('Número de Píxeles');

%% 5. ELIMINAR PÍXELES CON INTENSIDAD MENOR A UN VALOR DADO
fprintf('\n--- ELIMINACIÓN DE PÍXELES POR UMBRAL ---\n');
umbralCorte = input('Introduce el umbral de corte [0 - 255] (por defecto 100): ');
if isempty(umbralCorte)
    umbralCorte = 100;
end

imgFiltrada = img;
imgFiltrada(imgFiltrada < umbralCorte) = 0; % Asignar negro (0) a píxeles inferiores al umbral

figure('Name', 'Práctica 1 - Umbralización / Eliminación de píxeles', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(img);
title('Imagen Original');

subplot(1, 2, 2);
imshow(imgFiltrada);
title(['Píxeles con nivel < ' num2str(umbralCorte) ' eliminados']);

%% 6. SUAVIZADO: FILTRO DE MEDIA Y FILTRO GAUSSIANO
fprintf('\n--- SUAVIZADO DE IMÁGENES ---\n');
tamMedia = input('Tamaño de ventana para filtro de media (ej. 5 para 5x5, por defecto 5): ');
if isempty(tamMedia)
    tamMedia = 5;
end
H_media = fspecial('average', [tamMedia tamMedia]);
imgMedia = imfilter(img, H_media, 'replicate');

sigmaGauss = input('Desviación típica sigma para filtro gaussiano (por defecto 2.0): ');
if isempty(sigmaGauss)
    sigmaGauss = 2.0;
end
tamGaussPorDefecto = 2 * ceil(2 * sigmaGauss) + 1;
tamGauss = input(sprintf('Tamaño de máscara gaussiana (por defecto 2*ceil(2*sigma)+1 = %d): ', tamGaussPorDefecto));
if isempty(tamGauss)
    tamGauss = tamGaussPorDefecto;
end
H_gauss = fspecial('gaussian', [tamGauss tamGauss], sigmaGauss);
imgGauss = imfilter(img, H_gauss, 'replicate');

figure('Name', 'Práctica 1 - Suavizado de Imágenes', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(img);
title('Original');

subplot(1, 3, 2);
imshow(imgMedia);
title(['Suavizado Media (' num2str(tamMedia) 'x' num2str(tamMedia) ')']);

subplot(1, 3, 3);
imshow(imgGauss);
title(sprintf('Gaussiano (%dx%d, \\sigma=%.2f)', tamGauss, tamGauss, sigmaGauss));

%% 7. CÁLCULO DEL GRADIENTE DE LA IMAGEN (PREWITT)
% Para calcular derivadas es imprescindible convertir a tipo double
imgDouble = im2double(img);

Hx = fspecial('prewitt');
Hy = Hx'; % Traspuesta para la dirección vertical

Gx = imfilter(imgDouble, Hx, 'replicate');
Gy = imfilter(imgDouble, Hy, 'replicate');

% Módulo aproximado del gradiente G ≈ |Gx| + |Gy|
G_mod = abs(Gx) + abs(Gy);

figure('Name', 'Práctica 1 - Gradiente (Operador de Prewitt)', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(mat2gray(abs(Gx)));
title('Componente Horizontal |Gx|');

subplot(1, 3, 2);
imshow(mat2gray(abs(Gy)));
title('Componente Vertical |Gy|');

subplot(1, 3, 3);
imshow(mat2gray(G_mod));
title('Módulo del Gradiente G \approx |Gx| + |Gy|');

%% 8. REALZADO DE LA IMAGEN MEDIANTE GRADIENTE Y LAPLACIANO
% Realzado con gradiente: I_realzada = I_original + 0.5 * (Gx + Gy)
imgRealzadaGrad = imgDouble + 0.5 * (Gx + Gy);
imgRealzadaGrad = min(max(imgRealzadaGrad, 0), 1); % Saturar en [0, 1]

% Realzado con Laplaciano: I_realzada = I_original - ∇²(I_original)
alphaLap = 0.2;
H_lap = fspecial('laplacian', alphaLap);
L = imfilter(imgDouble, H_lap, 'replicate');
imgRealzadaLap = imgDouble - L;
imgRealzadaLap = min(max(imgRealzadaLap, 0), 1); % Saturar en [0, 1]

figure('Name', 'Práctica 1 - Realzado de Bordes', 'NumberTitle', 'off');
subplot(1, 3, 1);
imshow(imgDouble);
title('Original');

subplot(1, 3, 2);
imshow(imgRealzadaGrad);
title('Realzado con Gradiente');

subplot(1, 3, 3);
imshow(imgRealzadaLap);
title(['Realzado con Laplaciano (\alpha=' num2str(alphaLap) ')']);

%% 9. ANÁLISIS DE LA IMAGEN im4.jpg: CINTA TRANSPORTADORA Y BOTELLAS
fprintf('\n--- ANÁLISIS DE LA IMAGEN im4.jpg (Cinta con Botellas) ---\n');
rutaIm4 = '';
if exist('im4.jpg', 'file')
    rutaIm4 = 'im4.jpg';
elseif exist(fullfile('IMG', 'im4.jpg'), 'file')
    rutaIm4 = fullfile('IMG', 'im4.jpg');
else
    fprintf('No se encontró "im4.jpg" en el directorio actual ni en "IMG/".\n');
    [f4, r4] = uigetfile({'*.jpg;*.png;*.tif', 'Imagen im4.jpg'}, 'Selecciona im4.jpg para el análisis de botellas');
    if ~isequal(f4, 0)
        rutaIm4 = fullfile(r4, f4);
    end
end

if ~isempty(rutaIm4)
    im4 = imread(rutaIm4);
    if size(im4, 3) == 3
        im4 = rgb2gray(im4);
    end
    [M4, N4] = size(im4);
    im4_dbl = im2double(im4);
    
    % Gradiente horizontal y vertical sobre im4
    Gx4 = imfilter(im4_dbl, Hx, 'replicate');
    Gy4 = imfilter(im4_dbl, Hy, 'replicate');
    G4 = abs(Gx4) + abs(Gy4);
    
    filaCentral = round(M4 / 2);
    perfilCentral = G4(filaCentral, :);
    
    % Representar la imagen con la línea de corte y la gráfica de la fila central
    figure('Name', 'Práctica 1 - Análisis im4.jpg (Fila Central del Gradiente)', 'NumberTitle', 'off');
    subplot(2, 1, 1);
    imshow(im4);
    hold on;
    line([1, N4], [filaCentral, filaCentral], 'Color', 'r', 'LineWidth', 2);
    title(sprintf('Imagen im4.jpg con fila central señalizada (Fila %d)', filaCentral));
    hold off;
    
    subplot(2, 1, 2);
    plot(1:N4, perfilCentral, 'b-', 'LineWidth', 1.2);
    grid on;
    title(['Perfil del módulo del gradiente en la fila central (' num2str(filaCentral) ')']);
    xlabel('Columna (píxeles)');
    ylabel('Magnitud del gradiente');
    xlim([1, N4]);
    
    % Cálculo de magnitudes físicas:
    % En la imagen se han capturado 90 cm de dicha cinta a lo largo de las N4 columnas.
    longitudCintaCm = 90.0;
    escalaCmPorPixel = longitudCintaCm / N4;
    
    % Detección de picos significativos que corresponden a los bordes de las botellas
    umbralPico = 0.25 * max(perfilCentral);
    [picos, locs] = findpeaks(perfilCentral, 'MinPeakHeight', umbralPico, 'MinPeakDistance', round(N4 * 0.03));
    
    % Resaltar picos detectados en la gráfica
    hold on;
    plot(locs, picos, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 5);
    legend('Gradiente', 'Bordes detectados');
    hold off;
    
    fprintf('Datos obtenidos de im4.jpg:\n');
    fprintf(' - Resolución: %d x %d píxeles\n', M4, N4);
    fprintf(' - Longitud real de la cinta: %.1f cm (en %d píxeles)\n', longitudCintaCm, N4);
    fprintf(' - Factor de escala: %.4f cm/píxel (o %.2f píxeles/cm)\n', escalaCmPorPixel, 1/escalaCmPorPixel);
    fprintf(' - Picos de gradiente detectados: %d bordes\n', length(locs));
    
    if length(locs) >= 4
        % Agrupamos pares de bordes (borde izquierdo y derecho de cada botella)
        anchosPix = [];
        separacionesPix = [];
        for i = 1:2:(length(locs)-1)
            anchosPix = [anchosPix, locs(i+1) - locs(i)];
            if (i+2) <= length(locs)
                separacionesPix = [separacionesPix, locs(i+2) - locs(i+1)];
            end
        end
        anchoMedioCm = mean(anchosPix) * escalaCmPorPixel;
        sepMediaCm = mean(separacionesPix) * escalaCmPorPixel;
        fprintf(' -> Ancho aproximado de cada botella: %.2f cm (aprox. %.1f px)\n', anchoMedioCm, mean(anchosPix));
        fprintf(' -> Separación aproximada entre botellas: %.2f cm (aprox. %.1f px)\n', sepMediaCm, mean(separacionesPix));
    else
        fprintf(' -> Para medir interactivamente en la gráfica, utiliza la herramienta Data Cursor o Zoom.\n');
    end
end

fprintf('\nPráctica 1 completada correctamente.\n');