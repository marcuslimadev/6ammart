-- Tradução da Landing Page para Português
USE multi_food_db;

UPDATE data_settings SET value = 'Gerencie Sua Vida Diária em uma plataforma' WHERE `key` = 'fixed_header_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Mais do que apenas uma plataforma de eCommerce confiável' WHERE `key` = 'fixed_header_sub_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Seu empreendimento de eCommerce começa aqui !' WHERE `key` = 'fixed_module_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Escolha o módulo adequado para o seu negócio' WHERE `key` = 'fixed_module_sub_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Recursos Incríveis' WHERE `key` = 'feature_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Descubra todos os recursos poderosos da nossa plataforma' WHERE `key` = 'feature_short_description' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Baixe o Aplicativo' WHERE `key` = 'app_section_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Disponível em iOS e Android' WHERE `key` = 'app_section_sub_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Ganhe com a gente' WHERE `key` = 'earn_money_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Cadastre-se e comece a ganhar' WHERE `key` = 'earn_money_sub_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Seja um Parceiro' WHERE `key` = 'business_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Cadastre sua loja e expanda seu negócio' WHERE `key` = 'business_sub_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Seja um Entregador' WHERE `key` = 'delivery_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'Ganhe dinheiro fazendo entregas' WHERE `key` = 'delivery_sub_title' AND type = 'admin_landing_page';
UPDATE data_settings SET value = 'O que nossos clientes dizem' WHERE `key` = 'testimonial_title' AND type = 'admin_landing_page';

SELECT 'Landing page traduzida com sucesso!' AS resultado;
