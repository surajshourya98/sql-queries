

				                            
;WITH TotalRoutesUpload  AS 
(
	--select DISTINCT RM.TERMINAL_CODE+'$'+ RM.ROCO_CODE+'$'+rm.Reverification ROUTE, OP46Num, UPLOAD_DATE
	select DISTINCT RM.TERMINAL_CODE  + '$' + RM.ROCO_CODE + '$' + rm.Reverification ROUTE, RM.OP46Num as OP46Num, 
	RM.UPLOAD_DATE AS DATE , RM.ROUTE_NO AS NUMBER , RM.ROUTE_VERSION AS VERSION
	from ROCO_ROUTEMASTER RM
	JOIN ROCO_DETAILMASTER DM 
	ON RM.TERMINAL_CODE=DM.TERMINAL_CODE AND RM.ROCO_CODE=DM.ROCO_CODE
	where RTD_Type='Transport RTD'AND LOGINID='T06' 
) ,

Approved AS (
	select DISTINCT RM.TERMINAL_CODE+'$'+ RM.ROCO_CODE+'$'+rm.Reverification ROUTE
	from ROCO_ROUTEMASTER RM
	JOIN ROCO_DETAILMASTER DM ON RM.TERMINAL_CODE=DM.TERMINAL_CODE AND RM.ROCO_CODE=DM.ROCO_CODE
	where ROUTE_STATUS='Approved'
    and RTD_Type='Transport RTD' AND LOGINID='T06' 
) ,

REJECTED AS (
	SELECT DISTINCT DM.TERMINAL_CODE + '$'+ DM.ROCO_CODE+'$'+rm.Reverification route
	FROM ROCO_DETAILMASTER DM
	INNER JOIN
	ROCO_ROUTEMASTER RM
	ON
	DM.TERMINAL_CODE = RM.TERMINAL_CODE
	AND DM.ROCO_CODE = RM.ROCO_CODE
	WHERE DM.LOGINID = 'T06'  
	AND RM.ROUTE_STATUS = 'Rejected' and Reverification='Normal'
    -- AND RM.ROUTE_YEAR = @RouteYear 
    and RTD_Type='Transport RTD'
	AND CONVERT(VARCHAR,DM.TERMINAL_CODE) + '$' + DM.ROCO_CODE NOT IN
	(
		SELECT DISTINCT CONVERT(VARCHAR,TERMINAL_CODE) + '$' + ROCO_CODE
		FROM ROCO_ROUTEMASTER
		WHERE ROUTE_STATUS IN ('Submitted', 'Approved')
        --and ROUTE_YEAR = @RouteYear 
        and RTD_Type='Transport RTD' and Reverification='Normal'
	)
	and DM.TERMINAL_CODE+'$'+ DM.ROCO_CODE in 
	(
		select substring(op46num,9,4)+'$'+substring(op46num,16,6)
		from ROCO_APPR_REJ_MASTER where  RTD_Type='Transport RTD'
		and RejectedByEmpLoginId in 
		(
			select USER_FO AS OFFICIAL from roco_relationmaster where USER_FO='T06' 
			UNION
			select DIV_HEAD_ROCO from roco_relationmaster where USER_FO='T06' 
			UNION
			select SLC_SALES_ROCO  from roco_relationmaster where USER_FO='T06' 
			UNION
			select SLC_FIN  from roco_relationmaster where USER_FO='T06'  
			UNION
			select SLC_OPS from roco_relationmaster where USER_FO='T06'  
			UNION
			select SFH_OPS from roco_relationmaster where USER_FO='T06' 
		) 
	)	
)

SELECT OP46Num, DATE, NUMBER, VERSION FROM  TotalRoutesUpload 
WHERE ROUTE NOT IN 
(
	SELECT * FROM Approved
	UNION
	SELECT * FROM REJECTED
)