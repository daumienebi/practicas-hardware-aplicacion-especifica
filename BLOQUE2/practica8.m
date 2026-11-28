% Práctica 8: Procesado de vídeo
% script para script para la lectura y procesado de un archivo de vídeo

%% Seleccionar el archivo de vídeo con el que se desea trabajar. 
% Mostramos la interfaz de usuario para que se selecione el video
filename = uigetfile({'*.avi';'*.mpg'},'Selecciona el video');

%% Mostrar todas las propiedades relacionadas con el archivo de vídeo. 
info = mmfileinfo(filename);
disp(info.Video)

%% Crear un archivo de escritura de vídeo y fijar su velocidad de 
% reproducción a 24 fps.
wObj = VideoWriter('salida_p8');
set(wObj,'FrameRate',24);
open(wObj)
%% Mostrar las propiedades del archivo de vídeo final.
get(wObj) % Aqui de momento el archivo no tiene ningún contenido
%% Leer y procesar cada frame del archivo de vídeo original aplicando un
% mapa de color.
rObj = VideoReader(filename);
m = colormap(jet(256));
nFrames = 0;
start = tic;
% Ahora leemos del video mientras haya frames disponibles
while hasFrame(rObj)
    frame = readFrame(rObj);
    % Pasamos cada frame a escala de grises y aplicamos el mapa de color
    frameGris = rgb2gray(frame);
    I = ind2rgb(frameGris, m);
    %% Guardar en el archivo de vídeo final cada frame procesado.
    writeVideo(wObj,I)
    nFrames = nFrames + 1;
end
% Detenemos el temporizador y cerramos el archivo de escritura
elapsed = toc(start);
close(wObj)
%% Mostrar el tiempo de procesamiento empleado (en segundos) y la velocidad
%  de procesamiento (en fps).
fps = nFrames / elapsed;
disp(['Tiempo de procesamiento: ' num2str(elapsed) ' s']);
disp(['Velocidad de procesamiento: ' num2str(fps) ' fps']);

%% Comprobar que se ha creado correctamente el archivo de vídeo final. 
if exist('salida_p8.avi', 'file')
    disp('El archivo salida_p8.avi se ha creado correctamente.');
    infoFinal = mmfileinfo('salida_p8.avi');
    disp(infoFinal.Video);
else
    disp('Error: No se ha encontrado el archivo de vídeo final.');
end