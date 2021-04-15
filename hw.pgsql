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
date  timestamp NOT NULL DEFAULT CURRENT_DATE,
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
        ('Product6', 16);

INSERT INTO Sale (sum_sale)
VALUES (0),
        (0),
        (0),
        (0),
        (0),
        (0),
        (0),
        (0),
        (0),
        (0),
        (0),
        (0);

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
        WHERE Product.id = Checkk.id_product
        GROUP BY Checkk.id_sale
        ORDER BY Checkk.id_sale
) AS product_sum
WHERE Sale.id = product_sum.id_sale;

/* выбирает общую сумму по id_sale
SELECT Checkk.id_sale, SUM (Product.price * Checkk.count_product) AS Total
FROM Product JOIN Checkk ON Product.id = Checkk.id_product
WHERE Product.id = Checkk.id_product
GROUP BY Checkk.id_sale
ORDER BY Checkk.id_sale */
