

--Dice sides:
DECLARE @MaxDice TINYINT = 6;

--Shut the box possibilities between:
DECLARE @MinAnswer TINYINT = 1;
DECLARE @MaxAnswer TINYINT = 10;


;WITH Dice (Roll)
AS
(
	SELECT 1
	UNION ALL
    SELECT Roll + 1
	FROM Dice d
	WHERE d.Roll < @MaxDice
)
,PossibleCominations AS
(
	SELECT
		 [d1] = d1.Roll
		,[d2] = d2.Roll
		,[Sum] = d1.Roll + d2.Roll
		,[Minus] = d1.Roll - d2.Roll
		,[Multiply] = d1.Roll * d2.Roll
	FROM Dice d1
	CROSS JOIN Dice d2
)
,Answers AS
(
	SELECT pc.d1, pc.d2, [Answer] = pc.d1
	FROM PossibleCominations pc
	WHERE pc.d1 BETWEEN @MinAnswer AND @MaxAnswer
	UNION ALL
	SELECT pc.d1, pc.d2, pc.d2
	FROM PossibleCominations pc
	WHERE pc.d2 BETWEEN @MinAnswer AND @MaxAnswer
	UNION all
	SELECT pc.d1, pc.d2, pc.Sum
	FROM PossibleCominations pc
	WHERE pc.Sum BETWEEN @MinAnswer AND @MaxAnswer
/*
	UNION all
	SELECT pc.d1, pc.d2, pc.Minus
	FROM PossibleCominations pc
	WHERE pc.Minus BETWEEN @MinAnswer AND @MaxAnswer
	UNION all
	SELECT pc.d1, pc.d2, pc.Multiply
	FROM PossibleCominations pc
	WHERE pc.Multiply BETWEEN @MinAnswer AND @MaxAnswer
--*/
), TotalCount(tc) AS
(
	SELECT COUNT(*) 
	FROM Answers
)
SELECT 
	 a.Answer
	,[Possible Outcomes] = COUNT(*)
	,[Chance to roll] = CAST((COUNT(*) / CAST(MAX(t.tc) AS DECIMAL(5,2)))*100.0 AS DECIMAL(5,2))
FROM Answers a
CROSS JOIN TotalCount t
GROUP BY a.Answer
