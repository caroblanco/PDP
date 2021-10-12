%vocaloid(nombre,cancion(nombre,duracion)).

vocaloid(megurineLuka,cancion(nightFever,4)).
vocaloid(megurineLuka,cancion(foreverYoung,5)).
vocaloid(hatsuneMiku,cancion(tellYourWorld,4)).
vocaloid(gumi,cancion(foreverYoung,4)).
vocaloid(gumi,cancion(tellYourWorld,5)).
vocaloid(seeU,cancion(novemberRain,6)).
vocaloid(seeU,cancion(nightFever,5)).

%PUNTO 1
esNovedoso(Vocaloid):-
    sabeDosCanciones(Vocaloid),
    duracionTotal(Vocaloid,Duraciones),
    Duraciones < 15.

sabeDosCanciones(Vocaloid):-
    vocaloid(Vocaloid,cancion(Cancion1,Duracion1)),
    vocaloid(Vocaloid,cancion(Cancion2,Duracion2)),
    Cancion1 \= Cancion2.

duracionTotal(Vocaloid,DuracionT):-
    findall(Duracion, vocaloid(Vocaloid, cancion(_,Duracion)), DuracionesL),
    sum_list(DuracionesL, Duraciones).

%PUNTO 2
esAcelerado(Vocaloid):-
    vocaloid(Vocaloid,cancion(_,Duracion)),
    not(Duracion > 4).

%concierto(nombre,pais,fama,tipo).
%gigante(cantMinSaber,duracionTotalMin).
%mediano(duracionTotalMaxima).
%pequenio(algunaDureMasQue)

concierto(mikuExpo, eeuu, 2000, gigante(2,6)).
concierto(magicalMirai, japon, 3000, gigante(3,10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, diminuto(4)).

%PUNTO 3
puedeParticipar(hatsuneMiku,Concierto):-
    concierto(Concierto,_,_,_).

puedeParticipar(Vocaloid,Concierto):-
    vocaloid(Vocaloid,_),
    Vocaloid \= hatsuneMiku,
    concierto(Concierto,_,_,Tipo),
    cumpleRequisitos(Tipo,Vocaloid).

cumpleRequisitos(grande(CantMin,DuracionTMin),Vocaloid):-
    cantidadCanciones(Vocaloid,CantCanciones),
    CantCanciones >= CantMin,
    duracionTotal(Vocaloid,DuracionT),
    DuracionT > DuracionTMin.

cumpleRequisitos(mediano(DuracionTMax),Vocaloid):-
    duracionTotal(Vocaloid,DuracionT),
    DuracionT < DuracionMAx.

cumpleRequisitos(pequenio(DuracionDeUna),Vocaloid):-
    vocaloid(Vocaloid,cancion(_,Duracion)),
    Duracion > DuracionDeUna.

cantidadCanciones(Vocaloid,CantCanciones):-
    findall(Cancion,vocaloid(Vocaloid,Cancion),CancionesL),
    length(CancionesL,CantCanciones).

%PUNTO 4
masFamoso(Vocaloid):-
    vocaloid(Vocaloid,_),
    nivelFama(Vocaloid,NivelFama),
    forall((vocaloid(Otro,_),Otro\=Vocaloid,nivelFama(Otro,NivelFamaO)),NivelFama>NivelFamaO).

nivelFama(Vocaloid,NivelFama):-
    findall(PuntosFama,(concierto(Concierto,_,PuntosFama,_),puedeParticipar(Vocaloid,Concierto)),ListaPuntos),
    sum_list(ListaPuntos, PuntosT),
    cantidadCanciones(Vocaloid,CantidadCanciones),
    NivelFama is PuntosT * CantidadCanciones.

%PUNTO 5
conoce(megurineLuka,hatsuneMiku).
conoce(megurineLuka,gumi).
conoce(gumi,seeU).
conoce(seeU,kaito).

conoceA(Uno,Otro):-
    conoce(Uno,Otro).
conoceA(Uno,Otro):-
    conoce(Otro,Uno).

esElUnico(Vocaloid,Concierto):-
    puedeParticipar(Vocaloid,Concierto),
    not((conocidos(Vocaloid,Otro),puedeParticipar(Otro,Concierto))).

conocidos(Vocaloid,Otro):-
    conoceA(Vocaloid,Otro).

conocidos(Vocaloid,Otro):-
    conoceA(Vocaloid,Intermedio),
    conocidos(Intermedio,Otro).

%PUNTO 5
/*
habria que agregar una nueva clausula para cumpleRequisitos donde se tenga en cuenta el nuevo tipo con sus requititos.
El concepto que facilita los cambios para el nuevo requerimiento es el polimorfismo, que nos permite dar un tratamiento 
en particular a cada uno de los conciertos en la cabeza de la cláusula.
*/