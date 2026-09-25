# AutoFlow — Acessos e painéis V1

## 1. Modelo de acesso

O produto possui **dois acessos voltados ao público** e **um acesso interno da Munivox**:

### Consumidor
A pessoa procura empresas, cadastra veículos, agenda, paga, acompanha o serviço, favorita empresas e avalia.

Menu inicial:
- Início
- Buscar serviços
- Meus agendamentos
- Meus veículos
- Favoritos
- Notificações
- Minha conta

### Empresa
A empresa administra sua operação dentro do AutoFlow.

Menu lateral:
- Visão geral
- Agenda
- Serviços e pacotes
- Clientes
- Veículos
- Orçamentos
- Ordens de serviço
- Relatórios
- Marketing
- Financeiro
- Minha empresa
- Configurações

Perfis internos da empresa continuam subordinados a este contexto: administrador da empresa, gerente, atendimento, lavador/técnico, motorista e financeiro.

### Administrador Munivox
É um contexto separado e não aparece para consumidores ou empresas.

Menu:
- Visão geral
- Empresas
- Conteúdo e banners
- Campanhas
- Planos
- Pagamentos e repasses
- Marketing particular
- Relatórios globais
- Usuários e permissões
- Configurações
- Auditoria

## 2. Regra de segurança

O backend deve determinar o contexto e as permissões a partir da sessão/claims do usuário. Nunca confiar em `company_id` enviado pelo navegador.

## 3. Cadastro de empresa

A empresa cadastra livremente seus serviços usando `+ Adicionar serviço`. Não existe catálogo fixo obrigatório no cadastro.

Uploads:
- logo;
- capa/fotos;
- documentos/anexos opcionais, que podem ser concluídos depois.

## 4. Marketing

- Plano AutoFlow: 8% por serviço realizado.
- AutoFlow Destaque: 12% por serviço realizado, com recursos de marketing interno.
- Marketing externo é um upgrade comercial separado e negociado pela Munivox.
