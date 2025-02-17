

/*
INTERFAZ GRAFICA: Esta parte del sistema experto es la que se encarga de
interactuar con la persona comun, mostrar imagenes, botones, textos, etc.

INICIAR SISTEMA EXPERTO:
PARA CORRER EL PROGRAMA, ES NESESARIO CARGAR LAS 3 PARTES AL SWI PROLOG
Y LUEGO SOLO CONSULTAR TODO, AUTOMATICAMENTE SE ABRIRA LA VENTANA DEL PROGRAMA
*/
 :- use_module(library(pce)).
 :- pce_image_directory('./imagenes').
 :- use_module(library(pce_style_item)).
 :- dynamic color/2.

 resource(img_principal, image, image('img_principal.jpg')).
 resource(portada, image, image('portada.jpg')).
 resource(periodontitis, image, image('trat_periodontitis.jpg')).
 resource('pulpa daniada y viva reversiblemente', image, image('trat_pulpa daniada y viva reversiblemente.jpg')).
 resource('pulpa daniada y viva irreversiblemente', image, image('trat_pulpa daniada y viva irreversiblemente.jpg')).
 resource('pulpa muerta', image, image('trat_pulpa muerta.jpg')).
 resource('fractura horizontal sin pulpa implicada', image, image('trat_fractura horizontal sin pulpa implicada.jpg')).
 resource(lo_siento_diagnostico_desconocido, image, image('desconocido.jpg')).
 resource('fractura horizontal con pulpa implicada', image, image('trat_fractura horizontal con pulpa implicada.jpg')).
 resource('fractura oblicua sin pulpa implicada', image, image('trat_fractura oblicua sin pulpa implicada.jpg')).
 resource('fractura oblicua con pulpa implicada', image, image('trat_fractura oblicua con pulpa implicada.jpg')).

%RECURSOS PARA LAS IMAGENES DE PREGUNTAS
%
 resource('diente con fisuras', image, image('diente con fisuras.jpg')).
 resource('diente con caries grandes', image, image('diente con caries grandes.jpg')).
 resource('el diente se mueve', image, image('el diente se mueve.jpg')).
 resource('perdida de masa osea', image, image('perdida de masa osea.jpg')).
 resource('dolor agudo desde hace 7 dias', image, image('dolor agudo desde hace 7 dias.jpg')).
 resource('dolor a la percusion vertical', image, image('dolor a la percusion vertical.jpg')).
 resource('dolor a la percusion horizontal', image, image('dolor a la percusion horizontal.jpg')).
 resource('dolor al poner aire frio al diente', image, image('dolor al poner aire frio al diente.jpg')).
 resource('dolor a la palpacion apical', image, image('dolor a la palpacion apical.jpg')).
 resource('diente fracturado oblicuamente', image, image('diente fracturado oblicuamente.jpg')).
 resource('la pulpa esta expuesta', image, image('la pulpa esta expuesta.jpg')).


 mostrar_imagen(Pantalla, Imagen) :- new(Figura, figure),
                                     new(Bitmap, bitmap(resource(Imagen),@on)),
                                     send(Bitmap, name, 1),
                                     send(Figura, display, Bitmap),
                                     send(Figura, status, 1),
                                     send(Pantalla, display,Figura,point(100,80)).
  mostrar_imagen_tratamiento(Pantalla, Imagen) :-new(Figura, figure),
                                     new(Bitmap, bitmap(resource(Imagen),@on)),
                                     send(Bitmap, name, 1),
                                     send(Figura, display, Bitmap),
                                     send(Figura, status, 1),
                                     send(Pantalla, display,Figura,point(20,100)).
 nueva_imagen(Ventana, Imagen) :-new(Figura, figure),
                                new(Bitmap, bitmap(resource(Imagen),@on)),
                                send(Bitmap, name, 1),
                                send(Figura, display, Bitmap),
                                send(Figura, status, 1),
                                send(Ventana, display,Figura,point(0,0)).
  imagen_pregunta(Ventana, Imagen) :-new(Figura, figure),
                                new(Bitmap, bitmap(resource(Imagen),@on)),
                                send(Bitmap, name, 1),
                                send(Figura, display, Bitmap),
                                send(Figura, status, 1),
                                send(Ventana, display,Figura,point(500,60)).
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
  botones:-borrado,
                send(@boton, free),
                send(@btntratamiento,free),
                mostrar_diagnostico(Enfermedad),
                send(@texto, selection('El Diagnostico a partir de los datos es:')),
                send(@resp1, selection(Enfermedad)),
                new(@boton, button('Iniciar consulta',
                message(@prolog, botones)
                )),

                new(@btntratamiento,button('Detalles y Tratamiento',
                message(@prolog, mostrar_tratamiento,Enfermedad)
                )),
                send(@main, display,@boton,point(20,450)),
                send(@main, display,@btntratamiento,point(138,450)).



  mostrar_tratamiento(X):-new(@tratam, dialog('Tratamiento')),
                          send(@tratam, append, label(nombre, 'Explicacion: ')),
                          send(@tratam, display,@lblExp1,point(70,51)),
                          send(@tratam, display,@lblExp2,point(50,80)),
                          tratamiento(X),
                          send(@tratam, transient_for, @main),
                          send(@tratam, open_centered).

