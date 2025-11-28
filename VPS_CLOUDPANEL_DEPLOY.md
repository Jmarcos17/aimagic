# 🖥️ Deploy em VPS com CloudPanel

## ✅ Por que VPS + CloudPanel é Ideal para Laravel

- ✅ **Controle total**: Você tem acesso root ao servidor
- ✅ **PHP nativo**: Suporte completo para Laravel
- ✅ **Composer**: Instalação e execução normais
- ✅ **Cron Jobs**: Funcionam perfeitamente
- ✅ **Queues**: Processos em background funcionam
- ✅ **Storage local**: Funciona normalmente
- ✅ **WebSockets**: Suportados
- ✅ **SSL gratuito**: Let's Encrypt integrado
- ✅ **Gerenciamento fácil**: Interface web moderna
- ✅ **Múltiplos sites**: Gerencie vários projetos

## 📋 Requisitos da VPS

### Especificações Mínimas Recomendadas:

- **CPU**: 2 cores
- **RAM**: 4GB (8GB recomendado)
- **Disco**: 40GB SSD
- **Sistema Operacional**: Ubuntu 22.04 LTS ou Debian 11/12
- **Rede**: IP público estático

### Provedores Recomendados:

1. **DigitalOcean** ($24/mês - 4GB RAM)
   - Link: https://www.digitalocean.com
   - Drops: $4/mês (1GB - mínimo)

2. **Linode/Akamai** ($24/mês - 4GB RAM)
   - Link: https://www.linode.com
   - Nanode: $5/mês (1GB - mínimo)

3. **Vultr** ($24/mês - 4GB RAM)
   - Link: https://www.vultr.com
   - Regular: $6/mês (1GB - mínimo)

4. **Hetzner** (€4.15/mês - 4GB RAM)
   - Link: https://www.hetzner.com
   - Melhor custo-benefício na Europa

5. **Contabo** (€4.99/mês - 8GB RAM)
   - Link: https://www.contabo.com
   - Excelente custo-benefício

## 🚀 Passo a Passo Completo

### 1. Criar e Configurar a VPS

1. **Criar VPS** no provedor escolhido
2. **Escolher Ubuntu 22.04 LTS** ou Debian 11/12
3. **Anotar o IP** da VPS
4. **Configurar SSH Key** (recomendado) ou usar senha

### 2. Conectar via SSH

```bash
ssh root@SEU_IP
# ou
ssh root@SEU_IP -p PORTA
```

### 3. Instalar CloudPanel

Execute o comando de instalação:

```bash
# Para Ubuntu 22.04
bash <(curl -s https://installer.cloudpanel.io/ce/ubuntu/install.sh)

# Para Debian 11/12
bash <(curl -s https://installer.cloudpanel.io/ce/debian/install.sh)
```

O instalador irá:
- ✅ Instalar Nginx
- ✅ Instalar PHP 8.1, 8.2, 8.3
- ✅ Instalar MySQL/MariaDB
- ✅ Instalar Redis
- ✅ Instalar Node.js
- ✅ Configurar firewall
- ✅ Criar usuário admin

### 4. Acessar CloudPanel

Após a instalação, você verá:
- **URL**: `https://SEU_IP:8443`
- **Usuário**: `admin`
- **Senha**: (será exibida no terminal)

⚠️ **Importante**: A primeira vez, aceite o certificado SSL auto-assinado.

### 5. Configurar Site no CloudPanel

1. **Login** no CloudPanel
2. Clique em **Sites** > **+ Add Site**
3. Preencha:
   - **Domain**: `seu-dominio.com` (ou IP temporário)
   - **PHP Version**: `8.2`
   - **Document Root**: `/home/cloudpanel/htdocs/seu-dominio.com`
   - **User**: `cloudpanel` (padrão)

### 6. Fazer Upload do Projeto

#### Opção A: Via Git (Recomendado)

```bash
# Conectar via SSH como usuário cloudpanel
ssh cloudpanel@SEU_IP

# Navegar para o diretório do site
cd /home/cloudpanel/htdocs/seu-dominio.com

# Clonar o repositório
git clone https://github.com/Jmarcos17/aimagic.git .

# Ou se já tem o projeto local, fazer push e pull
```

#### Opção B: Via SFTP/FTP

1. Use FileZilla ou similar
2. Conecte com:
   - **Host**: `SEU_IP`
   - **Usuário**: `cloudpanel`
   - **Senha**: (definida na instalação)
   - **Porta**: `22` (SSH)
3. Navegue até: `/home/cloudpanel/htdocs/seu-dominio.com`
4. Faça upload dos arquivos

#### Opção C: Via CloudPanel File Manager

1. No CloudPanel, vá em **Sites** > **seu-dominio.com**
2. Clique em **File Manager**
3. Faça upload dos arquivos

