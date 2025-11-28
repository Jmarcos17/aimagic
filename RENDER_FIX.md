# 🔧 Como Corrigir o Deploy no Render

## ⚠️ Problema Atual

O Render está tentando executar `npm start` porque o serviço está configurado como **Node.js**, mas Laravel precisa de **PHP**.

## ✅ Solução: Reconfigurar o Serviço

### Opção 1: Deletar e Recriar (Recomendado)

1. **No Dashboard do Render:**
   - Vá para o seu serviço
   - Clique em **Settings** (Configurações)
   - Role até o final e clique em **Delete Service**
   - Confirme a exclusão

2. **Criar Novo Serviço:**
   - Clique em **New** > **Web Service**
   - Conecte o repositório: `Jmarcos17/aimagic`
   - O Render deve detectar o `render.yaml` automaticamente
   - Se não detectar, configure manualmente (veja Opção 2)

### Opção 2: Editar Serviço Existente

1. **No Dashboard do Render:**
   - Vá para o seu serviço
   - Clique em **Settings**

2. **Alterar Runtime:**
   - Encontre a seção **Environment**
   - Procure por **Runtime** ou **Environment Type**
   - **MUDE de "Node" para "PHP"**
   - Salve as alterações

3. **Configurar Build Command:**
   ```
   composer install --no-dev --optimize-autoloader && npm install && npm run build && php artisan config:cache && php artisan route:cache && php artisan view:cache
   ```

4. **Configurar Start Command:**
   ```
   php artisan serve --host=0.0.0.0 --port=$PORT
   ```

5. **Root Directory:** (deixe vazio)

## 📋 Variáveis de Ambiente Obrigatórias

Adicione todas estas variáveis no dashboard do Render:

### Banco de Dados (Neon):
```
DB_CONNECTION=pgsql
DB_HOST=ep-fancy-hill-ac1fxrdp-pooler.sa-east-1.aws.neon.tech
DB_PORT=5432
DB_DATABASE=neondb
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_39PfFdObjnSC
DB_SSLMODE=require
```

### Aplicação:
```
APP_NAME=MagicAI
APP_ENV=production
APP_KEY=                    # Gere com: php artisan key:generate
APP_DEBUG=false
APP_URL=https://seu-app.onrender.com
```

### Outras Importantes:
```
QUEUE_CONNECTION=database
LOG_CHANNEL=stderr
```

## 🔑 Gerar APP_KEY

Você precisa gerar a chave da aplicação. Opções:

### Opção A: Via Console do Render (Após Deploy)
1. No dashboard, vá para **Shell** ou **Console**
2. Execute:
   ```bash
   php artisan key:generate --show
   ```
3. Copie a chave gerada
4. Adicione como variável de ambiente `APP_KEY` no dashboard
5. Faça redeploy

### Opção B: Gerar Localmente
1. No seu computador:
   ```bash
   cd Magicai-Server-Files
   php artisan key:generate --show
   ```
2. Copie a chave
3. Adicione como variável de ambiente no Render

## ✅ Checklist Final

- [ ] Runtime configurado como **PHP** (não Node.js)
- [ ] Build Command configurado corretamente
- [ ] Start Command: `php artisan serve --host=0.0.0.0 --port=$PORT`
- [ ] Todas as variáveis de ambiente adicionadas
- [ ] APP_KEY gerado e configurado
- [ ] Banco de dados (Neon) configurado

## 🚀 Após o Deploy Bem-Sucedido

Execute via Console do Render:

```bash
php artisan migrate --force
php artisan storage:link
```

## 📞 Se Ainda Não Funcionar

1. Verifique os logs no dashboard do Render
2. Certifique-se de que o Runtime está como **PHP**
3. Verifique se todas as variáveis de ambiente estão corretas
4. O `render.yaml` está no repositório e deve ser detectado automaticamente

