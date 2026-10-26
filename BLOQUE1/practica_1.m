% Práctica 1 : Procesado básico de imágenes 
% % Pedir al usuario la imagen
% nombre_img = input("Dame el nombre del fichero de imagen: ", "s");
% 
% % Solo si encuentra y es B/N lo acepta
% while isempty(nombre_img) || ~exist(nombre_img, 'file') || imfinfo(nombre_img).ColorType ~= "grayscale"
%     disp("El fichero no es una imagen de tipo 'grayscale'.");
%     nombre_img = input("Dame el nombre del fichero de imagen: ", "s");
% end
% 
% A = imread(nombre_img);

% % Pedir datos de brillo
% brillo = input("¿Quieres ajustar el brillo? (+/- 0-255): ");
% umbral = input("Intensidad umbral [0-255]: ");
% 
% 
% % Imagen brillo
% B = max(min(double(A) + brillo, 255), 0);
% B = uint8(B);
% figure
% subplot(1,2,1)
% imshow(B)
% title("Imagen modificada")
% subplot(1,2,2)
% imhist(B)
% title("Histograma")
% 
% % Imagen ecualizada
% C = histeq(A);
% figure
% subplot(2,2,1)
% imshow(C)
% title("Imagen ecualizada")
% subplot(2,2,2)
% imhist(C)
% title("Histograma ecualizado")
% subplot(2,2,3)
% imshow(A)
% title("Imagen Original")
% subplot(2,2,4)
% imhist(A)
% title("Histograma Original")
% 
% 
% % Quitar filtrando por umbral
% umbral = max(umbral, 0);
% umbral = min(umbral, 255);
% D = A;
% D(A < umbral) = 0;
% figure
% subplot(2,2,1)
% imshow(D)
% title("Imagen umbral")
% subplot(2,2,2)
% imhist(D)
% title("Histograma umbral")
% subplot(2,2,3)
% imshow(A)
% title("Imagen Original")
% subplot(2,2,4)
% imhist(A)
% title("Histograma Original")

% Suavizados Media y Gaussiano
% FILTRO_MEDIA = fspecial("average", [5 5]);
% FILTRO_GAUSSIANO = fspecial("gaussian", [5 5]);
% FILTRADO_MEDIA = imfilter(A, FILTRO_MEDIA);
% FILTRADO_GAUSSIANO = imfilter(A, FILTRO_GAUSSIANO);
% 
% figure
% subplot(1,3,1)
% imshow(A)
% title("Imagen original")
% subplot(1,3,2)
% imshow(FILTRADO_MEDIA)
% title("Filtro Media")
% subplot(1,3,3)
% imshow(FILTRADO_GAUSSIANO)
% title("Filtro Gaussiano")


% Gradiente
% Hx = fspecial("prewitt");
% Hy = Hx';
% Gx = imfilter(A, Hx);
% Gy = imfilter(A, Hy);
% G = abs(Gy) + abs(Gx);
% figure
% subplot(2,2,1);
% imshow(A)
% title("Imagen orignal")
% subplot(2,2,2);
% imshow(G)
% title("Gradiente absoluto")
% subplot(2,2,3);
% imshow(Gx)
% title("Gradiente Eje X")
% subplot(2,2,4);
% imshow(Gy)
% title("Gradiente Eje Y")

% % Laplaciano
% H = fspecial("laplacian");
% L = imfilter(A, H);
% figure
% subplot(1,2,1)
% imshow(A)
% title("Imagen original")
% subplot(1,2,2)
% imshow(L)
% title("Laplaciano")


% Plot del gradiente de la linea central
% I = imread("im4.jpg");
% H = fspecial("prewitt");
% Gx = imfilter(I, H);
% 
% [rows, cols] = size(I);
% fila_central = ceil(rows/2); 
% 
% fila = Gx(fila_central,:);
% 
% plot(fila)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% De la ultima se puede sacar el 
% ultimo apartado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%