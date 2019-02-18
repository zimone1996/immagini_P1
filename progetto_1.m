%% Creare il database
imagespath=dir('C:\Users\Simone\Desktop\uni\immagini\database per gli elaborati di Tipo 2-20190208\Yale\Yale');
imagespath
ImagesPath=imagespath(4:end,:);% Per eliminare i primi tre elementi che non sono immagini
images=struct;
lista_tipologie=struct;
for i=1:size(ImagesPath,1)
    images(i).images=imread([ImagesPath(i).folder,'/',ImagesPath(i).name]);
    % creo il path totale dell'immagine, quindi
    % sto caricando con ogni ciclo la struttura ad ogni immagine
    %creo struct con tuttii nomi delle immagini
    lista_tipologie(i).lista = extractAfter(ImagesPath(i).name,".");
end
%creo array di stringhe che conterrà i nomi delle 11 tipologie delle
%immagini
lista_stringhe = string(lista_tipologie(1).lista);

for i=1:size(lista_tipologie,2)
    %prendo tutti i nomi dalla struct e li confronto con quelli presente in
    %lista_stringhe
    count = 0;
    for k=1:size(lista_stringhe,1)
        if count ==0 && ~strcmp(lista_tipologie(i).lista, lista_stringhe(k))
        else
            count = 1;
        end
    end
    if count == 0
        %aggiungo la nuova tipologia in lista_stringhe
        lista_stringhe = [lista_stringhe;string(lista_tipologie(i).lista)];
    end
end



%Tutte le immagini convertite in double
%% %%%%% P1
%% Creo immagini (16x16) spazio
for i=1:size(ImagesPath,1)
    DB(1).database(1).dimensione(1).dominio(1).immagini(1).matrice(i).matrice=im2double(imresize(images(i).images,[16 16]));
end

%% Creo immagini (32x32) spazio
for i=1:size(ImagesPath,1)
    DB(1).database(2).dimensione(1).dominio(1).immagini(1).matrice(i).matrice=im2double(imresize(images(i).images,[32 32]));
end

%%  Creo immagini (16x16) frequenza(DCT2)
for i=1:size(DB(1).database(1).dimensione(1).dominio(1).immagini(1).matrice,2)
    DB(1).database(1).dimensione(2).dominio(1).immagini(1).matrice(i).matrice = dct2(im2double(DB(1).database(1).dimensione(1).dominio(1).immagini(1).matrice(i).matrice));
end

%% Creo immagini (32x32) frequenza(DCT2)
for i=1:size(DB(1).database(1).dimensione(1).dominio(1).immagini(1).matrice,2)
    DB(1).database(2).dimensione(2).dominio(1).immagini(1).matrice(i).matrice = dct2(im2double(DB(1).database(2).dimensione(1).dominio(1).immagini(1).matrice(i).matrice));
end

%% Ciclo for per tutti i rumori
for z = 2 : 5 
% vettore potenza del rumore
 potenza_rumore = logspace(-5,-1,5);
 
for k=1:size(DB(1).database(1).dimensione(1).dominio(1).immagini(1).matrice,2)
     
      %%  (16x16) spazio
      DB(z).database(1).dimensione(1).dominio(1).immagini(1).matrice(k).matrice =...
      im2double(DB(1).database(1).dimensione(1).dominio(1).immagini(1).matrice(k).matrice) + ...
      sqrt(potenza_rumore(z))*randn(size(DB(1).database(1).dimensione(1).dominio(1).immagini(1).matrice(k).matrice));
  
      %%  (16x16) frequenza
      DB(z).database(1).dimensione(2).dominio(1).immagini(1).matrice(k).matrice =...
      im2double(DB(1).database(1).dimensione(2).dominio(1).immagini(1).matrice(k).matrice) +...
      sqrt(potenza_rumore(3))*randn(size(DB(1).database(1).dimensione(2).dominio(1).immagini(1).matrice(k).matrice));
  
      %%  (32x32) spazio
      DB(z).database(2).dimensione(1).dominio(1).immagini(1).matrice(k).matrice=...
      im2double(DB(1).database(2).dimensione(1).dominio(1).immagini(1).matrice(k).matrice) +...
      sqrt(potenza_rumore(4))*randn(size(DB(1).database(2).dimensione(1).dominio(1).immagini(1).matrice(k).matrice));
  
      %%  (32x32) frequenza
      DB(z).database(2).dimensione(2).dominio(1).immagini(1).matrice(k).matrice =...
      im2double(DB(1).database(2).dimensione(2).dominio(1).immagini(1).matrice(k).matrice) +...
      sqrt(potenza_rumore(5))*randn(size(DB(1).database(2).dimensione(2).dominio(1).immagini(1).matrice(k).matrice));
  
end
end

