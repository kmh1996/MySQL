-- 변수 초기화
-- 일반적인 언어에서는 대입 연산자(=) 사용
-- SQL에서는 =가 비교연산자로도 사용됨.

-- 변수 사용
-- @를 통해서 변수를 표시
-- @ 하나는 사용자 변수
-- @@ 두개는 시스템 변수
-- 대입연산자로만 사용되는 := 도 존재함.

USE sqlDb;

-- 선언과 초기화
SET @myVal1 = 10;
-- 변수가 선언이 될때 타입으로 공간을 차지해야하므로 
-- 선언과 동시에 값이 대입 되어야 함.
-- SET @myVal2; -- 오류
SET @myVal2 = 3;
SET @myVal3 = 3.141592;
SET @myVal4 = '이름->';

SELECT @myVal1;

SELECT @myVal2 + @myVal3;

SELECT @myVal4, name FROM userTbl 
WHERE height > 180;

SET @myVal4 = '가수 이름=>';
SELECT @myVal4, name FROM userTbl 
WHERE height > 180;


-- 행 번호 얻기
SELECT * FROM buyTbl ORDER BY num DESC LIMIT 5;
DELETE FROM buyTbl WHERE num = 13;
-- := 대입연산자
SELECT @rn := 0;

SELECT @rn:=@rn+1 AS rownum, buyTbl.* FROM buyTbl;

SELECT * FROM
(SELECT @rn:=@rn+1 AS rnum, num, userid, prodName 
 FROM buyTbl ,(SELECT @rn:=0) a ) b 
 WHERE b.rnum BETWEEN 5 AND 10;


-- VIEW
-- 가상의 테이블
-- 논리적으로 존재 하지 않지만 
-- SELECT문을 통해 생성된 구조와 정보를 가지고 있음
-- VIEW 사용
-- 질의안에 직접 SELECT 문을 통해 생성된 VIEW - 인라인 뷰
-- CREATE를 통해 생성된 개체 - VIEW 개체
-- CREATE VIEW 뷰이름 AS SELECT문;
USE smartWeb;

CREATE VIEW v_emp AS SELECT empno, ename FROM emp;
SELECT * FROM v_emp;

SELECT a.empno, a.ename FROM 
(SELECT empno, ename FROM emp) AS a;

SELECT emp.empno, ename FROM emp;

-- SELECT 문의 결과를 이름을 가지는 뷰라는 개체로 생성
-- 실제 데이터를 비추는 창문에 비유
-- 보안적인 목적으로 사용
-- 사용자는 사용되고 있는 데이터가 실제 table인지
-- 가상 테이블(view)인지 구별할 수 없음
-- 실제 테이블의 구조를 파악하기 힘듬.



use sqlDB;

CREATE VIEW v_usertbl AS 
SELECT userID, name FROM userTbl;

INSERT INTO v_userTbl 
VALUES('ABC','가나다');

SELECT * FROM v_userTbl;

UPDATE v_userTbl SET name = '홍길동' 
WHERE userID ='BBK';

SELECT * FROM userTbl;

DELETE FROM v_userTbl WHERE userID = 'LSG';

UPDATE v_userTbl SET birthYear = 1900 
WHERE userID = 'BBK';





rollback;

/***************************************************/
-- MySQL 내장 함수
-- dual 테이블
-- 데이터가 없고, 함수 계산을 위해 사용하는 가상의 테이블
-- 모든 RDBMS에 존재하는 테스트용 테이블

SELECT 1+1 FROM dual;

-- Mysql에서는 생략해도 가능.
SELECT 1+1;

-- 현재 날짜/시간 함수
SELECT sysdate(), now() FROM dual;

-- 현재 사용자 조회 함수
SELECT user() FROM dual;

-- 나머지를 구하는 함수
SELECT MOD(27,2), MOD(27,5), MOD(27,7);

use smartWeb;
-- 사원번호가 홀수인 사원의 사원번호, 사원명 출력
SELECT empno, ename FROM emp 
WHERE mod(empno, 2) = 1;

-- 문자열 처리 함수's
-- 문자열을 대소문자로 처리

SELECT 'Welcome to MySQL', 
upper('Welcome to MySQL'),	-- 대문자로 변경
lower('Welcome to MySQL');  -- 소문자로 변경

-- 문자열의 길이 구하는 함수
SELECT length('MySQL'), length('마이에스큐엘');

-- 문자열 추출 함수
SET @temp = 'Welcome to Mysql';
-- (문자열,시작위치,개수)
SELECT substr(@temp,4,3);
-- (문자열,음수일경우 뒤에서 부터, 개수)
SELECT substr(@temp,-4,3);