### 7. Configurar Laravel

```bash
# Conectar via SSH
ssh cloudpanel@SEU_IP
cd /home/cloudpanel/htdocs/seu-dominio.com

# Instalar dependências PHP
composer install --no-dev --optimize-autoloader

# Instalar dependências Node.js
npm install

# Compilar assets
npm run build

# Copiar arquivo .env
cp .env.example .env

# Gerar chave da aplicação
php artisan key:generate
```

### 8. Configurar Arquivo .env

Edite o `.env`:

```bash
nano .env
```

Configure:

```env
APP_NAME=MagicAI
APP_ENV=production
APP_KEY=                    # Já gerado acima
APP_DEBUG=false
APP_URL=https://seu-dominio.com

# Banco de Dados (Neon PostgreSQL)
DB_CONNECTION=pgsql
DB_HOST=ep-fancy-hill-ac1fxrdp-pooler.sa-east-1.aws.neon.tech
DB_PORT=5432
DB_DATABASE=neondb
DB_USERNAME=neondb_owner
DB_PASSWORD=npg_39PfFdObjnSC
DB_SSLMODE=require

# Ou usar MySQL local do CloudPanel
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=magicai
# DB_USERNAME=cloudpanel
# DB_PASSWORD=senha_do_banco

# Cache
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

# Redis (já instalado pelo CloudPanel)
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# Mail (configure conforme seu provedor)
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=noreply@seu-dominio.com
MAIL_FROM_NAME="${APP_NAME}"
```

### 9. Configurar Permissões

```bash
# Dar permissões corretas
sudo chown -R cloudpanel:cloudpanel /home/cloudpanel/htdocs/seu-dominio.com
chmod -R 755 /home/cloudpanel/htdocs/seu-dominio.com
chmod -R 775 /home/cloudpanel/htdocs/seu-dominio.com/storage
chmod -R 775 /home/cloudpanel/htdocs/seu-dominio.com/bootstrap/cache
```

### 10. Executar Migrations

```bash
php artisan migrate --force
```

### 11. Criar Link Simbólico do Storage

```bash
php artisan storage:link
```

### 12. Configurar Nginx no CloudPanel

O CloudPanel já configura o Nginx automaticamente, mas você pode ajustar:

1. No CloudPanel: **Sites** > **seu-dominio.com** > **Nginx Config**
2. Adicione/ajuste se necessário:

```nginx
location / {
    try_files $uri $uri/ /index.php?$query_string;
}

location ~ \.php$ {
    fastcgi_pass unix:/var/run/php/php8.2-fpm-cloudpanel.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
    include fastcgi_params;
}
```

### 13. Configurar SSL (Let's Encrypt)

1. No CloudPanel: **Sites** > **seu-dominio.com** > **SSL**
2. Clique em **Let's Encrypt**
3. Preencha:
   - **Domain**: `seu-dominio.com`
   - **Email**: `seu-email@exemplo.com`
4. Clique em **Install**
5. ✅ SSL será instalado automaticamente

⚠️ **Importante**: O domínio deve apontar para o IP da VPS antes de instalar SSL.

### 14. Configurar Domínio

No seu provedor de domínio (Registro.br, GoDaddy, etc.):

1. Configure DNS:
   - **Tipo**: A
   - **Nome**: `@` (ou deixe em branco)
   - **Valor**: `IP_DA_VPS`
   - **TTL**: 3600

2. Para subdomínio `www`:
   - **Tipo**: A
   - **Nome**: `www`
   - **Valor**: `IP_DA_VPS`
   - **TTL**: 3600

### 15. Configurar Cron Jobs

No CloudPanel: **Sites** > **seu-dominio.com** > **Cron Jobs**

Adicione:

```bash
* * * * * cd /home/cloudpanel/htdocs/seu-dominio.com && php artisan schedule:run >> /dev/null 2>&1
```

### 16. Configurar Queue Worker (Opcional)

Para processar jobs em background:

```bash
# Criar systemd service
sudo nano /etc/systemd/system/magicai-queue.service
```

Adicione:

```ini
[Unit]
Description=MagicAI Queue Worker
After=network.target

[Service]
User=cloudpanel
Group=cloudpanel
Restart=always
ExecStart=/usr/bin/php /home/cloudpanel/htdocs/seu-dominio.com/artisan queue:work redis --sleep=3 --tries=3 --max-time=3600

[Install]
WantedBy=multi-user.target
```

Ative o serviço:

```bash
sudo systemctl daemon-reload
sudo systemctl enable magicai-queue
sudo systemctl start magicai-queue
sudo systemctl status magicai-queue
```

### 17. Otimizações

