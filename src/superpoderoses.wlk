class Heroe {
	var property espiritualidad = 0
	var property estrategia = 0 
	const poderes = []
	
	method agregarPoder(poder){
		poderes.add(poder)
	}
	
	method capacidadDeBatalla() {
		var total = 0
		poderes.forEach{poder => total += poder.capacidadDeBatalla()}
		return total
	}
	
	method esInmune(){
		var flag = false
		
		poderes.forEach{poder =>
			if(poder.otorgaInmunidad()){
				flag = true
			}
		}
		
		return flag
	}
	method afrontaPeligro(peligro){
		estrategia += peligro.nivelDeComplejidad()
	}
}

class Metahumano inherits Heroe{
	override method capacidadDeBatalla() {
		var total = 0
		poderes.forEach{poder => total += poder.capacidadDeBatalla()}
		return (total * 2)
	}
	
	override method esInmune(){
		return true
	}
	
	override method afrontaPeligro(peligro){
		estrategia += peligro.nivelDeComplejidad()
		espiritualidad += peligro.nivelDeComplejidad()
	}
}

class Mago inherits Metahumano{
	var property poderAcumulado
	
	override method capacidadDeBatalla() {
		var total = 0
		poderes.forEach{poder => total += poder.capacidadDeBatalla()}
		return ((total * 2) + poderAcumulado)
	}
	
	override method afrontaPeligro(peligro){
		if(poderAcumulado > 10){
			estrategia += peligro.nivelDeComplejidad()
			espiritualidad += peligro.nivelDeComplejidad()
		}
		
		if(poderAcumulado >= 5){
			poderAcumulado -= 5
		} else {
			poderAcumulado = 0
		}
	}
}

class Poder{
	var property agilidad
	var property fuerza
	var property habilidadEspecial
	
	method capacidadDeBatalla(){
		return ((agilidad + fuerza) * habilidadEspecial)
	}
}

class Velocidad inherits Poder{
	var property rapidez
	
	override method agilidad(personaje){
		agilidad = personaje.estrategia() * rapidez
		return agilidad
	}
	
	override method fuerza(personaje){
		fuerza = personaje.espiritualidad() * rapidez
		return fuerza
	}
	
	override method habilidadEspecial(personaje){
		habilidadEspecial = personaje.espiritualidad() + personaje.estrategia()
		return habilidadEspecial
	}
	
	method otorgaInmunidad(){
		return false
	}
}

class Vuelo inherits Poder{
	var property alturaMaxima
	var property energiaDespegue
	
	override method agilidad(personaje){
		agilidad = (personaje.estrategia() * alturaMaxima) / energiaDespegue
		return agilidad
	}
	
	override method fuerza(personaje){
		fuerza = personaje.espiritualidad() + alturaMaxima - energiaDespegue
		return fuerza
	}
	
	override method habilidadEspecial(personaje){
		habilidadEspecial = personaje.espiritualidad() + personaje.estrategia()
		return habilidadEspecial
	}
	
	method otorgaInmunidad(){
		return alturaMaxima > 200
	}
}

class PoderAmplificador inherits Poder{
	var property poderBase
	var property amplificador
	
	override method agilidad(){
		agilidad = poderBase.agilidad()
		return agilidad
	}
	
	override method fuerza(){
		fuerza = poderBase.fuerza()
		return fuerza
	}
	
	override method habilidadEspecial(){
		habilidadEspecial = poderBase.habilidadEspecial() * amplificador
		return habilidadEspecial
	}
	method otorgaInmunidad(){
		return true
	}
}

class Equipo {
	const miembros = []
	const mejoresPoderes = []
	
	method miembros(){
		return miembros
	}
	
	method miembros(integrante){
		miembros.add(integrante)
	}
	
	method masDebil(){
		var aux = null
		
		miembros.forEach{miembro =>
			if(aux == null){
				aux = miembro
			}
			if(miembro.capacidadDeBatalla()< aux.capacidadDeBatalla()){
				aux = miembro
			}
		}
		
		return aux
	}
	
	method calidad(){
		var capacidadTotal = 0
		
		miembros.forEach{miembro => capacidadTotal += miembro.capacidadDeBatalla()}
		
		return capacidadTotal / miembros.size()
	}
	
	method mejoresPoderes(){
		var aux = null
		
		miembros.forEach{miembro =>
			miembro.poderes().forEach{poder =>
				if(aux == null){
					aux = poder
				}
				if(poder.capacidadDeBatalla() > aux.capacidadDeBatalla()){
					aux = poder
				}
			}
			mejoresPoderes.add(aux)
		}
		
		return mejoresPoderes
	}
	
	method afrontaPeligro(peligro){
		const miembrosHabilitados = []
		
		miembros.forEach{miembro => 
			if(peligro.afrontablePara(miembro) and peligro.capacidadJugadores() > miembrosHabilitados.size()){
				miembrosHabilitados.add(miembro)
			}
		}
		
		return miembrosHabilitados
	}
}

class Peligro {
	var property capacidadDeBatalla
	var property desechosRadioactivos =  false
	var property nivelDeComplejidad
	var property capacidadJugadores
	
	method afrontablePara(personaje){
		if(desechosRadioactivos){
			return personaje.capacidadDeBatalla() > capacidadDeBatalla and personaje.esInmune()
		} else {
			return personaje.capacidadDeBatalla() > capacidadDeBatalla
		}
	}
	
	method sensatoParaEquipo(equipo){
		var aux = 0
		const miembros = equipo.miembros()
		const longitud = miembros.size()
		
		miembros.forEach{ miembro => 
			if(self.afrontablePara(miembro)){
				aux += 1
			}
		}
			
		return (aux == longitud)
	}
}

