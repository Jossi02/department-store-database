-- 1. 성이 김씨인 직원이 사는 시와 구 (중복 제외)
SELECT DISTINCT 시, 구
FROM 직원
WHERE 이름 LIKE '김%';

-- 2. 록시땅 매장에서 일하는 직원의 이름과 고용일
SELECT e.이름, e.입사년, e.입사월, e.입사일
FROM 직원 e
JOIN 매장 s ON s.매장코드 = e.매장코드
WHERE s.매장이름 = '록시땅';

-- 3. 전신안마의자를 판매하는 백화점의 주소
SELECT d.시, d.구, d.동
FROM 상품 p
JOIN 매장 s ON s.매장코드 = p.매장코드
JOIN 백화점 d ON d.지점이름 = s.지점이름
WHERE p.이름 = '전신안마의자';

-- 4. 서울시에 위치한 백화점 고객의 생일을 월별로 집계
SELECT c.출생월, COUNT(*) AS 인원수
FROM 고객 c
JOIN 백화점 d ON d.지점이름 = c.지점이름
WHERE d.시 = '서울시'
GROUP BY c.출생월
ORDER BY c.출생월;

-- 5. 총구매금액이 가장 높은 고객이 구매한 상품
SELECT DISTINCT p.이름
FROM 멤버십 m
JOIN 구매 b ON b.고객번호 = m.고객번호
JOIN 상품 p ON p.상품코드 = b.상품코드
WHERE m.총구매금액 = (SELECT MAX(총구매금액) FROM 멤버십);

-- 6. 600만원 이상 결제한 고객과 같은 구에 사는 고객
SELECT c.이름
FROM 고객 c
WHERE c.구 IN (
    SELECT DISTINCT buyer.구
    FROM 고객 buyer
    JOIN 구매 b ON b.고객번호 = buyer.고객번호
    JOIN 결제 pay ON pay.결제번호 = b.결제번호
    WHERE pay.결제금액 >= 6000000
)
ORDER BY c.이름;
