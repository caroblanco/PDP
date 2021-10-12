creeEn(gabriel,campanita).
creeEn(gabriel,magoDeOz).
creeEn(gabriel,cavenaghi).
creeEn(juan,conejoPascua).
creeEn(macarena,reyesMagos).
creeEn(macarena,magoCapria).
creeEn(macarena,campanita).

%cantante(discos).
%futbolista(equipo).
%loteria([numeros])

suenio(gabriel,loteria([5,9])).
suenio(gabriel,futbolista(arsenal)).
suenio(juan,cantante(100000)).
suenio(macarena,cantante(10000)).

chico(arsenal).
chico(aldosivi).

%PUNTO 2

criterio(Cantidad,6):-
    Cantidad > 500000.

criterio(Cantidad,4):-
    Cantidad =< 500000.

dificultad(cantante(Cantidad),Dificultad):-
    criterio(Cantidad,Dificultad).

dificultad(loteria(Numeros),Dificultad):-
    length(Numeros,Cant),
    Dificultad is Cant*10.

dificultad(futbolista(Equipo),Dificultad):-
    clasificacion(Equipo,Dificultad).

clasificacion(Equipo,3):-
    chico(Equipo).
clasificacion(Equipo,16):-
    not(chico(Equipo)).

ambiciosa(Persona):-
    suenio(Persona,_),
    findall(Dificultad,(suenio(Persona,Suenio),dificultad(Suenio,Dificultad)),Dificultades),
    sum_list(Dificultades, SumaTot),
    SumaTot > 20.

%PUNTO 3
tieneQuimica(Personaje,Persona):-
    creeEn(Persona,Personaje),
    criterioTieneQuimica(Personaje,Persona).

criterioTieneQuimica(campanita, Persona):-
    suenio(Persona,Suenio),
    dificultad(Suenio,Dificultad),
    Dificultad < 5.

criterioTieneQuimica(Personaje,Persona):-
    Personaje \= campanita,
    forall(suenio(Persona,Suenio),suenioPuro(Suenio)),
    not(ambiciosa(Persona)).

suenioPuro(futbolista(_)).
suenioPuro(cantante(Discos)):-
    Discos < 200000.

%PUNTO 4
amigue(campanita,reyesMagos).
amigue(reyesMagos,campanita).
amigue(conejoPascua,campanita).
amigue(campanita,conejoPascua).
amigue(conejoPascua,cavenaghi).
amigue(cavenaghi,conejoPascua).

enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoPascua).

puedeAlegrar(Personaje,Persona):-
    suenio(Persona,_),
    tieneQuimica(Personaje,Persona),
    personajeOBackUpNoEnfermos(Personaje).

personajeOBackUpNoEnfermos(Personaje):-
    not(enfermo(Personaje)).

personajeOBackUpNoEnfermos(Personaje):-
    personajeBackUp(Personaje, BackUp),
    not(enfermo(BackUp)).

personajeBackUp(Principal, BackUp):-
    amigue(Principal, Otro),
    personajeBackUp(Otro, BackUp).

personajeBackUp(Principal, BackUp):-
    amigue(Principal, BackUp).
