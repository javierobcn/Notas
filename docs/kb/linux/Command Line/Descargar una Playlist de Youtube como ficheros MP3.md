#Descargar una Playlist de Youtube como ficheros MP3

O ampliar tu colección de música «by the face» 🙂

Instalamos la última versión de youtube-dl y le damos permisos de ejecución a todos los usuarios de la máquina local con:

    sudo wget https://yt-dl.org/latest/youtube-dl -O /usr/local/bin/youtube-dl
    sudo chmod a+x /usr/local/bin/youtube-dl
    youtube-dl --version

Ahora para descargar por ejemplo mi lista de música disponible en:

https://www.youtube.com/playlist?list=PL2gdCKFmkidaN-hDS1x_RJYrBlzIKhCt4 

ejecutamos el comando:
 
    mkdir descarga_playlist
    youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "https://www.youtube.com/playlist?list=PL2gdCKFmkidaN-hDS1x_RJYrBlzIKhCt4"