%% Ciclo for per tutti i rumori
for z= 1:5
%% Ciclo for per tutte i domini (spazio e frequenza)
for a = 1 : 2
%% Ciclo for per tutte le dimensioni (16x16 e 32x32)
    for b = 1: 2
        
% Creo immagini riferimenti per entrambi i domini e i database
stringa_sub = '01';
for i=1:size(lista_stringhe,1)
    for k=1:size(ImagesPath,1)
        if strcmp(extractAfter(ImagesPath(k).name,"."),lista_stringhe(i))&& ...
                strcmp(extractBefore(ImagesPath(k).name,"."),['subject',stringa_sub])
            DB(z).database(b).dimensione(a).dominio(1).immagini(2).matrice(i).matrice = DB(1).database(b).dimensione(a).dominio(1).immagini(1).matrice(k).matrice;
            DB(z).database(b).dimensione(a).dominio(1).immagini(2).matrice(i).tipologia = extractAfter(ImagesPath(k).name,".");
            DB(z).database(b).dimensione(a).dominio(1).immagini(2).matrice(i).soggetto = extractBefore(ImagesPath(k).name,".");
            DB(z).database(b).dimensione(a).dominio(1).immagini(2).matrice(i).etichetta = i;
       switch stringa_sub
                case '01'
                    stringa_sub = '02';
                case '02'
                    stringa_sub = '03';
                case '03'
                    stringa_sub = '04';
                case '04'
                    stringa_sub = '05';
                case '05'
                    stringa_sub = '06';
                case '06'
                    stringa_sub = '07';
                case '07'
                    stringa_sub = '08';
                case '08'
                    stringa_sub = '09';
                case '09'
                    stringa_sub = '10';
                case '10'
                    stringa_sub = '11';
            end
            break;
        end
    end
end
  

% Associo alle immagini le tipologie corrispondenti
for k=1:size(ImagesPath,1)
    for i=1:size(lista_stringhe,1)
        if strcmp(extractAfter(ImagesPath(k).name,"."),lista_stringhe(i))
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(k).tipologia = extractAfter(ImagesPath(k).name,".");
        end
    end
end

% Associo alle immagini le etichette corrispondenti
for i=1:size(DB(z).database(1).dimensione(1).dominio(1).immagini(1).matrice,2)
    switch DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).tipologia
        case 'glasses'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta= 1; 
        case 'happy'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 2;
        case 'leftlight'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 3;
        case 'noglasses'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 4;
        case 'normal'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 5;
        case 'rightlight'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 6;
        case 'sad'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 7;
        case 'sleepy'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 8;
        case 'surprised'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 9;
        case 'wink'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 10;
        case 'centerlight'
            DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(i).etichetta = 11;
                  
    end
end

%% Ciclo for utile per creare le features per le immagini di riferimento e le totali
for c = 1 : 2
   % Function per le medie delle due parti
     diff_media = media_parti_rif(DB(z).database, size(DB(z).database(1).dimensione(1).dominio(1).immagini(c).matrice,2),a,b,c);
%Creo feature 
for i=1:size(DB(z).database(1).dimensione(1).dominio(1).immagini(c).matrice,2)
     %media
     DB(z).database(b).dimensione(a).dominio(2).immagini(c).matrice(i).tipo(1).feature =  mean(mean(DB(z).database(b).dimensione(a).dominio(1).immagini(c).matrice(i).matrice));
     %entropia
     DB(z).database(b).dimensione(a).dominio(2).immagini(c).matrice(i).tipo(2).feature = entropy(DB(z).database(b).dimensione(a).dominio(1).immagini(c).matrice(i).matrice);
     %media delle parti
     DB(z).database(b).dimensione(a).dominio(2).immagini(c).matrice(i).tipo(3).feature = diff_media(i);
     % simmetria
     DB(z).database(b).dimensione(a).dominio(2).immagini(c).matrice(i).tipo(4).feature = skewness(skewness(im2double(DB(z).database(b).dimensione(a).dominio(1).immagini(c).matrice(i).matrice)));
 %    DB(z).database(b).dimensione(a).dominio(2).immagini(c).matrice(i).tipo(5).feature = DB(z).database(b).dimensione(a).dominio(1).immagini(c).matrice(i).etichetta;

end
 end


