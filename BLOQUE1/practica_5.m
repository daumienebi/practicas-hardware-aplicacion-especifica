% =========================================================================
% Práctica 5: Reconocimiento y clasificación
% =========================================================================
clear; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seleccionar la imagen en color im12.jpg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('im12.jpg');
% Pasamos a escala de grises para poder binarizar
%I_gray = rgb2gray(I);
I_gray = I(:,:,3); % Usamos el canal azul para contrastar el objeto amarillo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Realizar un proceso de segmentación para la detección de objetos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
umbral = graythresh(I_gray);
% Invertimos la máscara asumiendo objetos más oscuros que el fondo
BW = not(imbinarize(I_gray, umbral)); 
BW_rellena = imfill(BW, 'holes');
BW_limpia = bwareaopen(BW_rellena, 100); % Limpiamos ruido pequeño


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualizar los objetos detectados con su rectángulo de área mínima 
% y etiquetarlos utilizando la función text
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[L, num_objetos] = bwlabel(BW_limpia);
rprop = regionprops(L, 'BoundingBox', 'Centroid');
figure('Name', 'Detección y Etiquetado');
imshow(I);
title('Objetos detectados');

for i = 1:num_objetos
    caja = rprop(i).BoundingBox;
    rectangle('Position', caja, 'EdgeColor', 'g', 'LineWidth', 2);
    
    centro = rprop(i).Centroid;
    text(centro(1), centro(2), num2str(i), 'Color', 'r', 'FontSize', 12, ...
        'FontWeight', 'bold');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcular el factor de forma y la textura para cada objeto detectado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rprop_geo = regionprops(L, 'Area', 'Perimeter');

% Usamos la conversión estándar a grises para analizar la textura real
I_textura = rgb2gray(I);
rprop_tex = regionprops(L, I_textura, 'PixelValues');

% Inicializamos vectores para guardar los resultados
factor_forma = zeros(1, num_objetos);
textura = zeros(1, num_objetos);

for i = 1:num_objetos
    % F = (4 * pi * Area) / Perimetro^2
    area = rprop_geo(i).Area;
    perimetro = rprop_geo(i).Perimeter;
    factor_forma(i) = (4 * pi * area) / (perimetro^2);
    
    % Cálculo de la Entropía
    valores = rprop_tex(i).PixelValues;
    textura(i) = entropy(valores);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Representar gráficamente los resultados de los descriptores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Descriptores Individuales');
subplot(1,2,1);
stem(factor_forma);
title('Factor de Forma');
xlabel('Número de objeto');

subplot(1,2,2);
stem(textura);
title('Textura (Entropía)');
xlabel('Número de objeto');

figure('Name', 'Clasificación Bidimensional');
plot(factor_forma, textura, 'o');
title('Factor de Forma vs Textura');
xlabel('Factor de Forma');
ylabel('Textura (Entropía)');

% Etiquetar los puntos en la gráfica para saber a qué objeto corresponden
for i = 1:num_objetos
    text(factor_forma(i), textura(i), num2str(i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Señalar los elementos circulares que sean falsos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Detección de Falsificaciones');
imshow(I);
title('Elemento circular falso');

for i = 1:num_objetos
    % Condición: Forma circular (F > 0.9) y textura lisa (Entropía baja)
    if factor_forma(i) > 0.9 && textura(i) < 4
        % Reutilizamos la variable rprop del bloque de etiquetado
        caja = rprop(i).BoundingBox; 
        rectangle('Position', caja, 'EdgeColor', 'r', 'LineWidth', 3);
    end
end