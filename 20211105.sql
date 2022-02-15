-- 조인 - 여러 테이블의 정보를 합치는 것
use sqlDB;

-- CROSS JOIN 
SELECT count(*) FROM userTbl; -- 11
SELECT count(*) FROM buyTbl;  -- 13	
SELECT count(*) FROM userTbl, buyTbl; -- 143

-- INNER JOIN - 일반적으로 가장 많이 사용되는 형태
-- 기준 테이블과 조인 테이블 모두 데이터가 존재해야 조회됨.
SELECT count(*) FROM userTbl INNER JOIN buyTbl; -- 143
SELECT count(*) FROM userTbl JOIN buyTbl; -- 143

SELECT * FROM userTbl AS U , buyTbl AS B 
WHERE U.userID = B.userID;

-- outer join
-- left/right join
-- 기준 테이블에만 데이터가 존재하면 조회됨
-- 일치하지 않는 값이라도 남아있는 기준 테이블의 값을 검색
SELECT * FROM userTbl AS U LEFT JOIN buyTbl AS B 
ON U.userID = B.userID ORDER BY B.num;

use smartWeb;
SELECT e1.ename AS 사원명 , e2.ename AS 매니저  
FROM emp AS e1 INNER JOIN emp AS e2 
ON e1.mgr = e2.empno;
SELECT count(*) FROM emp;

SELECT ename, mgr FROM emp;
-- 매니저가 없는 사람도 포함해서 출력
SELECT e1.ename , e2.ename FROM
emp e1 LEFT JOIN emp e2 
ON e1.mgr = e2.empno;
-- 매니저가 아닌 사람도 출력
SELECT e1.ename , e2.ename FROM
emp e1 RIGHT JOIN emp e2 
ON e1.mgr = e2.empno;

use sqlDB;
-- '전자' 그룹 물품을 구매한 사용자의 
-- 이름, 출생년도, 전화번호, 상품그룹이름, 상품이름 검색

SELECT 
	u.name, 
    u.birthYear, 
    concat(u.mobile1,u.mobile2) AS 전화번호,
    b.groupName,
    b.prodName
FROM userTbl AS u JOIN buyTbl AS b 
ON u.userID = b.userID 
AND b.groupName = '전자';

-- 위의 내용을 NATURAL JOIN 으로 변경
SELECT 
	u.name, 
    u.birthYear, 
    concat(u.mobile1,u.mobile2) AS 전화번호,
    b.groupName,
    b.prodName
FROM userTbl AS u NATURAL JOIN buyTbl AS b
WHERE b.groupName = '전자';

/***********************************************/
-- VIEW 활용하여 검색 결과에 대한 
-- 데이터를 결합하는 
-- UNION
-- 연결된 SELECT문의 결과 값을 합집합으로 묶어줌
-- 결과값의 중복은 제거
use smartWeb;

(SELECT empno, ename, sal, deptno FROM emp 
WHERE deptno = 20
UNION
SELECT empno, ename, sal, deptno FROM emp 
WHERE deptno = 10) ORDER BY deptno;

CREATE VIEW temp_view 
AS SELECT empno, ename, sal, deptno FROM emp;
-- WHERE deptno = 10 OR deptno = 20;

SELECT * FROM temp_view WHERE deptno = 20 
OR deptno = 10
UNION ALL
SELECT * FROM temp_view WHERE deptno = 10;

-- emp table과 salgrade table을 join 하여
-- 각 사원의 급여 등급을 사원명, 급여, 급여등급 으로 출력
SELECT e.ename , e.sal, s.grade FROM 
emp e, salgrade s 
WHERE e.sal BETWEEN s.losal AND s.hisal;

-- 인라인 뷰를 이용하여 부서별 평균 급여가 2500 이상인 부서의 
-- 부서 번호, 평균 급여를 출력
SELECT * FROM 
	(SELECT deptno, avg(sal) AS '급여평균' FROM emp 
	GROUP BY deptno) tmp
