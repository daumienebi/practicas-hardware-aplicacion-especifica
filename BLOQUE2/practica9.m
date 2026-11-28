% Práctica 9: Grabación de video
% Script para la grabación de un vídeo “timelapse”.

%% Crear el objeto de vídeo.
cam = webcam(1);
wObj = VideoWriter('salida_p9');

%% Fijar la velocidad de reproducción a 24 fps.
fps_rep = 24;
set(wObj,'FrameRate',fps_rep);

%% Pedir el factor de aceleración deseado.
factor_ac = input("Indica el factor de aceleración [ > 1, ej. 12]: ");

%% Pedir el tiempo de captura deseado (en segundos).
tiempo_cap = input("Indica el tiempo de captura(seg.) [ > 1, ej. 30]: ");

%% A partir de los valores introducidos por el usuario, calcular y mostrar
% los principales parámetros del vídeo: velocidad de captura (en fps), 
% número de imágenes que se van a capturar e intervalo de tiempo entre 
% cada captura.
velocidad_cap = fps_rep / factor_ac;
nImagenes = round(tiempo_cap * velocidad_cap);
intervalo = 1 / velocidad_cap;
disp(['Velocidad de captura: ' num2str(velocidad_cap) ' fps']);
disp(['Intervalo entre capturas: ' num2str(intervalo) ' s']);
disp(['Número de imágenes a capturar: ' num2str(nImagenes)]);
%% Guardar las imágenes capturadas en un archivo de vídeo.
open(wObj);
tm = timer('Period', intervalo, ...
           'TasksToExecute', nImagenes, ...
           'ExecutionMode', 'fixedRate', ...
           'TimerFcn', {@mi_Funcion_p9, cam, wObj});

disp('Iniciando grabación time lapse...');
start(tm);
wait(tm);
disp('Grabación finalizada.');

% Cerramos el archivo de vídeo y liberamos recursos
close(wObj);
delete(tm);
delete(cam);
%% Comprobar el resultado visualizando el archivo de vídeo final desde el 
% Sistema Operativo.
if exist('salida_p9.avi', 'file')
    disp('El archivo salida_p9.avi se ha creado correctamente.');
    infoFinal = mmfileinfo('salida_p9.avi');
    disp(infoFinal.Video);
else
    disp('Error: No se ha encontrado el archivo de vídeo final.');
end

% Truco para saber cuanto durará el video más o menos : tiempo / factor_acc