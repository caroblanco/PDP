module Lib where
import Text.Show.Functions

data Mutante = UnMutante {
    nombre :: String,
    vida::Int,
    habilidades :: [String],
    armas :: [Arma]
} 

type Arma = Mutante -> Mutante

dead :: Mutante
dead= UnMutante "dead" 300 ["baile metal","correr metal","metal","espiritu metal"] [(espada 16)]
shisus :: Mutante
shisus= UnMutante "dead" 300 ["baile metal","correr metal","metal","Esquivar Golpes"] [puno,(espada 16),(espada 16)]
wade :: Mutante
wade= UnMutante "Wade Wilson" 300 ["baile metal","correr metal","metal","Esquivar Golpes"] [puno,(pistola 9),(espada 16),(espada 16)]
muereFacil :: Mutante
muereFacil =  UnMutante "Wade Wilson" 5 ["baile metal","correr metal","metal","Esquivar Golpes"] [puno,(pistola 9),(espada 16),(espada 16)]
muereFacil2 :: Mutante
muereFacil2 =  UnMutante "Wade Wilson" 6 ["baile metal","correr metal","metal","Esquivar Golpes"] [puno,(pistola 9),(espada 16),(espada 16)]
muereFacil3 :: Mutante
muereFacil3 =  UnMutante "Wade Wilson" 4 ["baile metal","correr metal","metal","Esquivar Golpes"] [puno,(pistola 9),(espada 16),(espada 16)]

-------------1,2,3
estaMuerto :: Mutante -> Bool
estaMuerto = esIgualA 0 vida

esFrancis :: Mutante -> Bool
esFrancis = esIgualA "Francis" nombre

isMyDad :: Mutante -> Bool 
isMyDad mutante = esIgualA "Coloso" nombre mutante && (habilidadMetalica.habilidades) mutante

habilidadMetalica :: [String] -> Bool
habilidadMetalica = any (elem "metal"). map words 

esIgualA :: Eq a => a -> (Mutante -> a)-> Mutante -> Bool
esIgualA parametro funcion = (==parametro).funcion 

----------4,5,6
cambiarVida :: Int -> Mutante -> Mutante
cambiarVida cantidad mutante = mutante {vida = max 0 (vida mutante - cantidad)}

puno :: Arma
puno mutante 
    |esquivarGolpes mutante = cambiarVida 5 mutante
    |otherwise = mutante

esquivarGolpes :: Mutante -> Bool
esquivarGolpes = elem "Esquivar Golpes" . habilidades

pistola :: Int -> Arma
pistola calibre mutante = cambiarVida ((segunCalibre calibre . habilidades)mutante) mutante

segunCalibre :: Int -> [String] -> Int
segunCalibre calibre = (*calibre). length 

espada :: Int -> Arma
espada fuerza = cambiarVida (div fuerza 2)

--------------7
cambiarArmas :: ([Arma]->[Arma]) -> Mutante -> Mutante
cambiarArmas f mutante = mutante {armas = f (armas mutante)}

abastecernosConMasArmas :: [Arma] -> Mutante -> Mutante
abastecernosConMasArmas armasAgregar mutante
    |esIgualA "Wade" nombre mutante = mutante
    |otherwise = cambiarArmas (++ armasAgregar) mutante

-----------8,9,10
type Ataque = Mutante -> Mutante -> Mutante

ataqueRapido :: Ataque
ataqueRapido atacante = head.armas $ atacante

atacarConTodo :: Ataque
atacarConTodo atacante = foldl1 (.) (armas atacante) 

todosAUno :: [Mutante] -> Mutante -> Mutante
todosAUno atacantes = foldl1 (.) (listaArmas atacantes)

listaArmas :: [Mutante] -> [Arma]
listaArmas = foldl1 (++).map armas

-----------11,12,13
comoEstaSuFamilia :: Mutante -> [Mutante] ->  [String]
comoEstaSuFamilia atacante = map nombre . filter (estaMuerto.ataqueRapido atacante)

rescataASuChique :: Mutante -> [Mutante] -> [Mutante] -> Bool
rescataASuChique yo amigos  = (==0).length. atacarEnemigos yo amigos 

atacarEnemigos:: Mutante -> [Mutante] -> [Mutante] ->[Mutante]
atacarEnemigos yo amigos  = map (amigosAtacanConTodo amigos) . yoAtacoRapidamente yo 

yoAtacoRapidamente :: Mutante -> [Mutante] -> [Mutante]
yoAtacoRapidamente yo  = filter (not.estaMuerto) . map (ataqueRapido yo)

amigosAtacanConTodo :: [Mutante] -> Mutante -> Mutante
amigosAtacanConTodo amigos = todosAUno amigos

cualEsMiNombre :: (Mutante -> [b]) -> Int -> (Mutante -> a) -> [Mutante] -> [b] 
cualEsMiNombre x y z = concatMap fst . map (\n -> (x n, z n)) . filter ((y>).vida)

----------------------14
chuck = UnMutante "Chuck Norris" 1000000 ["patada giratoria"] infinitosPunos

infinitosPunos :: [Arma]
infinitosPunos = puno : infinitosPunos

{-
B) si, ya que se aplica la primer arma nomas, no toda la lista
C) no, ya que se quedara colgado aplicando infinitamente el arma
al enemigo. no termina. 
-}