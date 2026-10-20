# Busca Placa

Aplicativo Flutter para consultar dados de veículos brasileiros usando a placa. A tela inicial oferece consultas de informações básicas, cidade associada à placa e dados complementares. As telas também tentam buscar um GIF relacionado ao veículo ou à cidade.

## Funcionalidades

- Aceita placas no formato antigo (`ABC1234`) e no padrão Mercosul (`ABC1D23`). Espaços e caracteres não alfanuméricos são removidos antes da consulta.
- Consulta dados do veículo pela API Placas.app.br.
- Exibe informações básicas, como marca, modelo, anos e segmento.
- Exibe município, UF e informações complementares disponibilizadas pela API.
- Busca um GIF relacionado ao veículo ou à cidade com a API Giphy. A busca do GIF é opcional: se falhar ou não encontrar resultado, os dados do veículo continuam disponíveis.
- Permite abrir o GIF em uma tela ampliada.

## Requisitos

- Flutter SDK compatível com a restrição definida em `pubspec.yaml` (`^3.12.2`) e Dart correspondente.
- Uma chave de acesso da API de placas (Placas.app.br).
- Uma chave da API Giphy.
- Um emulador Android ou dispositivo conectado para executar o aplicativo.

## Configuração

Na raiz do projeto, crie um arquivo `.env` com as credenciais:

```dotenv
PLACAS_API_TOKEN=seu_token_da_api_de_placas
GIPHY_API_KEY=sua_chave_da_giphy
```

O `.env` é carregado na inicialização e está declarado como asset em `pubspec.yaml`. Mantenha suas chaves privadas e não as publique no repositório.

## Executar

Na raiz do projeto, execute:

```bash
flutter pub get
flutter run
```

Para gerar um APK de release para Android:

```bash
flutter build apk --release
```

O artefato é gerado em `build/app/outputs/flutter-apk/app-release.apk`.

## Como usar

1. Na tela inicial, escolha uma das três opções de consulta.
2. Digite a placa (por exemplo, `ABC1234` ou `ABC1D23`) e toque no botão de busca.
3. Consulte os dados retornados. Se houver um GIF, toque nele para abrir a visualização ampliada.

## Organização do código

```text
lib/
├── main.dart                 # Inicialização, carregamento do .env e tema
├── models/
│   └── vehicle.dart          # Representação e leitura dos dados do veículo
├── service/
│   ├── vehicle_service.dart  # Requisição à API Placas.app.br
│   └── giphy_service.dart    # Busca de GIFs na API Giphy
└── view/
    ├── home_page.dart                  # Menu inicial
    ├── busca_informacoes_page.dart      # Dados básicos
    ├── busca_cidade_page.dart           # Município e UF
    ├── busca_complementares_page.dart   # Dados complementares
    └── gif_page.dart                   # Visualização ampliada do GIF
```

## APIs utilizadas

- **Placas.app.br**: consulta de dados por placa via `POST https://placas.app.br/api/v1/placas/numero`, autenticada com token Bearer.
- **Giphy**: pesquisa de GIFs via `GET https://api.giphy.com/v1/gifs/search`, limitada a um resultado com classificação `G`.

As chamadas têm timeout de 20 segundos. Erros de autenticação, placa não encontrada e respostas HTTP inesperadas são apresentados na interface.
