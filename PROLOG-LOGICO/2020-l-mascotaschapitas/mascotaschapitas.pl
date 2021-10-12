%mascota(duenio,tipo(nombre,cuando)).

duenio(martin,adopto,pepa,2014).
duenio(martin,adopto,frida,2015).
duenio(martin,adopto,kali,2016).
duenio(martin,adopto,olivia,2014).
duenio(constanza,leRegalaron,abril,2006).
duenio(constanza,adopto,mambo,2015).
duenio(hector,adopto,abril,2015).
duenio(hector,adopto,mambo,2015).
duenio(hector,adopto,buenaventura,1971).
duenio(hector,adopto,severino,2007).
duenio(hector,adopto,simon,2016).
duenio(martin,compro,piru,2010).
duenio(hector,compro,abril,2006).
duenio(silvio,leRegalaron,quinchin,1990).

%PUNTO 7
persona(Persona):-
    duenio(Persona,_,_,_).
persona(cami).
persona(esteban).

% perro(tamaño)
% gato(sexo, cantidad de personas que lo acariciaron)
% tortuga(carácter)

mascota(pepa, perro(mediano)).
mascota(frida, perro(grande)).
mascota(piru, gato(macho,15)).
mascota(kali, gato(macho,3)).
mascota(olivia, gato(hembra,16)).
mascota(mambo, gato(macho,2)).
mascota(abril, gato(hembra,4)).
mascota(buenaventura, tortuga(agresiva)).
mascota(severino, tortuga(agresiva)).
mascota(simon, tortuga(tranquila)).
mascota(quinchin, gato(macho,0)).

%PUNTO 1
/*
universo cerrado.
*/

%PUNTO 2
comprometidos(Persona1,Persona2):-
    duenio(Persona1,adopto,Mascota,Anio),
    duenio(Persona2,adopto,Mascota,Anio),
    Persona1 \= Persona2.

%PUNTO 3
locoDeLosGatos(Persona):-
    tieneMasDeUnAnimal(Persona),
    forall(duenio(Persona,_,Mascota,_),mascota(Mascota,gato(_,_))).

tieneMasDeUnAnimal(Persona):-
    duenio(Persona,_,Mascota,_),
    duenio(Persona,_,Mascota2,_),
    Mascota\=Mascota2.

%PUNTO 4
puedeDormir(Persona):-
    persona(Persona),
    not((duenio(Persona,_,Mascota,_),estaChapita(Mascota))).

estaChapita(Mascota):-
    mascota(Mascota,Especie),
    especieChapita(Especie).

especieChapita(perro(chico)).

especieChapita(tortuga(_)).

especieChapita(gato(macho,CantVeces)):-
    CantVeces<10.


%PUNTO 5
crisisNerviosa(Persona,Anio):-
    AnioAnterior is Anio-1,
    duenio(Persona,_,Mascota,AnioAnterior),
    duenio(Persona,_,MascotaOtra,_),
    Mascota\=MascotaOtra,
    estaChapita(Mascota),
    estaChapita(MascotaOtra).

% b) No es inversible por el segundo argumento. Anio debe llegar ligada al is para que el is pueda resolver la cuenta, 
% por lo tanto si Anio es variable, el is no funciona. Una forma de hacerlo inversible es plantearlo como una suma, poniendo el tiene primero:
% tiene(Persona,MascotaChapita,AnioAnterior,_),
% Anio is AnioAnterior + 1,
% ....


%PUNTO 6
mascotaAlfa(Persona,Mascota):-
    duenio(Persona,_,Mascota,_),
    forall((duenio(Persona,_,Otra,_),Otra\=Mascota), dominaA(Mascota,Otra)).

dominaA(Mascota,Otra):-
    mascota(Mascota,EspecieM),
    mascota(Otra,EspecieO),
    puedeDominar(EspecieM,EspecieO).

puedeDominar(gato(_,_),perro(_)).

puedeDominar(perro(grande),perro(chico)).

puedeDominar(EspecieM,EspecieO):-
    especieChapita(EspecieM),
    not(especieChapita(EspecieO)).

puedeDominar(tortuga(agresiva),_).

%PUNTO 7
materialista(Persona):-
    persona(Persona),
    not(duenio(Persona,_,_,_)).
%hay que agregar clausula persona(Alguien) para que sea inversible.

materialista(Persona):-
    cuantasSegunCriterio(compro,Persona,CantidadC),
    cuantasSegunCriterio(adopto,Persona,CantidadA),
    CantidadC > CantidadA.

cuantasSegunCriterio(Criterio,Persona,Cantidad):-
    persona(Persona),
    findall(Mascota,duenio(Persona,Criterio,Mascota,_),Mascotas),
    length(Mascotas,Cantidad).