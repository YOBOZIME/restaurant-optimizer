-- Créer le schéma restaurant
CREATE SCHEMA IF NOT EXISTS restaurant;

-- Créer la table ingredient
CREATE TABLE restaurant.ingredient (
                                       id SERIAL PRIMARY KEY,
                                       name VARCHAR(100) NOT NULL,
                                       unit VARCHAR(20) NOT NULL,
                                       current_price DECIMAL(10, 2),
                                       shelf_life_days INTEGER,
                                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Données de test
INSERT INTO restaurant.ingredient (name, unit, current_price, shelf_life_days) VALUES
                                                                                   ('Beef Chuck', 'kg', 12.50, 7),
                                                                                   ('Chicken Breast', 'kg', 8.75, 5),
                                                                                   ('Tomatoes', 'kg', 3.20, 14),
                                                                                   ('Lettuce', 'kg', 2.80, 10),
                                                                                   ('Onions', 'kg', 1.50, 30);

-- Vérification
SELECT 'Database initialized successfully' as status;