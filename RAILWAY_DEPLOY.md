# 🚂 Deploy no Railway (Recomendado)

O Railway tem suporte **nativo para PHP/Laravel** e é muito mais simples que o Render.

## Passos para Deploy:

### 1. Criar Conta e Projeto

1. Acesse: https://railway.app
2. Faça login com GitHub
3. Clique em **New Project**
4. Selecione **Deploy from GitHub repo**
5. Escolha o repositório: `Jmarcos17/aimagic`

### 2. Configuração Automática

O Railway detecta Laravel automaticamente e configura:
- ✅ PHP 8.2
- ✅ Composer
- ✅ Nginx
- ✅ Build e deploy automáticos

### 3. Adicionar Banco de Dados PostgreSQL

1. No projeto Railway, clique em **+ New**
2. Selecione **Database** > **Add PostgreSQL**
3. Railway criará um PostgreSQL automaticamente
4. **OU** use o Neon que você já tem

### 4. Configurar Variáveis de Ambiente

No Railway, vá em **Variables** e adicione:

#### Se usar PostgreSQL do Railway:
```
DB_CONNECTION=pgsql
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_DATABASE=${{Postgres.PGDATABASE}}
DB_USERNAME=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}
```

#### Se usar Neon (externo):
```
DB_CONNECTION=pgsql
DB_HOST=ep-fancy-hill-ac1fxrdp-pooler.sa-east-1.aws.neon.tech
DB_PORT=5432
DB_DATABASE=neondb
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_39PfFdObjnSC
DB_SSLMODE=require
```

#### Aplicação:
```
APP_NAME=MagicAI
APP_ENV=production
APP_DEBUG=false
APP_URL=${{RAILWAY_PUBLIC_DOMAIN}}
```

### 5. Gerar APP_KEY

Após o primeiro deploy, no **Deploy Logs**, execute:

```bash
php artisan key:generate
```

Ou via **Railway CLI**:
```bash
railway run php artisan key:generate
```

### 6. Executar Migrations

Após configurar o banco:

```bash
railway run php artisan migrate --force
railway run php artisan storage:link
```

## Vantagens do Railway:

- ✅ Suporte nativo PHP/Laravel
- ✅ Deploy automático do GitHub
- ✅ PostgreSQL incluído (ou use externo)
- ✅ SSL automático
- ✅ Sem "sleep" no plano pago
- ✅ Muito mais simples que Render

## Comparação:

| Recurso | Railway | Render |
|---------|---------|--------|
| PHP Nativo | ✅ Sim | ❌ Não (precisa Docker) |
| Deploy Automático | ✅ Sim | ✅ Sim |
| PostgreSQL | ✅ Incluído | ✅ Disponível |
| Facilidade | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

## Próximos Passos:

1. Crie conta no Railway
2. Conecte o repositório
3. Configure variáveis de ambiente
4. Deploy automático! 🚀

