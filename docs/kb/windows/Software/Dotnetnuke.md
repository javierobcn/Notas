## La Caché de los módulos en Dotnetnuke

En general todos los módulos que, para mostrar información, utilizan plantillas no funcionanarán bien si en la configuración de la caché le pones algo mayor que 0.


## webresource.axd

Resulta que el otro dia activé en algunos portales de nueva creación la compresión para ver como funcionaba. La consecuencia ha sido que que los usuarios no podían crear páginas, que tenian problemas al registrarse y otros problemas varios.

Al final y para todo aquel que le sirva, el error es que si el fichero webresource.axd se comprime, los errores son variados pero coinciden con las validaciones de los formularios.

La solución después de numerosas pruebas ha sido excluir este fichero de la compresión. En las opciones para Host hay una lista de peticiones que se excluyen de la compresión

## WebForm_PostBackOptions undefined

Problemas javascript al registrarse o al crear una página. Este problema aparece al pulsar el botón de registrarse, al intentar añadir una página y en general en todas aquellas situaciones en las que se ve involucrado un control validador Html. Suele darse en versiones DNN 4.5.1 – 4.5.3, para resolverlo  excluye la peticion webresource.axd de la compresión.

Este error se produce como consecuencia del cambio de ASP NET 1 a ASP NET 2. Mientras que en las aplicaciones asp.net 1.0 los validadores estaban incluidos en la carpeta “aspnet_client” a partir de asp.net 2.0 los validadores se procesan como un recurso en la cara del servidor mediante el fichero WebResource.AXD.

He detectado que en caso de estar activada la compresión, el fichero WebResource.AXD ha de excluirse de esta compresión ya que si no los javascripts de los validadores no se renderizan.

Para evitar este error, añada el fichero Webresource.axd a la lista de exclusiones de la compresión.Necesitarás entrar como Host en tu sitio para poder hacer este cambio.

## Obtener Información de la base de datos

Puedes descargar este módulo y agregarlo a una página llamada “Control”. Para ejecutar las consultas configura varios módulos con las consultas inferiores. De esta forma la información se irá refrescando de forma automática en la instalación On-Line…

http://www.dnnstuff.com/Modules/SQLView/tabid/182/Default.aspx

### Última Actividad de Usuarios:

``` SQL
    SELECT Users.Username, Users.FirstName, Users.LastName, aspnet_Users.LastActivityDate
    FROM aspnet_Users INNER JOIN
    Users ON aspnet_Users.UserName = Users.Username
    order by aspnet_Users.LastActivityDate DESC
```

### Último Login de Usuarios:

``` SQL
    SELECT Users.Username, Users.FirstName, Users.LastName, aspnet_Membership.LastLoginDate
    FROM Users INNER JOIN
    aspnet_Users ON Users.Username = aspnet_Users.UserName INNER JOIN
    aspnet_Membership ON aspnet_Users.UserId = aspnet_Membership.UserId
```

###Páginas vistas por mes
GetSiteLog8 0,»,’2005-1-1′,’2007-12-31′ –> El primer parámetro 0 es el ID del portal

###Resumen con los enlaces más visitados
SELECT m.ModuleTitle AS Titulo, t.Url AS URL, t.Clicks, t.LastClick AS [Último Click], t.PortalID AS [Portal ID] FROM UrlTracking AS t INNER JOIN
Modules AS m ON t.ModuleId = m.ModuleID
WHERE (t.PortalID = 1) AND (t.TrackClicks = 1)
ORDER BY t.Clicks DESC

###Resumen de los documentos más descargados
SELECT Documents.Title, UrlTracking.Clicks, UrlTracking.LastClick
FROM Documents LEFT OUTER JOIN
UrlTracking ON Documents.URL = UrlTracking.Url Order by urltracking.clicks desc

