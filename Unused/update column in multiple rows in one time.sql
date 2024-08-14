/****** Script for SelectTopNRows command from SSMS  ******/
UPDATE B SET 
Total_Toll_Supply=A.Total_Toll_Supply,
CurrRoute_RoundTripToll_Supply	=a.CurrRoute_RoundTripToll_Supply,
CurrRoute_RoundTripToll_Supply_MultiAxle	=a.CurrRoute_RoundTripToll_Supply_MultiAxle,
Toll_Id_Supply=a.Toll_Id_Supply

--SELECT A.*,B.*
  FROM [GEORTD_BSO_LPG_WEB].[dbo].[Approved] A JOIN 
  ROCO_ROUTEMASTER B ON A.SNO=B.SNO AND A.OP46NUM=B.OP46Num