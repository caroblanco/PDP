/*
Nombre: BLANCO, CAROLINA
Legajo: 1715951
*/

tiene(ana,agua).
tiene(ana,vapor).
tiene(ana,tierra).
tiene(ana,hierro).
tiene(beto,agua).
tiene(beto,vapor).
tiene(beto,tierra).
tiene(beto,hierro).
tiene(cata,fuego).
tiene(cata,tierra).
tiene(cata,agua).
tiene(cata,aire).

elemento(pasto,[agua,tierra]).
elemento(hierro,[fuego,agua,tierra]).
elemento(huesos,[pasto,agua]).
elemento(vapor,[agua,fuego]).
elemento(presion,[hierro,vapor]).
elemento(silicio,[tierra]).
elemento(plastico,[huesos,presion]).
elemento(playStation,[silicio,hierro,plastico]).

% Los círculos alquímicos tienen diámetro en cms y cantidad de niveles.
% Las cucharas tienen una longitud en cms.
% Hay distintos tipos de libro.
herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

%PUNTO 2
tieneIngredientesPara(Persona,Elemento):-
    tiene(Persona,_),
    elemento(Elemento,LoNecesario),
    forall(member(Necesito,LoNecesario),tiene(Persona,Necesito)).

%PUNTO 3
estaVivo(Elemento):-
    elemento(Elemento,Componentes),
    member(Componente,Componentes),
    estaVivo(Componente).

estaVivo(fuego).
estaVivo(agua).

%PUNTO 4
puedeConstruir(Persona,Elemento):-
    tieneIngredientesPara(Persona,Elemento),
    tieneHerramientaUtil(Persona,Elemento).

tieneHerramientaUtil(Persona,Elemento):-
    herramienta(Persona,Herramienta),
    sirveHerramienta(Herramienta,Elemento).

sirveHerramienta(libro(vida),Elemento):-
    estaVivo(Elemento).

sirveHerramienta(libro(inerte),Elemento):-
    not(estaVivo(Elemento)).

sirveHerramienta(cuchara(Longitud),Elemento):-
    cantidadComponentes(Elemento,CantidadComponentes),
    Soporta is Longitud / 10,
    CantidadComponentes =< Soporta.

sirveHerramienta(circulo(Centimetros,Niveles),Elemento):-
    cantidadComponentes(Elemento,CantidadComponentes),
    Soporta is Centimetros / 100 * Niveles,
    CantidadComponentes =< Soporta.

cantidadComponentes(Elemento,Cantidad):-
    elemento(Elemento,Componentes),
    length(Componentes,Cantidad).

%PUNTO 5
todoPoderoso(Persona):-
    puedeConstruirCadaElementoQueNoTiene(Persona),
    forall(elementosPrimitivos(Elemento),tiene(Persona,Elemento)).

puedeConstruirCadaElementoQueNoTiene(Persona):-
    tiene(Persona,_),
    forall(not(tiene(Persona,Elemento)),tieneHerramientaUtil(Persona,Elemento)).

elementosPrimitivos(agua).
elementosPrimitivos(fuego).
elementosPrimitivos(tierra).
elementosPrimitivos(aire).

/*
OTRA FORMA QUE PODRIA HABER HECHO LOS ELEMENTOS PRIMITIVOS...
elemento(agua,[]).
elemento(aire,[]).
elemento(fuego,[]).
elemento(tierra,[]).

elementosPrimitivos(Elemento):-
    elemento(Elemento,[]),
    not(puedeConstruir(_,Elemento)).
*/

%PUNTO 6
quienGana(Persona):-
    cantidadQuePuedeConstruir(Persona,CantidadP),
    forall((cantidadQuePuedeConstruir(OtraPersona,CantidadOtra),OtraPersona \= Persona), CantidadP > CantidadOtra).

cantidadQuePuedeConstruir(Persona,Cantidad):-
    tiene(Persona,_),
    findall(Elemento,puedeConstruir(Persona,Elemento),Elementos),
    length(Elementos,Cantidad).

%PUNTO 7
/*
el concepto de universo cerrado nos permite trabajar con que todo lo que no declaramos, es decir, lo desconocido, se toma como falso. En otras
palabras, todo aquello que no podemos probar es falso. Debido a esto, no es necesario declarar en la base de conocimientos hechos que no se cumplan,
como por ejemplo que cata NO TIENE vapor. Como es desconocido y no se va a poder probar como verdadero, dara falso. Si algo no esta en la base
de conocimiento, sera falso.
*/

%PUNTO 8
puedeLlegarATener(Persona,Elemento):-
    tiene(Persona,Elemento).

puedeLlegarATener(Persona,Elemento):-
    puedeConstruir(Persona,Elemento).

puedeLlegarATener(Persona,Elemento):-
    tieneHerramientaUtil(Persona,Elemento),
    elemento(Elemento,LoNecesario),
    forall(member(Necesito,LoNecesario),puedeLlegarATener(Persona,Necesito)).

% ~(°_°~) ~(°_°)~ (~°_°)~ ~(°_°)~ ~(°_°~) ~(°_°)~ (~°_°)~ ~(°_°)~ ~(°_°~) ~(°_°)~ (~°_°)~ ~(°_°)~ ~(°_°~) ~(°_°)~ (~°_°)~ ~(°_°)~ ~(°_°~) ~(°_°)~ (~°_°)~ 
