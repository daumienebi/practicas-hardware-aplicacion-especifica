% =========================================================================
% RETO 1: CONTEO DE MONEDAS DE EURO
% =========================================================================
clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentación: Separar fondo y objetos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = im2double(imread('im00.jpg'));
ImagenHSV = rgb2hsv(I);
I_gray = rgb2gray(I);

% Binarizar, invertir máscara y limpiar ruidos/huecos
%%mostrar 
umbral = graythresh(I_gray);
BW = not(imbinarize(I_gray, umbral));
BW_rellena = imfill(BW, 'holes');
BW_limpia = bwareaopen(BW_rellena, 100);


% Etiquetar objetos detectados
[L, num_objetos] = bwlabel(BW_limpia);

% Visualizar segmentación
figure('Name', 'Resultados Intermedios Reto 1');
subplot(1,2,1), imshow(BW_limpia), title('Máscara Limpia');
L_norm = mat2gray(L);
subplot(1,2,2), imshow(L_norm), title('Objetos etiquetados (Falso Color)');
colormap(jet(num_objetos + 1));
colorbar;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcular el factor de forma y la textura para cada objeto detectado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rprop_geo = regionprops(L, 'Area', 'Perimeter');

% Usamos la conversión estándar a grises para analizar la textura real
% I_textura = rgb2gray(I);

% Usamos el canal H de la imagen y la media de todo eso seria la H que
% buscamos
canalH = ImagenHSV(:,:,1);
rprop_canalH = regionprops(L, canalH, 'PixelValues');

% Inicializamos vectores para guardar los resultados
factor_forma = zeros(1, num_objetos);
mediaCanalH = zeros(1, num_objetos);

for i = 1:num_objetos
    % F = (4 * pi * Area) / Perimetro^2
    area = rprop_geo(i).Area;
    perimetro = rprop_geo(i).Perimeter;
    factor_forma(i) = (4 * pi * area) / (perimetro^2);
    
    % Cálculo de la media del canal H ya que eso nos indica el color
    valores = rprop_canalH(i).PixelValues;
    mediaCanalH(i) = mean(valores);
end

%obtener la media de cada uno de los objetos

% usar imshow y stem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Señalar los elementos circulares que sean falsos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Detección de las monedas Euro');
imshow(I);
title('Monedas de Euro');
rprop = regionprops(L, 'BoundingBox', 'Centroid');
centro = rprop(i).Centroid;
    text(centro(1), centro(2), num2str(i), 'Color', 'r', 'FontSize', 12, ...
        'FontWeight', 'bold');
    contador = 0;
for i = 1:num_objetos
    % Condición: Forma circular (F > 0.9) y que la media de H sea 
    % entre cierto rango (asi sabemos por el color que es moneda euro)
    % primero sacamos el factor de forma
    %if factor_forma(i) > 0.9 && mediaCanalH(i) < 0.146453
     %if factor_forma(i) > 0.98
     % 136238
     if mediaCanalH(i) < 0.146453
        contador = contador + 1
        % Reutilizamos la variable rprop del bloque de etiquetado
        caja = rprop(i).BoundingBox; 
        rectangle('Position', caja, 'EdgeColor', 'y', 'LineWidth', 3);
    end
end

% Separar por tamaños al final para identificar los distintos tamaños