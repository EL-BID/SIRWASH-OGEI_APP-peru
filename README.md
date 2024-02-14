# Pasos para levantar el proyecto

1. Clonar el repositorio e ingresar a la carpeta de la aplicación.
3. Ejecutar el siguiente comando para descargar las dependencias.
```
flutter pub get
```
4. Seleccionar emulador
5. Ejecutar en modo depuración con F5

<br>
NOTA: Para más detalles, revisar el manual técnico de apps entregado.

Para cambiar el ícono de la aplicación
1. Cambiar los iconos en la carpeta assets/appicon/
<br>
NOTA: Los iconos adaptativos (foreground y background) deben tener la extensión.png. El otro ícono (app-icon) puede ser .jpg o .png
<br>
Referencia: https://github.com/fluttercommunity/flutter_launcher_icons/issues/148
2. Verificar la configuración en pubspec.yaml
3. Ejecutar el siguiente comando
```
flutter pub run flutter_launcher_icons
```
