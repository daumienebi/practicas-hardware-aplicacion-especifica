% Práctica 10: Procesado en tiempo real
% Script para la realización de un Chroma Key en tiempo real utilizando un 
% fondo arbitrario

%% Seleccionar el dispositivo de captura y crear un menú de opciones para 
% escoger la resolución de la imagen capturada por la cámara.

% Selección Camara :
disp('Dispositivos detectados:')
info = webcamlist;
nDEV = size(info,1);
for i = 1:nDEV
 nombre = info{i};
 disp(['[' num2str(i) '] ' nombre])
end
dID = input('> Selecciona dispositivo: [1]? ');
if(isempty(dID))
 dID = 1;
end

% Selección Resolución :
cam = webcam(dID);
formatosDisponibles = cam.AvailableResolutions;
nResoluciones = size(formatosDisponibles,2); %2 para acceder a las columnas
for i = 1:nResoluciones
    nombreResolucion = formatosDisponibles{i};
    disp(['[' num2str(i) ']' nombreResolucion])
end
rID = input('> Selecciona la resolución :');
if(isempty(rID))
    rID = 1;
end
formato = cam.AvailableResolutions{rID};
% asignamos el formato a la camara
set(cam,"Resolution",formato);

%% Seleccionar el fichero con la imagen del nuevo fondo. Se pueden utilizar
% las imágenes im21.jpg o im22.jpg. Hay que tener en cuenta que el tamaño 
% de la imagen del nuevo fondo debe coincidir con la resolución de la 
% imagen capturada. Para ello se puede utilizar la función imresize:
% B = imresize(A,[numrows numcols]): Devuelve en la imagen B la imagen A
% reescalada según el número de filas y columnas especificado por [numrows
% numcols]. Es conveniente comprobar que no hay valores fuera del rango.

img_fondo = uigetfile({'*.jpg'},'Selecciona im22.jpg o im21.jpg');

%% Capturar una imagen que contenga únicamente el fondo que se desea 
%  eliminar.


%% Pedir el número de imágenes que se van capturar y fijar la velocidad 
% de reproducción del archivo de vídeo final.


%% Iniciar el proceso del efecto chroma para cada uno de los fotogramas 
% capturados. Se debe mostrar en una misma ventana cada imagen capturada y 
% la imagen procesada.


%% Calcular el rendimiento del sistema expresado en frames/segundo (fps).


%% A partir del rendimiento anterior y de la velocidad de reproducción 
% establecida, ¿cuál será la aceleración del vídeo final? 
