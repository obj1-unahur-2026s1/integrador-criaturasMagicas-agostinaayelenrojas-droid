class Criatura{
    var property poderMagico
    var property astucia
    var property rol

    method rolEnElParque() = rol

    method poderOfensivo(){
       poderMagico * 10 + rol.extraPoder()
    }

    method perderPoderMagico(){
        poderMagico = poderMagico * 0.85
    }

    method esFormidable(){
        self.esAstuta() || self.esExtraordinaria()
    }

    method esExtraordinaria(){
        return rol.esExtraordinario(self)
    }

    method cambiarRol(){
        rol.cambiarRolDe(self)
    }

    method esAstuta()=false
}

class Duende inherits Criatura{

    override method poderOfensivo(){
        super().poderOfensivo() * 1.1
    }

    override method esAstuta() = false
}

class Hada inherits Criatura{
    var kilometrosQuePuedeVolar = 2

    method aumentarKilometros(unaCantidad){
        kilometrosQuePuedeVolar = (kilometrosQuePuedeVolar + unaCantidad).min(25)
    }

    override method esAstuta(){
        return astucia > 50
    }

    override method esExtraordinaria(){
        super().esExtraordinaria() &&
        kilometrosQuePuedeVolar > 10
    }
}

object guardian {

    method extraPoder() = 100

    method esExtraordinario(unaCriatura){
        unaCriatura.poderMagico() > 50
    }

    method cambiarRolDe(unaCriatura){
        unaCriatura.rol(new Domador())

        unaCriatura.rol().agregarMascota(
            new MascotaMitologica(
                edad = 1,
                tieneCuernos = false
            )
        )
    }
}

object hechicero{

    method extraPoder() = 0

    method esExtraordinario(unaCriatura) = true

    method cambiarRolDe(unaCriatura){
        unaCriatura.rol(guardian)
    }
}

class Domador{

    const mascotasMitologicas = []

    method agregarMascota(unaMascota){
        mascotasMitologicas.add(unaMascota)
    }

    method extraPoder(){
        mascotasMitologicas.count({m => m.tieneCuernos()}) * 150
    }

    method esExtraordinario(unaCriatura){
        unaCriatura.poderMagico() >= 15 &&
        mascotasMitologicas.all({m => m.esVeterana()})
    }

    method cambiarRolDe(unaCriatura){

        if(!mascotasMitologicas.any({m => m.tieneCuernos()})){
            self.error("El ritual no puede realizarse")
        }

        unaCriatura.rol(hechicero)
    }
}

class MascotaMitologica{
    var property edad
    var property tieneCuernos

    method esVeterana(){
        edad >= 10
    }
}

class Colonia{

    const criaturas = []

    method poderOfensivo(){
       criaturas.sum({c => c.poderOfensivo()})
    }

    method cantidadDeFormidables(){
        criaturas.count({c => c.esFormidable()})
    }

    method perderConquista(){
        criaturas.forEach({c =>
            c.perderPoderMagico()
        })
    }
}

class Area{

    var property coloniaHabitante

    method poderDefensivo()

    method conquistar(coloniaInvasora){

        if(coloniaInvasora.poderOfensivo() >
            self.poderDefensivo()){

            coloniaHabitante = coloniaInvasora
        }
        else{
            coloniaInvasora.perderConquista()
        }
    }
}

class Castillo inherits Area{

    override method poderDefensivo(){
        coloniaHabitante.cantidadDeFormidables() * 200
    }
}

class Claro inherits Area{

    override method poderDefensivo(){
        coloniaHabitante.poderOfensivo() + 100
    }
}