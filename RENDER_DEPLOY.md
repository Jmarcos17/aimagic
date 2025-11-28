# Deploy no Render - Configuração

## ⚠️ Importante

O Render precisa ser configurado como **Web Service PHP**, não Node.js!

## Passos para Deploy:

### 1. No Dashboard do Render:

1. **New** > **Web Service**
2. Conecte seu repositório GitHub: `Jmarcos17/aimagic`
3. Configure:

#### Configurações Básicas:
- **Name**: `magicai` (ou o nome que preferir)
- **Region**: Escolha a região mais próxima
- **Branch**: `main`
- **Runtime**: **PHP** (não Node.js!)
- **Build Command**: 
  ```bash
  composer install --no-dev --optimize-autoloader && npm install && npm run build && php artisan config:cache && php artisan route:cache && php artisan view:cache
  ```
- **Start Command**:
  ```bash
  php artisan serve --host=0.0.0.0 --port=$PORT
  ```

#### Variáveis de Ambiente:

Adicione todas as variáveis do seu `.env`:

**Banco de Dados (Neon PostgreSQL):**
```
DB_CONNECTION=pgsql
DB_HOST=ep-fancy-hill-ac1fxrdp-pooler.sa-east-1.aws.neon.tech
DB_PORT=5432
DB_DATABASE=neondb
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_39PfFdObjnSC
DB_SSLMODE=require
```

**Aplicação:**
```
APP_NAME=MagicAI
APP_ENV=production
APP_KEY=                    # Gere com: php artisan key:generate
APP_DEBUG=false
APP_URL=https://seu-app.onrender.com
```

**Outras variáveis importantes:**
- `OPENAI_API_KEY=`
- `MAIL_*` (configurações de email)
- `STRIPE_KEY=`, `STRIPE_SECRET=` (se usar)
- Etc.

### 2. Banco de Dados PostgreSQL:

1. No Render: **New** > **PostgreSQL**
2. Ou use o Neon (já configurado)
3. Conecte as variáveis de ambiente acima

### 3. Após o Deploy:

1. Execute as migrations:
   ```bash
   php artisan migrate --force
   ```

2. Crie o link simbólico do storage:
   ```bash
   php artisan storage:link
   ```

### 4. Usando render.yaml (Alternativa):

Se preferir, você pode usar o arquivo `render.yaml` que foi criado. O Render detectará automaticamente.

## Troubleshooting:

- **Erro "Missing script: start"**: Certifique-se de que o Runtime está configurado como **PHP**, não Node.js
- **Erro de conexão com banco**: Verifique as variáveis de ambiente do PostgreSQL
- **Erro 500**: Verifique os logs no dashboard do Render
- **Assets não carregam**: Certifique-se de que o build foi executado (`npm run build`)

## Notas:

- O Render oferece plano gratuito com limitações
- Após 15 minutos de inatividade, o serviço "dorme" (wake up em ~30s)
- Para produção, considere o plano pago para evitar o "sleep"

