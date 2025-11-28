# 🐳 Deploy com Docker + Portainer

## ✅ Por que Docker + Portainer é Excelente

- ✅ **Isolamento**: Cada aplicação em seu próprio container
- ✅ **Portabilidade**: Funciona em qualquer servidor com Docker
- ✅ **Fácil gerenciamento**: Interface web do Portainer
- ✅ **Escalabilidade**: Fácil adicionar mais containers
- ✅ **Backup simples**: Volumes Docker
- ✅ **Rollback fácil**: Reverter para versão anterior
- ✅ **Zero conflitos**: Não interfere com outros serviços

## 📋 Pré-requisitos

- ✅ VPS com Docker instalado
- ✅ Portainer instalado e funcionando
- ✅ Acesso SSH à VPS
- ✅ Acesso ao Portainer (geralmente `http://SEU_IP:9000`)

## 🚀 Passo a Passo Completo

### 1. Preparar o Projeto Localmente

#### Opção A: Via Git (Recomendado)

```bash
# No seu computador
cd /caminho/do/projeto
git add .
git commit -m "Prepare for Docker deployment"
git push origin main
```

#### Opção B: Criar arquivo .env.example

Crie um arquivo `.env.example` com todas as variáveis necessárias:

```env
APP_NAME=MagicAI
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=http://localhost:8080

# Banco de Dados (Neon PostgreSQL)
DB_CONNECTION=pgsql
DB_HOST=ep-fancy-hill-ac1fxrdp-pooler.sa-east-1.aws.neon.tech
DB_PORT=5432
DB_DATABASE=neondb
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_39PfFdObjnSC
DB_SSLMODE=require

# Cache e Sessões
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=database

# Mail
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@example.com
MAIL_FROM_NAME="MagicAI"
```

### 2. Fazer Upload do Projeto para a VPS

#### Opção A: Via Git (Recomendado)

```bash
# Conectar na VPS via SSH
ssh usuario@SEU_IP

# Criar diretório para o projeto
mkdir -p ~/projects/magicai
cd ~/projects/magicai

# Clonar o repositório
git clone https://github.com/Jmarcos17/aimagic.git .
```

#### Opção B: Via SFTP

1. Use FileZilla ou similar
2. Conecte na VPS
3. Navegue até `~/projects/` (ou onde preferir)
4. Faça upload de todos os arquivos do projeto

### 3. Configurar Arquivo .env na VPS

```bash
# Na VPS, navegar até o projeto
cd ~/projects/magicai

# Copiar .env.example para .env
cp .env.example .env

# Editar .env
nano .env
```

Configure todas as variáveis, especialmente:
- `APP_KEY` (será gerado depois)
- `APP_URL` (URL do seu domínio ou IP)
- Credenciais do banco de dados
- Configurações de email

### 4. Deploy via Portainer

#### Método 1: Stack no Portainer (Recomendado)

1. **Acesse o Portainer**
   - URL: `http://SEU_IP:9000` ou `https://SEU_IP:9443`
   - Faça login

2. **Criar Stack**
   - No menu lateral, clique em **Stacks**
   - Clique em **Add stack**
   - Nome: `magicai`

3. **Configurar Stack**
   - **Build method**: Selecione **Repository**
   - **Repository URL**: `https://github.com/Jmarcos17/aimagic.git`
   - **Repository reference**: `main` (ou sua branch)
   - **Compose path**: `docker-compose.yml`
   
   **OU** se já fez upload dos arquivos:
   - **Build method**: Selecione **Web editor**
   - Cole o conteúdo do `docker-compose.yml`

4. **Variáveis de Ambiente**
   - Role até **Environment variables**
   - Adicione todas as variáveis do `.env`:
   
   ```
   APP_KEY=base64:...
   APP_URL=https://seu-dominio.com
   DB_HOST=ep-fancy-hill-ac1fxrdp-pooler.sa-east-1.aws.neon.tech
   DB_PORT=5432
   DB_DATABASE=neondb
   DB_USERNAME=neondb_owner
   DB_PASSWORD=npg_39PfFdObjnSC
   DB_SSLMODE=require
   MAIL_HOST=smtp.mailtrap.io
   MAIL_PORT=2525
   MAIL_USERNAME=seu-usuario
   MAIL_PASSWORD=sua-senha
   ```

