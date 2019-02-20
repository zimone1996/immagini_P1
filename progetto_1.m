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

 %vettore features 
 if a==1 && z == 1 && b == 1% 16x16
      v_16_spazio(:,i)=[DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(1).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(2).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(3).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(4).feature];
 end
if  z == 1 && b == 1 && a==2
      v_16_frequenza(:,i)=[DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(1).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(2).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(3).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(4).feature];
 end      
 
  
 if  z == 1 && b == 2 && a ==1
      v_32_spazio(:,i) = [DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(1).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(2).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(3).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(4).feature];
  
 end 
  if  z == 1 && b == 2 && a ==2
     v_32_frequenza(:,i) = [DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(1).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(2).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(3).feature;
      DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(i).tipo(4).feature];
         
    end
     
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
             % simmetria e entropia               
                 DB(z).database(b).dimensione(a).dominio(3).immagini(5).matrice(i,k) = ...
                     pdist([DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(4).feature,  DB(z).database(b).dimensione(a).dominio(2).immagini(1).matrice(k).tipo(2).feature;...
                     DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(4).feature, DB(z).database(b).dimensione(a).dominio(2).immagini(2).matrice(i).tipo(2).feature]);      
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

%calcolo vaianza delle features
for i= 1 : 4
    varianza_16_spazio(i) = var(v_16_spazio(i,:));
    varianza_16_frequenza(i) = var(v_16_frequenza(i,:));
    varianza_32_spazio(i) = var(v_32_spazio(i,:));
    varianza_32_frequenza(i) = var(v_32_frequenza(i,:));
end
    

%%istogramma varianza features
figure
bar([varianza_16_spazio; varianza_32_spazio; varianza_16_frequenza; varianza_32_frequenza]);
xticklabels({'16x16 spazio','32x32 spazio','16x16 frequenza','32x32 frequenza'});
legend({'Media','Entropia','Media Parti','Asimmetria'});


%% Risultati P1
%%                             16x16 SPAZIO entropia e media parti
%% counter e accuratezza
for z=1:5
    %in questa maniera prendo il counter di quella coppia di feature (
    %entropia e media_parti) tutti i rumori 
    vettore_counter(z) = DB(z).database(1).dimensione(1).dominio(5).immagini(3).matrice.counter;
    vettore_accuracy(z) = DB(z).database(1).dimensione(1).dominio(5).immagini(3).matrice.accuratezza;
end

media_counter = mean(vettore_counter);
media_accuracy = mean(vettore_accuracy);
std_counter = std(vettore_counter);
std_accuracy = std(vettore_accuracy);

%% recall e precision
%creiamo matrice con tutte le recall
for z= 1:5
    for i= 1:11
       matrice_recall(i,z) = DB(z).database(1).dimensione(1).dominio(5).immagini(3).matrice.recall(i).recall;
       matrice_precision(i,z) = DB(z).database(1).dimensione(1).dominio(5).immagini(3).matrice.precision(i).precision;
    end
end

media_recall = mean(matrice_recall,2)*100;
media_precision = mean(matrice_precision,2)*100;
std_recall = std(matrice_recall,0,2)*100;
std_precision = std(matrice_precision,0,2)*100;




%%                             32x32 SPAZIO entropia e media parti
%% counter e accuratezza
for z=1:5
    %in questa maniera prendo il counter di quella coppia di feature (
    %entropia e media_parti) tutti i rumori 
    vettore_counter_32s(z) = DB(z).database(2).dimensione(1).dominio(5).immagini(3).matrice.counter;
    vettore_accuracy_32s(z) = DB(z).database(2).dimensione(1).dominio(5).immagini(3).matrice.accuratezza;
end

media_counter_32s = mean(vettore_counter_32s)*100;
media_accuracy_32s = mean(vettore_accuracy_32s)*100;
std_counter_32s = std(vettore_counter_32s)*100;
std_accuracy_32s = std(vettore_accuracy_32s)*100;

%% recall e precision
%creiamo matrice con tutte le recall
for z= 1:5
    for i= 1:11
       matrice_recall_32s(i,z) = DB(z).database(2).dimensione(1).dominio(5).immagini(3).matrice.recall(i).recall;
       matrice_precision_32s(i,z) = DB(z).database(2).dimensione(1).dominio(5).immagini(3).matrice.precision(i).precision;
    end
end

media_recall_32s = mean(matrice_recall_32s,2)*100;
media_precision_32s = mean(matrice_precision_32s,2)*100;
std_recall_32s = std(matrice_recall_32s,0,2)*100;
std_precision_32s = std(matrice_precision_32s,0,2)*100;



