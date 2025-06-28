CREATE TABLE stocks (
  stock_id SERIAL PRIMARY KEY,
  ticker VARCHAR(10),
  company_name VARCHAR(100),
  sector VARCHAR(50)
);

CREATE TABLE portfolio_transactions (
  transaction_id SERIAL PRIMARY KEY,
  stock_id INT,
  transaction_date DATE,
  transaction_type VARCHAR(10), 
  quantity INT,
  price_per_share DECIMAL(10,2),
  FOREIGN KEY (stock_id) REFERENCES stocks(stock_id)
);
CREATE TABLE daily_prices (
  price_id SERIAL PRIMARY KEY,
  stock_id INT,
  price_date DATE,
  close_price DECIMAL(10,2),
  FOREIGN KEY (stock_id) REFERENCES stocks(stock_id)
);
INSERT INTO daily_prices (stock_id, price_date, close_price) VALUES
(1, '2024-06-25', 190.00),
(1, '2024-06-26', 192.50),
(2, '2024-06-25', 650.00),
(2, '2024-06-26', 660.00);


INSERT INTO stocks (ticker, company_name, sector) VALUES
('AAPL', 'Apple Inc.', 'Technology'),
('TSLA', 'Tesla Inc.', 'Automotive');

INSERT INTO portfolio_transactions (stock_id, transaction_date, transaction_type, quantity, price_per_share) VALUES
(1, '2024-01-10', 'BUY', 10, 150.00),
(1, '2024-03-15', 'BUY', 5, 170.00),
(2, '2024-02-10', 'BUY', 8, 600.00);

SELECT 
  s.ticker,
  SUM(CASE WHEN pt.transaction_type = 'BUY' THEN pt.quantity 
           WHEN pt.transaction_type = 'SELL' THEN -pt.quantity ELSE 0 END) AS net_quantity
FROM portfolio_transactions pt
JOIN stocks s ON pt.stock_id = s.stock_id
GROUP BY s.ticker;


SELECT 
  s.ticker,
  SUM(
    (CASE WHEN pt.transaction_type = 'BUY' THEN pt.quantity 
          WHEN pt.transaction_type = 'SELL' THEN -pt.quantity ELSE 0 END) 
    * dp.close_price
  ) AS current_value
FROM portfolio_transactions pt
JOIN stocks s ON pt.stock_id = s.stock_id
JOIN daily_prices dp ON dp.stock_id = s.stock_id
WHERE dp.price_date = CURRENT_DATE
GROUP BY s.ticker;


SELECT 
  s.ticker,
  SUM(CASE 
    WHEN pt.transaction_type = 'BUY' THEN pt.quantity
    WHEN pt.transaction_type = 'SELL' THEN -pt.quantity
  END) AS net_quantity
FROM portfolio_transactions pt
JOIN stocks s ON pt.stock_id = s.stock_id
GROUP BY s.ticker;


SELECT 
  s.sector,
  SUM(pt.quantity * pt.price_per_share) AS sector_investment
FROM portfolio_transactions pt
JOIN stocks s ON pt.stock_id = s.stock_id
WHERE pt.transaction_type = 'BUY'
GROUP BY s.sector;



