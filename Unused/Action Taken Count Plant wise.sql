

    WITH CTEMain AS(
		SELECT DISTINCT ITM.IdInvTripMstr
		,CASE WHEN VAM.IdInvTripMstr IS NULL THEN 'Open' ELSE 'Closed' END ActionTaken
		FROM INVOICE_TRIP_MASTER ITM WITH (NOLOCK)
		JOIN DeviceMaster DM ON ITM.IMEI=DM.IMEINO
		JOIN funcGetPlanCodeByRole(1,123456)ROL ON DM.PlantCode=ROL.PlantCode
		LEFT JOIN ACTION_TAKEN_REMARKS VAM ON ITM.IdInvTripMstr=VAM.IdInvTripMstr
		WHERE ITM.DocumentTime BETWEEN '2022-01-01' AND '2023-01-01' AND IsComplete=1  and DM.PlantCode=2373
		)

		SELECT COUNT(DISTINCT IdInvTripMstr) FROM (
		SELECT ITM.*,SPDCount ViolationCount,VIOLTYPE FROM CTEMain ITM
		 JOIN (SELECT COUNT(*) SPDCount,IdInvTripMstr,'Speed Voilation' as VIOLTYPE FROM SpeedVoilationDetailedReport WHERE HighestSpeed > 60 GROUP BY IdInvTripMstr) SPD ON ITM.IdInvTripMstr=SPD.IdInvTripMstr	
		UNION 
		SELECT ITM.*,STPCount ViolationCount,VIOLTYPE FROM CTEMain ITM
		 JOIN (SELECT COUNT(*) STPCount,IdInvTripMstr,'Stoppage Voilation' as VIOLTYPE FROM StoppageViolationDetailedReport GROUP BY IdInvTripMstr) STP ON ITM.IdInvTripMstr=STP.IdInvTripMstr	
		UNION 
		SELECT ITM.*,RVCount ViolationCount,VIOLTYPE FROM CTEMain ITM
		 JOIN (SELECT COUNT(*) RVCount,IdInvTripMstr,'Route Voilation' as VIOLTYPE FROM Route_Voilation_Report GROUP BY IdInvTripMstr) RV ON ITM.IdInvTripMstr=RV.IdInvTripMstr	
		UNION 
		SELECT ITM.*,NGTCount ViolationCount,VIOLTYPE FROM CTEMain ITM
		 JOIN (SELECT COUNT(*) NGTCount,IdInvTripMstr,'Night Driving Voilation' as VIOLTYPE FROM NightDrivingVoilationDetailedReport  GROUP BY IdInvTripMstr) NGT ON ITM.IdInvTripMstr=NGT.IdInvTripMstr	
		UNION 
		SELECT ITM.*,VMUOFCount ViolationCount,VIOLTYPE FROM CTEMain ITM
		 JOIN (SELECT COUNT(*) VMUOFCount,IdInvTripMstr,'Tampering of VMU of VTS' as VIOLTYPE FROM VMUOffReport  GROUP BY IdInvTripMstr) VMU ON ITM.IdInvTripMstr=VMU.IdInvTripMstr	
	)T 
	WHERE ViolationCount>0 AND ActionTaken='CLOSED' 
