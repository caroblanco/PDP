class Persona{
	var posicion
	const property elementos = []
	var criterio
	var criterioComida
	var comi = []
	
	
	method posicion() = posicion
	
	method cambiarEstado(nuevoE){
		criterio = nuevoE
	}
	
	method pedirPasarA(alguien,algo){
		alguien.pasarA(self,algo)
	}
	
	method pasarA(alguien,algo){
		self.validarQueTengo(algo)
		criterio.pasar(self,alguien,algo)
	}
	
	method validarQueTengo(algo){
		if(not self.tiene(algo)){
			self.error("NO TENGO EL ELEMENTO")
		}
	}
	
	method tiene(elemento) = elementos.contains(elemento)
	
	method sacar(elemento){
		elementos.remove(elemento)
	}
	
	method agregar(elemento){
		elementos.add(elemento)
	}
	
	method pasar(recibe,algo){
		self.sacar(algo)
		recibe.agregar(algo)
	}
	
	method primerElemento() = elementos.head()

	method vaciarElementos() = elementos.clear()
	
	method cambiarPos(otro){
		posicion = otro.posicion()
	}
	
	method eligeComer(algo){
		if(criterioComida.criterio(algo)){
			self.agregarComida(algo)	
		}
	}
	
	method agregarComida(algo){
		comi.add(algo)
	}
	
	method cambiarCriterioComida(nuevoC){
		criterioComida = nuevoC
	}
	
	method estaPipon() = comi.any({unaComida => unaComida.esPesada()})
	
	method comioAlgo() = not comi.isEmpty()
	
	method pasandolaBien() = self.comioAlgo() && self.criterioInd()
	
	method criterioInd()
	
	method comioCarne() = comi.any({unaComida => unaComida.esCarne()})
	
	method maxElementosCerca(limite) = self.elementosCerca() <= limite
	
	method elementosCerca() = elementos.size()
}

/////////////////////////////////////////////////////////////////////////////////////////
object osky inherits Persona{
	
	override method pasandolaBien() = true
	override method criterioInd(){}
	
}

object moni inherits Persona{
	
	override method criterioInd() =  (posicion == "1@1")
}

object facu inherits Persona{
	
	override method criterioInd() = self.comioCarne()
}

object vero inherits Persona{
	override method criterioInd() = self.maxElementosCerca(3)
}

//////////////////////////////////////////////////////////////////////////////////////////

object sordo{
	method pasar(yo,alguien,algo){
		const primer = yo.primerElemento()
		yo.pasar(alguien,primer)
	}
}

object pasarTodo{
	method pasar(yo,alguien,algo){
		const elementos = yo.elementos()
		alguien.elementos().addAll(elementos)
		yo.vaciarElementos()
	}
}

object cambiarPosicion{
	method pasar(yo,alguien,algo){
		yo.cambiarPos(alguien)
		alguien.cambiarPos(yo)
	}
}

object pasarElemento{
	method pasar(yo,alguien,algo){
		yo.pasar(alguien,algo)
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
class Comida{
	const calorias
	const esCarne
	
	method esCarne() = esCarne
	method calorias() = calorias
	
	method esPesada() = calorias > 500
}

///////////////////////////////////////////////////////////////////////////////////////////////
object vegetariano{
	method criterio(algo) = not algo.esCarne()	
}

object dietetico{
	const recomendacionOMS = 500
	
	method criterio(algo) = algo.calorias() < recomendacionOMS
}

object alternado{
	var acepteComida
	
	method criterio(algo){
		acepteComida = !acepteComida
		return acepteComida
	}
}

object todas{
	method criterio(algo) = vegetariano.criterio(algo) && dietetico.criterio(algo) && alternado.criterio(algo)
}

/* ASI LO HIZO BELEN Y NACHO

 object combinado{
	var property tipos = [alternado, dietetico, vegetariano]
	
	method aceptaComida(comida){
		tipos.all({ preferencia => preferencia.aceptaComida(comida) })
	}
}
 */

////////////////////////////////////////////////////////////////////////////////////////////////////

