class Arbol{
	const regalos = []
	const tarjetas = []
	const adornos = []
	const elementos = regalos + tarjetas
	
	method agregarRegalo(regalo){
		self.tieneCapacidadPara(regalo)
		regalos.add(regalo)
	}
	
	method capacidad()
	
	method capacidadRestante() = self.capacidad() - self.cantOcupada()
	
	method tieneCapacidadPara(regalo){
		if(regalo.espacioQueOcupa() > self.capacidadRestante()){
			self.error("no se pudo agregar el regalo")
		}
	}
	
	method cantOcupada() = elementos.sum({unElem => unElem.espacioQueOcupa()})
	
	method beneficiariosArbol() = regalos.map{regalo => regalo.destinatario()} + tarjetas.map{tar => tar.destinatario()}
	
	method costoTotal() = elementos.sum({unElemento=> unElemento.precio()})
	
	method importancia() = adornos.sum({unAdorno => unAdorno.importancia()})
	
	method cantRegalos() = elementos.size()
	
	method precioPromedio() = self.costoTotal() / self.cantRegalos()
	
	method regaloAmoroso(regalo) = regalo.precio() > self.precioPromedio()
	
	method regalosAmorosos() = regalos.filter({unRegalo => self.regaloAmoroso(unRegalo)})
	
	method tarjetaCara() = tarjetas.any({unaTar => unaTar.valorAdjunto() >= 1000})
	
	method arbolPortentoso() =  self.regalosAmorosos().size() > 5 || self.tarjetaCara()
	
	method adornoMasPesado() = adornos.max({unAdorno => unAdorno.peso()})
	
}

class ArbolNat inherits Arbol{
	const vejez
	const tronco
	
	override method capacidad() = vejez*tronco
}

class ArbolArt inherits Arbol{
	const varas
	
	override method capacidad() = varas
}

///////////////////////////////////////////////////

class Regalo{
	const property precio
	const property destinatario
	const espacioQueOcupa

	method espacioQueOcupa() = espacioQueOcupa	

}

class Tarjeta{
	const property destinatario
	const property valorAdjunto

	method espacioQueOcupa() = 0
	method precio() = 2
}

class Adornos{
	const pesoBase
	const coefSuperioridad
	
	method peso() = pesoBase
	
	method importancia() = self.peso() * coefSuperioridad
}

class Luces inherits Adornos{
	const cantLamparas
	
	method luminosidad() = cantLamparas
	
	override method importancia() =  super() * self.luminosidad()
}

class Figuras inherits Adornos{
	const volumen
	
	override method importancia() = super() * volumen
}

class Guirnalda inherits Adornos{
	var anioDeCompra
	const aniosDeUso = new Date() - anioDeCompra
	
	
	override method peso() = pesoBase * - 100*aniosDeUso
	
}
