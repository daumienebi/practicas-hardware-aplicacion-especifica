% % Trabajando con RGB
% I = imread("im22.jpg");
% 
% R=I(:,:,1);
% G=I(:,:,2);
% B=I(:,:,3);
% 
% whos("I")
% % imfinfo("im22.jpg")
% 
% impixel(I)

% Abrir un fichero con extension jpg
% filename = uigetfile('*.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fichero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RGB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R=A(:,:,1);
% G=A(:,:,2);
% B=A(:,:,3);
% subplot(1,3,1);
% imhist(R)
% title("Canal R")
% subplot(1,3,2);
% imhist(G)
% title("Canal R")
% subplot(1,3,3);
% imhist(B)
% title("Canal R")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HSV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B = rgb2hsv(A);
% H=B(:,:,1);
% S=B(:,:,2);
% V=B(:,:,3);
% subplot(1,3,1);
% imhist(H)
% title("Canal H")
% subplot(1,3,2);
% imhist(S)
% title("Canal S")
% subplot(1,3,3);
% imhist(V)
% title("Canal V")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YUV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C = rgb2ycbcr(A);
% Y=B(:,:,1);
% U=B(:,:,2);
% V=B(:,:,3);
% subplot(1,3,1);
% imhist(Y)
% title("Canal Y")
% subplot(1,3,2);
% imhist(U)
% title("Canal U")
% subplot(1,3,3);
% imhist(V)
% title("Canal V")


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seleccionar un color de la imagen y modificarla para
% que solo aparezca dicho color y el resto en escala de grises
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A = imread("colorWheel.png");
% A = im2double(A);
% [x, y, rgb] = impixel(A)
% [h s v] = rgb2hsv(rgb);
% [H S V] = rgb2hsv(A);
% M = (H > (h-0.02) & H<(h+0.02));
% % Ahhora muls tiplicamos la H original por la la mascara M
% R = [H .* M ];
% RS = [S .* M];
% T = cat(3,R,RS,V);
% 
% Trgb = hsv2rgb(T);


% % subplot(1,2,1)
% % imshow(A);
% title("Imagen original");
% subplot(1,2,2)
% imshow(Trgb);
% title("Imagen resultado");





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cargar una imagen en escala de grises (imágenes im1.jpg a im6.jpg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A = imread("im1.jpg");
% m = colormap(jet);
% I = ind2rgb(A, m);
% 
% subplot(1,2,1);
% imshow(A);
% title("Imagen en escala de grises");
% subplot(1,2,2);
% imshow(I);
% title("Imagen en mapa de colores");
% colorbar();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gris a Color con HSV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A = imread("im1.jpg");
% A = im2double(A)
% W = imread("colorWheel.png");
% W = im2double(W);
% 
% [x,y,P] = impixel(W);
% [h,s,v] = rgb2hsv(P);
% 
% H = ones(size(A,2)) * h;
% S = ones(size(A,2)) * s;
% 
% % A (en grises) lo usamos como S(saturacion) y V(intensidad)
% R = cat(3, H, A, A);
% 
% I = hsv2rgb(R);
% 
% subplot(1,2,1);
% imshow(A);
% subplot(1,2,2);
% imshow(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Diametro moneda
% Tamaño de la imagen aprox. 4800 mm2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = imread("im10.jpg");
% Siempre en doubles
A = im2double(A);
G = rgb2gray(A);
% Todo lo que no sea blanco (con cierto umbral)
L = (G < 0.9);
% Podemos sumar todos los 1 (sum suma vectores, columna a columna)
% Por eso hacerlo dos veces...
pixelesMoneda = sum(sum(L));

% Ahora quiero calcular el area
[rows, cols, z] = size(A);
pixelesTotal = rows * cols;

% Regla de tres para sacar el area total (son dos caras por eso entre 2)
areaMoneda = pixelesMoneda / pixelesTotal * 4800 / 2;

% Como sacar el diametro a partir del area
% d = 2*sqrt(A/pi)

% Diametro en mm
diametro = 2 * sqrt(areaMoneda/pi)