# AutoFlow — Decisões V1

- Escopo inicial: lava-car.
- Marketplace e gestão empresarial usam a mesma plataforma/backend.
- A empresa tem um espaço dentro do AutoFlow; não é necessário criar um aplicativo separado para cada empresa.
- Avaliações existem em todos os planos.
- Recursos analíticos avançados podem variar por plano.
- Veículos atendidos são calculados por serviços concluídos.
- `Aberto agora`, `Online agora` e `Disponível para agendamento` são estados diferentes.
- Publicidade não é reputação: destaques pagos precisam de identificação.
- Selo de verificação depende de critérios objetivos e pode ser removido.
- Preços dos planos ficam configuráveis no banco/admin, não hardcoded no frontend.
- Marketing particular é um serviço comercial separado do SaaS e da mídia.
- Senhas de contas externas de anúncios não são armazenadas no AutoFlow.
- Integração de pagamentos usa uma abstração de provedor e um modelo aprovado para marketplace/split.
- Banco deve registrar histórico de status, não apenas o status atual.


## V15 — Modelo comercial simplificado

- A empresa não paga mensalidade nos dois planos iniciais.
- **AutoFlow:** 8% por serviço realizado pelo marketplace, com acesso à plataforma completa.
- **AutoFlow Destaque:** 12% por serviço realizado, incluindo recursos de marketing interno como destaques, posições patrocinadas identificadas, banners e campanhas dentro do AutoFlow.
- Marketing externo (Google Ads, Meta Ads, criativos, gestão de mídia e serviços semelhantes) é um **upgrade comercial separado**, solicitado pela empresa e negociado com a Munivox conforme escopo e verba de mídia.
- Avaliações continuam disponíveis para as empresas; comentários fazem parte da avaliação e podem ser exibidos publicamente quando publicados.
- Serviços da empresa são cadastrados pelo próprio estabelecimento, sem lista fixa obrigatória no cadastro.
- Uploads de logo, fotos e anexos fazem parte do cadastro, mas etapas documentais podem ser concluídas posteriormente.
- Destaques pagos não alteram a nota/reputação objetiva da empresa e devem ser identificados como patrocinados quando aplicável.
