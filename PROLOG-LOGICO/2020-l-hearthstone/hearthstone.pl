
% jugadores
jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo).

% cartas
criatura(Nombre, PuntosDanio, PuntosVida, CostoMana).
hechizo(Nombre, FunctorEfecto, CostoMana).

% efectos
danio(CantidadDanio).
cura(CantidadCura).

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

%PUNTO 1
tieneCarta(Jugador,Carta):-
    cartas(Jugador,Cartas),
    member(Carta,Cartas).

cartas(jugador(_,_,_,Cartas,_,_),Cartas).
cartas(jugador(_,_,_,_,Cartas,_), Cartas).
cartas(jugador(_,_,_,_,_,Cartas), Cartas).

%PUNTO 2
esGuerrero(Jugador):-
    jugador(Jugador,_,_,_,_,_),
    forall(tieneCarta(Jugador,Carta),cartaCriatura(Carta)).

cartaCriatura(criatura(_,_,_,_)).

%PUNTO 3
jugada(JugadorA,JugadorD):-
    jugador(JugadorA, _, PuntosManaA, [Carta|Cartas], CartasManoA, _),
    union(CartasManoA, [Carta], CartasManoD),
    PuntosManaD is PuntosManaA +1,
    jugador(JugadorD, _, PuntosManaD, Cartas, CartasManoD, _).

%PUNTO 4
puedeJugar(Jugador,Carta):-
    jugador(Jugador,_,Mana,_,_,_),
    mana(Carta,ManaC),
    Mana >= ManaC.


puedeJugarNext(Jugador,Carta):-
    jugada(Jugador,JugadorD),
    jugador(JugadorD,_,_,_,Mano,_),
    puedeJugar(JugadorD,Carta),
    member(Carta,Mano).

%PUNTO 5
