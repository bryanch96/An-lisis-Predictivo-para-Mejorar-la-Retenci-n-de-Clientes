Create Database BancoP;
use BancoP;
--Cambio de nombre de  columnas 

EXEC sp_rename 'dbo.BancoProyecto.Balance', 'Saldo', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.CustomerId', 'ID', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.Surname', 'Apellido', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.CreditScore', 'Cal_Crediticia', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.Gender', 'Genero', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.Age', 'Edad', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.HasCrCard', 'Tarjeta', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.ISActiveMember', 'Miembro_Activo', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.EstimatedSalary', 'Salario', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.Exited', 'Fuera_Del_Banco', 'COLUMN';
EXEC sp_rename 'dbo.BancoProyecto.Tenure', 'Tiempo_Cliente', 'COLUMN';


Select Top 1000 *
From[dbo].[BancoProyecto];

Select Count(*)
From [dbo].[BancoProyecto]
where Saldo is null;

Select Count(*)
From [dbo].[BancoProyecto]
where Edad is null;

Select Count(*)
From [dbo].[BancoProyecto]
where Miembro_Activo is null;

Select Count(*)
From [dbo].[BancoProyecto]
where Tarjeta is null;

Select Count(*)
From [dbo].[BancoProyecto]
where Genero is null;

Select Count(*)
From [dbo].[BancoProyecto]
where Fuera_Del_Banco is null;

--Revision de Duplicados en ID
Select ID, Count(*) As Revision
From [dbo].[BancoProyecto]
Group by ID
Having Count(*) <1;

--Para ver Categorizacion de Generos 
Select Distinct Genero From [dbo].[BancoProyecto];

--Para ver Categorizacion de Salidas 1=Si 2=No
Select Distinct Fuera_Del_Banco From [dbo].[BancoProyecto];

--Para ver Categorizacion de Si es Miembro Activo 1=Si 2=No
Select Distinct Miembro_Activo From [dbo].[BancoProyecto];

--Para ver Categorizacion de si tiene Tarjeta de Credito 1=Si 2=No
Select Distinct Tarjeta From [dbo].[BancoProyecto];


-- Saldo es de tipo VarChar y debe ser Decimal 

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BancoProyecto' AND COLUMN_NAME = 'Saldo';

--Converti datos no numericos en Decimales
ALTER TABLE [dbo].[BancoProyecto]
ALTER COLUMN Saldo DECIMAL(18, 2);

-- Cal_Crediticia es de tipo VarChar y debe ser Decimal 
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BancoProyecto' AND COLUMN_NAME = 'Cal_Crediticia';

--Converti datos no numericos en Decimales
ALTER TABLE [dbo].[BancoProyecto]
ALTER COLUMN Cal_Crediticia DECIMAL(18, 2);


-- Edad es de tipo VarChar y debe ser entero 
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BancoProyecto' AND COLUMN_NAME = 'Edad';

--Converti datos no numericos en entero
ALTER TABLE [dbo].[BancoProyecto]
ALTER COLUMN Edad Int;


--Tiempo_Cliente es de tipo VarChar y debe ser entero 
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BancoProyecto' AND COLUMN_NAME = 'Tiempo_Cliente';

--Converti datos no numericos en entero
ALTER TABLE [dbo].[BancoProyecto]
ALTER COLUMN Tiempo_Cliente Int;



--Aca comprobamos que no existen edades menores al tiempo en el banco
Select*
From BancoProyecto
Where Edad<Tiempo_Cliente;

--Actualizamos los valores de Genero
Update [dbo].[BancoProyecto]
set Genero =
Case
When Genero = 'Female' Then 'Femenino'
Else 'Masculino'
End;

--Creamos un rango en edad para manejar mejor los datos

UPDATE dbo.BancoProyecto
SET Edad = CASE
    WHEN Edad BETWEEN 0 AND 10 THEN '0-10'
    WHEN Edad BETWEEN 11 AND 20 THEN '11-20'
    WHEN Edad BETWEEN 21 AND 30 THEN '21-30'
    WHEN Edad BETWEEN 31 AND 40 THEN '31-40'
    WHEN Edad BETWEEN 41 AND 50 THEN '41-50'
    WHEN Edad BETWEEN 51 AND 60 THEN '51-60'
    WHEN Edad BETWEEN 61 AND 70 THEN '61-70'
    ELSE '71+'
END;

ALTER TABLE dbo.BancoProyecto
ALTER COLUMN Edad NVARCHAR(10);

--Combertimos el 1 y 0 en si y no para comprender mejor

ALTER TABLE dbo.BancoProyecto
ALTER COLUMN Miembro_Activo NVARCHAR(3);

UPDATE dbo.BancoProyecto
SET Miembro_Activo = CASE
    WHEN Miembro_Activo = '0' THEN 'No'
    WHEN Miembro_Activo = '1' THEN 'Sí'
    ELSE Miembro_Activo
END;

--Combertimos el 1 y 0 en si y no para comprender mejor
ALTER TABLE dbo.BancoProyecto
ALTER COLUMN Fuera_Del_Banco NVARCHAR(3);

UPDATE dbo.BancoProyecto
SET Fuera_Del_Banco = CASE
    WHEN Fuera_Del_Banco = '0' THEN 'No'
    WHEN Fuera_Del_Banco = '1' THEN 'Sí'
    ELSE Fuera_Del_Banco
END;