WHERE 급여평균 >= 2500;
-- 부서별 평균급여와 급여등급을 출력 - 인라인 뷰 이용
SELECT deptno, avgSal, grade FROM 
(SELECT deptno, avg(sal) AS avgSal 
FROM emp GROUP BY deptno) e, salgrade s 
WHERE avgSal BETWEEN s.losal AND s.hisal;

-- 부서별 평균급여와 급여등급을 검색 - 인라인 뷰 이용
-- 부서이름, 평균급여, 급여등급 형식으로 출력
SELECT d.dname, e.deptno, avgSal, grade FROM 
(SELECT deptno, avg(sal) AS avgSal 
FROM emp GROUP BY deptno) e, salgrade s, dept d 
WHERE avgSal BETWEEN s.losal AND s.hisal 
AND d.deptno = e.deptno;

SELECT * FROM dept;


-- 급여등급별 인원수와, 평균 급여 출력
-- 급여등급, 인원수 , 평균급여
SELECT s.grade, count(*), avg(sal) 
FROM emp e, salgrade s 
WHERE e.sal BETWEEN s.losal AND s.hisal 
GROUP BY s.grade;



/************************************************/
-- INDEX - 색인 , 목록
-- Data 를 찾기 위한 데이터
-- 책의 목차에 비유
-- 특정 테이블의 특정 컬럼(열)을 지정하여 인덱스를 생성
-- 지정한 인덱스를 이용하여 데이터를 검색
-- 목적은 빠른 데이터 검색
-- 기본키(PRIMARY KEY)를 지정한 컬럼에 대해서는 
-- 자동으로 INDEX가 생성:생성된 기본키를 기준으로 순서대로 정렬
-- 나머지 컬럼(열)이 검색 조건이 된다면
-- 직접 인덱스를 생성해서 사용

-- 인덱스 생성
-- CREATE INDEX 인덱스 이름 ON 테이블이름(컬럼이름);
-- ALTER TABLE 테이블 이름 ADD INDEX 인덱스 이름(컬럼이름);
-- emp 테이블의 sal열에 idx_emp_sal이름의 인덱스 부여
ALTER TABLE emp ADD INDEX idx_emp_sal(sal);
CREATE INDEX inx_emp_sal ON emp(sal);

-- emp 테이블에 적용된 인덱스 정보 확인
SHOW INDEXES FROM emp;

-- 인덱스 삭제
-- DROP INDEX 인덱스 이름 ON table이름.column이름;
-- ALTER TABLE 테이블 이름 DROP INDEX 인덱스 이름;
ALTER TABLE emp DROP INDEX idx_emp_sal;
DROP INDEX inx_emp_sal ON smartWeb.emp;

SHOW INDEXES FROM emp;

use employees;
show tables;
SELECT count(*) FROM employees;
DESC employees;

SELECT * FROM employees WHERE gender = 'M';
CREATE INDEX idx_emp_gender ON employees(gender);
DROP INDEX idx_emp_gender ON employees.employees;
SHOW INDEXES FROM employees;

-- 인덱스는 몯든 컬럼에 생성하는것이 좋지 않음.
-- 저장 공간 차지
-- 인덱스가 생성된 컬럼에 데이터의 삽입/삭제/수정이 일어나면
-- 인덱스 페이지를 새로 생성해야 할 수 있어서 성능에 악영향
-- 검색에 자주 사용되는 컬럼에만 생성
-- 데이터 변경이 자주 일어나지 않는 테이블에 생성
-- 검색쿼리에 인덱스는 영향을 받는다.
/*********************************************/
-- 스토어 프로시저(Stored Procedure)
-- 여러 개의 쿼리 혹은 동작을 프로시저라는 개체로 묶어서 저장
-- 프로시저 이름을 통해서 작동시키므로 내부의 쿼리를 숨길 수 있음
-- 작성된 프로시저는 CALL 이라는 예약어를 활용해서 사용(호출)

/*
	CREATE PROCEDURE 프로시저 이름(매개변수...)
		BEGIN 
			내용
		END
*/
-- DELIMITER : 구문 문자
-- 일반 프로그램의 ';' 역할을 한다.
use smartWeb;


