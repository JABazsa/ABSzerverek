CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    price NUMERIC(10, 2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
);

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    country VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    city VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL
);





CREATE INDEX idx_customers_country ON Customers(country);
CREATE INDEX idx_customers_zip_code ON Customers(zip_code);
CREATE INDEX idx_customers_city ON Customers(city);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE
);

CREATE INDEX idx_order_items_order_id ON Order_Items(order_id);
CREATE INDEX idx_order_items_book_id ON Order_Items(book_id);

CREATE TABLE Invoices (
    invoice_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    invoice_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);
-- Teszt adatok a Books táblához
INSERT INTO Books (title, author, genre, price, stock) 
VALUES ('Book Title 1', 'Author Name', 'Fiction', 19.99, 10);

-- Teszt adatok a Customers táblához
INSERT INTO Customers (name, email, mobile, country, zip_code, city, address)
VALUES ('John Doe', 'john@example.com', '123456789', 'USA', '10001', 'New York', '123 Main St');

-- Teszt adatok az Orders táblához
INSERT INTO Orders (customer_id, status)
VALUES (1, 'COMPLETED');

-- Teszt adatok az Order_Items táblához
INSERT INTO Order_Items (order_id, book_id, quantity)
VALUES (1, 1, 2);

-- Teszt adatok az Invoices táblához
INSERT INTO Invoices (order_id, total_amount)
VALUES (1, 39.98);

INSERT INTO books (title, author, genre, price, stock, status) VALUES 
('A varázsló gyűrűje', 'J.R.R. Tolkien', 'Fantasy', 4500.00, 25, 'available'),
('1984', 'George Orwell', 'Sci-fi', 3750.00, 20, 'available'),
('A kis herceg', 'Antoine de Saint-Exupéry', 'Ifjúsági', 2800.00, 30, 'available'),
('Bűn és bűnhődés', 'Fjodor Dosztojevszkij', 'Klasszikus', 5200.00, 15, 'available'),
('A Gyűrűk Ura', 'J.R.R. Tolkien', 'Fantasy', 6300.00, 18, 'available'),
('Harry Potter és a Bölcsek Köve', 'J.K. Rowling', 'Fantasy', 3600.00, 40, 'available'),
('A Da Vinci-kód', 'Dan Brown', 'Krimi', 4100.00, 22, 'available'),
('Alkonyat', 'Stephenie Meyer', 'Romantikus', 2900.00, 35, 'available');


INSERT INTO customers (name, email, mobile, country, zip_code, city, address) VALUES 
('Szabó Anna', 'szabo.anna@email.com', '06709876543', 'Magyarország', '3300', 'Eger', 'Dobó tér 7.'),
('Kiss Márton', 'kiss.marton@email.com', '06304567890', 'Magyarország', '7624', 'Pécs', 'Rákóczi út 23.'),
('Horváth Eszter', 'horvath.eszter@email.com', '06205678901', 'Magyarország', '9025', 'Győr', 'Baross utca 56.'),
('Nagy Katalin', 'nagy.katalin@email.com', '06706789012', 'Magyarország', '4026', 'Debrecen', 'Piac utca 33.'),
('Fehér Tibor', 'feher.tibor@email.com', '06308901234', 'Magyarország', '6720', 'Szeged', 'Tisza Lajos körút 12.');


INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-11-05 08:30:00', 'completed'),
(2, '2024-11-06 12:00:00', 'pending'),
(3, '2024-11-07 13:15:00', 'completed'),
(4, '2024-11-08 15:45:00', 'shipped'),
(5, '2024-11-09 18:20:00', 'completed');


INSERT INTO Order_Items (order_id, book_id, quantity) VALUES
(1, 1, 2),
(2, 3, 1),
(3, 2, 10),
(4, 4, 1),
(5, 5, 3);




INSERT INTO Invoices (order_id, invoice_date, total_amount) VALUES
(1, '2024-11-05 09:00:00', 5274.0),
(2, '2024-11-06 13:00:00', 3825.0),
(3, '2024-11-07 14:00:00', 25420.0),
(4, '2024-11-08 16:00:00', 5092.0),
(5, '2024-11-09 19:00:00', 17826.0);





-- Adat generáló script

-- 1. Könyvek (Books) táblához tesztadatok generálása
DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO Books (title, author, genre, price, stock)
        VALUES (
            'Book Title ' || i,
            'Author Name ' || (i % 10 + 1),  -- 10 különböző szerző
            CASE
                WHEN i % 3 = 0 THEN 'Fiction'
                WHEN i % 3 = 1 THEN 'Non-Fiction'
                ELSE 'Science'
            END,
            ROUND((10 + (RANDOM() * 40))::NUMERIC, 2),  -- Véletlenszerű ár 10 és 50 között
            FLOOR(RANDOM() * 20)  -- Véletlenszerű készlet 0 és 20 között
        );
    END LOOP;
END $$;

-- 2. Vásárlók (Customers) táblához tesztadatok generálása
DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..30 LOOP
        INSERT INTO Customers (name, email, mobile, country, zip_code, city, address)
        VALUES (
            'Customer ' || i,
            'customer' || i || '@example.com',
            '555' || LPAD(i::TEXT, 10, '0'),  -- Véletlenszerű mobil szám
            'Country ' || (i % 5 + 1),  -- 5 különböző ország
            LPAD((10000 + i)::TEXT, 5, '0'),  -- Véletlenszerű irányítószám
            'City ' || (i % 10 + 1),  -- 10 különböző város
            'Address ' || i
        );
    END LOOP;
END $$;

