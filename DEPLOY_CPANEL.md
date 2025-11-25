# 🚀 Guia de Deploy para cPanel

Este guia detalha o processo completo de deploy do 6amMart em um servidor cPanel.

## 📋 Pré-requisitos no Servidor

- **PHP:** >= 8.2 com extensões: OpenSSL, PDO, Mbstring, Tokenizer, XML, Ctype, JSON, BCMath, Fileinfo, GD
- **MySQL:** >= 5.7 ou MariaDB >= 10.2
- **Composer:** Instalado no servidor (ou compile localmente)
- **Memória PHP:** Mínimo 256MB recomendado
- **Acesso SSH:** Recomendado (mas não obrigatório)

## 🔧 Preparação Local (Antes do Upload)

### 1. Compile os Assets

```bash
cd "Admin panel new install V3.2"
npm run production
```

### 2. Otimize o Autoloader

```bash
composer install --optimize-autoloader --no-dev
```

### 3. Limpe Arquivos Desnecessários

Remova estas pastas antes de compactar:
- `node_modules/`
- `.git/`
- `tests/`
- `storage/logs/*.log`
- `.env` (será criado no servidor)

### 4. Compacte o Projeto

```bash
# No Windows PowerShell
Compress-Archive -Path "Admin panel new install V3.2\*" -DestinationPath "6ammart-backend.zip"
```

## 📤 Upload para cPanel

### Passo 1: Fazer Upload do Arquivo

1. Acesse o cPanel
2. Abra **Gerenciador de Arquivos**
3. Navegue até `public_html` (ou pasta do seu domínio)
4. Clique em **Upload**
5. Faça upload do `6ammart-backend.zip`
6. Após o upload, clique com botão direito e selecione **Extract**

### Passo 2: Configurar Document Root

**Opção A: Via cPanel (Recomendado)**

1. No cPanel, vá em **Domínios** ou **Addon Domains**
2. Edite o domínio principal ou crie um subdomínio
3. Configure o **Document Root** para: `public_html/Admin panel new install V3.2/public`
4. Salve as alterações

**Opção B: Mover Arquivos (Alternativa)**

Se não puder alterar o document root:

```bash
# Via Terminal SSH
cd public_html
mv "Admin panel new install V3.2/public"/* .
mv "Admin panel new install V3.2/public/.htaccess" .
mv "Admin panel new install V3.2" ../backend
```

Depois edite o `index.php` para corrigir os caminhos:

```php
require __DIR__.'/../backend/vendor/autoload.php';
$app = require_once __DIR__.'/../backend/bootstrap/app.php';
```

## 🗄️ Configuração do Banco de Dados

### 1. Criar Banco de Dados via cPanel

1. No cPanel, vá em **MySQL Databases**
2. Crie um novo banco de dados: `seunome_6ammart`
3. Crie um novo usuário: `seunome_admin`
4. Defina uma senha forte
5. Adicione o usuário ao banco com **TODAS AS PERMISSÕES**
6. Anote: nome do banco, usuário e senha

### 2. Configurar o Arquivo .env

No Gerenciador de Arquivos, navegue até a pasta raiz do Laravel e:

1. Copie `.env.example` para `.env`
2. Edite o arquivo `.env`:

```env
APP_NAME=6amMart
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://seudominio.com

LOG_CHANNEL=stack
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=seunome_6ammart
DB_USERNAME=seunome_admin
DB_PASSWORD=sua_senha_forte

BROADCAST_DRIVER=log
CACHE_DRIVER=file
QUEUE_CONNECTION=database
SESSION_DRIVER=file
SESSION_LIFETIME=120

# Configure seu email SMTP
MAIL_MAILER=smtp
MAIL_HOST=mail.seudominio.com
MAIL_PORT=587
MAIL_USERNAME=contato@seudominio.com
MAIL_PASSWORD=sua_senha_email
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=contato@seudominio.com
MAIL_FROM_NAME="${APP_NAME}"
```

## 🔑 Configuração via SSH (Recomendado)

Se você tem acesso SSH:

### 1. Conecte via SSH

```bash
ssh usuario@seuservidor.com
cd public_html/Admin panel new install V3.2
```

### 2. Gerar Application Key

```bash
php artisan key:generate
```

### 3. Executar Migrations

```bash
php artisan migrate --force
```

### 4. Executar Seeders (se disponível)

```bash
php artisan db:seed --force
```

### 5. Criar Link Simbólico para Storage

```bash
php artisan storage:link
```

### 6. Configurar Permissões

```bash
chmod -R 755 storage
chmod -R 755 bootstrap/cache
```

### 7. Otimizar para Production

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## 🚫 Configuração SEM SSH (Alternativa)

Se NÃO tem acesso SSH:

### 1. Gerar APP_KEY Localmente

No seu computador:

```bash
php artisan key:generate --show
```

Copie a chave gerada e cole no `.env` do servidor.

### 2. Criar Rota Temporária para Migration

Crie um arquivo temporário: `public/install.php`

