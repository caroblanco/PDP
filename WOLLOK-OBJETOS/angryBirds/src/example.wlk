class Pajaro{
	var ira
	var velocidad
	
	method fuerza() = ira*2
	
	method enojarse(){
		ira*=2
	}
	
	method esFuerte() = self.fuerza() > 50 
	
	method tranquilizar(){
		ira -=5
	}
	
	method puedeDerribar(obstaculo) = self.fuerza() > obstaculo.resistencia()
	
	method atacar(islaC){
		const obstaculo = islaC.obstaculoCercano()
		
		if(self.puedeDerribar(obstaculo))
			islaC.perderObstaculo(obstaculo)
	}
}

class PajaroRencoroso inherits Pajaro{
	var enojos = 0
		
	override method enojarse(){
		super()
		enojos++
	}
}

class Red inherits PajaroRencoroso{
	
	override method fuerza() = ira * 10 * enojos
}

class Bomb inherits Pajaro{
	
	override method fuerza() = super().min(9000)
}

class Chuck inherits PajaroRencoroso{
	
	override method fuerza() = 150 + 5 * 0.max(velocidad - 80)
	override method enojarse(){
		super()
		velocidad *= 2
	}
	
	override method tranquilizar(){}
}

class Terence inherits PajaroRencoroso{
	var multiplicador
	
	override method fuerza() = ira * multiplicador * enojos
}

class Matilda inherits Pajaro{
	const huevos = []
		
	override method fuerza() = super() + self.sumaFuerzaHuevos()
	
	override method enojarse(){
		super()
		self.agregarHuevo()
	}
	
	method sumaFuerzaHuevos() = huevos.sum({unHu => unHu.fuerza()})
	
	method agregarHuevo(){
		const huevo = new Huevo(peso = 2)
		huevos.add(huevo)
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////

class Huevo{
	const peso
	method fuerza() = peso
}

////////////////////////////////////////////////////////////////////////////////////////////////

class IslaPajaro{
	const pajaros = []
	
	method pajarosFuertes() = pajaros.filter({unP => unP.esFuerte()})
	
	method fuerza() = self.pajarosFuertes().sum({unP => unP.fuerza()})
	
	method realizarEvento(evento){
		evento.realizar(self)          //method pajaros.forEach({unP => evento.afectar(unP)})
	}
	
	method tranquilizarPajaros(){
		pajaros.forEach({unP => unP.tranquilizar()})
	}
	
	method enojarATodos(){
		pajaros.forEach({unP => unP.enojarse()})
	}
	
	method hacerEnojarA(homenajeados){
		homenajeados.forEach({unP => unP.enojarse()})
	}
	
	method atacar(islaC){
		pajaros.forEach({unP => unP.atacar(islaC)})
	}
	
	method huevosRecuperados(islaC) = islaC.sinObstaculos()
}

////////////////////////////////////////////////////////////////////////////////////////////

object manejoDeIra{
	method realizar(isla){
		isla.tranquilizarPajaros()
	}
}

class InvasionCerditos{
	const invasores 
	method realizar(isla){
		invasores.div(100).times({_ => isla.enojarATodos()})
	}
}

class FiestaSorpresa{
	const homenajeados = []
	
	method realizar(isla){
		self.hayHomenajeados()
		isla.hacerEnojarA(homenajeados)
	}
	
	method hayHomenajeados(){
		if(homenajeados.isEmpty()){
			self.error("NO HAY PAJAROS HOMENAJEADOS")
		}
	}
}

class SerieDeEventosDesafortunados{
	const eventos = []
	
	method realizar(isla){
		eventos.forEach({unE => unE.realizar(isla)})
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class IslaCerdito{
	
	const obstaculos = []
	
	method sinObstaculos() = obstaculos.isEmpty()
	
	method obstaculoCercano() = obstaculos.first()
	
	method perderObstaculo(obst) = obstaculos.remove(obst)
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class Pared{
	const anchoPared
	const material
	
	method resistencia() = material.resistencia() * anchoPared
}

object vidrio{
	method resistencia() = 10
}

object madera{
	method resistencia() = 25
}

object piedra{
	method resistencia() = 50
}

object cerditoObrero{
	method resistencia() = 50
}

class CerditoArmado{
	const armadura
	
	method resistencia() = 10 * armadura.resistencia()
}

class Casco{
	var resistencia
	method resistencia() = resistencia
}

class Escudo{
	var resistencia
	method resistencia() = resistencia
}