% Funcion de llamada del temporizador para la Practica 9
function miFuncion(tm, event, cam, Wobj)
    frame = snapshot(cam);
    writeVideo(Wobj, frame);
end