5. **Deploy**
   - Clique em **Deploy the stack**
   - Aguarde o build e deploy

#### Método 2: Container Individual

1. **Acesse o Portainer**
2. **Containers** > **Add container**
3. **Configurações**:
   - **Name**: `magicai-app`
   - **Image**: (será buildado do Dockerfile)
   - **Ports**: `8080:80`
   - **Volumes**: 
     - `/caminho/para/projeto/storage:/var/www/html/storage`
     - `/caminho/para/projeto/bootstrap/cache:/var/www/html/bootstrap/cache`
   - **Environment**: Adicione todas as variáveis
4. **Deploy**

### 5. Gerar APP_KEY

Após o container estar rodando:

```bash
# Entrar no container
docker exec -it magicai-app bash

# Gerar chave
php artisan key:generate --show

# Copiar a chave gerada
# Sair do container
exit
```

Depois, atualize no Portainer:
1. **Containers** > **magicai-app** > **Duplicate/Edit**
2. Adicione `APP_KEY` nas variáveis de ambiente
3. **Recreate** o container

### 6. Executar Migrations

```bash
# Entrar no container
docker exec -it magicai-app bash

# Executar migrations
php artisan migrate --force

# Criar link do storage
php artisan storage:link

# Otimizar
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Sair
exit
```

### 7. Verificar Logs

No Portainer:
1. **Containers** > **magicai-app**
2. Clique em **Logs**
3. Verifique se há erros

Ou via terminal:
```bash
docker logs magicai-app
docker logs magicai-app -f  # Seguir logs em tempo real
```

### 8. Configurar Nginx Reverse Proxy (Opcional)

Se quiser usar domínio próprio ao invés de porta:

```bash
# Instalar Nginx (se não tiver)
sudo apt update
sudo apt install nginx -y

# Criar configuração
sudo nano /etc/nginx/sites-available/magicai
```

Adicione:

