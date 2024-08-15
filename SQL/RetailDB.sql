-- 1. **Create the Database and Table** Create a database named `RetailDB`.
 -- Create a table named `customers` with columns: `id`, `name`, `email`, `phone`, and `address`.


CREATE DATABASE RetailDB;
USE RetailDB;

CREATE TABLE customers (
    customers_id INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(30),
    Address VARCHAR(200)
);
 -- 2. **Insert Sample Data**
-- Insert multiple rows of sample data that include various inconsistencies such as leading/trailing spaces, mixed case text, and NULL values.
DROP TABLE IF EXISTS customers;

INSERT INTO customers (customers_id, Name, Email, Phone, Address)  
VALUES  
    (1, 'John Doe', 'JOHN.DOE@EXAMPLE.COM', '12345-67890', '123 MAIN st.'),
    (2, 'Jane Smith', 'Smith@EXAMPLE.COM', NULL, '456 ELM STREET'),
    (3, 'Alice Johnson', 'ALICE.JOHNSON@EXAMPLE.COM', '98765-43210', '789 PINE rd.'),
    (4, 'Bob Brown', 'bob.brown@EXAMPLE.com', NULL, '987 OAK Avenue'),
    (5, 'Mary Williams', 'MARY.WILLIAMS@EXAMPLE.COM', '3216549870', "UNKNOWN");

-- 3. **Select Data Before Cleaning**
 SELECT *
 FROM customers;
 
 -- 4.*Apply TRIM Function**
-- Remove leading and trailing spaces from the `name` and `email` columns.

 UPDATE customers
SET 
	name = TRIM(TRAILING " " FROM name),
	Email = TRIM(TRAILING " " FROM Email);

  UPDATE customers
SET 
	name = TRIM(LEADING " " FROM name),
	Email = TRIM(LEADING " " FROM Email);

-- 5. **Apply UPPER Function** Standardize all names to uppercase.

UPDATE customers
SET
   NAME=UPPER(NAME);
 
 -- 6. **Apply LOWER Function**
   -- Standardize all email addresses to lowercase.
UPDATE customers
SET
   Email= LOWER(Email);
 
 SELECT *
 FROM retaildb.customers;
 
 -- 7. **Apply REPLACE Function**
   -- Standardize phone numbers by removing any dashes.
   
UPDATE customers
SET 
	Phone=REPLACE(Phone,"-","");
    
-- 8- **Handle NULL Values with COALESCE**
   -- Replace NULL values in the `phone` column with 'N/A'.
UPDATE Customers
SET
   Phone =coalesce(PHONE,"N/A");
   
-- 9**Handle Specific Known Values with NULLIF**
   -- Treat specific known values (e.g., 'UNKNOWN') in the `address` column as NULL.
UPDATE customers
SET Address = NULLIF(Address, 'UNKNOWN');


-- 10. **Select Data After Cleaning**
   -- Select and display the data after performing all cleaning operations.

 SELECT *
 FROM customers;