/*1.Total Loan Applications*/
--select * from loan_data;--

select count (id) as total_loan_applications from loan_data

/* monitor the Month-to-Date (MTD) Loan Applications
and PRIVIOUS MONTH-TO-DATE(PMTD)

I accidentally forgot to convert a few columns into DATE format, so they were stored as VARCHAR. 
To fix this, we used the SQL CONVERT() function with style code 105, 
which allows SQL Server to correctly interpret the dates in DD-MM-YYYY format.
*/

SELECT COUNT(id) AS MTD_total_loan_applications
FROM loan_data
WHERE
    MONTH(CONVERT(date, issue_date, 105)) = 12
AND YEAR(CONVERT(date, issue_date, 105)) = 2021

SELECT COUNT(id) AS PMTD_total_loan_applications
FROM loan_data
WHERE
    MONTH(CONVERT(date, issue_date, 105)) = 11
AND YEAR(CONVERT(date, issue_date, 105)) = 2021


/* 2.Total Funded Amount */
SELECT 
    SUM(CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount FROM loan_data

/* MTD AND PMTD*/

SELECT 
    SUM(CONVERT(decimal(18,2), loan_amount)) AS MTD_Total_Funded_Amount FROM loan_data
    WHERE
    MONTH(CONVERT(date, issue_date, 105)) = 12
AND YEAR(CONVERT(date, issue_date, 105)) = 2021

SELECT 
    SUM(CONVERT(decimal(18,2), loan_amount)) AS PMTD_Total_Funded_Amount FROM loan_data
    WHERE
    MONTH(CONVERT(date, issue_date, 105)) = 11
AND YEAR(CONVERT(date, issue_date, 105)) = 2021


/* 3.Total Amount Received */

select sum(total_payment) as Total_amount_received from Loan_data


 select sum(total_payment) as MTD_Total_amount_received from Loan_data
    WHERE
    MONTH(CONVERT(date, issue_date, 105)) = 12
AND YEAR(CONVERT(date, issue_date, 105)) = 2021

select sum(total_payment) as PMTD_Total_amount_received from Loan_data
    WHERE
    MONTH(CONVERT(date, issue_date, 105)) = 11
AND YEAR(CONVERT(date, issue_date, 105)) = 2021

/*4.Average Interest Rate:  */
-- multiple by 100 to get response in int--

select avg(int_rate)*100 as avg_Intrest_Rate from Loan_data

/*if u need ans in round the u can run the following qry
select round(avg(int_rate),4)*100 as avg_Intrest_Rate from Loan_data */
SELECT AVG(int_rate)*100 AS MTD_Avg_Int_Rate FROM loan_data
WHERE MONTH (convert(date,issue_date,105)) = 12 and year(convert(date,issue_date, 105)) = 2021

SELECT AVG(int_rate)*100 AS MTD_Avg_Int_Rate FROM loan_data
WHERE MONTH (convert(date,issue_date,105)) = 11 and year(convert(date,issue_date, 105)) = 2021

--5.Average Debt-to-Income Ratio (DTI): --
SELECT AVG(dti)*100 AS Avg_DTI FROM loan_data;

SELECT AVG(dti)*100 AS Avg_DTI FROM loan_data
WHERE MONTH (convert(date,issue_date,105)) = 12 and year(convert(date,issue_date, 105)) = 2021

SELECT AVG(dti)*100 AS Avg_DTI FROM loan_data
WHERE MONTH (convert(date,issue_date,105)) = 11 and year(convert(date,issue_date, 105)) = 2021



--A. GOOD LOAN VS BAD LOAN --
-- 3 type fully paid, current and charged off--

select loan_status from Loan_data; --to check the loan type--

--good loan--
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM loan_data


SELECT COUNT(id) AS Good_Loan_Applications FROM loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

SELECT 
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Good_Loan_Funded_Amount
FROM loan_data
WHERE loan_status IN ('Fully Paid', 'Current')


SELECT SUM(total_payment) AS Good_Loan_amount_received FROM loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'


--bad loan--
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM loan_data

SELECT COUNT(id) AS Bad_Loan_Applications FROM loan_data
WHERE loan_status = 'Charged Off'

SELECT SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Bad_Loan_Funded_amount FROM loan_data
WHERE loan_status = 'Charged Off'

SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM loan_data
WHERE loan_status = 'Charged Off'

-- LOAN STATUS--
SELECT
    loan_status,
    COUNT(id) AS LoanCount,
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS Total_Amount_Received,
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount,
    AVG(TRY_CONVERT(decimal(10,4), int_rate) * 100) AS Interest_Rate,
    AVG(TRY_CONVERT(decimal(10,4), dti) * 100) AS DTI
FROM loan_data
GROUP BY loan_status


SELECT 
    loan_status, 
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS MTD_Total_Amount_Received, 
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS MTD_Total_Funded_Amount 
FROM loan_data
WHERE 
    CONVERT(date, issue_date, 105)
    BETWEEN '2021-12-01' AND '2021-12-31'
GROUP BY loan_status


--B.BANK LOAN REPORT  --

--month--
SELECT 
    MONTH(CONVERT(date, issue_date, 105)) AS Month_Number, 
    DATENAME(MONTH, CONVERT(date, issue_date, 105)) AS Month_Name, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount,
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS Total_Amount_Received
FROM loan_data
GROUP BY 
    MONTH(CONVERT(date, issue_date, 105)),
    DATENAME(MONTH, CONVERT(date, issue_date, 105))
ORDER BY 
    MONTH(CONVERT(date, issue_date, 105))

--state--
SELECT 
    address_state AS State, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount,
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS Total_Amount_Received
FROM loan_data
GROUP BY address_state
ORDER BY address_state

-- term --
SELECT 
    term AS Term, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount,
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS Total_Amount_Received
FROM loan_data
GROUP BY term
ORDER BY term

-- Employee Length --
SELECT 
    emp_length AS Employee_Length, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount,
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS Total_Amount_Received
FROM loan_data
GROUP BY emp_length
ORDER BY emp_length

-- purpose--

SELECT 
    purpose AS Purpose, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount,
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS Total_Amount_Received
FROM loan_data
GROUP BY purpose
ORDER BY purpose

--Home Ownership--
SELECT 
    home_ownership AS Home_Ownership, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount,
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS Total_Amount_Received
FROM loan_data
GROUP BY home_ownership
ORDER BY home_ownership

SELECT 
    purpose AS PURPOSE, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(TRY_CONVERT(decimal(18,2), loan_amount)) AS Total_Funded_Amount,
    SUM(TRY_CONVERT(decimal(18,2), total_payment)) AS Total_Amount_Received
FROM loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose

-- =====================================================
-- My Additional Analysis
-- =====================================================
SELECT
    grade,
    AVG(annual_inc) AS avg_annual_income,
    COUNT(*) AS total_loans
FROM financial_loan
GROUP BY grade
ORDER BY grade;

SELECT
    purpose,
    COUNT(*) AS total_loans,
    SUM(loan_amnt) AS total_loan_amount,
    AVG(loan_amnt) AS avg_loan_amount
FROM financial_loan
GROUP BY purpose
ORDER BY total_loan_amount DESC;

SELECT
    loan_status,
    COUNT(*) AS total_loans,
    AVG(loan_amnt) AS avg_loan_amount,
    AVG(int_rate) AS avg_interest_rate
FROM financial_loan
GROUP BY loan_status
ORDER BY total_loans DESC;