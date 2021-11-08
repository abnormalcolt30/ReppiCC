## Readme

Capas de la aplicacion
- Datos (MovieRepository, SerieRepository)
- Red (Http, API)
- Negocio (StartViewModel, DetailViewModel)
- Vistas (StartView, DetailsView, Cells folder, Component Fonder)
- Modelos (Movie, Serie, Content, Videos)


Responsabilidad de cada clase
Moview y Serie Reposotory son las encargadas de proveer la interfaz de data a la capa logica, estas determinan si hay conexion a internet para ir a buscar al API o caso contrario usar el cache

Http y API son la interfaz de consumo de recursos remotos, son genericas y encodean al modelo que se envie, en caso de no poder encodear retornaran error

StartViewModel y DetailViewModel son los encargados de generar los blueprints para las vistas y ejecutar las llamadas a los repositorios para obtener la data, estan conectados con objetos publushed con las vistas

Modelos, el modelo de content funciona como un wrapper para poder enviar de manera sencilla data a la vista de detalle