-- 사원의 정보를 사원번호, 사원명, 입사년, 월로 출력
SELECT hiredate FROM emp;
SELECT empno, ename , 
substr(hiredate,1,4),
substr(hiredate,6,2) FROM emp;

-- 9월에 입사한 사원의 사원번호, 사원명, 입사일 출력
SELECT empno, ename, hiredate FROM emp 
WHERE substr(hiredate, 6, 2) = '09';

-- 문자의 위치를 구하는 함수
SELECT instr('WELCOME TO MYSQL','O') FROM dual; -- 5
SELECT instr('Welcome to Mysql','O') FROM dual; -- 5
SELECT instr('이것이 MySQL이다','다')FROM dual; 	-- 11

-- 공백을 제거 하는 함수
-- '            MySQL'
SELECT '            MySQL';
-- 'MySQL'
SELECT ltrim('            MySQL');	-- 왼쪽 공백제거
-- 'MySQL'
SELECT rtrim('MySQL            '); 	-- 오른쪽 공백제거

-- 양쪽에서 특정 문자 제거
-- 'MySQLab'
SELECT trim('a' FROM 'aaaaMySQLabaa');
-- 'MySQL ab'
SELECT trim(' ' FROM '    MySQL ab    ');

-- 문자열로 매개변수들을 묶어주는 concat()
SELECT concat('MySQL',80,' 을',' 배웁니다.') FROM dual;

-- 사원의 정보를 'SCOTT은 월급을 받습니다.' 형태로 출력
SELECT concat(ename,'은 ',sal,'을 받습니다.') AS 'RESULT' 
FROM emp ORDER BY sal DESC;

-- 날짜 관련 함수's
-- 현재 시간을 반환하는 sysdate(), now()
SELECT sysdate() FROM dual;
SELECT sysdate() - INTERVAL 1 day AS 어제,
	   sysdate() AS 오늘,
       sysdate() + INTERVAL 1 day AS 내일;

-- 한달 전
SELECT sysdate() - INTERVAL 1 month;
-- 1년전
SELECT sysdate() - INTERVAL 1 year;
-- 10년 후
SELECT sysdate() + INTERVAL 10 year;
-- 현재시간에서 1분을 더함.
-- date_add(기준시간,계산시간)
SELECT now() , date_add(now(), INTERVAL 1 MINUTE);
-- 1분 이전
SELECT now() , date_add(now(), INTERVAL -1 MINUTE);
-- 1시간 이전
SELECT now() , date_sub(now(), INTERVAL 1 HOUR);
-- 3시간 이후
SELECT now() , date_sub(now(), INTERVAL -3 HOUR);

-- 두 시간 사이의 간격(차이)를 계산
-- timestampdiff(년월일,비교할 기준 시간, 비교할 기준시간);
-- 사원 들의 근무년수 구하기
SELECT empno, ename, hiredate, now(), 
timestampdiff(year, hiredate, now())
FROM emp;
-- 사원들의 근무 개월 수
SELECT empno, ename, hiredate, now(), 
timestampdiff(month, hiredate, now())
FROM emp;

-- 날짜를 형식에 맞는 문자열로 반환하는 함수
-- date_format
/*
	%Y 4자리 년도		%y 2자리 년도		%m 숫자 월(2자리)
    %c 숫자 월(1자리) %M 긴 월(영문)		%b (짧은 월) 영문
    %d 일자(두자리)	%e 일자(한자리)	%W (요일이름 영문)
    %a (짧은 요일 영문)%I 시간(12시)		%H 시간(24시)
    %i 분			%S 초	
    %r hh:mm:ss AM,PM
    %T hh:mm:ss
*/
SELECT now(), date_format(now(),'%Y/%m/%d') FROM dual;
SELECT now(), date_format(now(), '%y/%m/%d %T');

-- 년 월 주 별로 전달한 date가 언제인지 표현하는 함수
SELECT dayname(now());	-- 요일 이름(영문)
-- 일요일 1 ~~ 토요일 7
SELECT dayOfWeek(now());	-- 5(목요일)
SELECT dayofmonth(now());	-- 월중 날짜
SELECT dayOfYear(now());	-- 308

-- case문
-- 특정 속성의 값을 비교하여 다른 형태의 값으로 제공
-- 사원 정보를 검색하여 부서번호에 따라 
-- 사원이름, 부서번호, 부서명을 출력
SELECT ename, deptno, 
	CASE WHEN deptno = 10 THEN 'ACCOUNTING' 
		 WHEN deptno = 20 THEN 'RESEARCH'
		 WHEN deptno = 30 THEN 'SALES'
		 WHEN deptno = 20 THEN 'OPERATINGS'
    END AS dname
FROM emp;