###Ultima visita del bot Google u otros…
select top 1 DateTime, cast(DateDiff(minute,DateTime,getDate())/60.00 as
decimal(9,2) ) AS [Hours Ago] from sitelog where portalid = 0 < — Atención aquí tu portalid
and useragent like ‘%googlebot%’
order by DateTime Desc

###Listado de los 20 artículos más vistos (Módulo Ventrian Systems)
    SELECT TOP 20 Title as Título,
    NumberOfViews as Vistas
    FROM DnnForge_NewsArticles_Article
    WHERE IsApproved = 1 –Solo articulos aprobados
    AND IsDraft = 0 –No borradores
    AND StartDate < = GETDATE() –Creado antes de hoy
    AND (EndDate IS NULL
    OR EndDate >= GETDATE()) –Nunca debe expirar, o continuar activo
    ORDER BY NumberOfViews DESC

###Listado de los 20 artículos más votados (Módulo Ventrian Systems) con un contador de los votos emitidos

    SELECT TOP 20 a.Title,
    COUNT(r.rating) AS “Num. Votos”,
    AVG(r.rating) AS “Calificación”
    FROM DnnForge_NewsArticles_Article a
    INNER JOIN DnnForge_NewsArticles_Rating r
    ON (a.articleId = r.articleId)
    WHERE IsApproved = 1 –Solo articulos aprobados
    AND IsDraft = 0 –No borradores
    AND StartDate < = GETDATE() –Creado antes de hoy
    AND (EndDate IS NULL
    OR EndDate >= GETDATE()) –Nunca debe expirar, o continuar activo
    GROUP BY a.Title
    ORDER BY AVG(r.rating) DESC — Cambiar a ASC para ver los menos votados

### Determinar el tamaño de los objetos en la base de datos por si tu instalación de DNN funciona muy lenta o la base de datos es muy grande.

* Chequea el tamaño de la base de datos (SELECT * FROM Sysfiles)
* Chequea la carpeta \Portals\_default\Logs en busca de los ficheros XML más grandes (> 5MBs)
* ¿Cuantas filas hay en la tabla sitelog? (SELECT Count(*) FROM SiteLog)
* ¿Cuantas filas hay en la tabla ScheduleHistory? (SELECT Count(*) FROM ScheduleHistory)
* ¿Cuantas filas hay en la tabla EventLog? (SELECT Count(*) FROM EventLog)
* Puede usarse exec sp_spaceused en tablas especificas para averiguar el espacio físico que ocupan, tamaño de los indices y filas

    exec sp_spaceused SiteLog
    exec sp_spaceused ScheduleHistory
    exec sp_spaceused EventLog

Esta consulta la utilizo en www.verweb.com para devolver los 20 últimos portales con actividad reciente por el administrador. Tiene una característica interesante y es que muestra un hipervínculo en el resultado SQL

    SELECT DISTINCT ‘ dbo.aspnet_Users.LastActivityDate AS [Última Actividad] FROM dbo.aspnet_Users INNER JOIN
    dbo.Users ON dbo.aspnet_Users.UserName = dbo.Users.Username INNER JOIN
    dbo.Portals ON dbo.Users.UserID = dbo.Portals.AdministratorId INNER JOIN
    dbo.PortalAlias ON dbo.Portals.PortalID = dbo.PortalAlias.PortalID
    ORDER BY dbo.aspnet_Users.LastActivityDate DESC

### Referencias

http://www.smart-thinker.com/Resources/SimpleSQL/tabid/267/Default.aspx

http://www.dnnstuff.com/Modules/SQLView/SQLViewSamples/tabid/187/Default.aspx

## DotNetNuke 6 y Log4net

Algún cliente de nuestros servicios de hosting dotnetnuke en Sugestionweb, nos ha indicado que se quedaba sin espacio en disco debido a unos archivos de Log que se están guardando en la carpeta /portals/_default/logs. Desde la versión 6 de DNN, se incluye la librería log4net de Apache y se utiliza para guardar ciertos eventos.

