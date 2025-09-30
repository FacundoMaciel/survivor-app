# Survivor App

Aplicación Flutter para el modo “Survival La Liga”, donde los usuarios compiten por vidas, pozo acumulado y supervivencia.

## Tabla de contenidos

- [Demo / Capturas](#demo--capturas)  
- [Características](#características)  
- [Arquitectura / Estructura](#arquitectura--estructura)  
- [Instalación](#instalación)  
- [Uso / ejecución](#uso--ejecución)  
- [Flujos / navegación](#flujos--navegación)  
- [Dependencias principales](#dependencias-principales)  
- [Assets / íconos / recursos](#assets--íconos--recursos)  
- [Pruebas](#pruebas)  
- [Contribución](#contribución)  
- [Licencia](#licencia)  

---

## Demo / Capturas

<img src="screenshots/captura1.png" width="400"/>
<img src="screenshots/captura2.png" width="400"/>
<img src="screenshots/captura3.png" width="400"/>
<img src="screenshots/captura4.png" width="400"/>
<img src="screenshots/captura5.png" width="400"/>
<img src="screenshots/captura6.png" width="400"/>
<img src="screenshots/captura7.png" width="400"/>
<img src="screenshots/captura8.png" width="400"/>
<img src="screenshots/captura9.png" width="400"/>
<img src="screenshots/captura10.png" width="400"/>
<img src="screenshots/captura11.png" width="400"/>
<img src="screenshots/captura12.png" width="400"/>

## Características

- Modo “Survival La Liga”  
- Vidas, posición, pozo acumulado y número de sobrevivientes  
- Listado de jornadas y partidos  
- Navegación entre pestañas: Por jugar / Resultados / Tabla  
- Íconos personalizados y diseño UI moderno  

## Arquitectura / Estructura

La estructura principal del proyecto es:

```
lib/
 ├── main.dart
 ├── screens/
 ├── widgets/
 ├── models/
 ├── services/
 └── utils/
assets/
```

### Navegación básica

El flujo de navegación es:

- Login logico básico para pruebas → Home page  
- En List page: ligas y sus jornadas totales
- Al tocar una liga, ir a Matches page pantalla de detalle  
- En Matches page pestañas “Por jugar”, “Resultados”, “Tabla”, selección de partidos y simulación 
- Cada pestaña muestra su contenido  

## Instalación

```bash
git clone https://github.com/FacundoMaciel/survivor-app.git
cd survivor-app
npm install
flutter pub get
```

## Uso / ejecución

Para correr en dispositivo/emulador:

```bash
flutter run
```

## Flujos / navegación

```mermaid
flowchart LR
  Login --> Home
  List --> Ligas para elegir
  Matches --> PorJugar: es donde seleccionamos los partidos y tenemos la opcionde unirme con mis partidos
  IMPORTANTE--> Para visualizar correctamente la tabla debemos reiniciar nuestra app cuando hayamos hecho la selección y unirme, se hace nuevamente el flujo, "comenzar", seleccion y unirme antes de simular. De esa manera tendriamos 2 o mas (depende de cuantos quiera) usuarios para comparar resultados y tener bien el ranking
  Matches --> Resultados: Es donde (aplicado para pruebas) tenemos "simular" y el deplegable de resultados de la simulación
  Matches --> Tabla: Es donde vemos el ranking de como quedó la competición survivor de esa lga
```

## Dependencias principales

| Paquete         | Uso principal                        |
|-----------------|--------------------------------------|
| flutter_svg     | Renderizar íconos SVG                |
| http / dio      | Solicitudes HTTP a API               |
| provider / bloc | Manejo de estado                     |
| shared_preferences | Almacenamiento local              |

## Assets / íconos / recursos

Los íconos SVG e imagenes se encuentran en `assets/`.  
Ejemplo de uso:

```dart
Image.asset(
            "assets/penkaLogo.png",
             width: 22,
             height: 22,
           ),
```

## Pruebas

Para ejecutar test:

```bash
flutter test
```

(Cuando agregues tests, agregá ejemplos aquí)

## Contribución

1. Hacé un fork  
2. Creá una feature branch (`feature/nombre`)  
3. Realizá commits claros  
4. Abrí un pull request  

## Licencia

Este proyecto está bajo la licencia MIT — ver archivo `LICENSE` para más detalles.  
