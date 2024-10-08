


SELECT DISTINCT R.ROCO_CODE, R.TERMINAL_CODE, R.ROUTE_YEAR,R.ROUTE_STATUS, R.Reverification,
CASE WHEN N.Reverification IS NULL THEN 0 ELSE 1 END REV
FROM ROCO_ROUTEMASTER R
JOIN ROCO_ROUTE_VERIFIED_HIERARCHY RV ON R.OP46Num = RV.OP46Num
LEFT JOIN (SELECT * FROM ROCO_ROUTEMASTER WHERE Reverification='Reverification-1')N ON N.ROCO_CODE=R.ROCO_CODE AND N.TERMINAL_CODE=R.TERMINAL_CODE
WHERE R.ROUTE_STATUS = 'APPROVED' AND R.Reverification = 'NORMAL' --AND RV.ApprovalNumber IS NOT NULL

