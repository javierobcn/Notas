
##Evitar cerrar y reducir de forma automática la base de datos SQL Server

Si en tu visor de eventos de Windows Server aparecen muchas entradas informativas del servicio SQL Server con el texto «Starting up database nombredelaBD» quiere decir que tu base de datos se está cerrando de forma automática y volviendo a arrancar cuando se le solicitan nuevas conexiones.

En un entorno de producción se han de desactivar las opciones «Cerrar automaticamente» y «Reducir automáticamente».

Ambas opciones están ubicadas a nivel de propiedades de la base de datos, en el grupo de propiedades «Opciones» y en «Automático».

Fuentes:

http://sqlmag.com/sql-server/avoiding-autoclose-and-autoshrink-options
http://technet.microsoft.com/es-es/library/ms135094%28v=sql.105%29.aspx
http://technet.microsoft.com/es-es/library/ms136209%28v=sql.105%29.aspx

##Consulta SQL Server para obtener el número de registros de cada tabla

La siguiente consulta es muy útil cuando queremos ver el número de registros que contiene cada tabla de una base de datos SQL Server. Normalmente cuantos mas registros haya en una tabla, mas espacio ocupará, así que es una forma de averiguar que tablas ocupan mas tamaño en una base de datos.

```SQL
select si.rows as 'filas', SO.Name as Tabla, SI.name as 'Index', SFG.groupname as 'Filegroup'
from sysobjects as SO
    join sysindexes as SI on SO.Id = SI.id
    join sysfilegroups as SFG on SI.GroupId = SFG.GroupId
order by si.rows desc, SO.Name , SI.name, SFG.GroupName
```
También hay otra opción mas completa, encontré este procedimiento hace un tiempo:

```SQL
CREATE PROCEDURE GetAllTableSizes
AS
/*
    Obtains spaced used data for ALL user tables in the database
*/
DECLARE @TableName VARCHAR(100)    --For storing values in the cursor
 
--Cursor to get the name of all user tables from the sysobjects listing
DECLARE tableCursor CURSOR
FOR
select [name]
from dbo.sysobjects
where  OBJECTPROPERTY(id, N'IsUserTable') = 1
FOR READ ONLY
 
--A procedure level temp table to store the results
CREATE TABLE #TempTable
(
    tableName varchar(100),
    numberofRows varchar(100),
    reservedSize varchar(50),
    dataSize varchar(50),
    indexSize varchar(50),
    unusedSize varchar(50)
)
 
--Open the cursor
OPEN tableCursor
 
--Get the first table name from the cursor
FETCH NEXT FROM tableCursor INTO @TableName
 
--Loop until the cursor was not able to fetch
WHILE (@@Fetch_Status &amp;gt;= 0)
BEGIN
    --Dump the results of the sp_spaceused query to the temp table
    INSERT  #TempTable
        EXEC sp_spaceused @TableName
 
    --Get the next table name
    FETCH NEXT FROM tableCursor INTO @TableName
END
 
--Get rid of the cursor
CLOSE tableCursor
DEALLOCATE tableCursor
 
--Select all records so we can use the reults
SELECT *
FROM #TempTable
 
--Final cleanup!
DROP TABLE #TempTable
 
GO
Despues podemos ejecutar el procedimiento con el comando
EXEC GetAllTableSizes
```
y podriamos ver el resultado, algo como:


Otra consulta que hace lo mismo de otra forma

```SQL

SELECT
    X.[name], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[rows]), 1), '.00', '') 
        AS [rows], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[reserved]), 1), '.00', '') 
        AS [reserved], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[data]), 1), '.00', '') 
        AS [data], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[index_size]), 1), '.00', '') 
        AS [index_size], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[unused]), 1), '.00', '') 
        AS [unused] 
FROM
(SELECT
    CAST(object_name(id) AS varchar(50)) 
        AS [name], 
    SUM(CASE WHEN indid < 2 THEN CONVERT(bigint, [rows]) END) 
        AS [rows],
    SUM(CONVERT(bigint, reserved)) * 8 
        AS reserved, 
    SUM(CONVERT(bigint, dpages)) * 8 
        AS data, 
    SUM(CONVERT(bigint, used) - CONVERT(bigint, dpages)) * 8 
        AS index_size, 
    SUM(CONVERT(bigint, reserved) - CONVERT(bigint, used)) * 8 
        AS unused 
    FROM sysindexes WITH (NOLOCK) 
    WHERE sysindexes.indid IN (0, 1, 255) 
        AND sysindexes.id > 100 
        AND object_name(sysindexes.id) <> 'dtproperties'
    GROUP BY sysindexes.id WITH ROLLUP
) AS X
WHERE X.[name] is not null
ORDER BY X.[rows] DESC
```