tratamiento(X):- send(@lblExp1,selection('De Acuerdo Al Diagnostico El Tratamiento Es:')),
                 mostrar_imagen_tratamiento(@tratam,X).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   preguntar(Preg,Resp):-new(Di,dialog('Colsultar Datos:')),
                        new(L2,label(texto,'Responde las siguientes preguntas')),
                        id_imagen_preg(Preg,Imagen),
                        imagen_pregunta(Di,Imagen),
                        new(La,label(prob,Preg)),
                        new(B1,button(si,and(message(Di,return,si)))),
                        new(B2,button(no,and(message(Di,return,no)))),
                        send(Di, gap, size(25,25)),
                        send(Di,append(L2)),
                        send(Di,append(La)),
                        send(Di,append(B1)),
                        send(Di,append(B2)),
                        send(Di,default_button,'si'),
                        send(Di,open_centered),get(Di,confirm,Answer),
                        free(Di),
                        Resp=Answer.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  interfaz_principal:-new(@main,dialog('Sistema Experto - Odontologo',
        size(1000,1000))),
        new(@texto, label(nombre,'El Diagnostico a partir de los datos es:',font('times','roman',18))),
        new(@resp1, label(nombre,'',font('times','roman',22))),
        new(@lblExp1, label(nombre,'',font('times','roman',14))),
        new(@lblExp2, label(nombre,'',font('times','roman',14))),
        new(@salir,button('SALIR',and(message(@main,destroy),message(@main,free)))),
        new(@boton, button('Iniciar consulta',message(@prolog, botones))),

        new(@btntratamiento,button('¿Tratamiento?')),

        nueva_imagen(@main, img_principal),
        send(@main, display,@boton,point(138,450)),
        send(@main, display,@texto,point(20,130)),
        send(@main, display,@salir,point(300,450)),
        send(@main, display,@resp1,point(20,180)),
        send(@main,open_centered).

       borrado:- send(@resp1, selection('')).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  crea_interfaz_inicio:- new(@interfaz,dialog('Bienvenido al Sistema Experto Diagnosticador',
  size(1000,1000))),

  mostrar_imagen(@interfaz, portada),

  new(BotonComenzar,button('COMENZAR',and(message(@prolog,interfaz_principal) ,
  and(message(@interfaz,destroy),message(@interfaz,free)) ))),
  new(BotonSalir,button('SALIDA',and(message(@interfaz,destroy),message(@interfaz,free)))),
  send(@interfaz,append(BotonComenzar)),
  send(@interfaz,append(BotonSalir)),
  send(@interfaz,open_centered).

  :-crea_interfaz_inicio.