```nginx
server {
    listen 80;
    server_name seu-dominio.com www.seu-dominio.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Ativar:
```bash
sudo ln -s /etc/nginx/sites-available/magicai /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 9. Configurar SSL (Let's Encrypt)

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obter certificado
sudo certbot --nginx -d seu-dominio.com -d www.seu-dominio.com

# Renovação automática (já configurado)
sudo certbot renew --dry-run
```

### 10. Configurar Queue Worker (Opcional)

O `docker-compose.yml` já inclui um serviço de queue. Para ativar:

1. No Portainer, edite a stack `magicai`
2. Certifique-se de que o serviço `queue` está habilitado
3. Deploy novamente

Ou crie manualmente:
```bash
docker exec -it magicai-queue php artisan queue:work database --daemon
```

## 🔧 Comandos Úteis

### Gerenciar Containers

```bash
# Ver containers rodando
docker ps

# Ver todos os containers
docker ps -a

# Parar container
docker stop magicai-app

# Iniciar container
docker start magicai-app

# Reiniciar container
docker restart magicai-app

# Remover container
docker rm magicai-app

# Ver logs
docker logs magicai-app
docker logs magicai-app -f  # Seguir logs
```

### Executar Comandos no Container

```bash
# Entrar no container
docker exec -it magicai-app bash

# Executar comando específico
docker exec -it magicai-app php artisan migrate
docker exec -it magicai-app php artisan cache:clear
docker exec -it magicai-app composer install
```

### Gerenciar Volumes

```bash
# Ver volumes
docker volume ls

# Inspecionar volume
docker volume inspect magicai_redis-data

# Remover volume (cuidado!)
docker volume rm magicai_redis-data
```

### Rebuild da Imagem

```bash
# Parar containers
docker-compose down

# Rebuild sem cache
docker-compose build --no-cache

# Subir novamente
docker-compose up -d
```

## 📊 Monitoramento

### No Portainer

1. **Dashboard**: Veja uso de recursos
2. **Containers**: Status de cada container
3. **Logs**: Logs em tempo real
4. **Stats**: CPU, RAM, Network

### Via Terminal

```bash
# Estatísticas dos containers
docker stats

# Uso de disco
docker system df

# Limpar recursos não usados
docker system prune -a
```

## 🔄 Atualizações

### Atualizar Código

```bash
# Via Git
cd ~/projects/magicai
git pull origin main

# Rebuild e restart
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Executar migrations se houver
docker exec -it magicai-app php artisan migrate --force
```

### Via Portainer

1. **Stacks** > **magicai** > **Editor**
2. Faça alterações no `docker-compose.yml`
3. **Update the stack**
4. Portainer fará rebuild automático

## 💾 Backup

### Backup do Storage

```bash
# Criar backup
tar -czf backup-storage-$(date +%Y%m%d).tar.gz ~/projects/magicai/storage

# Restaurar
tar -xzf backup-storage-20241128.tar.gz -C ~/projects/magicai/
```

### Backup do Banco de Dados

```bash
# Se usar PostgreSQL local (não é o caso, mas exemplo)
docker exec -it postgres-container pg_dump -U usuario -d magicai > backup.sql

# Restaurar
docker exec -i postgres-container psql -U usuario -d magicai < backup.sql
```

### Backup via Portainer

1. **Volumes** > Selecione o volume
2. **Backup** > Download

## 🔒 Segurança

### 1. Firewall

```bash
# Permitir apenas portas necessárias
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw allow 9000/tcp  # Portainer (ou use VPN)
sudo ufw enable
```

### 2. Portainer com Autenticação

- Use senha forte
- Habilite 2FA se disponível
- Considere usar VPN ao invés de expor porta 9000

### 3. Container Security

- Sempre use imagens oficiais
- Mantenha imagens atualizadas
- Não exponha portas desnecessárias
- Use secrets para senhas (Portainer tem suporte)

## 🆘 Troubleshooting

### Container não inicia

```bash
# Ver logs
docker logs magicai-app

# Verificar se porta está em uso
sudo netstat -tulpn | grep 8080

# Verificar recursos
docker stats
```

### Erro 500

```bash
# Ver logs do Laravel
docker exec -it magicai-app tail -f storage/logs/laravel.log

# Limpar caches
docker exec -it magicai-app php artisan cache:clear
docker exec -it magicai-app php artisan config:clear
docker exec -it magicai-app php artisan view:clear
```

### Banco de dados não conecta

```bash
# Testar conexão
docker exec -it magicai-app php artisan tinker
# No tinker: DB::connection()->getPdo();

# Verificar variáveis de ambiente
docker exec -it magicai-app env | grep DB_
```

### Assets não carregam

```bash
# Rebuild assets
docker exec -it magicai-app npm run build

# Verificar permissões
docker exec -it magicai-app ls -la public/build
```

## 📋 Checklist Final

- [ ] Projeto enviado para VPS
- [ ] Arquivo `.env` configurado
- [ ] Stack criada no Portainer
- [ ] Containers rodando
- [ ] APP_KEY gerado e configurado
- [ ] Migrations executadas
- [ ] Storage link criado
- [ ] Caches otimizados
- [ ] Nginx configurado (se usar domínio)
- [ ] SSL configurado (se usar domínio)
- [ ] Queue worker rodando (se necessário)
- [ ] Backup configurado
- [ ] Firewall configurado
- [ ] Testado e funcionando

## 🎯 Vantagens vs Outras Opções

| Recurso | Docker + Portainer | VPS Direto | Render/Railway |
|---------|-------------------|------------|----------------|
| Isolamento | ✅ | ❌ | ✅ |
| Portabilidade | ✅ | ❌ | ✅ |
| Interface Web | ✅ | ❌ | ✅ |
| Controle Total | ✅ | ✅ | ❌ |
| Fácil Rollback | ✅ | ⚠️ | ✅ |
| Custo | VPS | VPS | $7-25/mês |

## 📚 Recursos

- [Portainer Documentation](https://docs.portainer.io/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Laravel Docker Guide](https://laravel.com/docs/deployment)

## 🎉 Conclusão

Docker + Portainer é uma excelente escolha para deploy de Laravel porque:
- ✅ Fácil gerenciamento via interface web
- ✅ Isolamento completo
- ✅ Fácil backup e restore
- ✅ Escalável
- ✅ Portátil

Boa sorte com o deploy! 🚀