% tolgo le 11 immagini di riferimento aggiugendo matrici nulle e creando
% così lista di immagini senza riferimento
for k=1:size(DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice,2)
  trovato = 0;
  for i=1:size(DB(z).database(1).dimensione(1).dominio(1).immagini(2).matrice,2)
      if DB(z).database(b).dimensione(a).dominio(1).immagini(2).matrice(i).matrice == DB(1).database(b).dimensione(a).dominio(1).immagini(1).matrice(k).matrice
          DB(z).database(b).dimensione(a).dominio(1).immagini(3).matrice(k).matrice = zeros(size( DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(k).matrice,2));
          %Metto a zero anche le features corrispondenti agli indici delle
          %immagini di riferimento
          DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(1).feature = 0;
          DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(2).feature = 0; 
          DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(3).feature = 0;
          DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(4).feature = 0;    
          
          trovato = 1;
          indici(i)=k;
      else
          if trovato == 0
          DB(z).database(b).dimensione(a).dominio(1).immagini(3).matrice(k).matrice = DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(k).matrice;
        %  DB(z).database(b).dimensione(a).dominio(1).immagini(3).matrice(k).tipologie = DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(k).tipologia;
        %  DB(z).database(b).dimensione(a).dominio(1).immagini(3).matrice(k).etichetta = DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(k).etichetta;
          end
      end
  end
end

% Calcolo le distanze tra le immagini (153) e i riferimenti
 for k= 1:size(DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice,2)
     if rank(im2double(DB(z).database(b).dimensione(a).dominio(1).immagini(3).matrice(k).matrice)) ~= 0
         for i= 1: size(DB(z).database(1).dimensione(1).dominio(1).immagini(2).matrice,2)
             % media e entropia
                 DB(z).database(b).dimensione(a).dominio(3).immagini(1).matrice(i,k) = ...
                     pdist([DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(1).feature,  DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(2).feature;...
                     DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(1).feature, DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(2).feature]);
             % media, entropia e  media parti  
                 DB(z).database(b).dimensione(a).dominio(3).immagini(2).matrice(i,k) = ...
                     pdist([DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(1).feature,DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(2).feature  ,DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(3).feature;...
                     DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(1).feature,DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(2).feature, DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(3).feature]);
             % entropia e media parti  
                 DB(z).database(b).dimensione(a).dominio(3).immagini(3).matrice(i,k) = ...
                     pdist([DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(2).feature,  DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(3).feature;...
                     DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(2).feature, DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(3).feature]);
             % media e media part  
                 DB(z).database(b).dimensione(a).dominio(3).immagini(4).matrice(i,k) = ...
                     pdist([DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(1).feature,  DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(3).feature;...
                     DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(1).feature, DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(3).feature]);
             % simmetria e media parti               
                 DB(z).database(b).dimensione(a).dominio(3).immagini(5).matrice(i,k) = ...
                     pdist([DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(4).feature,  DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(3).feature;...
                     DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(4).feature, DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(3).feature]);      
         end
         end
 end  

 %% Ciclo for per tutte le combinazioni di features (5)
 for d=1:5
 DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).counter=0;    
 %Etichetta calcolata = minima distanza con le immagini di riferimento
 for k= 1:size(DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice,2)
     if sum(DB(z).database(b).dimensione(a).dominio(3).immagini(5).matrice(:,k)) ~= 0
        [minimo,index] = min(DB(z).database(b).dimensione(a).dominio(3).immagini(d).matrice(:,k));
        DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(k).minimo = minimo;
        DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(k).etichetta_calcolata = index;
        DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(k).etichetta_vera = DB(z).database(b).dimensione(a).dominio(1).immagini(1).matrice(k).etichetta;
          
        if DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(k).etichetta_calcolata == ...
              DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(k).etichetta_vera
          % 1 se il classificatore ha restituito risultato corretto
            DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(k).gt=1;
          % Counter (traccia matrice di confusione)
            DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).counter =  DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).counter+1;
        else
          % 0 se il classificatore non ha restituito risultato corretto
            DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(k).gt=0;
        end
     end
 end
 %% Accuratezza
 % Calcolo accuratezza
 DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).accuratezza = (DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).counter / 153)*100;

 %% Matrice di confusione
 for j = 1 : 164
      if ~isempty(DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(j).etichetta_calcolata)
         etichetta_calcolata(j) = DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(j).etichetta_calcolata;
         etichetta_vera(j) = DB(z).database(b).dimensione(a).dominio(4).immagini(d).matrice(j).etichetta_vera;
      end
 
 end
  
% Calcolo matrice di confusione
 DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).matrice_confusione = ...
     confusionmat(etichetta_vera,etichetta_calcolata);
 DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).matrice_confusione =...
     DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).matrice_confusione(2:12,2:12);
   
 diagon = diag(DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).matrice_confusione);
        for i=1:size(DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).matrice_confusione,2)
            %calcolo recall
            DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).recall(i).recall = (diagon(i)/...
              sum(DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).matrice_confusione(i,:)));
            %calcolo precision
            DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).precision(i).precision = diagon(i)/...
              sum(DB(z).database(b).dimensione(a).dominio(5).immagini(d).matrice(1).matrice_confusione(:,i));
        end   
 end
  end
end
end