-- Query문을 미리 등록 시켜놓고 필요한 것을 후에 전달하는
-- PREPARE EXCUTE 문
-- PREPARE 이름 FROM 'Query문';

PREPARE mQuery FROM 
'SELECT ename, sal FROM emp ORDER BY sal LIMIT ?';
SET @tempVal = 3;

EXECUTE mQuery USING @tempVal;
SET @tempVal = 10;
EXECUTE mQuery USING @tempVal;

/***************************************************/
-- 사원의 부서 번호와 이름을 합쳐서 출력되게 검색
SELECT concat(deptno,ename) FROM emp;

-- 사원의 이름, 입사일자를 '80/12/17에 입사한 SWITH입니다.' 
-- 형식으로 검색
SELECT concat(
date_format(hiredate,'%y/%m/%d'),
'에 입사한 ',ename,'입니다.') 
FROM emp;

-- 사원 번호가 79로 시작하는 사원들의 이름과 급여, 커미션을 검색
-- substr 사용
SELECT empno, ename, sal, comm FROM emp 
WHERE substr(empno,1,2) = 79;
-- 1981년 2월에 입사한 사원의 사원번호, 이름, 부서번호를 검색
-- substr 사용 
SELECT hiredate FROM emp;
SELECT empno, ename, deptno 
-- 1981-02-20
FROM emp WHERE substr(hiredate, 1, 7) ='1981-02';

-- 사원정보에서 사원들의 이름을 소문자로 직무를 대문자로 검색
SELECT lower(ename) , upper(job) FROM emp;

-- 사원들의 이름을 검색하되 첫자만 대문자로 변경하여 검색
SELECT ename, substr(ename, 1, 1) FROM emp;
SELECT ename, 
substr(ename, 1, 1), 
substr(ename, 2, length(ename)-1) FROM emp;

SELECT ename, 
concat(substr(ename, 1, 1), 
(lower(substr(ename, 2, length(ename)-1)))) AS 이름 
FROM emp;

/****************************************************/
SELECT * FROM salgrade;
-- JOIN
-- 테이블의 정보를 합치는 것

-- 크로스 조인
SELECT * FROM emp, dept;

-- inner join
SELECT emp.*, dept.* 
FROM emp, dept WHERE emp.deptno = dept.deptno;

-- natural join -- 중복되는 속성을 기준으로 조인
SELECT * FROM emp NATURAL JOIN dept 
ORDER BY emp.empno;
-- 조인을 사용해서 뉴욕에서 근무하는 사원의 이름과 급여 출력
SELECT emp.ename, emp.sal  
FROM emp, dept 
WHERE emp.deptno = dept.deptno 
AND dept.loc ='NEW YORK';

-- join을 이용하여 SCOTT이 근무하는 부서이름 출력
SELECT dname FROM emp , dept 
WHERE dept.deptno = emp.deptno 
AND emp.ename = 'SCOTT';

SELECT dname FROM emp JOIN dept 
ON dept.deptno = emp.deptno 
WHERE emp.ename = 'SCOTT';

-- sub query
SELECT dname FROM dept 
WHERE deptno = (
	SELECT deptno FROM emp 
    WHERE ename = 'SCOTT'
);

-- NATURAL JOIN 
SELECT dname FROM 
emp NATURAL JOIN dept 
WHERE emp.ename = 'SCOTT';

-- SELF JOIN
-- 사원의 이름과 그 사원의 매니저 이름을 출력하기
-- ename - mgr & mgr = 사원번호 : ename
SELECT a.ename AS 사원, b.ename AS 매니저 
FROM emp AS a, emp AS b 
WHERE a.mgr = b.empno; 

-- SCOTT 이랑 동일한 근무지에 근무하는 사람의 사원명 출력
-- SCOTT 제외
SELECT a.ename , b.ename FROM emp AS a, emp AS b 
WHERE a.deptno = b.deptno AND a.ename='SCOTT' 
AND b.ename != 'SCOTT';

-- outer join
-- LEFT JOIN / RIGHT JOIN
-- 일치하지 않는 값이라도 남아있는 테이블의 값이 존재하면 검색
SELECT a.ename , b.ename FROM emp a RIGHT JOIN emp b 
ON a.mgr = b.empno ORDER BY a.ename DESC;
-- 매니저인 사람 BLAKE FORD JONES CLARK KING SCOTT
-- 매니저가 아닌 사람 
-- SMITH ALLEN WARD MARTIN TURNER ADAMS JAMES MILLER
-- JOIN 조건에서 벗난 우측 테이블의 행 정보 까지 JOIN
-- 범위에 포함

SELECT a.ename , b.ename FROM emp a LEFT JOIN emp b 
ON a.mgr = b.empno ORDER BY a.ename DESC;
































































