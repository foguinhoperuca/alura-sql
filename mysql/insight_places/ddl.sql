USE insight_places;

CREATE TABLE addresses (
  id VARCHAR(255) PRIMARY KEY,
  street VARCHAR(255),
  address_number INT,
  neighborhood VARCHAR(255),
  city VARCHAR(255),
  address_state VARCHAR(2),
  postal_code VARCHAR(16)
);

CREATE TABLE clients (
  id VARCHAR(255) PRIMARY KEY,
  client_name VARCHAR(255),
  cpf VARCHAR(16),
  contact VARCHAR(255)
);

CREATE TABLE owners (
  id VARCHAR(255) PRIMARY KEY,
  owner_name VARCHAR(255),
  cpf_cnpj VARCHAR(32),
  contact VARCHAR(255)
);

CREATE TABLE accommodations (
  id VARCHAR(255) PRIMARY KEY,
  accommodation_type VARCHAR(50),
  address_id VARCHAR(255),
  owner_id VARCHAR(255),
  active bool,
  FOREIGN KEY (address_id) REFERENCES addresses(id),
  FOREIGN KEY (owner_id) REFERENCES owners(id)
);

CREATE TABLE rents (
  id VARCHAR(255) PRIMARY KEY,
  client_id VARCHAR(255),
  accommodation_id VARCHAR(255),
  start_date DATE,
  end_date DATE,
  total_price DECIMAL(10, 2),
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (accommodation_id) REFERENCES accommodations(id)
);

CREATE TABLE reviews (
  id VARCHAR(255) PRIMARY KEY,
  client_id VARCHAR(255),
  accommodation_id VARCHAR(255),
  rate INT,
  comment TEXT,
  FOREIGN KEY (client_id) REFERENCES clients(id),
  FOREIGN KEY (accommodation_id) REFERENCES accommodations(id)
);