%%                            16x16 FREQUENZA Simmetria e Entropia
%% counter e accuratezza recall e precision
for z = 1 : 5 
   %migliore simmetria e entropia
    vettore_counter_16f(z) = DB(z).database(1).dimensione(2).dominio(5).immagini(5).matrice.counter;
    vettore_accuracy_16f(z) = DB(z).database(1).dimensione(2).dominio(5).immagini(5).matrice.accuratezza;
    for j = 1 : 11
        matrice_recall_16f(j,z) = DB(z).database(1).dimensione(2).dominio(5).immagini(5).matrice.recall(j).recall;
        matrice_precision_16f(j,z) = DB(z).database(1).dimensione(2).dominio(5).immagini(5).matrice.precision(j).precision;
    end
end

media_accuracy_16f = mean(vettore_accuracy_16f)*100;
media_counter_16f = mean(vettore_counter_16f)*100;
std_counter_16f = std(vettore_counter_16f)*100;
std_accuracy_16f = std(vettore_accuracy_16f)*100;

 media_recall_16f =  mean(matrice_recall_16f,2)*100;
 std_recall_16f = std(matrice_recall_16f,0,2)*100;    
 media_precision_16f = mean(matrice_precision_16f,2)*100;
 std_precision_16f= std(matrice_precision_16f,0,2)*100;


 
%%                            32x32 FREQUENZA Simmetria e Entropia

for z = 1 : 5 
   %migliore simmetria e entropia
    vettore_counter_32f(z) = DB(z).database(2).dimensione(2).dominio(5).immagini(5).matrice.counter;
    vettore_accuracy_32f(z) = DB(z).database(2).dimensione(2).dominio(5).immagini(5).matrice.accuratezza;
    for j = 1 : 11
        matrice_recall_32f(j,z) = DB(z).database(2).dimensione(2).dominio(5).immagini(5).matrice.recall(j).recall;
        matrice_precision_32f(j,z) = DB(z).database(2).dimensione(2).dominio(5).immagini(5).matrice.precision(j).precision;
    end
end

media_accuracy_32f = mean(vettore_accuracy_32f)*100;
media_counter_32f = mean(vettore_counter_32f)*100;
std_counter_32f = std(vettore_counter_32f)*100;
std_accuracy_32f = std(vettore_accuracy_32f)*100;

media_recall_32f =  mean(matrice_recall_32f,2)*100;
std_recall_32f = std(matrice_recall_32f,0,2)*100;    
media_precision_32f = mean(matrice_precision_32f,2)*100;
std_precision_32f= std(matrice_precision_32f,0,2)*100;

%grafici
% counter
figure
x=1:1:4;
y=[media_counter media_counter_32s media_counter_16f media_counter_32f];
err = [std_counter std_counter_32s std_counter_16f std_counter_32f];
scatter(x,y,'o','b','LineWidth', 2)
hold on
errorbar(x,y,err,'.r')
grid on
xlim([0 5])
ylim([0 164])
title('N° etichette corrette per feature migliore')
ylabel('N° di etichette stimate correttamente')
legend({'Media','deviazione standard'})
xticks(0:1:5)
yticks(0:10:164)
xticklabels({' ','16x16 spazio e_ mp','32x32 spazio e_ mp','16x16 frequenza s_ e','32x32 frequenza s_ e'})
xtickangle(45)

%accuracy
figure
x=1:1:4 ;
y=[media_accuracy media_accuracy_32s media_accuracy_16f media_accuracy_32f ];
err1 = [std_accuracy std_accuracy_32s std_accuracy_16f std_accuracy_32f];
scatter(x,y,'o','b','LineWidth', 2)
hold on
errorbar(x,y,err1,'.r')
grid on
xlim([0 5])
ylim([0 100])
title('Accuracy della feature migliore')
ylabel('Accuratezza [%]')
legend({'Media','deviazione standard'})
xticks(0:1:5)
yticks(0:10:100)
xticklabels({' ','16x16 spazio e_ mp','32x32 spazio e_ mp','16x16 frequenza s_ e', '32x32 frequenza s_ e' })
xtickangle(45)


%% 16x16 SPAZIO entropia e media parti
%recall per tutte e 11
figure
x=1:1:11;
scatter(x,media_recall,'o','b','LineWidth', 2)
hold on
errorbar(x,media_recall,std_recall,'.r')
grid on
legend({'Media','deviazione standard'})
xlim([0 12])
title({'Recall della feature entropia e media parti';'16x16 spazio'})
ylabel('Recall')
xticks(0:1:12)
xticklabels({' ','glasses','happy','leftlight','noglasses','normal','rightlight','sad','sleepy',...
    'surprised','wink','centerlight',' '})