En el directorio raiz de DNN encontramos un archivo de configuración llamado dotnetnuke.log4net.config, es un archivo XML donde podemos especificar numerosos parámetros, por defecto viene así:

```xml
    <?xml version="1.0" encoding="utf-8" ?>
    <log4net>
      <appender name="RollingFile" type="log4net.Appender.RollingFileAppender">
        <file value="Portals/_default/Logs/" />
        <datePattern value="yyyy.MM.dd'.log.resources'" />
        <rollingStyle value="Date" />
        <staticLogFileName value="false" />
        <appendToFile value="true" />
        <maximumFileSize value="10MB" />
        <maxSizeRollBackups value="5" />
        <lockingModel type="log4net.Appender.FileAppender+MinimalLock"/>
        <layout type="log4net.Layout.PatternLayout">
          <conversionPattern value="%date [%property{log4net:HostName}][Thread:%thread][%level] %logger - %message%newline" />
          <locationInfo value="true" />
        </layout>
      </appender>
      <root>
        <level value="Error" />
        <appender-ref ref="RollingFile" />
      </root>
    </log4net>
```
    
En el nodo root encontramos el elemento level value=»Error» , basta cambiar este value a «OFF» para que el log se desactive y dejen de escribirse entradas. Particularmente, yo no lo desactivaría sin antes averiguar que entradas está guardando y por qué se está llenando tanto el Log, pero desactivarlo solucionará tu problema de espacio en disco…

Muchos de los parámetros de la configuración de log4net se explican viendo su nombre, son interesantes File Value donde podremos especificar la ruta donde se guardarán los logs o el de maximumFileSize para especificar el tamaño máximo de cada archivo.

Para obtener información de que hace cada parámetro de la configuración, puedes ver la página de log4net en
http://logging.apache.org/log4net/    


## Backup Portales DNN y SQL

Ponemos el siguiente bat (copia_all.bat) en una carpeta por ej. C:\Users\Administrator\Documents\otrastareas\

Programamos el backup mediante el scheduler para cada dia a las 3 de la mañana

```bat
    @REM Seamonkey’s quick date batch (MMDDYYYY format)
    @REM Set ups %date variable
    @REM First parses month, day, and year into mm , dd, yyyy formats and then combines to be MMDDYYYY
     
    @ECHO OFF
    SETLOCAL
     
    @REM FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
    @REM FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
    @REM FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('echo %CDATE%') DO SET dd=%%B
    @REM FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('echo %CDATE%') DO SET yyyy=%%B
    @REM SET date=%mm%%dd%%yyyy%
    set date=%DATE:/=%
     
    set directory_of_this_script=C:\Users\Administrator\Documents\otrastareas\
    set directory_tmp=C:\Users\Administrator\Documents\otrastareas\tmp\
    set backup_destination=C:\backups\
    set backup_origin=C:\HostingSpaces\
    set instance_sql=.\SQLEXPRESS
     
    REM Delete the previous backups, only the last backup here and download daily for FTP
    del /Q /F  %backup_destination%*.7z
     
    REM Build a list of databases to backup
    SET DBList=%directory_tmp%SQLDBList.txt
    SET FOLDERList=%directory_tmp%FOLDERList.txt
    dir %backup_origin% /AD /B > "%FOLDERList%"
    SqlCmd -E -S %instance_sql% -h-1 -W -Q "SET NoCount ON; SELECT Name FROM master.dbo.sysDatabases WHERE [Name] NOT IN ('master','model','msdb','tempdb')" > "%DBList%"
     
    REM Backup each database, prepending the date to the filename
    FOR /F "tokens=*" %%I IN (%DBList%) DO (
        ECHO Backing up database: %%I
        SqlCmd -E -S %instance_sql% -Q "BACKUP DATABASE [%%I] TO Disk='%directory_tmp%%date%_%%I.bak'"
        7za a -r %backup_destination%%%I_SQL_%date%.7z %directory_tmp%%date%_%%I.bak
        del %directory_tmp%%date%_%%I.bak
         
    ECHO.
    )
     
    REM Backup each folder,
    FOR /F "tokens=*" %%I IN (%FOLDERList%) DO (
        ECHO Backing up folder: %%I
        7za a -r %backup_destination%%%I_%date%.7z %backup_origin%%%I\
    ECHO.
    )
     
    REM Clean up the temp file
    IF EXIST "%DBList%" DEL /F /Q "%DBList%"
    IF EXIST "%FOLDERList%" DEL /F /Q "%FOLDERList%"
     
    ENDLOCAL
    
```