--Combertimos el 1 y 0 en si y no para comprender mejor
ALTER TABLE dbo.BancoProyecto
ALTER COLUMN Tarjeta NVARCHAR(3);

UPDATE dbo.BancoProyecto
SET Tarjeta = CASE
    WHEN Tarjeta = '0' THEN 'No'
    WHEN Tarjeta = '1' THEN 'Sí'
    ELSE Tarjeta
END;

-- vamos a hacer rangos en el saldo para estudiar mejor los datos 


SELECT MAX(Saldo) AS MaxSaldo
FROM dbo.BancoProyecto;
SELECT Min(Saldo) AS MaxSaldo
FROM dbo.BancoProyecto;

ALTER TABLE dbo.BancoProyecto
ADD RangoSaldo NVARCHAR(50);

-- Definir variables para los rangos
DECLARE @MaxSaldo DECIMAL(18, 2) = 250898.09;
DECLARE @Rango DECIMAL(18, 2) = @MaxSaldo / 5;
DECLARE @Rango1 DECIMAL(18, 2) = @Rango;
DECLARE @Rango2 DECIMAL(18, 2) = @Rango * 2;
DECLARE @Rango3 DECIMAL(18, 2) = @Rango * 3;
DECLARE @Rango4 DECIMAL(18, 2) = @Rango * 4;

-- Actualizar la columna RangoSaldo con los rangos en formato de texto
UPDATE dbo.BancoProyecto
SET RangoSaldo = CASE
    WHEN Saldo <= @Rango1 THEN '0 - ' + CAST(@Rango1 AS NVARCHAR(20))
    WHEN Saldo <= @Rango2 THEN CAST(@Rango1 AS NVARCHAR(20)) + ' - ' + CAST(@Rango2 AS NVARCHAR(20))
    WHEN Saldo <= @Rango3 THEN CAST(@Rango2 AS NVARCHAR(20)) + ' - ' + CAST(@Rango3 AS NVARCHAR(20))
    WHEN Saldo <= @Rango4 THEN CAST(@Rango3 AS NVARCHAR(20)) + ' - ' + CAST(@Rango4 AS NVARCHAR(20))
    ELSE CAST(@Rango4 AS NVARCHAR(20)) + ' - ' + CAST(@MaxSaldo AS NVARCHAR(20))
END;



SELECT TOP 1000 *
FROM dbo.BancoProyecto;



Create Database PBD;
Use PBD


--Creamos la dimension de Genero 
Select Genero Descripcion_Genero,
ROW_NUMBER() Over (Order By Genero) Id_Genero
Into PBD.Dbo.Dim_Banco_Genero
From [dbo].[BancoProyecto]
Group by Genero
Order by Genero;

--Creamos la dimension de Edad
Select Edad Rango_Edad,
ROW_NUMBER() Over (Order By Edad) Id_Edad
Into PBD.Dbo.Dim_Banco_Edad
From [dbo].[BancoProyecto]
Group by Edad
Order by Edad;

--Creamos la dimension de Miembro_Activo

Select Miembro_Activo Miembro_Activo,
ROW_NUMBER() Over (Order By Miembro_Activo) Id_Miembro_Activo
Into PBD.Dbo.Dim_Banco_Miembro_Activo
From [dbo].[BancoProyecto]
Group by Miembro_Activo
Order by Miembro_Activo;


--Creamos la dimension de Tarjeta
Select Tarjeta Tarjeta,
ROW_NUMBER() Over (Order By Tarjeta) Id_Tarjeta
Into PBD.Dbo.Dim_Banco_Tarjeta
From [dbo].[BancoProyecto]
Group by Tarjeta
Order by Tarjeta;

--Creamos la dimension de Saldo
Select RangoSaldo Rango_Saldo,
ROW_NUMBER() Over (Order By RangoSaldo) Id_Rango_Saldo
Into PBD.Dbo.Dim_Banco_Rango_Saldo
From [dbo].[BancoProyecto]
Group by RangoSaldo
Order by RangoSaldo;


--Creamos la dimension de Fuera_Del_Banco
Select Fuera_Del_Banco Fuera_Del_Banco,
ROW_NUMBER() Over (Order By Fuera_Del_Banco) Id_Fuera_Del_Banco
Into PBD.Dbo.Dim_Banco_Fuera_Del_Banco
From [dbo].[BancoProyecto]
Group by Fuera_Del_Banco
Order by Fuera_Del_Banco;
--Creacion del FAC
Select  B.ID,
DG.Id_Genero, 
DE.Id_Edad,
DM.Id_Miembro_Activo,
DT.Id_Tarjeta,
DS.Id_Rango_Saldo,
DF.Id_Fuera_Del_Banco

Into PBD.Dbo.FAC_Banco_Datos
From [dbo].[BancoProyecto] B
Join PBD.Dbo.Dim_Banco_Genero DG on DG.Descripcion_Genero = B.Genero
join PBD.Dbo.Dim_Banco_Edad DE on DE.Rango_Edad = B.Edad
Join PBD.Dbo.Dim_Banco_Miembro_Activo DM on DM.Miembro_Activo = B.Miembro_Activo
Join PBD.Dbo.Dim_Banco_Tarjeta DT on DT.Tarjeta = B.Tarjeta
Join PBD.Dbo.Dim_Banco_Rango_Saldo DS on DS.Rango_Saldo = B.RangoSaldo
Join PBD.Dbo.Dim_Banco_Fuera_Del_Banco DF on DF.Fuera_Del_Banco = B.Fuera_Del_Banco;