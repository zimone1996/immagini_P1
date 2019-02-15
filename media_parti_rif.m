function diff_media = media_parti_rif_16x16(database, lunghezza_rif,a,b,c)

%% Feature: Media delle parti rif
elab_immagine_rif = struct;
for i=1:lunghezza_rif
   [~, threshold] = edge(database(b).dimensione(a).dominio(1).immagini(c).matrice(i).matrice, 'sobel');
   fudgeFactor = .2;
   elab_immagini_rif(i).imm_contorni = edge(database(b).dimensione(a).dominio(1).immagini(c).matrice(i).matrice,'sobel', threshold * fudgeFactor);
  
end
%imshow(elab_immagini(3).imm_contorni)

for i=1:lunghezza_rif
   elab_immagini_rif(i).imm_fill = imfill(elab_immagini_rif(i).imm_contorni, 'holes');
end
%figure
%imshow(elab_immagini(5).imm_fill)

background_rif= struct;
for i=1:lunghezza_rif
   elab_immagini_rif(i).binary = imbinarize(database(b).dimensione(a).dominio(1).immagini(1).matrice(i).matrice)
%prendo le due fasce laterali dell'immagine   
   background_rif(i).background = elab_immagini_rif(i).binary - elab_immagini_rif(i).imm_fill
end
%imshow(background(11).background)

for i=1:lunghezza_rif
     if b==1
       background_rif(i).backpartesx = background_rif(i).background(1:16,1:4);
     end
     if b == 2
          background_rif(i).backpartesx = background_rif(i).background(1:32,1:8);
     end
end
% imshow(background(4).backpartesx)

for i=1:lunghezza_rif
     if b == 1
   background_rif(i).backpartedx = background_rif(i).background(1:16,13:16);
     end
     if b == 2
          background_rif(i).backpartedx = background_rif(i).background(1:32,25:32);
     end
end


%calcolo media

for i=1:lunghezza_rif
   media_partesx_rif(i,1) = mean2(background_rif(i).backpartesx);
end


for i=1:lunghezza_rif
   media_partedx_rif(i,1) = mean2(background_rif(i).backpartedx);
end
diff_media=media_partesx_rif-media_partedx_rif;

end