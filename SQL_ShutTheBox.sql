

--Dice sides:
DECLARE @MaxDice INT = 8;

--Shut the box possibilities between:
DECLARE @MinAnswer INT = 1;
DECLARE @MaxAnswer INT = 10;


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
	UNION ALL
	SELECT pc.d1, pc.d2, pc.d2
	FROM PossibleCominations pc
	UNION all
	SELECT pc.d1, pc.d2, pc.Sum
	FROM PossibleCominations pc
/*
	UNION all
	SELECT pc.d1, pc.d2, pc.Minus
	FROM PossibleCominations pc
	UNION all
	SELECT pc.d1, pc.d2, pc.Multiply
	FROM PossibleCominations pc
--*/
), TotalCount(tc) AS
(
	SELECT COUNT(*) 
	FROM Answers
), CompleteAnswerSet(Answer) AS
(
	SELECT @MinAnswer
	UNION ALL
    SELECT Answer + 1
	FROM CompleteAnswerSet c
	WHERE c.Answer < @MaxAnswer
)
SELECT 
	 cas.Answer
	,[Possible Outcomes] = MAX(z.AnswerCount)
	,[Chance to roll] = CAST((MAX(z.AnswerCount) / CAST(MAX(t.tc) AS DECIMAL(6,2)))*100.0 AS DECIMAL(6,2))
FROM CompleteAnswerSet cas
CROSS JOIN TotalCount t
OUTER APPLY (
	SELECT COUNT(*)
	FROM Answers a
	WHERE a.Answer = cas.Answer
) z (AnswerCount)
WHERE cas.Answer BETWEEN @MinAnswer AND @MaxAnswer
GROUP BY cas.Answer
ORDER BY cas.Answer;
