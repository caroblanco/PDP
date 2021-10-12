% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(sam, jessie, 3).

% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa, caraDePapa([original(pieIzquierdo),original(pieDerecho),repuesto(nariz)])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1,[sombrero])).
% Dice si una persona es coleccionista
esColeccionista(sam).

%PUNTO 1

tematica(Juguete,Tematica):-
    juguete(Juguete,Tipo),
    tipo(Tipo,Tematica).

tipo(deTrapo(Tematica),Tematica).
tipo(deAccion(Tematica,_),Tematica).
tipo(miniFiguras(Tematica,_),Tematica).
tipo(caraDePapa(_),caraDePapa).

esDePlastico(Juguete):-
    juguete(Juguete,Tipo),
    cumplePlastico(Tipo).

cumplePlastico(miniFiguras(_,_)).
cumplePlastico(caraDePapa(_)).

esDeColeccion(Juguete):-
    juguete(Juguete,Tipo),
    cumpleColeccion(Tipo).

cumpleColeccion(deTrapo(_)).
cumpleColeccion(deAccion(Tipo,Accesorios)):-
    esRaro(deAccion(Tipo,Accesorios)).
cumpleColeccion(caraDePapa(Accesorios)):-
    esRaro(caraDePapa(Accesorios)).

%PUNTO 2
amigoFiel(Duenio,Juguete):-
    juguete(Juguete,_),
    not(esDePlastico(Juguete)),
    duenio(Duenio,Juguete,Tiempo),
    forall((duenio(Duenio,Otro,TiempoO),Otro\=Juguete),Tiempo>TiempoO).

%PUNTO 3
superValioso(Juguete):-
    juguete(Juguete,Tipo),
    esDeColeccion(Juguete),
    not((duenio(Duenio,Juguete,_),esColeccionista(Duenio))),
    cumpleValioso(Tipo).

cumpleValioso(deTrapo(_)).
cumpleValioso(caraDePapa(Piezas)):-
    todasOriginales(Piezas).
cumpleValioso(deAccion(_,Piezas)):-
    todasOriginales(Piezas).

todasOriginales(Piezas):-
    not((member(Pieza,Piezas),Pieza==repuesto(_))).
    %forall(member(Pieza,Piezas),Pieza==original(_)).

%PUNTO 4
duoDinamico(Duenio,Juguete1,Juguete2):-
    juguete(Juguete1,_),
    juguete(Juguete2,_),
    Juguete2 \= Juguete1,
    duenio(Duenio,Juguete1,_),
    duenio(Duenio,Juguete2,_),
    hacenBuenaPareja(Juguete1,Juguete2).

hacenBuenaPareja(Juguete1,Juguete2):-
    tematica(Juguete1,Tematica),
    tematica(Juguete2,Tematica).

hacenBuenaPareja(woody,buzz).
hacenBuenaPareja(buzz,woody).

%PUNTO 5
felicidad(Duenio,Felicidad):-
    duenio(Duenio,_,_),
    findall(Felicidad,(duenio(Duenio,Juguete,_),puntos(Juguete,Felicidad)),Felicidades),
    sum_list(Felicidades, Felicidad).

puntos(Juguete,Felicidad):-
    juguete(Juguete,miniFiguras(_,Cantidad)),
    Felicidad is 20*Cantidad.
puntos(Juguete,Felicidad):-
    juguete(Juguete,caraDePapa(Piezas)),
    findall(PiezaO,(member(PiezaO,Piezas),PiezaO==original(_)),PiezasO),
    findall(PiezaR,(member(PiezaR,Piezas),PiezaR==repuesto(_)),PiezasR),
    length(PiezasO, CantO),
    length(PiezasR, CantR),
    Felicidad is CantO*5 + CantR*8.
puntos(Juguete,100):-
    juguete(Juguete,deTrapo(_)).
puntos(Juguete,Felicidad):-
    juguete(Juguete,deAccion(_,_)),
    cumpleCondiciones(Juguete,Felicidad).

cumpleCondiciones(Juguete,120):-
    esDeColeccion(Juguete),
    duenio(Duenio,Juguete,_),
    esColeccionista(Duenio).

cumpleCondiciones(Juguete,100):-
    not(esDeColeccion(Juguete)).
cumpleCondiciones(Juguete,100):-
    duenio(_,Juguete,_),
    not(esColeccionista(Juguete)).

%PUNTO 6
puedeJugarCon(Alguien,Juguete):-
    juguete(Juguete,_),
    cumpleCondicionesPuedeJugar(Alguien,Juguete).

cumpleCondicionesPuedeJugar(Alguien,Juguete):-
    duenio(Alguien,Juguete,_).

cumpleCondicionesPuedeJugar(Alguien,Juguete):-
    puedeJugarCon(Otro,Juguete),
    puedePrestarle(Otro,Alguien).

puedePrestarle(Otro,Alguien):-
    cantidadJuguetes(Otro,CantO),
    cantidadJuguetes(Alguien,CantA),
    CantO>CantA.

cantidadJuguetes(Duenio,Cantidad):-
    duenio(Duenio,_,_),
    findall(Juguete,duenio(Duenio,Juguete,_),Juguetes),
    length(Juguetes,Cantidad).

%PUNTO 7
podriaDonar(Duenio,Juguetes,Felicidad):-
    duenio(Duenio,_,_),
    findall(Felicidad,(member(Juguete,Juguetes),puntos(Juguete,Felicidad)),Felicidades),
    sum_list(Felicidades, FelicidadJ),
    FelicidadJ<Felicidad.

%PUNTO 8
/*
se aprovecha en tematica,super valioso y en felicidad.
*/