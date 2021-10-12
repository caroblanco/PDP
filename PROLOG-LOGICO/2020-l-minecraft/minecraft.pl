jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

%PUNTO 1 
tieneItem(Jugador,Item):-
    jugador(Jugador,Cosas,_),
    member(Item,Cosas).

sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador,Items,_),
    tieneItemComestible(I1,Items),
    tieneItemComestible(I2,Items),
    I1 \= I2.

tieneItemComestible(Comestible,Items):-
    comestible(Comestible),
    member(Comestible,Items).

cantidadDeItem(Jugador,Item,Cant):-
    tieneItem(_,Item),
    jugador(Jugador,Cosas,_),
    findall(Item,member(Item,Cosas),CantidadCosas),
    length(CantidadCosas,Cant).

tieneMasDe(Jugador,Item):-
    jugador(Jugador,_,_),
    cantidadDeItem(Jugador,Item,CantJ),
    forall((jugador(Otro,_,_),cantidadDeItem(Otro,Item,CantOtro),Otro \= Jugador), CantJ > CantOtro).

%PUNTO 2

hambriento(Jugador):-
    jugador(Jugador,_,Hambre),
    between(0,4,Hambre).

hayMonstruos(Lugar):-
    lugar(Lugar,_,Nivel),
    between(7, 10, Nivel).
    
correPeligro(Jugador):-
    jugador(Jugador,_,_),
    lugar(Lugar,Jugadores,_),
    member(Jugador,Jugadores),
    hayMonstruos(Lugar).

correPeligro(Jugador):-
    jugador(Jugador,Items,_),
    hambriento(Jugador),
    not(tieneItemComestible(_,Items)).

nivelPeligrosidad(Lugar,Nivel):-
    lugar(Lugar,Personas,_),
    not(hayMonstruos(Lugar)),
    findall(Hambriento,(member(Hambriento,Personas), hambriento(Hambriento)),Hambrientos),
    sort(Hambrientos,HambrientosCorto),
    length(HambrientosCorto,CantH),
    length(Personas,CantT),
    CantT \= 0,
    Nivel is CantH / CantT * 100.

nivelPeligrosidad(Lugar,100):-
    lugar(Lugar,_,_),
    hayMonstruos(Lugar).

nivelPeligrosidad(Lugar,Nivel):-
    lugar(Lugar,[],Oscuridad),
    Nivel is Oscuridad*10.

%PUNTO 3
item(horno, [itemSimple(piedra, 8)]).
item(placaDeMadera, [itemSimple(madera, 1)]).
item(palo, [itemCompuesto(placaDeMadera)]).
item(antorcha, [itemCompuesto(palo), itemSimple(carbon, 1)]).

puedeConstruir(Jugador, Item):-
    jugador(Jugador, _, _),
    item(Item, ComponentesNecesarios),
    forall(member(ItemNecesario, ComponentesNecesarios), tieneAlMenos(Jugador, ItemNecesario)).

tieneAlMenos(Jugador, itemSimple(Item, CantidadMinima)):-
    cantidadDeItem(Jugador, Item, CantidadReal),
    CantidadReal >= CantidadMinima.

tieneAlMenos(Jugador, itemCompuesto(Item)):-
    item(Item, Items),
    member(ItemNecesario, Items),
    tieneAlMenos(Jugador, ItemNecesario).


/*
puedeConstruir(Jugador,Item):-
    item(Item, Necesito),
    jugador(Jugador,_,_),
    forall(member(itemSimple(Simple,Cant),Necesito),tengoLaCantidad(Jugador,Simple,Cant)),
    forall(member(itemCompuesto(Compuesto),Necesito),puedeConstruir(Jugador,Compuesto)).

tengoLaCantidad(Jugador,Simple,Cant):-
    cantidadDeItem(Jugador,Simple,CantT),
    CantT >= Cant.
*/
%PUNTO 4
/*
¿Qué sucede si se consulta el nivel de peligrosidad del desierto? ¿A qué se debe?
como el desierto no esta en nuestra base de datos establecida, el programa no lo toma como existente y devuelve false. esto se debe al 
universo cerrado, donde lo que no declaramos en nuestra base de conocimientos no existe.

¿Cuál es la ventaja que nos ofrece el paradigma lógico frente a funcional a la hora de realizar una consulta?
si realizamos una consulta existencial, el paradigma logico nos devolvera todos los valores que cumplen con las condiciones. en el 
paradigma funcional, habia q ir probando una por una.
*/