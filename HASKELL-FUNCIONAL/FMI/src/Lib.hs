module Lib where
import Text.Show.Functions
import Data.List


data Pais = UnPais {
    ingresoPerCapita :: Int,
    poblacionPriv ::Int,
    poblacionPub :: Int,
    recursosNat :: [String],
    deudaFMI :: Int
}

type Estrategia = Pais -> Pais

cambiarDeuda :: (Int -> Int) -> Estrategia
cambiarDeuda f pais = pais {deudaFMI = f (deudaFMI pais)}

cambiarPobPublica :: (Int -> Int) -> Estrategia
cambiarPobPublica f pais = pais {poblacionPub = f (poblacionPub pais)}

cambiarIngresoPorCapita ::(Int -> Int) -> Estrategia
cambiarIngresoPorCapita f pais = pais {ingresoPerCapita = f (ingresoPerCapita pais)}

prestarle :: Int -> Estrategia
prestarle millones = cambiarDeuda (\deudaAct -> deudaAct + ((`div`100)millones*150)) 

reducirPuestosTrabajo :: Int -> Estrategia
reducirPuestosTrabajo cantidad pais 
    |cantidad > 100 = cambiar cantidad 80 pais
    |otherwise = cambiar cantidad 85 pais
        
cambiar :: Int -> Int -> Estrategia
cambiar trabajos porcentaje = cambiarPobPublica (\existentes -> existentes-trabajos).cambiarIngresoPorCapita (\actual ->((`div`100)actual*porcentaje))

darEmpresaAlFMI :: String -> Estrategia 
darEmpresaAlFMI recurso = quitarRecurso recurso . cambiarDeuda (\actual -> actual - 2) 

quitarRecurso :: String -> Estrategia
quitarRecurso recurso pais = pais {recursosNat = filter ((/=)recurso) (recursosNat pais)} 

{- blindaje :: Estrategia
blindaje pais =(cambiarPobPublica (\actual -> actual-500). cambiarDeuda (pbi pais)) pais
-}

poblacionActiva :: Pais -> Int 
poblacionActiva pais = poblacionPriv pais + poblacionPub pais

pbi :: Pais -> Int
pbi pais = ingresoPerCapita pais * (poblacionActiva pais) 

------1
namibia :: Pais
namibia = UnPais {
    ingresoPerCapita= 4140,
    poblacionPub = 400000,
    poblacionPriv = 650000,
    recursosNat = ["mineria", "ecoturismo"],
    deudaFMI = 50    
}

------2
implementarEstrategias :: Estrategia -> Pais -> Pais
implementarEstrategias estrategia = estrategia

-------3
type Receta = [Estrategia]

recetaEj :: Receta
recetaEj = [prestarle 200, darEmpresaAlFMI "mineria"]

aplicarReceta :: Receta -> Pais -> Pais
aplicarReceta receta pais = foldr ($) pais receta

--foldl (\pais estrategia -> estrategia pais) pais receta

-------4
zafa :: [Pais] ->[Pais]
zafa = filter (elem "petroleo".recursosNat)

totalDeuda :: [Pais] -> Int
totalDeuda = sum . map deudaFMI --foldr ((+) . deuda) 0 paises

------5
estaOrdenada :: Pais -> [Receta] -> Bool
estaOrdenada pais [receta] = True
estaOrdenada pais (receta1 : receta2 : recetas) = revisarPBI receta1 pais <= revisarPBI receta2 pais && estaOrdenada pais (receta2 : recetas)

revisarPBI :: Receta -> Pais -> Int
revisarPBI receta = pbi.aplicarReceta receta 

{- = pbiConRecetas pais recetas == sort (pbiConRecetas pais recetas)
    
pbiConRecetas :: Pais -> [Receta]-> [Int]
pbiConRecetas pais= map pbi . map (`aplicarReceta` pais) -}

--------6
recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos

--a
{-
si se evaluase la lista infinita en el 4a, la funcion se quedaria colgada buscando la palabra
petroleo en una lista infitnita de "energia", por lo que no termiaria.
-}
--b
{-
se puede ya que esta no tiene en cuenta los recursos naturales, solo la deuda que tiene el pais, que es finito.
esta relacionado con la EVALUCION DIFERIDA, SOLO EVALUO LO QUE NECESITO. LAZY EVALUATION.
-}