/* BASE DE CONOCIMIENTOS:
el identificador de imagenes de acuerdo al  sintoma
*/
conocimiento('fractura oblicua con pulpa implicada',
['diente con fisuras', 'diente fracturado oblicuamente',
'la pulpa esta expuesta']).

conocimiento('fractura oblicua sin pulpa implicada',
['diente con fisuras', 'diente fracturado oblicuamente']).

conocimiento('fractura horizontal con pulpa implicada',
['diente con fisuras', 'la pulpa esta expuesta']).

conocimiento('fractura horizontal sin pulpa implicada',
['diente con fisuras']).

conocimiento('pulpa muerta',
['diente con caries grandes', 'dolor agudo desde hace 7 dias',
 'dolor a la percusion vertical','dolor a la percusion horizontal',
 'dolor a la palpacion apical']).

conocimiento('pulpa daniada y viva irreversiblemente',
['diente con caries grandes', 'dolor agudo desde hace 7 dias',
'dolor a la percusion horizontal', 'dolor al poner aire frio al diente']).

conocimiento('pulpa daniada y viva reversiblemente',
['diente con caries grandes', 'dolor agudo desde hace 7 dias',
'dolor al poner aire frio al diente']).

conocimiento('periodontitis',
['el diente se mueve', 'perdida de masa osea']).


id_imagen_preg('diente con fisuras','diente con fisuras').
id_imagen_preg('diente con caries grandes','diente con caries grandes').
id_imagen_preg('el diente se mueve','el diente se mueve').
id_imagen_preg('perdida de masa osea','perdida de masa osea').
id_imagen_preg('dolor agudo desde hace 7 dias','dolor agudo desde hace 7 dias').
id_imagen_preg('dolor a la percusion vertical','dolor a la percusion vertical').
id_imagen_preg('dolor a la percusion horizontal','dolor a la percusion horizontal').
id_imagen_preg('dolor al poner aire frio al diente','dolor al poner aire frio al diente').
id_imagen_preg('dolor a la palpacion apical','dolor a la palpacion apical').
id_imagen_preg('diente fracturado oblicuamente','diente fracturado oblicuamente').
id_imagen_preg('la pulpa esta expuesta','la pulpa esta expuesta').

 /* MOTOR DE INFERENCIA: Esta parte del sistema experto se encarga de
 inferir cual es el diagnostico a partir de las preguntas realizadas
 */
:- dynamic conocido/1.

  mostrar_diagnostico(X):-haz_diagnostico(X),clean_scratchpad.
  mostrar_diagnostico(lo_siento_diagnostico_desconocido):-clean_scratchpad .

  haz_diagnostico(Diagnosis):-
                            obten_hipotesis_y_sintomas(Diagnosis, ListaDeSintomas),
                            prueba_presencia_de(Diagnosis, ListaDeSintomas).


obten_hipotesis_y_sintomas(Diagnosis, ListaDeSintomas):-
                            conocimiento(Diagnosis, ListaDeSintomas).


prueba_presencia_de(Diagnosis, []).
prueba_presencia_de(Diagnosis, [Head | Tail]):- prueba_verdad_de(Diagnosis, Head),
                                              prueba_presencia_de(Diagnosis, Tail).


prueba_verdad_de(Diagnosis, Sintoma):- conocido(Sintoma).
prueba_verdad_de(Diagnosis, Sintoma):- not(conocido(is_false(Sintoma))),
pregunta_sobre(Diagnosis, Sintoma, Reply), Reply = 'si'.


pregunta_sobre(Diagnosis, Sintoma, Reply):- preguntar(Sintoma,Respuesta),
                          process(Diagnosis, Sintoma, Respuesta, Reply).


process(Diagnosis, Sintoma, si, si):- asserta(conocido(Sintoma)).
process(Diagnosis, Sintoma, no, no):- asserta(conocido(is_false(Sintoma))).


clean_scratchpad:- retract(conocido(X)), fail.
clean_scratchpad.


conocido(_):- fail.

not(X):- X,!,fail.
not(_).
