USE autoflow;
INSERT INTO roles(name) VALUES ('platform_admin'),('customer'),('company_admin'),('manager'),('attendant'),('washer'),('driver'),('financial');
INSERT INTO plans(name,description,monthly_price,commission_rate,features) VALUES
('AutoFlow','Plataforma completa sem mensalidade; comissão por serviço realizado.',0.00,8.00,'{"reviews":true,"profile":true,"booking":true,"metrics":true,"internal_marketing":false,"external_marketing":false}'),
('AutoFlow Destaque','Plataforma completa com maior visibilidade e marketing interno dentro do AutoFlow.',0.00,12.00,'{"reviews":true,"profile":true,"booking":true,"metrics":true,"internal_marketing":true,"sponsored_search":true,"banners":true,"external_marketing":false}');
INSERT INTO ad_placements(code,name,description) VALUES
('search_sponsored','Destaque na busca','Empresa patrocinada em resultados de pesquisa'),
('home_banner','Banner da home','Banner comercial na página inicial'),
('category_banner','Banner de categoria','Banner dentro da área de lava-car'),
('offer_featured','Oferta em destaque','Oferta destacada na área promocional');
INSERT INTO companies(name,slug,description,phone,email,city,state,status,verification_status) VALUES
('LavaCar Exemplo','lavacar-exemplo','Empresa demonstrativa do protótipo AutoFlow.','(11) 99999-0000','demo@autoflow.com.br','Registro','SP','active','verified');
INSERT INTO branches(company_id,name,address_line,city,state,postal_code) VALUES
(1,'Unidade Centro','Rua Exemplo, 100','Registro','SP','11900-000');
INSERT INTO services(company_id,name,description,base_price,duration_minutes) VALUES
(1,'Lavagem simples','Lavagem externa e acabamento básico.',39.90,45),
(1,'Lavagem completa','Lavagem externa, interna e acabamento.',79.90,70),
(1,'Higienização interna','Limpeza detalhada do interior do veículo.',129.90,120);
INSERT INTO service_addons(company_id,name,description,price,duration_minutes) VALUES
(1,'Proteção de vidros','Aplicação de proteção nos vidros.',19.90,15),
(1,'Aromatizante premium','Finalização aromática.',9.90,5);
