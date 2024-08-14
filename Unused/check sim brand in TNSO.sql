


SELECT * FROM DeviceMaster DM

 LEFT JOIN
	   (
	   SELECT [Mobile No],'Airtel' as ISP
  FROM [GEORTD_TN_VTS].[dbo].[ALL_BhartiAirtelDec20]
where [Mobile No] in (select SIM_NUMBER from DeviceMaster where IsVehAssign=1)
UNION
SELECT [Mobile No],'Vodafone' as ISP
  FROM [GEORTD_TN_VTS].[dbo].[ALL_VodafoneIdeaDec20]
  where [Mobile No] in (select SIM_NUMBER from DeviceMaster where IsVehAssign=1)
	   )ISP ON DM.SIM_NUMBER=ISP.[Mobile No]
	   WHERE AssignVehNo  = 'TN32BA0331'



	