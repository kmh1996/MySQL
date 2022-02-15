 -- 20211103.sql
 -- 그룹별로 합계를 한번에 구할때 사용
 -- GROUP BY를 사용하면 GROUP BY 뒤에 오는 컬럼(열)별로
 -- 합계를 구해주는데 
 -- 항목별 합계에 전체 합계가 같이 나오게 하는것이 
 -- WITH ROLLUP이다.
 -- 전체 판매금액
 SELECT sum(price*amount) FROM buyTbl; 
 -- 그룹별 판매금액
 SELECT groupName, sum(price*amount) FROM buyTbl
 GROUP BY groupName; 
 
 -- 상품 별 총 판매 금액 검색
 SELECT groupName, prodName, sum(price*amount) 
 FROM buyTbl GROUP BY groupName, prodName 
 WITH ROLLUP ORDER BY groupName DESC, prodName DESC;
 
 -- avg(열이름) - 평균
 SELECT avg(height) FROM userTbl;
 
 -- 지역별 평균 키
 SELECT addr, avg(height) AS '평균키' FROM userTbl 
 GROUP BY addr ORDER BY 평균키 DESC;
 
 -- 실수값을 소수점 첫째자리에서 반올림 ROUND()
 SELECT addr, ROUND(avg(height)) AS '평균키' 
 FROM userTbl 
 GROUP BY addr ORDER BY 평균키 DESC;
 -- CEIL 올림
SELECT addr, CEIL(avg(height)) AS '평균키' 
FROM userTbl 
GROUP BY addr ORDER BY 평균키 DESC;
-- 내림 FLOOR()
SELECT addr, FLOOR(avg(height)) AS '평균키' 
FROM userTbl 
GROUP BY addr ORDER BY 평균키 DESC;
-- 지역별 평균키를 구하고 전체 회원의 평균 키를 검색
SELECT addr, ROUND(avg(height)) AS '평균키' 
FROM userTbl GROUP BY addr WITH ROLLUP ORDER BY 평균키 DESC;

/************************************************/ 
-- 임시 테이블을 생성하여 기존 테이블의 정보를 가져와서 저장
DESC userTbl;
-- userID, name, mDate
CREATE TABLE temp_user_tbl(
	userID char(8) PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    mDate date
);
INSERT INTO temp_user_tbl 
SELECT userID, name, mDate FROM userTbl;

SELECT * FROM temp_user_tbl;

CREATE TABLE buyTbl2(
	SELECT * FROM buyTbl
);
DESC buyTbl2;
SELECT * FROM buyTbl2;

CREATE TABLE buyTbl3(
	SELECT userID FROM buyTbl
);
DESC buyTbl3;
SELECT * FROM buyTbl3;

-- 데이터는 백업하지 않고 구조만 일치하는 새로운 테이블 생성
CREATE TABLE buyTbl4(
	SELECT * FROM buyTbl WHERE 1=0
);
DESC buyTbl4;
SELECT * FROM buyTbl4;
SELECT count(*) buyTbl4;

-- 특정 행의 값을 변경하는 UPDATE문
SELECT * FROM buyTbl2;
-- buyTbl2의 모니터 가격을 250으로 변경
UPDATE buyTbl2 SET price = 250 
WHERE prodName = '모니터';
SELECT * FROM buyTbl2;

-- buyTbl2의 상품 중 청바지의 가격을 60으로 변경하고
-- 판매개수(amount)를 5로 변경
UPDATE buyTbl2 SET price = 60, amount = 5 
WHERE prodName = '청바지';
SELECT * FROM buyTbl2;

-- num이 8번인 행의 prodName을 면바지로 price를 40으로
-- amount를 7 , groupName을 의류로 변경
UPDATE buyTbl2 SET 
prodName = '면바지',
price = 40 ,
amount = 7,
groupName = '의류' 
WHERE num = 8;
SELECT * FROM buyTbl2;
-- 조건절이 없는 UPDATE
-- 모든 물품의 가격 5 인상
UPDATE buyTbl2 SET price = price + 5;
SELECT * FROM buyTbl2;

-- table에 삽입되어있는 행의 정보를 삭제하는 DELETE문
-- buyTbl2에서 아이디가 BBK인 정보 삭제
DELETE FROM buyTbl2 WHERE userID='BBK';
SELECT * FROM buyTbl2;

-- commit; 실행된 DML구문을 적용
-- rollback; 실행된 DML구문을 이전 commit단계로 되돌림

-- 자동 commit 설정 정보 확인
SELECT @@autocommit;
-- 1 autocommit 
-- 0 자동으로 commit 실행 안함.
SET autocommit = 0;
SELECT * FROM buyTbl2;
UPDATE buyTbl2 SET price = 0;
rollback;
SELECT * FROM buyTbl2;
UPDATE buyTbl2 SET price = price + 50;
commit;
rollback;
CREATE TABLE smart1(SELECT * FROM employees.employees);
CREATE TABLE smart2(SELECT * FROM employees.employees);
CREATE TABLE smart3(SELECT * FROM employees.employees);

DELETE FROM smart1;
SELECT * FROM smart1;
rollback;
UPDATE buyTbl2 SET price = 0;
SELECT * FROM buyTbl2;
commit; 
-- table에 삽인된 모든 행의 정보를 삭제하고 commit;
TRUNCATE TABLE smart2;
SELECT * FROM smart2;
rollback;

DROP TABLE smart3;
SELECT * FROM smart3;
rollback;

-- 계정 생성과 권한 부여
-- 사용자 계정 생성
-- CREATE USER 계정명@접속위치 IDENTIFIED BY 비밀번호;
CREATE USER user1@'localhost' IDENTIFIED BY '1234';

CREATE USER 'director'@'%' IDENTIFIED BY '1234';
CREATE USER 'staff'@'%' IDENTIFIED BY '1234';
CREATE USER 'ceo'@'%' IDENTIFIED BY '1234';

GRANT ALL on *.* to director@'%' WITH GRANT OPTION;
SHOW GRANTS FOR director@'%';

GRANT SELECT, INSERT, DELETE, UPDATE ON sqlDB.*  
TO staff@'%';
SHOW GRANTS FOR staff@'%';

GRANT SELECT, UPDATE ON sqlDB.* TO ceo@'%';
SHOW GRANTS FOR ceo@'%';

REVOKE UPDATE ON sqlDb.* FROM ceo@'%';














































 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 