xtickangle(45)

%precision per tutte e 11
figure
x=1:1:11;
scatter(x,media_precision,'o','b','LineWidth', 2)
hold on
errorbar(x,media_precision,std_precision,'.r')
grid on
legend({'Media','deviazione standard'})
xlim([0 12])
title({'Precision della feature entropia e media parti';'16x16 spazio'})
ylabel('Precision')
xticks(0:1:12)
xticklabels({' ','glasses','happy','leftlight','noglasses','normal','rightlight','sad','sleepy',...
    'surprised','wink','centerlight',' '})
xtickangle(45)

%% 32x32 SPAZIO entropia e media parti
%recall per tutte e 11
figure
x=1:1:11;
scatter(x,media_recall_32s,'o','b','LineWidth', 2)
hold on
errorbar(x,media_recall_32s,std_recall_32s,'.r')
grid on
legend({'Media','deviazione standard'})
xlim([0 12])
title({'Recall della feature entropia e media parti';'32x32 spazio'})
ylabel('Recall')
xticks(0:1:12)
xticklabels({' ','glasses','happy','leftlight','noglasses','normal','rightlight','sad','sleepy',...
    'surprised','wink','centerlight',' '})
xtickangle(45)

%precision per tutte e 11
figure
x=1:1:11;
scatter(x,media_precision_32s,'o','b','LineWidth', 2)
hold on
errorbar(x,media_precision_32s,std_precision_32s,'.r')
grid on
legend({'Media','deviazione standard'})
xlim([0 12])
title({'Precision della feature entropia e media parti';'32x32 spazio'})
ylabel('Precision')
xticks(0:1:12)
xticklabels({' ','glasses','happy','leftlight','noglasses','normal','rightlight','sad','sleepy',...
    'surprised','wink','centerlight',' '})
xtickangle(45)

%% 16x16 FREQUENZA Simmetria e Entropia
%recall per tutte e 11
figure
x=1:1:11;
scatter(x,media_recall_16f,'o','b','LineWidth', 2)
hold on
errorbar(x,media_recall_16f,std_recall_16f,'.r')
grid on
legend({'Media','deviazione standard'})
xlim([0 12])
title({'Recall della feature simmetria e entropia';'16x16 frequenza'})
ylabel('Recall')
xticks(0:1:12)
xticklabels({' ','glasses','happy','leftlight','noglasses','normal','rightlight','sad','sleepy',...
    'surprised','wink','centerlight',' '})
xtickangle(45)

figure
%precision per tutte e 11
x=1:1:11;
scatter(x,media_precision_16f,'o','b','LineWidth', 2)
hold on
errorbar(x,media_precision_16f,std_precision_16f,'.r')
grid on
legend({'Media','deviazione standard'})
xlim([0 12])
title({'Precision della feature simmetria e entropia';'16x16 frequenza'})
ylabel('Precision')
xticks(0:1:12)
xticklabels({' ','glasses','happy','leftlight','noglasses','normal','rightlight','sad','sleepy',...
    'surprised','wink','centerlight',' '})
xtickangle(45)

%% 32x32 FREQUENZA Simmetria e Entropia
%recall per tutte e 11
figure
x=1:1:11;
scatter(x,media_recall_32f,'o','b','LineWidth', 2)
hold on
errorbar(x,media_recall_32f,std_recall_32f,'.r')
grid on
legend({'Media','deviazione standard'})
xlim([0 12])
title({'Recall della feature simmetria e entropia';'32x32 frequenza'})
ylabel('Recall')
xticks(0:1:12)
xticklabels({' ','glasses','happy','leftlight','noglasses','normal','rightlight','sad','sleepy',...
    'surprised','wink','centerlight',' '})
xtickangle(45)

%precision per tutte e 11
figure
x=1:1:11;
scatter(x,media_precision_32f,'o','b','LineWidth', 2)
hold on
errorbar(x,media_precision_32f,std_precision_32f,'.r')
grid on
legend({'Media','deviazione standard'})
xlim([0 12])
title({'Precision della feature simmetria e entropia';'32x32 frequenza'})
ylabel('Precision')
xticks(0:1:12)
xticklabels({' ','glasses','happy','leftlight','noglasses','normal','rightlight','sad','sleepy',...
    'surprised','wink','centerlight',' '})
xtickangle(45)