DELIMITER // 
CREATE PROCEDURE readEmp()
	BEGIN 
		SELECT * FROM EMP;
	END //
DELIMITER ; 

CALL readEmp();

-- 매개변수를 전달하는 프로시저
-- 특정 사원번호를 매개변수로 받아서 해당 사원의 정보를 검색
-- 매개변수 선언 형식 : 'IN 매개변수명 데이터 형식'
DELIMITER $$ 
CREATE PROCEDURE info_emp(IN _empno INT)
	BEGIN 
		SELECT * FROM emp WHERE empno = _empno;
    END $$
DELIMITER ;

-- 입력값 이상의 급여를 받는 사원의 사원번호, 이름, 입사일 ,급여
-- 를 검색하는 프로시저
DELIMITER $$ 
CREATE PROCEDURE `info_sal_over` (IN _sal INT)
BEGIN
	SELECT empno, ename, hiredate, sal 
    FROM emp 
    WHERE sal >= _sal;
    END $$
DELIMITER ;

CALL info_sal_over(1500);

-- 여러개의 매개변수를 전달받는 프로시저
-- 두개의 급여를 전달받아 두 급여사이의 급여를 받는 사원 정보
-- 검색
delimiter //
CREATE PROCEDURE info_sal_between(
	IN a_sal INT ,
    IN b_sal INT
)
BEGIN 
	SELECT * FROM emp 
    WHERE sal BETWEEN a_sal AND b_sal;
END //
delimiter ;

CALL info_sal_between(2000,3000);

use sqlDB;
-- 회원 이름을 입력받아서 
-- 회원의 나이에 따라 1980년 이전이다 나이가 많으시네요.
-- 1980년 이후 출색 아직 젊으시네요
DELIMITER //
CREATE PROCEDURE checkYear(
	IN uname VARCHAR(10)
)
BEGIN 
	DECLARE yearBirth INT; -- yearBirth 변수 선언
    SELECT birthYear INTO yearBirth FROM userTbl 
    WHERE name = uname;
    IF (yearBirth >= 1980) THEN
		SELECT '아직 젊으시네요.. ' AS ANSWER;
    ELSE 
		SELECT '나이가 지긋하시네요' AS ANSWER;
    END IF;  
END //
DELIMITER ;

CALL checkYear('이승기');
-- PROCEDURE roof
-- 99단의 단수를 입력받아서 해당 단수를 출력하고 
-- table에 저장
CREATE TABLE temp_tbl(txt TEXT);

delimiter $$
	CREATE PROCEDURE whileTest(
		IN num INT
    )
    BEGIN 
		DECLARE str VARCHAR(100);-- 각 단을 문자열로 저장
        DECLARE i INT;	-- 구구단 뒷자리
        SET str = '';
        SET i = 1;
        -- 사용자에게 입력받은 구구단수 - num
        WHILE(i < 10) DO
			SET str = concat(
				str,' ', num , 'X' , i ,'=',num*i
            ); -- 문자열 만들기
            -- 테이블에 저장
            INSERT INTO temp_tbl VALUES(str);
			SET i = i + 1; -- 자리수 증가
        END WHILE; -- while 종료
        SELECT str AS RESULT; -- 문자열 출력
    END $$
delimiter ;

CALL whileTest(3);
SELECT * FROM temp_tbl;

-- 회원 테이블
CREATE TABLE member_tbl(
	num INT PRIMARY KEY auto_increment,	-- 회원번호
    id VARCHAR(50) UNIQUE,				-- id
    pw VARCHAR(50) NOT NULL,			-- 비밀번호
    name VARCHAR(10),					-- 이름
    regDate TIMESTAMP default now()		-- 회원등록일
);

INSERT INTO member_tbl(id,pw,name) 
VALUES('id001','pw001','최기근');
SELECT * FROM member_tbl;
INSERT INTO member_tbl(id,pw,name) 
VALUES(null, 'pw002','박종혁');
-- 동일 세션에서 가장 최근에 등록된 기본키 값을 반환
SELECT LAST_INSERT_ID();

UPDATE member_tbl SET id = 'id002' WHERE 
num = LAST_INSERT_ID();

