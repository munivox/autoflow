CREATE DATABASE IF NOT EXISTS autoflow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE autoflow;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS audit_logs, marketing_leads, marketing_service_orders, marketing_campaigns, ad_placements, notification_events, disputes, refunds, payment_splits, payments, subscriptions, plans, reviews, order_status_history, order_items, orders, quote_items, quotes, appointment_status_history, appointments, service_addons, service_packages, service_media, services, company_files, company_media, vehicles, customers, user_roles, users, roles, branches, companies;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE companies (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(160) NOT NULL,
  legal_name VARCHAR(180) NULL,
  document_number VARCHAR(32) NULL UNIQUE,
  slug VARCHAR(100) NOT NULL UNIQUE,
  description TEXT NULL,
  phone VARCHAR(30) NULL,
  email VARCHAR(160) NULL,
  website VARCHAR(255) NULL,
  address_line VARCHAR(180) NULL,
  city VARCHAR(100) NULL,
  state VARCHAR(2) NULL,
  postal_code VARCHAR(12) NULL,
  status ENUM('pending','active','suspended','blocked') NOT NULL DEFAULT 'pending',
  verification_status ENUM('none','pending','verified','revoked') NOT NULL DEFAULT 'none',
  verification_checked_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_company_location (city,state),
  INDEX idx_company_status (status,verification_status)
) ENGINE=InnoDB;

CREATE TABLE company_media (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  media_type ENUM('logo','cover','photo') NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  sort_order INT UNSIGNED NOT NULL DEFAULT 0,
  status ENUM('active','hidden') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
  INDEX idx_company_media (company_id,media_type,status,sort_order)
) ENGINE=InnoDB;

CREATE TABLE company_files (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  file_type VARCHAR(60) NULL,
  file_name VARCHAR(255) NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  review_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
  INDEX idx_company_files (company_id,review_status,created_at)
) ENGINE=InnoDB;

CREATE TABLE branches (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(120) NOT NULL,
  address_line VARCHAR(180) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(2) NOT NULL,
  postal_code VARCHAR(12) NULL,
  timezone VARCHAR(64) NOT NULL DEFAULT 'America/Sao_Paulo',
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  INDEX idx_branch_company (company_id,status),
  INDEX idx_branch_location (city,state)
) ENGINE=InnoDB;

CREATE TABLE roles (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(40) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NULL,
  name VARCHAR(160) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NULL,
  phone VARCHAR(30) NULL,
  status ENUM('active','inactive','blocked') NOT NULL DEFAULT 'active',
  last_login_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  INDEX idx_user_company (company_id,status)
) ENGINE=InnoDB;

CREATE TABLE user_roles (
  user_id BIGINT UNSIGNED NOT NULL,
  role_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY(user_id,role_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

CREATE TABLE customers (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  name VARCHAR(160) NOT NULL,
  email VARCHAR(160) NULL,
  phone VARCHAR(30) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_customer_user (user_id)
) ENGINE=InnoDB;

CREATE TABLE vehicles (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT UNSIGNED NOT NULL,
  plate VARCHAR(12) NULL,
  make VARCHAR(80) NULL,
  model VARCHAR(100) NULL,
  year SMALLINT UNSIGNED NULL,
  color VARCHAR(50) NULL,
  vehicle_type VARCHAR(50) NULL,
  photo_url VARCHAR(500) NULL,
  notes TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  INDEX idx_vehicle_customer (customer_id),
  INDEX idx_vehicle_plate (plate)
) ENGINE=InnoDB;

CREATE TABLE services (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(140) NOT NULL,
  description TEXT NULL,
  base_price DECIMAL(12,2) NOT NULL DEFAULT 0,
  duration_minutes INT UNSIGNED NOT NULL DEFAULT 60,
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
  INDEX idx_service_company (company_id,status)
) ENGINE=InnoDB;

CREATE TABLE service_media (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  service_id BIGINT UNSIGNED NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  sort_order INT UNSIGNED NOT NULL DEFAULT 0,
  status ENUM('active','hidden') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
  INDEX idx_service_media (service_id,status,sort_order)
) ENGINE=InnoDB;

CREATE TABLE service_packages (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  service_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(140) NOT NULL,
  description TEXT NULL,
  price DECIMAL(12,2) NOT NULL,
  duration_minutes INT UNSIGNED NOT NULL,
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
  INDEX idx_package_service (service_id,status)
) ENGINE=InnoDB;

CREATE TABLE service_addons (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(140) NOT NULL,
  description TEXT NULL,
  price DECIMAL(12,2) NOT NULL DEFAULT 0,
  duration_minutes INT UNSIGNED NOT NULL DEFAULT 0,
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
  INDEX idx_addon_company (company_id,status)
) ENGINE=InnoDB;

CREATE TABLE appointments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  branch_id BIGINT UNSIGNED NOT NULL,
  customer_id BIGINT UNSIGNED NOT NULL,
  vehicle_id BIGINT UNSIGNED NOT NULL,
  service_id BIGINT UNSIGNED NOT NULL,
  package_id BIGINT UNSIGNED NULL,
  scheduled_start DATETIME NOT NULL,
  scheduled_end DATETIME NOT NULL,
  status ENUM('scheduled','arrived','inspection','in_service','finishing','almost_ready','ready','completed','cancelled','no_show') NOT NULL DEFAULT 'scheduled',
  notes TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
  FOREIGN KEY (service_id) REFERENCES services(id),
  FOREIGN KEY (package_id) REFERENCES service_packages(id),
  INDEX idx_appointment_company_time (company_id,scheduled_start,status),
  INDEX idx_appointment_vehicle (vehicle_id,scheduled_start)
) ENGINE=InnoDB;

CREATE TABLE appointment_status_history (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  appointment_id BIGINT UNSIGNED NOT NULL,
  from_status VARCHAR(40) NULL,
  to_status VARCHAR(40) NOT NULL,
  changed_by_user_id BIGINT UNSIGNED NULL,
  note VARCHAR(500) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
  FOREIGN KEY (changed_by_user_id) REFERENCES users(id),
  INDEX idx_appointment_history (appointment_id,created_at)
) ENGINE=InnoDB;

CREATE TABLE quotes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  branch_id BIGINT UNSIGNED NULL,
  customer_id BIGINT UNSIGNED NOT NULL,
  vehicle_id BIGINT UNSIGNED NOT NULL,
  status ENUM('requested','sent','approved','rejected','expired','cancelled') NOT NULL DEFAULT 'requested',
  subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
  total DECIMAL(12,2) NOT NULL DEFAULT 0,
  customer_note TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NULL,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
  INDEX idx_quote_company_status (company_id,status,created_at)
) ENGINE=InnoDB;