-- 3. Rendelések (Orders) táblához tesztadatok generálása
DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO Orders (customer_id, status)
        VALUES (
            FLOOR(RANDOM() * 30) + 1,  -- Véletlenszerű vásárló az 1-30 közötti tartományban
            CASE
                WHEN i % 3 = 0 THEN 'COMPLETED'
                WHEN i % 3 = 1 THEN 'PENDING'
                ELSE 'CANCELLED'
            END
        );
    END LOOP;
END $$;

-- 4. Rendelés tételek (Order_Items) táblához tesztadatok generálása
DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO Order_Items (order_id, book_id, quantity)
        VALUES (
            FLOOR(RANDOM() * 50) + 1,  -- Véletlenszerű rendelés az 1-50 közötti tartományban
            FLOOR(RANDOM() * 50) + 1,  -- Véletlenszerű könyv az 1-50 közötti tartományban
            FLOOR(RANDOM() * 5) + 1  -- Véletlenszerű mennyiség 1 és 5 között
        );
    END LOOP;
END $$;

-- 5. Számlák (Invoices) táblához tesztadatok generálása
DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO Invoices (order_id, total_amount)
        VALUES (
            FLOOR(RANDOM() * 50) + 1,  -- Véletlenszerű rendelés az 1-50 közötti tartományban
            ROUND((RANDOM() * 100)::NUMERIC, 2)  -- Véletlenszerű összeg 0 és 100 között
        );
    END LOOP;
END $$;


SELECT 
    title AS 'Könyv címe',
    author AS 'Szerző',
    genre AS 'Műfaj',
    price AS 'Ár',
    stock AS 'Készlet'
FROM 
    Books
ORDER BY 
    title;

SELECT 
    c.name AS 'Vásárló neve',
    c.email AS 'Email',
    o.order_date AS 'Rendelés dátuma',
    o.status AS 'Rendelés státusza',
    SUM(oi.quantity) AS 'Rendelések száma',
    SUM(oi.quantity * b.price) AS 'Összeg'
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Books b ON oi.book_id = b.book_id
GROUP BY c.customer_id, o.order_id
ORDER BY c.name, o.order_date;

SELECT 
    c.name AS 'Vásárló neve',
    o.order_id AS 'Rendelés ID',
    o.order_date AS 'Rendelés dátuma',
    o.status AS 'Rendelés státusza'
FROM 
    Orders o
JOIN 
    Customers c ON o.customer_id = c.customer_id
ORDER BY 
    o.order_date DESC;

   
   DELIMITER //
CREATE TRIGGER update_book_stock_after_order
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'completed' THEN
        DECLARE book_quantity INT;

        SELECT SUM(quantity) INTO book_quantity
        FROM Order_Items
        WHERE order_id = NEW.order_id;

        UPDATE Books
        SET stock = stock - book_quantity,
            status = CASE 
                WHEN stock - book_quantity <= 0 THEN 'NOT AVAILABLE'
                ELSE 'AVAILABLE'
            END
        WHERE book_id IN (SELECT book_id FROM Order_Items WHERE order_id = NEW.order_id);
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE generate_invoice(IN order_id INT)
BEGIN
    DECLARE total_amount DECIMAL(10, 2);

    SELECT SUM(Books.price * Order_Items.quantity) INTO total_amount
    FROM Order_Items
    JOIN Books ON Order_Items.book_id = Books.book_id
    WHERE Order_Items.order_id = order_id;

    INSERT INTO Invoices (order_id, invoice_date, total_amount)
    VALUES (order_id, NOW(), total_amount);
END;
//
DELIMITER ;

CALL generate_invoice(1);

DELIMITER //
CREATE PROCEDURE top_selling_books(IN limit_num INT)
BEGIN
    SELECT Books.book_id, Books.title, Books.author, SUM(Order_Items.quantity) AS total_sold
    FROM Order_Items
    JOIN Books ON Order_Items.book_id = Books.book_id
    GROUP BY Books.book_id, Books.title, Books.author
    ORDER BY total_sold DESC
    LIMIT limit_num;
END;
//


CALL top_selling_books(3);


DELIMITER //
CREATE PROCEDURE most_active_customers(IN limit_num INT)
BEGIN
    SELECT Customers.customer_id, Customers.name, Customers.email, COUNT(Orders.order_id) AS total_orders
    FROM Orders
    JOIN Customers ON Orders.customer_id = Customers.customer_id
    GROUP BY Customers.customer_id, Customers.name, Customers.email
    ORDER BY total_orders DESC
    LIMIT limit_num;
END;
//
CALL most_active_customer(3);


DELIMITER //
CREATE PROCEDURE highest_value_orders(IN limit_num INT)
BEGIN
    SELECT Orders.order_id, Customers.name AS customer_name, Invoices.total_amount, Orders.order_date
    FROM Orders
    JOIN Invoices ON Orders.order_id = Invoices.order_id
    JOIN Customers ON Orders.customer_id = Customers.customer_id
    ORDER BY Invoices.total_amount DESC
    LIMIT limit_num;
END;
//
DELIMITER ;

CALL highest_value_orders(3);

DELIMITER //
CREATE PROCEDURE top_ordering_cities(IN limit_num INT)
BEGIN
    SELECT Customers.city, COUNT(Orders.order_id) AS total_orders
    FROM Orders
    JOIN Customers ON Orders.customer_id = Customers.customer_id
    GROUP BY Customers.city
    ORDER BY total_orders DESC
    LIMIT limit_num;
END;
//
DELIMITER ;
 CALL top_ordering_cities(3);




