odiaA(harry,slytherin).
odiaA(draco,hufflepuff).
odiaA(hermione,_).

mago(harry).
mago(draco).
mago(hermione).
mago(ron).

caracteristicas(harry,coraje).
caracteristicas(harry, amistad).
caracteristicas(harry,orgullo).
caracteristicas(harry,inteligencia).
caracteristicas(draco,inteligencia).
caracteristicas(draco,orgullo).
caracteristicas(hermione,inteligencia).
caracteristicas(hermione,orgullo).
caracteristicas(hermione,responsabilidad).

sangre(harry,mestiza).
sangre(draco,pura).
sangre(hermione,impura).

casa(gryffindor,coraje).
casa(slytherin,orgullo).
casa(slytherin,inteligencia).
casa(ravenclaw,inteligencia).
casa(ravenclaw,responsabilidad).
casa(hufflepuff,amistad).

%SOMBRERO SELECCIONADOR
puedeEntrar(Casa, _):-
    Casa \= slytherin.

puedeEntrar(slytherin,Mago):-
    sangre(Mago,Sangre),
    Sangre\=impura.

caracterApropiado(Mago,Casa):-
    %mago(Mago),
    casa(Casa,Caracteristica),
    caracteristicas(Mago,Caracteristica).


puedeQuedarEn(Casa,Mago):-
    %mago(Mago),
    %casa(Casa,_),
    caracterApropiado(Mago,Casa),
    not(odiaA(Mago,Casa)),
    puedeEntrar(Casa,Mago).

puedeQuedarEn(gryffindor,hermione).

cadenaDeAmistades([],_).
cadenaDeAmistades([X|Y],Casa):-
    mago(X),
    caracteristicas(X,amistad),
    puedeQuedarEn(Casa,X),
    cadenaDeAmistades(Y,Casa).

%PARTE DOS

accion(harry,mala(fueraDeCama,-50)).
accion(harry,mala(fueBosque,-50)).
accion(harry,mala(fueTercerPiso,-75)).
accion(hermione,mala(fueTercerPiso,-75)).
accion(hermione,mala(fueSeccionRestringida,-10)).

accion(draco,neutral(fueMazmorra,0)).

accion(hermione,respondio(dondeEncuentroBezoar,20,snape)).
accion(hermione,respondio(levitarPluma,25,flitwick)).
accion(ron,buena(ganoAjedrez,50)).
accion(hermione,buena(salvoAmigos,50)).
accion(harry,buena(ganoAVoldemort,60)).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).


buenAlumno(Mago):-
    mago(Mago),
    not(accion(Mago,mala(_,_))),
    accion(Mago,_).

esRecurrente(Accion):-
    accion(Mago, Accion),
    accion(OtroMago, Accion),
    Mago \= OtroMago.

puntajeTotal(Casa,Puntaje):-
    findall(Puntaje,(esDe(Mago,Casa),accion(Mago,Accion),puntaje(Accion,Puntaje)),Puntajes),
    sumlist(Puntajes, Puntaje).
    
puntaje(mala(_,Puntaje),Puntaje).
puntaje(buena(_,Puntaje),Puntaje).
puntaje(respondio(_,Dificultad,snape),Puntaje):-
    Puntaje is Dificultad / 2.
puntaje(respondio(_,Dificultad,Profesor),Dificultad):-
    Profesor \= snape.

casaGanadora(Casa):-
    casa(Casa,_),
    forall((casa(OtraCasa,_),OtraCasa\=Casa,puntaje(OtraCasa,OtroPuntaje)),(puntaje(Casa,Puntaje), Puntaje>OtroPuntaje)).