CREATE TABLE quote_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  quote_id BIGINT UNSIGNED NOT NULL,
  description VARCHAR(180) NOT NULL,
  quantity DECIMAL(10,2) NOT NULL DEFAULT 1,
  unit_price DECIMAL(12,2) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE orders (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  branch_id BIGINT UNSIGNED NOT NULL,
  customer_id BIGINT UNSIGNED NOT NULL,
  vehicle_id BIGINT UNSIGNED NOT NULL,
  appointment_id BIGINT UNSIGNED NULL,
  quote_id BIGINT UNSIGNED NULL,
  status ENUM('scheduled','arrived','inspection','in_service','finishing','almost_ready','ready','completed','cancelled','disputed','refunded') NOT NULL DEFAULT 'scheduled',
  subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
  discount DECIMAL(12,2) NOT NULL DEFAULT 0,
  total DECIMAL(12,2) NOT NULL DEFAULT 0,
  completed_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
  FOREIGN KEY (appointment_id) REFERENCES appointments(id),
  FOREIGN KEY (quote_id) REFERENCES quotes(id),
  INDEX idx_order_company_status (company_id,status,created_at),
  INDEX idx_order_customer (customer_id,created_at)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  service_id BIGINT UNSIGNED NULL,
  package_id BIGINT UNSIGNED NULL,
  addon_id BIGINT UNSIGNED NULL,
  description VARCHAR(180) NOT NULL,
  quantity DECIMAL(10,2) NOT NULL DEFAULT 1,
  unit_price DECIMAL(12,2) NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(id),
  FOREIGN KEY (package_id) REFERENCES service_packages(id),
  FOREIGN KEY (addon_id) REFERENCES service_addons(id)
) ENGINE=InnoDB;

CREATE TABLE order_status_history (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  from_status VARCHAR(40) NULL,
  to_status VARCHAR(40) NOT NULL,
  changed_by_user_id BIGINT UNSIGNED NULL,
  note VARCHAR(500) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (changed_by_user_id) REFERENCES users(id),
  INDEX idx_order_history (order_id,created_at)
) ENGINE=InnoDB;

CREATE TABLE reviews (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  customer_id BIGINT UNSIGNED NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL UNIQUE,
  rating TINYINT UNSIGNED NOT NULL,
  comment TEXT NULL,
  status ENUM('published','hidden','pending') NOT NULL DEFAULT 'published',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  CHECK (rating BETWEEN 1 AND 5),
  INDEX idx_review_company (company_id,status,created_at)
) ENGINE=InnoDB;

CREATE TABLE plans (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE,
  description VARCHAR(255) NULL,
  monthly_price DECIMAL(12,2) NOT NULL DEFAULT 0,
  commission_rate DECIMAL(5,2) NOT NULL DEFAULT 0,
  features JSON NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE subscriptions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  plan_id BIGINT UNSIGNED NOT NULL,
  status ENUM('trial','active','past_due','cancelled','suspended') NOT NULL DEFAULT 'trial',
  provider VARCHAR(40) NULL,
  provider_subscription_id VARCHAR(160) NULL,
  started_at DATETIME NULL,
  current_period_start DATETIME NULL,
  current_period_end DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (plan_id) REFERENCES plans(id),
  INDEX idx_subscription_company (company_id,status)
) ENGINE=InnoDB;