SELECT * FROM member_tbl;

DELIMITER $$
	CREATE PROCEDURE loginCheck(
		IN _id VARCHAR(50), IN _pw VARCHAR(50)
    )
    BEGIN
		-- 검색결과를 문자열로 저장 할 변수 선언
		DECLARE result VARCHAR(10); 
        SET result = (
			SELECT id FROM member_tbl 
            WHERE id = _id AND pw = _pw
        );
        IF(result IS NOT NULL) THEN 
			SELECT TRUE;
        ELSE 
			SELECT FALSE;
        END IF;
    END $$
DELIMITER ;

CALL loginCheck('id001','pw001');
CALL loginCheck('id003','pw003');

/************************************************/
-- 트리거
-- 특정 테이블에 INSERT, DELETE, UPDATE 같은 DML문이
-- 수행되었을 때 데이터베이스에 등록된 QUERY문이 자동으로 
-- 동작하도록 작성된 프로그램.
-- 사용자의 직접호출이 아니라 데이터베이스의 의해서 
-- 자동으로 호출되는 것이 특징
-- DML의 Transaction과 주기를 같이 한다.
/*
	delimiter //
		CREATE TRIGGER trigger_name 
        {BEFORE | AFTER} 
        {INSERT | UPDATE | DELETE} 
        ON tabl_name 
        FOR EACH ROW
        BEGIN 
			-- 트리거에 실행될 내용
        END //
	delimiter ;
*/

DELIMITER //
	CREATE TRIGGER test_trg -- 트리거 이름 지정
		AFTER DELETE 		-- DELETE 이후에 작동
		ON member_tbl		-- 트리거를 부착할 테이블
        FOR EACH ROW		-- 각 행마다 적용
	BEGIN 
        SET @result = 'member DELETE';
    		-- member_tbl DELETE문 실행 이후에 동작할 내용
	END //
DELIMITER ;

SET @result = '';
SELECT @result;
INSERT INTO member_tbl(id,pw,name) 
VALUES('id003','pw003','예성준');
SELECT @result;
SELECT * FROM member_tbl;
DELETE FROM member_tbl WHERE num = 3;
SELECT @result;

DROP TRIGGER IF EXISTS test_trg;

delimiter //
	CREATE TRIGGER backup_trg
		AFTER 
        DELETE 
        ON member_tbl 
        FOR EACH ROW 
	BEGIN 
		INSERT INTO back_member_tbl(num,id,pw,name,regDate) 
        VALUES(OLD.num,OLD.id,OLD.pw,OLD.name,now());
    END //
delimiter ;


DESC back_member_tbl;
CREATE TABLE back_member_tbl(
	SELECT * FROM member_tbl WHERE 1=0
);

SELECT * FROM back_member_tbl;

SELECT * FROM member_tbl;

DELETE FROM member_tbl WHERE num = 2;

-- userTbl 값이 insert 되기 전에
-- 출생년도가  1890 이전에 태어난 사용자로 정보가 등록
-- 출생년도를  0으로 등록해서 잘못된 정보를 알려주고
-- 아니면 출생년도를 저장.
-- 출생년도 현재시간보다 크면 현재시간으로 등록
use sqlDB;

delimiter //
	CREATE TRIGGER before_usertbl
    BEFORE INSERT 
    ON userTbl 
    FOR EACH ROW
    BEGIN 
		IF NEW.birthYear < 1890 THEN 
			SET NEW.birthYear = 0;
		ELSEIF NEW.birthYear > YEAR(now()) THEN 
			SET NEW.birthYear = YEAR(now());
		END IF;
    END //
delimiter ;

SELECT YEAR(now());

INSERT INTO userTbl 
VALUES('ZZZ','지지지',1888,'평양','051','000000',182,'2020-12-25');

SELECT * FROM userTbl WHERE userID = 'ZZZ';

INSERT INTO userTbl 
VALUES('SHS','심현석',2988,'개성','071','000000',164,'2015-12-25');

SELECT * FROM userTbl;















































CALL info_emp(7369);


SELECT * FROM emp;




































