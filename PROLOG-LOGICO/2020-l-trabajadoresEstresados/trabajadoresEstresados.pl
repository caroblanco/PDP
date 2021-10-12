%% quedaEn(lugar, lugar)
quedaEn(venezuela, america).
quedaEn(argentina, america).
quedaEn(patagonia, argentina).
quedaEn(aula522, utn). % Sí, un aula es un lugar!
quedaEn(utn, buenosAires).
quedaEn(buenosAires, argentina).
juegaEn(primeraDivision,argentina).

esComplejo(examenPDP).

%examen(tema,lugar).
%discurso(lugar,cantPub).
%gol(torneo).

%tarea(persona,tarea,dia,mes,ano).

%nacio(Persona,LugarNac).

nacio(dani,buenosAires).
nacio(alf,buenosAires).
nacio(nico,buenosAires).

tarea(dani,examen(examenPDP,aula522),fecha(10,8,2017)).
tarea(dani,gol(primeraDivision),fecha(10,8,2017)).
tarea(alf,discurso(utn,0),fecha(11,8,2017)).

%PUNTO 1
nuncaSalioDeCasa(Persona):-
    nacio(Persona,LNacimiento),
    forall(tarea(Persona,Tarea,_),lugarTarea(Tarea,LNacimiento)).

lugarTarea(examen(_,Lugar),Lugar).
lugarTarea(discurso(Lugar,_),Lugar).
lugarTarea(gol(Torneo),Lugar):-
    juegaEn(Torneo,Lugar).

%PUNTO 2
esEstresante(Tarea):-
    tarea(_,Tarea,_),
    lugarTarea(Tarea,LugarT),
    quedaEnArg(Lugar,argentina),
    condicionesEstresantes(Tarea).

quedaEnArg(LugarHijo, LugarPadre):- 
 quedaEn(LugarHijo,LugarPadre).
 
quedaEnArg(LugarHijo, LugarPadre):-
  quedaEn(LugarHijo,OtroLugar),
  quedaEnArg(OtroLugar, LugarPadre).

condicionesEstresantes(discurso(_,Cantidad)):-
    Cantidad>30000.

condicionesEstresantes(examen(Tema,_)):-
    esComplejo(Tarea).

condicionesEstresantes(gol(_)).

%PUNTO 3

calificacion(Persona,zen):-
    tarea(Persona,Tarea,_),
    not(esEstresante(Tarea)).

calificacion(Persona,locos):-
    forall(tarea(Persona,Tarea,fecha(_,_,2017)),esEstresante(Tarea)).

calificacion(Persona,sabios):-
    tarea(Persona,Tarea,_),
    tarea(Persona,Tarea1,_),
    esEstresante(Tarea),
    not(esEstresante(Tarea1)).

%PUNTO 4

elMasChapita(Persona):-
    tarea(Persona,_,_),
    cantTareasEstresantes(Persona,Cant),
    forall((tarea(Persona2,_,_),Persona1\=Persona,cantTareasEstresantes(Persona1,Cant1)),Cant>Cant1).

cantTareasEstresantes(Persona,Cant):-
    findall(Tarea,(tarea(Persona,Tarea,_),esEstresante(Tarea)),Tareas),
    length(Tareas,Cant).

%PUNTO 5
