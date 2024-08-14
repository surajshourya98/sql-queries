
SELECT DISTINCT Toll.TOLL_PLAZA, tOLL.TOLL_6T_Rs, M.OP46Num,M.Toll_Id_Supply,
m.sno,
category = (cat.value),
rn = ROW_NUMBER() OVER (PARTITION BY M.sno ORDER BY (SELECT NULL))
,'https://mlinfomap.com/BSOLPGTollPDFViewer/'+toll.TOLL_PLAZA +'.pdf' CurrRoute_RoundTripTollFilePath_Supply
FROM ROCO_ROUTEMASTER m
CROSS APPLY STRING_SPLIT(Toll_Id_Supply, ',') cat
 JOIN ML_ORG.LPG_GeoRTDBSO_ROUTE.dbo.TOLL_PLAZA_BKP28SEP Toll on (cat.value=toll.sno or cat.value=toll.Toll_ID)
WHERE (m.Toll_Id_Supply  IS NOT NULL or m.Toll_Id_Supply='') --and len( cat.value)<3 
--AND M.SNO IN (
--SELECT SNO FROM ROCO_ROUTEMASTER WHERE OP46Num='BSORTD/2379/DB/261264/R-III/1/2022/22396'
--)
--TERMINAL && STATUS APPROVED
and  m.TERMINAL_CODE='2375' and m.ROUTE_STATUS='Approved'




 --select  * from ML_ORG.LPG_GeoRTDBSO_ROUTE.dbo.TOLL_PLAZA_BKP28SEP