CREATE TABLE payments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NULL,
  company_id BIGINT UNSIGNED NULL,
  customer_id BIGINT UNSIGNED NULL,
  type ENUM('order','subscription','marketing') NOT NULL,
  provider VARCHAR(40) NULL,
  provider_payment_id VARCHAR(160) NULL,
  amount DECIMAL(12,2) NOT NULL,
  fee_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  status ENUM('pending','authorized','paid','cancelled','refunded','chargeback') NOT NULL DEFAULT 'pending',
  paid_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  INDEX idx_payment_company (company_id,status,created_at),
  INDEX idx_payment_provider (provider,provider_payment_id)
) ENGINE=InnoDB;

CREATE TABLE payment_splits (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  payment_id BIGINT UNSIGNED NOT NULL,
  beneficiary_type ENUM('company','platform') NOT NULL,
  beneficiary_company_id BIGINT UNSIGNED NULL,
  amount DECIMAL(12,2) NOT NULL,
  provider_split_id VARCHAR(160) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE,
  FOREIGN KEY (beneficiary_company_id) REFERENCES companies(id),
  INDEX idx_split_payment (payment_id)
) ENGINE=InnoDB;

CREATE TABLE refunds (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  payment_id BIGINT UNSIGNED NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  reason VARCHAR(255) NULL,
  status ENUM('requested','processing','completed','rejected') NOT NULL DEFAULT 'requested',
  provider_refund_id VARCHAR(160) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (payment_id) REFERENCES payments(id),
  INDEX idx_refund_payment (payment_id,status)
) ENGINE=InnoDB;

CREATE TABLE disputes (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  opened_by_customer_id BIGINT UNSIGNED NULL,
  reason VARCHAR(120) NOT NULL,
  description TEXT NOT NULL,
  status ENUM('open','awaiting_company','under_review','resolved','closed') NOT NULL DEFAULT 'open',
  resolution VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at DATETIME NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (opened_by_customer_id) REFERENCES customers(id),
  INDEX idx_dispute_order (order_id,status)
) ENGINE=InnoDB;

CREATE TABLE notification_events (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NULL,
  customer_id BIGINT UNSIGNED NULL,
  channel ENUM('in_app','push','email','whatsapp') NOT NULL,
  event_type VARCHAR(80) NOT NULL,
  payload JSON NULL,
  status ENUM('queued','sent','failed') NOT NULL DEFAULT 'queued',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sent_at DATETIME NULL,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  INDEX idx_notification_status (status,created_at)
) ENGINE=InnoDB;

CREATE TABLE ad_placements (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(255) NULL,
  active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE marketing_campaigns (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NOT NULL,
  placement_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(160) NOT NULL,
  label VARCHAR(40) NOT NULL DEFAULT 'Patrocinado',
  creative_url VARCHAR(500) NULL,
  target_city VARCHAR(100) NULL,
  budget DECIMAL(12,2) NULL,
  price DECIMAL(12,2) NULL,
  status ENUM('draft','scheduled','active','paused','finished','cancelled') NOT NULL DEFAULT 'draft',
  starts_at DATETIME NULL,
  ends_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (placement_id) REFERENCES ad_placements(id),
  INDEX idx_campaign_active (status,starts_at,ends_at),
  INDEX idx_campaign_company (company_id,status)
) ENGINE=InnoDB;

CREATE TABLE marketing_leads (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NULL,
  contact_name VARCHAR(160) NOT NULL,
  email VARCHAR(160) NULL,
  phone VARCHAR(30) NULL,
  source VARCHAR(80) NOT NULL DEFAULT 'autoflow',
  requested_service VARCHAR(160) NULL,
  notes TEXT NULL,
  status ENUM('new','contacted','proposal','won','lost') NOT NULL DEFAULT 'new',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  INDEX idx_marketing_lead_status (status,created_at)
) ENGINE=InnoDB;

CREATE TABLE marketing_service_orders (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  lead_id BIGINT UNSIGNED NULL,
  company_id BIGINT UNSIGNED NULL,
  service_name VARCHAR(160) NOT NULL,
  scope TEXT NULL,
  management_fee DECIMAL(12,2) NULL,
  media_budget DECIMAL(12,2) NULL,
  status ENUM('draft','proposal','active','paused','completed','cancelled') NOT NULL DEFAULT 'draft',
  starts_at DATETIME NULL,
  ends_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (lead_id) REFERENCES marketing_leads(id),
  FOREIGN KEY (company_id) REFERENCES companies(id),
  INDEX idx_marketing_order_company (company_id,status)
) ENGINE=InnoDB;

CREATE TABLE audit_logs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  company_id BIGINT UNSIGNED NULL,
  user_id BIGINT UNSIGNED NULL,
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(80) NOT NULL,
  entity_id BIGINT UNSIGNED NULL,
  metadata JSON NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_audit_company (company_id,created_at),
  INDEX idx_audit_entity (entity_type,entity_id,created_at)
) ENGINE=InnoDB;