```bash
# Cache de configuração
php artisan config:cache

# Cache de rotas
php artisan route:cache

# Cache de views
php artisan view:cache

# Otimizar autoloader
composer install --optimize-autoloader --no-dev
```

### 18. Configurar Firewall

O CloudPanel já configura o firewall, mas verifique:

```bash
# Verificar regras
sudo ufw status

# Se necessário, abrir portas
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
```

## 🔧 Comandos Úteis

### Ver logs do Laravel
```bash
tail -f storage/logs/laravel.log
```

### Ver logs do Nginx
```bash
sudo tail -f /var/log/nginx/error.log
```

### Reiniciar PHP-FPM
```bash
sudo systemctl restart php8.2-fpm-cloudpanel
```

### Reiniciar Nginx
```bash
sudo systemctl restart nginx
```

### Ver status dos serviços
```bash
sudo systemctl status nginx
sudo systemctl status php8.2-fpm-cloudpanel
sudo systemctl status redis
sudo systemctl status mysql
```

### Limpar caches
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

## 📊 Monitoramento

### CloudPanel Dashboard

O CloudPanel fornece:
- ✅ Uso de CPU/RAM
- ✅ Uso de disco
- ✅ Logs do sistema
- ✅ Estatísticas de sites

### Adicionar Monitoramento Avançado (Opcional)

1. **New Relic**: Monitoramento de aplicação
2. **Sentry**: Rastreamento de erros
3. **Uptime Robot**: Monitoramento de uptime

## 🔒 Segurança

### 1. Atualizar Sistema Regularmente

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Configurar Fail2Ban (Opcional)

```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 3. Desabilitar Login Root (Recomendado)

```bash
# Criar novo usuário
sudo adduser novo-usuario
sudo usermod -aG sudo novo-usuario

# Desabilitar login root
sudo nano /etc/ssh/sshd_config
# Alterar: PermitRootLogin no

sudo systemctl restart sshd
```

## 💰 Custos Estimados

- **VPS**: $6-24/mês (dependendo do provedor)
- **Domínio**: $10-15/ano
- **SSL**: Gratuito (Let's Encrypt)
- **Total**: ~$6-25/mês

## ✅ Checklist Final

- [ ] VPS criada e configurada
- [ ] CloudPanel instalado
- [ ] Site criado no CloudPanel
- [ ] Projeto enviado para servidor
- [ ] Dependências instaladas (Composer + NPM)
- [ ] Arquivo .env configurado
- [ ] Permissões configuradas
- [ ] Migrations executadas
- [ ] Storage link criado
- [ ] SSL configurado
- [ ] Domínio apontando para VPS
- [ ] Cron jobs configurados
- [ ] Queue worker configurado (se necessário)
- [ ] Otimizações aplicadas
- [ ] Testado e funcionando

## 🆘 Troubleshooting

### Erro 500
- Verificar logs: `tail -f storage/logs/laravel.log`
- Verificar permissões: `chmod -R 775 storage bootstrap/cache`
- Verificar .env: `php artisan config:clear`

### Assets não carregam
- Verificar se `npm run build` foi executado
- Verificar permissões da pasta `public/build`
- Limpar cache: `php artisan view:clear`

### Banco de dados não conecta
- Verificar credenciais no .env
- Verificar se banco está acessível
- Testar conexão: `php artisan tinker` > `DB::connection()->getPdo();`

### SSL não funciona
- Verificar se domínio aponta para IP
- Aguardar propagação DNS (pode levar até 48h)
- Verificar logs: `sudo tail -f /var/log/nginx/error.log`

## 📚 Recursos

- [CloudPanel Documentation](https://www.cloudpanel.io/docs/)
- [Laravel Deployment](https://laravel.com/docs/deployment)
- [DigitalOcean Laravel Guide](https://www.digitalocean.com/community/tutorials/how-to-install-laravel-on-ubuntu-22-04)

## 🎯 Vantagens vs Outras Opções

| Recurso | VPS + CloudPanel | Render | Railway | Vercel |
|---------|------------------|--------|---------|--------|
| Controle Total | ✅ | ❌ | ❌ | ❌ |
| PHP Nativo | ✅ | ✅ | ✅ | ⚠️ |
| Storage Local | ✅ | ✅ | ✅ | ❌ |
| Queues | ✅ | ✅ | ✅ | ❌ |
| Cron Jobs | ✅ | ✅ | ✅ | ⚠️ |
| WebSockets | ✅ | ✅ | ✅ | ❌ |
| Custo | $6-24/mês | $7-25/mês | $5-20/mês | $0-20/mês |
| Complexidade | Média | Baixa | Baixa | Alta |

**Conclusão**: VPS + CloudPanel é a melhor opção se você quer controle total e não se importa em gerenciar o servidor.

