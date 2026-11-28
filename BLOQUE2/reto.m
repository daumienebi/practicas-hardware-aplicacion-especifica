% Reto 2: Cuantos coches pasan
clear; close all; clc;

%% Seleccionar el archivo de video
nombre = input('Nombre del video [video01.avi]: ', 's');
if isempty(nombre)
    nombre = 'video01.avi';
end
while ~exist(nombre, 'file')
    disp('El archivo de video no existe');
    nombre = input('Nombre del video: ', 's');
end

obj = VideoReader(nombre);
n_total = obj.NumFrames;

%% Inicializar el fondo mediante el primer fotograma y parametros
primer_frame = readFrame(obj);
B = im2double(rgb2gray(primer_frame));
[filas, columnas] = size(B);

% Parametros adaptados al tamano de la imagen para funcionar con otros videos
alpha = 0.02;
umbral = 0.20;
area_min = round(0.0012 * filas * columnas);
se = strel('disk', 3);

% Linea de salida cerca del borde inferior para contar cada coche una vez
linea_salida = filas - round(0.05 * filas);

total_coches = 0;
num_frame = 1;
hist_frames = [];
hist_posY = [];
colores = ['r', 'y', 'g', 'c', 'm', 'b'];

figure

%% Procesar el video fotograma a fotograma con media acumulativa
while hasFrame(obj)
    t_ini = tic;
    frame = readFrame(obj);
    num_frame = num_frame + 1;
    I = im2double(rgb2gray(frame));

    % Mascara binaria M(t) = |I(t) - B(t)| > umbral y actualizacion del fondo
    M = abs(I - B) > umbral;
    B = (1 - alpha) * B + alpha * I;

    % Procesado morfologico para limpiar ruido y rellenar los vehiculos
    M = imclose(M, se);
    M = imfill(M, 'holes');
    M = bwareaopen(M, area_min);

    % Etiquetado de objetos en movimiento y propiedades
    [L, num_coches] = bwlabel(M);
    rprop = regionprops(L, 'BoundingBox', 'Centroid');

    for i = 1:num_coches
        pos_y = rprop(i).Centroid(2);
        hist_frames(end + 1) = num_frame;
        hist_posY(end + 1) = pos_y;

        % Si el centro del coche cruza la zona final de la carretera se cuenta
        if pos_y > linea_salida
            total_coches = total_coches + 1;
        end
    end

    fps = 1 / toc(t_ini);

    % Fotograma actual con los coches detectados
    subplot(2,2,1), imshow(frame)
    title(['No coches: ' num2str(num_coches)])
    xlabel('Imagen original')
    for i = 1:num_coches
        c = colores(mod(i - 1, length(colores)) + 1);
        rectangle('Position', rprop(i).BoundingBox, 'EdgeColor', c, 'LineWidth', 2);
    end

    % Fondo actual obtenido por media acumulativa
    subplot(2,2,2), imshow(B)
    title(['Fotograma #' num2str(num_frame)])
    xlabel('Imagen de fondo')

    % Mascara binaria y velocidad de procesado
    subplot(2,2,3), imshow(M)
    title(['Velocidad de procesado: ' num2str(fps, '%.4f') ' fps'])
    xlabel('Mascara binaria')

    % Grafica con la posicion vertical de los coches detectados
    subplot(2,2,4)
    if ~isempty(hist_frames)
        stem(hist_frames, hist_posY)
    else
        stem(0, 0)
    end
    axis([0 n_total 0 filas])
    title(['TOTAL coches detectados: ' num2str(total_coches)])
    xlabel('No Fotograma')

    drawnow
end

disp(['Total de coches que han pasado: ' num2str(total_coches)])
