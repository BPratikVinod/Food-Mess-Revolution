SHOW DATABASES;

-- create database QSP_DB;
use  QSP_DB;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    address VARCHAR(255),
    user_type ENUM('Customer', 'Admin') DEFAULT 'Customer', -- Admin for staff members
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE MealPlans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    duration ENUM('Daily', 'Weekly', 'Monthly') NOT NULL,
    description TEXT
);
CREATE TABLE Subscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    plan_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (plan_id) REFERENCES MealPlans(plan_id)
);
CREATE TABLE Menu (
    menu_id INT PRIMARY KEY AUTO_INCREMENT,
    meal_type ENUM('Breakfast', 'Lunch', 'Dinner') NOT NULL,
    date DATE NOT NULL,
    description TEXT
);
CREATE TABLE Inventory (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL,
    unit VARCHAR(20) NOT NULL,
    threshold_quantity INT NOT NULL, -- Minimum stock level before reorder
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    menu_id INT,
    order_date DATE NOT NULL,
    status ENUM('Pending', 'Served', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (menu_id) REFERENCES Menu(menu_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    subscription_id INT NULL, -- Allow NULL for subscription_id
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Debit Card', 'Net Banking', 'Cash') NOT NULL,
    status ENUM('Success', 'Failed', 'Pending') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (subscription_id) REFERENCES Subscriptions(subscription_id) ON DELETE SET NULL -- Ensure that if a subscription is deleted, the value in Payments becomes NULL
);


INSERT INTO Users (name, email, phone_number, address, user_type) 
VALUES 
('John Doe', 'johndoe@example.com', '1234567890', '123 Main St, City', 'Customer'),
('Jane Smith', 'janesmith@example.com', '0987654321', '456 Elm St, City', 'Admin'),
('Alice Johnson', 'alicej@example.com', '5551234567', '789 Oak St, City', 'Customer'),
('Bob Brown', 'bobbrown@example.com', '5557654321', '101 Maple St, City', 'Customer'),
('Charlie Davis', 'charlied@example.com', '5552345678', '202 Pine St, City', 'Admin'),
('Emily Clark', 'emilyc@example.com', '5558765432', '303 Cedar St, City', 'Customer'),
('Frank Wilson', 'frankw@example.com', '5553456789', '404 Birch St, City', 'Customer'),
('Grace Lee', 'gracelee@example.com', '5559876543', '505 Walnut St, City', 'Admin'),
('Henry Scott', 'henryscott@example.com', '5554567890', '606 Chestnut St, City', 'Customer'),
('Ivy Taylor', 'ivytaylor@example.com', '5556789012', '707 Aspen St, City', 'Customer');

INSERT INTO MealPlans (plan_name, price, duration, description) 
VALUES 
('Basic Plan', 9.99, 'Daily', 'Basic daily meal plan.'),
('Standard Plan', 49.99, 'Weekly', 'Weekly meal plan with standard menu.'),
('Premium Plan', 199.99, 'Monthly', 'Premium monthly meal plan with a variety of options.'),
('Family Plan', 299.99, 'Monthly', 'Monthly meal plan for a family of 4.'),
('Vegetarian Plan', 149.99, 'Monthly', 'Monthly vegetarian meal plan.'),
('Keto Plan', 159.99, 'Monthly', 'Monthly keto diet meal plan.'),
('Low Carb Plan', 139.99, 'Weekly', 'Weekly low carb meal plan.'),
('High Protein Plan', 59.99, 'Weekly', 'Weekly meal plan for high protein intake.'),
('Vegan Plan', 169.99, 'Monthly', 'Monthly vegan meal plan.'),
('Gluten-Free Plan', 179.99, 'Monthly', 'Monthly gluten-free meal plan.');

INSERT INTO Subscriptions (user_id, plan_id, start_date, end_date, total_price) 
VALUES 
(1, 1, '2024-01-01', '2024-01-02', 9.99),
(2, 2, '2024-01-01', '2024-01-07', 49.99),
(3, 3, '2024-01-01', '2024-01-31', 199.99),
(4, 4, '2024-01-01', '2024-01-31', 299.99),
(5, 5, '2024-01-01', '2024-01-31', 149.99),
(6, 6, '2024-01-01', '2024-01-31', 159.99),
(7, 7, '2024-01-01', '2024-01-07', 139.99),
(8, 8, '2024-01-01', '2024-01-07', 59.99),
(9, 9, '2024-01-01', '2024-01-31', 169.99),
(10, 10, '2024-01-01', '2024-01-31', 179.99);

INSERT INTO Menu (meal_type, date, description) 
VALUES 
('Breakfast', '2024-01-01', 'Omelette, toast, and coffee.'),
('Lunch', '2024-01-01', 'Grilled chicken salad.'),
('Dinner', '2024-01-01', 'Steak and mashed potatoes.'),
('Breakfast', '2024-01-02', 'Pancakes and scrambled eggs.'),
('Lunch', '2024-01-02', 'Turkey sandwich with chips.'),
('Dinner', '2024-01-02', 'Pasta with marinara sauce.'),
('Breakfast', '2024-01-03', 'Cereal and fruit.'),
('Lunch', '2024-01-03', 'Caesar salad with grilled salmon.'),
('Dinner', '2024-01-03', 'Grilled shrimp with rice.'),
('Breakfast', '2024-01-04', 'Bagel with cream cheese and coffee.');

INSERT INTO Inventory (item_name, stock_quantity, unit, threshold_quantity) 
VALUES 
('Eggs', 200, 'pieces', 50),
('Bread', 100, 'loaves', 20),
('Chicken Breast', 150, 'kg', 30),
('Milk', 50, 'liters', 10),
('Rice', 300, 'kg', 100),
('Steak', 100, 'kg', 20),
('Pasta', 250, 'kg', 50),
('Cheese', 50, 'kg', 10),
('Coffee', 20, 'kg', 5),
('Potatoes', 200, 'kg', 50);

INSERT INTO Orders (user_id, menu_id, order_date, status) 
VALUES 
(1, 1, '2024-01-01', 'Pending'),
(2, 2, '2024-01-01', 'Served'),
(3, 3, '2024-01-01', 'Cancelled'),
(4, 4, '2024-01-02', 'Pending'),
(5, 5, '2024-01-02', 'Served'),
(6, 6, '2024-01-02', 'Cancelled'),
(7, 7, '2024-01-03', 'Pending'),
(8, 8, '2024-01-03', 'Served'),
(9, 9, '2024-01-03', 'Pending'),
(10, 10, '2024-01-04', 'Served');


INSERT INTO Payments (user_id, subscription_id, amount, payment_method, status) 
VALUES 
(1, 1, 9.99, 'Credit Card', 'Success'),
(2, 2, 49.99, 'Debit Card', 'Success'),
(3, 3, 199.99, 'Net Banking', 'Success'),
(4, 4, 299.99, 'Credit Card', 'Success'),
(5, 5, 149.99, 'Cash', 'Pending'),
(6, 6, 159.99, 'Credit Card', 'Success'),
(7, 7, 139.99, 'Debit Card', 'Failed'),
(8, 8, 59.99, 'Net Banking', 'Success'),
(9, 9, 169.99, 'Credit Card', 'Success'),
(10, 10, 179.99, 'Debit Card', 'Success');

INSERT INTO Orders (user_id, menu_id, order_date, status) 
VALUES 
(1, 1, '2024-01-01', 'Pending'),
(2, 2, '2024-01-01', 'Served'),
(3, 3, '2024-01-01', 'Cancelled'),
(4, 4, '2024-01-02', 'Pending'),
(5, 5, '2024-01-02', 'Served'),
(6, 6, '2024-01-02', 'Cancelled'),
(7, 7, '2024-01-03', 'Pending'),
(8, 8, '2024-01-03', 'Served'),
(9, 9, '2024-01-03', 'Pending'),
(10, 10, '2024-01-04', 'Served');


SELECT u.name, mp.plan_name, s.start_date, s.end_date
FROM Subscriptions s
JOIN Users u ON s.user_id = u.user_id
JOIN MealPlans mp ON s.plan_id = mp.plan_id
WHERE s.is_active = 1;

SELECT SUM(amount) AS total_revenue
FROM Payments
WHERE LOWER(status) = 'success';


SELECT meal_type, description
FROM Menu
WHERE date = '2024-09-01';
SELECT u.name, o.order_date, m.meal_type, o.status
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Menu m ON o.menu_id = m.menu_id
WHERE o.user_id = 1;


show tables;

SELECT * FROM Users ;
SELECT * FROM MealPlans;
SELECT * FROM menu;
SELECT * FROM inventory;
select * from payments;
select * from orders;
SELECT * FROM Subscriptions ;