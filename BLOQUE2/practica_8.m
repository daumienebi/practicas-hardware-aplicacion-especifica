% Practica 8: Procesado de video
clear; close all; clc;

%% Seleccionar el archivo de video de entrada
nombre = input('Nombre del video [video03.avi]: ', 's');
if isempty(nombre)
    nombre = 'video03.avi';
end
while ~exist(nombre, 'file')
    disp('El archivo de video no existe');
    nombre = input('Nombre del video: ', 's');
end

%% Mostrar las propiedades del archivo de video original
info = mmfileinfo(nombre)
info.Video
Robj = VideoReader(nombre);
get(Robj)

%% Crear el archivo de escritura de video a 24 fps y mostrar propiedades
salida = input('Nombre del video de salida [video_procesado.avi]: ', 's');
if isempty(salida)
    salida = 'video_procesado.avi';
end
Wobj = VideoWriter(salida);
set(Wobj, 'FrameRate', 24);
get(Wobj)

%% Seleccionar el mapa de color para procesar los fotogramas
mapa_nombre = input('Mapa de color (jet, hot, copper, ...) [jet]: ', 's');
if isempty(mapa_nombre)
    mapa_nombre = 'jet';
end
m = feval(mapa_nombre, 256);

%% Leer, procesar cuadro a cuadro y guardar en el archivo final
open(Wobj);
num_frames = 0;
inicio = tic;

while hasFrame(Robj)
    frame = readFrame(Robj);
    gris = rgb2gray(frame);
    frame_color = ind2rgb(gris, m);
    writeVideo(Wobj, frame_color);
    num_frames = num_frames + 1;
    if num_frames == 1
        primer_orig = frame;
        primer_proc = frame_color;
    end
end

tiempo = toc(inicio);
close(Wobj);

%% Mostrar el tiempo empleado y la velocidad de procesamiento
fps_proc = num_frames / tiempo;
disp(['Tiempo de procesamiento: ' num2str(tiempo, '%.4f') ' s'])
disp(['Velocidad de procesamiento: ' num2str(fps_proc, '%.2f') ' fps'])

%% Comprobar que se ha creado correctamente el archivo final
if exist(salida, 'file')
    info_salida = mmfileinfo(salida)
    figure
    subplot(1,2,1), imshow(primer_orig), title('Fotograma original')
    subplot(1,2,2), imshow(primer_proc), title(['Fotograma con mapa ' mapa_nombre])
end