```php
<?php
require __DIR__.'/../vendor/autoload.php';
$app = require_once __DIR__.'/../bootstrap/app.php';

use Illuminate\Support\Facades\Artisan;

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// Execute migrations
Artisan::call('migrate', ['--force' => true]);
echo "Migrations executadas!<br>";

// Execute seeders
Artisan::call('db:seed', ['--force' => true]);
echo "Seeders executados!<br>";

// Create storage link
Artisan::call('storage:link');
echo "Storage link criado!<br>";

// Cache
Artisan::call('config:cache');
Artisan::call('route:cache');
Artisan::call('view:cache');
echo "Cache otimizado!<br>";

echo "<br><strong>Instalação concluída! REMOVA ESTE ARQUIVO AGORA!</strong>";
```

Acesse: `https://seudominio.com/install.php`

**⚠️ IMPORTANTE:** Delete o arquivo `install.php` imediatamente após a execução!

### 3. Configurar Permissões via Gerenciador de Arquivos

1. Selecione a pasta `storage`
2. Clique em **Change Permissions**
3. Configure para `755`
4. Marque **Recurse into subdirectories**
5. Aplique
6. Repita para `bootstrap/cache`

## 📁 Estrutura de Pastas no Servidor

```
public_html/
├── Admin panel new install V3.2/
│   ├── app/
│   ├── bootstrap/
│   ├── config/
│   ├── database/
│   ├── public/          ← Este deve ser o Document Root
│   ├── resources/
│   ├── routes/
│   ├── storage/
│   ├── vendor/
│   ├── .env
│   └── artisan
```

## 🔒 Configurações de Segurança

### 1. Proteger Arquivo .env

Adicione no `.htaccess` (raiz do Laravel):

```apache
<Files .env>
    Order allow,deny
    Deny from all
</Files>
```

### 2. Desabilitar Listagem de Diretórios

No `public/.htaccess`:

```apache
Options -Indexes
```

### 3. Configurar Headers de Segurança

Adicione no `public/.htaccess`:

```apache
# Security Headers
<IfModule mod_headers.c>
    Header set X-Content-Type-Options "nosniff"
    Header set X-Frame-Options "SAMEORIGIN"
    Header set X-XSS-Protection "1; mode=block"
</IfModule>
```

## 📧 Configuração de Email

### Gmail (SMTP)

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=seuemail@gmail.com
MAIL_PASSWORD=sua_senha_de_app
MAIL_ENCRYPTION=tls
```

**Nota:** Você precisa gerar uma "Senha de App" no Google.

### cPanel Email

```env
MAIL_MAILER=smtp
MAIL_HOST=mail.seudominio.com
MAIL_PORT=587
MAIL_USERNAME=contato@seudominio.com
MAIL_PASSWORD=senha_do_email
MAIL_ENCRYPTION=tls
```

## 🔄 Configurar Cron Jobs (Agendador Laravel)

No cPanel, vá em **Cron Jobs** e adicione:

```bash
* * * * * cd /home/usuario/public_html/Admin\ panel\ new\ install\ V3.2 && php artisan schedule:run >> /dev/null 2>&1
```

Ou se o caminho tiver espaços, use:

```bash
* * * * * cd "/home/usuario/public_html/Admin panel new install V3.2" && php artisan schedule:run >> /dev/null 2>&1
```

## 🐛 Troubleshooting

### Erro 500 - Internal Server Error

1. **Verifique logs:**
   - `storage/logs/laravel.log`
   - cPanel > Errors (logs do Apache)

2. **Causas comuns:**
   - Permissões incorretas (storage/bootstrap)
   - `.env` mal configurado
   - APP_KEY não gerada
   - mod_rewrite não habilitado

### Erro de Banco de Dados

1. Verifique credenciais no `.env`
2. Teste conexão via phpMyAdmin
3. Verifique se o usuário tem permissões

### Assets/CSS não carregam

1. Verifique se o document root está correto
2. Execute: `php artisan storage:link`
3. Verifique permissões das pastas

### APP_KEY não definida

```bash
php artisan key:generate
```

Ou manualmente no `.env`:
```env
APP_KEY=base64:sua_chave_base64_aqui
```

## ✅ Checklist Final

- [ ] Banco de dados criado e configurado
- [ ] Arquivo `.env` configurado corretamente
- [ ] APP_KEY gerada
- [ ] Migrations executadas
- [ ] Seeders executados (se necessário)
- [ ] Storage link criado
- [ ] Permissões configuradas (755)
- [ ] Cache otimizado para production
- [ ] Cron jobs configurados
- [ ] Email SMTP configurado e testado
- [ ] SSL/HTTPS configurado
- [ ] Backup do banco de dados criado
- [ ] Arquivo `install.php` removido (se usado)

## 📊 Monitoramento e Manutenção

### Backups Regulares

Configure backups automáticos no cPanel:
1. **JetBackup** ou **Backup Wizard**
2. Frequência: Diário
3. Incluir: Arquivos + Banco de Dados

### Atualizar Dependências

```bash
composer update --no-dev
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Limpar Cache

```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

## 🚀 Performance

### Habilitar OPcache

Adicione no `php.ini`:

```ini
opcache.enable=1
opcache.memory_consumption=256
opcache.max_accelerated_files=20000
opcache.validate_timestamps=0
```

### Usar Redis (se disponível)

No `.env`:

```env
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

## 📞 Suporte

- **Documentação oficial:** https://6ammart.app/documentation/
- **Laravel Docs:** https://laravel.com/docs
- **cPanel Docs:** https://docs.cpanel.net/

---

**Última atualização:** Novembro 2025  
**Versão do Sistema:** 3.2
