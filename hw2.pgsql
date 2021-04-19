/* Создать базу данных (postgres).

table Product :
- id, name, price.
table Sale :
- id, date, sum_sale.
table Check :
- id_sale, id_product, count_product.

Связи Product-Sale как М-М через таблицу Check
(many-to-many relationship)
 */
CREATE TABLE Product
(
id           serial PRIMARY KEY,
name        varchar(64) NOT NULL,
price money
);

CREATE TABLE Sale
(
id           serial PRIMARY KEY,
date  date NOT NULL DEFAULT CURRENT_DATE,
sum_sale money
);

CREATE TABLE Checkk
(
id_sale integer REFERENCES Sale (id) ON DELETE SET NULL ON UPDATE CASCADE,
id_product integer REFERENCES Product (id) ON DELETE SET NULL ON UPDATE CASCADE,
count_product integer
);

INSERT INTO Product (name, price)
VALUES ('Product1', 11),
        ('Product2', 12),
        ('Product3', 13),
        ('Product4', 14),
        ('Product5', 15),
        ('Apple3', 13000),
        ('Apple4', 14000),
        ('Apple6', 16000);

INSERT INTO Sale (date, sum_sale)
VALUES ('2021-04-16', 0),
       ('2021-04-10', 0),
       ('2021-04-16', 0),
       ('2021-04-16', 0),
       ('2021-04-16', 0),
       ('2021-04-12', 0),
       ('2021-04-16', 0),
       ('2021-04-11', 0);

INSERT INTO Checkk (id_sale, id_product, count_product)
VALUES (1, 3, 53),
        (5, 2, 390),
        (6, 3, 434),
        (2, 6, 29),
        (4, 4, 42),
        (5, 5, 58),
        (3, 3, 5543),
        (6, 6, 123),
        (3, 2, 19),
        (2, 4, 352),
        (5, 1, 286),
        (4, 3, 57);

--каждый раз вам необходимо считать сумму покупки и обновлять данные
UPDATE Sale
SET sum_sale = product_sum.total
FROM (
        SELECT Checkk.id_sale, SUM (Product.price * Checkk.count_product) AS total
        FROM Product JOIN Checkk ON Product.id = Checkk.id_product
        -- WHERE Product.id = Checkk.id_product
        GROUP BY Checkk.id_sale
        ORDER BY Checkk.id_sale
) AS product_sum
WHERE Sale.id = product_sum.id_sale;

/* выбирает общую сумму по id_sale
SELECT C.id_sale, SUM (P.price * C.count_product) AS total
       FROM Product AS P JOIN Checkk AS C ON P.id = C.id_product
       --WHERE P.id = C.id_product
       GROUP BY C.id_sale
       ORDER BY C.id_sale */

--2) вывести информацию о покупке : состав ее и сумму к оплате
SELECT S.id, 
(SELECT string_agg (P.name, ', ') AS "Sostav_zakaza"), 
SUM (P.price * C.count_product) AS total_sum
       FROM Product AS P JOIN Checkk AS C ON P.id = C.id_product JOIN Sale AS S ON S.id = C.id_sale
       GROUP BY S.id
       ORDER BY S.id;

--3) вывести список товаров используя like
SELECT name
FROM Product
WHERE name LIKE 'Apple%';

--4) вывести товары до 10000грн
SELECT name
FROM Product
WHERE price < 10000::money;

--5) подсчитать количество продаж за день (период 5 дней)
SELECT S.date, count (S.id) AS "KolVo_prodazh"
FROM Sale AS S 
GROUP BY S.date
ORDER BY S.date;

--подсчитать количество продаж за период 5 дней
SELECT S.date, count (S.id) AS "KolVo_prodazh"
FROM Sale AS S 
WHERE current_date::date - S.date::date <=5
GROUP BY S.date
ORDER BY S.date;

--6) подсчитать сумму продаж за сегодня
SELECT sum (S.sum_sale) AS "Summa_prodazh"
FROM Sale AS S 
WHERE current_date::date = S.date::date;

--7) подсчитать количество продаж за сегодня
SELECT count (S.id) AS "KolVo_prodazh"
FROM Sale AS S 
WHERE current_date::date = S.date::date;