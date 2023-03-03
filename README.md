# searchcookies

El código es una serie de funciones escritas en PowerShell que buscan cookies almacenadas en diferentes navegadores web. Las funciones están diseñadas para buscar cookies en Google Chrome, Mozilla Firefox, Microsoft Edge y otros navegadores, y guardar la información en archivos de texto separados por navegador en una carpeta correspondiente.

Para cada navegador, las funciones utilizan consultas SQL para extraer información sobre las cookies, como el nombre, el valor, el tiempo de caducidad, el host y la ruta. Luego, esta información se almacena en objetos PowerShell y se agrega a una lista de cookies.

Finalmente, se guarda la lista de cookies en un archivo de texto separado por navegador y se almacena en una carpeta específica del navegador en el directorio actual
