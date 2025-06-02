\c postgres

CREATE SCHEMA energy;
CREATE TABLE energy.clients (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
CREATE TABLE energy.contracts (
    id SERIAL PRIMARY KEY,
    start_date TIMESTAMP NOT NULL,
    enabled BOOLEAN DEFAULT TRUE,
    client_id INTEGER NOT NULL,
    FOREIGN KEY (client_id) REFERENCES energy.clients(id)
);
CREATE TABLE energy.readings (
    id SERIAL PRIMARY KEY,
    reading_date TIMESTAMP NOT NULL,
    kwh_value NUMERIC(10,2) NOT NULL,
    contract_id INTEGER NOT NULL,
    FOREIGN KEY (contract_id) REFERENCES energy.contracts(id)
);