
%auto(modelo)
%moto(anioDeFabricacion, suspensionesExtras)
%camion(items)
%cuatri(marca)

%marca(marca,modelo).
marca(peugeot,auto(2008)).
marca(peugeot,auto(3008)).
marca(mini,auto(countryman)).
marca(volkswagen,auto(touareg)).
marca(toyota,auto(hilux)).


marca(ktm,moto(Anio,_)):-
    Anio>=2000.

marca(yamaha,moto(Anio,_)):-
    Anio<2000.

marca(kamaz,camion(Carga)):-
    llevaVodka(Carga).

marca(iveco,camion(Carga)):-
    not(llevaVodka(Carga)).

marca(Marca,cuatri(Marca)).

llevaVodka(Carga):-
    member(vodka,Carga).

marcaCara(mini).
marcaCara(toyota).
marcaCara(iveco).

ganador(1997,peterhansel,moto(1995, 1)).
ganador(1998,peterhansel,moto(1998, 1)).
ganador(2010,sainz,auto(touareg)).
ganador(2010,depress,moto(2009, 2)).
ganador(2010,karibov,camion([vodka, mate])).
ganador(2010,patronelli,cuatri(yamaha)).
ganador(2011,principeCatar,auto(touareg)).
ganador(2011,coma,moto(2011, 2)).
ganador(2011,chagin,camion([repuestos, mate])).
ganador(2011,patronelli,cuatri(yamaha)).
ganador(2012,peterhansel,auto(countryman)).
ganador(2012,depress,moto(2011, 2)).
ganador(2012,deRooy,camion([vodka, bebidas])).
ganador(2012,patronelli,cuatri(yamaha)).
ganador(2013,peterhansel,auto(countryman)).
ganador(2013,depress,moto(2011, 2)).
ganador(2013,nikolaev,camion([vodka, bebidas])).
ganador(2013,patronelli,cuatri(yamaha)).
ganador(2014,coma,auto(countryman)).
ganador(2014,coma,moto(2013, 3)).
ganador(2014,karibov,camion([tanqueExtra])).
ganador(2014,casale,cuatri(yamaha)).
ganador(2015,principeCatar,auto(countryman)).
ganador(2015,coma,moto(2013, 2)).
ganador(2015,mardeev,camion([])).
ganador(2015,sonic,cuatri(yamaha)).
ganador(2016,peterhansel,auto(2008)).
ganador(2016,prince,moto(2016, 2)).
ganador(2016,deRooy,camion([vodka, mascota])).
ganador(2016,patronelli,cuatri(yamaha)).
ganador(2017,peterhansel,auto(3008)).
ganador(2017,sunderland,moto(2016, 4)).
ganador(2017,nikolaev,camion([ruedaExtra])).
ganador(2017,karyakin,cuatri(yamaha)).
ganador(2018,sainz,auto(3008)).
ganador(2018,walkner,moto(2018, 3)).
ganador(2018,nicolaev,camion([vodka, cama])).
ganador(2018,casale,cuatri(yamaha)).
ganador(2019,principeCatar,auto(hilux)).
ganador(2019,prince,moto(2018, 2)).
ganador(2019,nikolaev,camion([cama, mascota])).
ganador(2019,cavigliasso,cuatri(yamaha)).

pais(peterhansel,francia).
pais(sainz,espania).
pais(depress,francia).
pais(karibov,rusia).
pais(patronelli,argentina).
pais(principeCatar,catar).
pais(coma,espania).
pais(chagin,rusia).
pais(deRooy,holanda).
pais(nikolaev,rusia).
pais(casale,chile).
pais(mardeev,rusia).
pais(sonic,polonia).
pais(prince,australia).
pais(sunderland,reinoUnido).
pais(karyakin,rusia).
pais(walkner,austria).
pais(cavigliasso,argentina).

etapa(marDelPlata,santaRosa,60).
etapa(santaRosa,sanRafael,290).
etapa(sanRafael,sanJuan,208).
etapa(sanJuan,chilecito,326).
etapa(chilecito,fiambala,177).
etapa(fiambala,copiapo,274).
etapa(copiapo,antofagasta,477).
etapa(antofagasta,iquique,557).
etapa(iquique,arica,377).
etapa(arica,arequipa,478).
etapa(arequipa,nazca,246).
etapa(nazca,pisco,276).
etapa(pisco,lima,29).


%PUNTO 2
ganadorReincidente(Conductor):-
    ganador(Anio,Conductor,_),
    ganador(Anio1,Conductor,_),
    Anio1 \= Anio.

%PUNTO 3
inspiraA(Conductor,Inspirador):-
    ganador(Anio,Inspirador,_),
    condicionInspira(Anio,Conductor),
    mismoPais(Conductor,Inspirador).

mismoPais(Conductor,Inspirador):-
    pais(Conductor,Pais),
    pais(Inspirador,Pais).

condicionInspira(_,Conductor):-
    not(ganador(_,Conductor,_)).

condicionInspira(AnioI,Conductor):-
    ganador(AnioC,Conductor,_),
    AnioI<AnioC.

%PUNTO 4
marcaDeLaFortuna(Conductor,Marca):-
    marca(Marca,_),
    ganador(_,Conductor,_),
    forall((ganador(_,Conductor,Vehiculo),marca(MarcaV,Vehiculo)),Marca == MarcaV).

%PUNTO 5

heroePopular(Corredor):-
    ganador(Anio,Corredor,Vehiculo),
    inspiraA(_,Corredor),
    forall((ganador(Anio,Otro,VehiculoOtro),Otro \= Corredor),esCaro(VehiculoOtro)),
    not(esCaro(Vehiculo)).
    
esCaro(cuatri(_)).

esCaro(moto(_,Suspensiones)):-
    Suspensiones>=3.

esCaro(Vehiculo):-
    marca(Marca,Vehiculo),
    marcaCara(Marca).

%PUNTO 6
cuantosKM(Inicio,Fin,KM):-
    etapa(Inicio,Fin,KM).

cuantosKM(Inicio,Fin,KM):-
    etapa(Inicio,Medio,Dist),
    cuantosKM(Medio,Fin,KMA),
    KM is KMA + Dist.


recorreDistancia(Vehiculo,Distancia):-
    condicionMax(Vehiculo,RecorridoMax),
    between(0,RecorridoMax,Distancia).

condicionMax(camion(Carga),RecorridoMax):-
    length(Carga,Cantidad),
    RecorridoMax is Cantidad*1000.

condicionMax(Vehiculo,2000):-
    esCaro(Vehiculo).

condicionMax(Vehiculo,1800):-
    not(esCaro(Vehiculo)).


destinoMasLejano(Vehiculo,Inicio,Fin):-
    cuantosKM(Inicio,Fin,Distancia),
    forall((cuantosKM(Inicio,OtroFin,DistanciaOtra),OtroFin\=Fin,recorreDistancia(Vehiculo,DistanciaOtra)),Distancia>DistanciaOtra),
    recorreDistancia(Vehiculo,Distancia).
