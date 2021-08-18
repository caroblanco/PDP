module Lib where
import Text.Show.Functions
import Data.List

data Raton = UnRaton {
    nombre :: String,
    edad :: Int,
    peso :: Float,
    enfermedades :: [String]
} deriving (Show, Eq)

cerebro :: Raton
cerebro = UnRaton {nombre = "Cerebro", edad =9, peso = 0.2 ,enfermedades= ["brucelosis","sarampion","tuberculosis"]}
bicenterrata :: Raton
bicenterrata = UnRaton {nombre = "Bicenterrata", edad =256, peso = 0.2 ,enfermedades= []}
huesudo :: Raton
huesudo = UnRaton {nombre = "Huesudo", edad =4, peso = 10.0 ,enfermedades =["Alta obesidad","sinusitis"]}

---------------2
type Hierba = Raton -> Raton

modificarPeso :: (Float -> Float) -> Raton -> Raton
modificarPeso f raton = raton {peso = f (peso raton)} 

modificarEdad ::(Int -> Int) -> Raton -> Raton 
modificarEdad f raton = raton {edad = f (edad raton)} 

modificarEnfermedades :: ([String]->[String]) ->Raton -> Raton
modificarEnfermedades f raton = raton {enfermedades = f (enfermedades raton)}

cambiarNombreA :: String -> Raton -> Raton
cambiarNombreA nuevoNombre raton = raton {nombre = nuevoNombre}
--------------------

hierbaBuena :: Hierba
hierbaBuena  = modificarEdad (round.sqrt.fromIntegral)

hierbaVerde :: String -> Hierba
hierbaVerde fin = modificarEnfermedades (filtrarSegunFin fin)

filtrarSegunFin :: String -> [String] -> [String]
filtrarSegunFin fin enfermedades = filter (distintoAlFin fin) enfermedades

distintoAlFin :: String -> String ->Bool
distintoAlFin fin = (/= (reverse fin)) . take (length fin) . reverse

alcachofa :: Hierba
alcachofa = modificarPeso pierdeSegun

pierdeSegun :: Float -> Float
pierdeSegun peso 
    |peso > 2.0 = peso*0.9
    |otherwise = peso * 0.5

hierbaZort :: Hierba
hierbaZort  = (cambiarNombreA "pinky"). modificarEnfermedades (\_ -> []). modificarEdad (\_ -> 0) 

hierbaDelDiablo :: Hierba
hierbaDelDiablo = modificarEnfermedades largoMenorA10 . modificarPeso pierdePoco 

pierdePoco :: Float -> Float
pierdePoco peso = max (peso - 0.1) 0

largoMenorA10 :: [String] -> [String] 
largoMenorA10 = filter ((>10).length) 

---------------------------3
sufijosInfecciosas = ["sis", "itis", "emia", "cocos"]
type Medicamento = Raton -> Raton

pondsAntiAge :: Medicamento
pondsAntiAge = composicionDeLista [hierbaBuena,hierbaBuena,hierbaBuena,alcachofa]

reduceFatFast :: Int -> Medicamento
reduceFatFast potencia = composicionDeLista (listaDeHierbas potencia)

listaDeHierbas :: Int -> [Hierba]
listaDeHierbas potencia = (replicate potencia alcachofa) ++ [(hierbaVerde "Obesidad")]

pdepCilina :: [String] -> Medicamento
pdepCilina sufijosInfecciosas = composicionDeLista (map (hierbaVerde) sufijosInfecciosas)

composicionDeLista :: [Hierba] -> (Raton -> Raton)
composicionDeLista [] = id
composicionDeLista (x:xs) = x.(composicionDeLista xs)
{-type Medicamento = [Hierba]

pondsAntiAge :: Medicamento 
pondsAntiAge = [hierbaBuena,hierbaBuena,hierbaBuena,alcachofa] 

reduceFatFast :: Int -> Medicamento
reduceFatFast potencia = [hierbaVerde "obesidad"] ++ replicate potencia alcachofa

pdepCilina :: [String] -> Medicamento
pdepCilina [] = []
pdepCilina (x:xs) = hierbaVerde x : pdepCilina xs

administrarARaton ::  Medicamento -> Raton -> Raton
administrarARaton medicamento = foldl1 (.) medicamento
-}

-------------------4
--------a
cantidadIdeal :: (Int -> Bool) -> Int
cantidadIdeal condicion = head (filter condicion [1..])

-------b
type Comunidad = [Raton]

lograEstabilizar :: Comunidad -> Medicamento -> Bool
lograEstabilizar comunidad medicamento = ningunoConSobrepeso(medicarRatones medicamento comunidad) && menosDe3Enfermedades(medicarRatones medicamento comunidad)

medicarRatones :: Medicamento -> [Raton] -> [Raton]
medicarRatones medicamento comunidad = map medicamento comunidad

ningunoConSobrepeso :: [Raton] -> Bool
ningunoConSobrepeso comunidad = all ((<1).peso) comunidad

menosDe3Enfermedades :: [Raton] -> Bool
menosDe3Enfermedades comunidad = all ((<3).(length.enfermedades)) comunidad

--------------------c
potenciaIdeal :: Comunidad -> Int
potenciaIdeal comunidad = cantidadIdeal (lograEstabilizar comunidad (reduceFatFast potencia hierbaVerde)) 
    
    --cantidadIdeal (lograEstabilizar comunidad (reduceFatFast))

--5
{-a
En el caso en que no logre estabilizar a toda la comunidad, si obtendremos respuesta ya que dejará de iterar 
cuando encuentre al primer caso que no cumpla con la condición requerida.
Nunca podremos saber si la condición se cumple para todos ya que nunca dejará de probar a menos que encuentre un caso falso
-}

{-b
Si es verdadero, lo sabremos en cuanto encuentre al primer ratón cumpla con pesar 2kg y tener 4 enfermedades
En cambio si es falso, nunca lo sabremos ya que continuará iterando infinitamente, a menos que encuentre un caso verdadero
-}

--6
{-a
simplemente hay que agregar la hierba, no es necesario cambiar ninguna de las otras funciones, a menos que 
cambie la definición de algún medicamento debido a la nueva hierba
-}

{-b
El concepto que está involucrado en la pregunta anterior es ...
tengo 3 capas de funciones, las principales, las que interactuan con ellas y las que interactuan con las segundas
las principales interactuan con los data
si cambio algo de algún data voy a tener que cambiar ese primer grupo de funciones, no las que las llaman que seguirán recibiendo lo mismo.
-}

{-c
Si se quiere poner el peso en libras hay que cambiar todas las funciones que hagan cálculos o comparaciones
con el peso ya que están puestas en kg
Ej: si un ratón pesa más de 2kg, hay que transformar el 2 a libras.
-}