##Error en DotNetNuke 4.4.1 con menú en vertical

La versión de instalación de Dotnetnuke 4.4.1 no incluye algunas librerías necesarias para el sistema de navegación en vertical.

Esto ocasiona que al cambiar de skin a uno cuyo menú esté definido en vertical el Dotnetnuke falle. Sube por FTP el archivo DotNetNuke.DNNTreeNavigationProvider.dll, que podrás extraerlo de una versión anterior de Dotnetnuke, a la carpeta /BIN con eso solucionarás el problema.

##Log del Sitio

Recientemente, he tenido alguna dificultad para comenzar a ver las entradas del Log del sitio, como era una instalación nueva ha habido que configurar algo.

Entra como Host y en Configuración del Host . en Otras Configuraciones, configura el Buffer del Log a 1, la historia en dias a 90 o a otro valor que prefieras, desmarca la casilla Usar Buffer del Log…

También, en Admin, Configuraciones del Sitio, Configuraciones Avanzadas, Historia en dias del Log escribe un numero de dias, por ej. 90

Con estos pasos deberías empezar a ver entradas en el Log

##La tabla Cat_Resources en Catalook

Después de realizar algunas pruebas, hemos detectado que al eliminar un producto no se eliminan las entradas en la tabla cat_Resources . He desarrollado esta consulta con la que podrás eliminar los registros huérfanos…

```SQL
SELECT * FROM dbo.CAT_Resources
WHERE (SUBSTRING(SUBSTRING(name, CHARINDEX('_', name) +1, LEN(name) - CHARINDEX('_', name)), 1, CHARINDEX('_', SUBSTRING(name,
CHARINDEX('_', name) +1, LEN(name) - CHARINDEX('_', name))) - 1) NOT IN
(SELECT ProductId
FROM Cat_Products))
```

##Optimizar Dotnetnuke

Hay algunas operaciones que podemos y debemos hacer de forma periódica para mantener la instalación DNN lo más fresca y rápida posible. Lee este artículo para obtener más información.

Haz antes una copia de seguridad de la Base de datos por si necesitaras acceder a esta información más adelante..

###Borrar el Sitelog

Con cada petición de página, normalmente se guarda una entrada en el LOG. Con el tiempo esta tabla se llena de forma imparable, así que deberás borrar el contenido de la tabla de forma periódica.

Ejecuta la intrucción
    
    Delete from Sitelog

desde Host – SQL

###Borrar el Eventlog

Muchos eventos dejan su huella en la tabla Eventlog así que periodicamente borra su contenido

Ejecuta la intrucción

    
    Delete from Eventlog

desde Host – SQL

###Borrar el Log de las tareas programas (Schedule History)

Las tareas programadas se ejecutan de forma automática cada cierto tiempo. En cada ejecución almacenan unas 3 entradas en la tabla Schedule History con lo que esta tabla también se va llenando de forma imparable. A partir de las 5000 – 6000 entradas podemos obtener errores de Timeout y algunos módulos como el de usuarios en línea pueden empezar a dar problemas.

Ejecuta la instrucción
    
    Delete from ScheduleHistory

desde Host – SQL

Otros

Chequea el tamaño de la base de datos (SELECT * FROM Sysfiles)
Chequea la carpeta \Portals\_default\Logs en busca de los ficheros XML más grandes (> 5MBs)
