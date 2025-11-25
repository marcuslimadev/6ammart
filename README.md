# 6amMart - Multi-vendor Food, Grocery, eCommerce, Pharmacy & Parcel Service

Sistema completo multi-vendor desenvolvido em Laravel (Backend) e Flutter (Frontend Mobile/Web).

## 📁 Estrutura do Projeto

```
├── Admin panel new install V3.2/  # Backend Laravel - Instalação completa
├── User app and web/               # Aplicativo Flutter (Mobile + Web)
└── Documentation.url               # Link para documentação oficial
```

## 🚀 Instalação Local

### Pré-requisitos

- PHP >= 8.2
- Composer
- Node.js >= 14.x
- MySQL >= 5.7
- Flutter SDK >= 3.2.0 (para compilar o app)

### Backend (Laravel)

1. **Navegue até o diretório do backend:**
   ```bash
   cd "Admin panel new install V3.2"
   ```

2. **Instale as dependências PHP:**
   ```bash
   composer install --ignore-platform-req=ext-sodium
   ```

3. **Configure o arquivo de ambiente:**
   ```bash
   cp .env.example .env
   ```

4. **Edite o `.env` e configure o banco de dados:**
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=multi_food_db
   DB_USERNAME=root
   DB_PASSWORD=sua_senha
   ```

5. **Gere a chave da aplicação:**
   ```bash
   php artisan key:generate
   ```

6. **Execute as migrations:**
   ```bash
   php artisan migrate
   ```

7. **Execute os seeders (se disponível):**
   ```bash
   php artisan db:seed
   ```

8. **Instale as dependências Node.js:**
   ```bash
   npm install
   ```

9. **Compile os assets:**
   ```bash
   npm run dev
   ```

10. **Inicie o servidor:**
    ```bash
    php artisan serve
    ```

Acesse: `http://localhost:8000`

### Frontend (Flutter)

1. **Instale o Flutter SDK:**
   - Siga as instruções em: https://flutter.dev/docs/get-started/install

2. **Navegue até o diretório do app:**
   ```bash
   cd "User app and web"
   ```

3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

4. **Configure o endpoint da API:**
   - Edite o arquivo de configuração para apontar para sua API
   - Geralmente em: `lib/util/app_constants.dart` ou similar

5. **Execute o app:**
   ```bash
   flutter run
   ```

## 📱 Compilação do Aplicativo

### Android

```bash
cd "User app and web"
flutter build apk --release
```

O arquivo APK estará em: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
cd "User app and web"
flutter build ios --release
```

### Web

```bash
cd "User app and web"
flutter build web --release
```

Os arquivos estarão em: `build/web/`

## 🌐 Deploy no cPanel

### Pré-requisitos no Servidor

- PHP >= 8.2
- MySQL >= 5.7
- Composer
- Node.js (opcional, para compilar assets localmente)

### Passos para Deploy

1. **Prepare os arquivos:**
   - Compile os assets localmente: `npm run production`
   - Remova pastas desnecessárias: `node_modules`, `.git`
   - Compacte a pasta "Admin panel new install V3.2" em um arquivo `.zip`

2. **Upload via cPanel:**
   - Acesse o cPanel do seu servidor
   - Vá em "Gerenciador de Arquivos"
   - Navegue até `public_html` (ou diretório desejado)
   - Faça upload do arquivo `.zip`
   - Extraia o arquivo

3. **Configure o Document Root:**
   - No cPanel, vá em "Domínios" ou "Subdomínios"
   - Configure o document root para apontar para a pasta `public` do Laravel
   - Exemplo: `public_html/Admin panel new install V3.2/public`

4. **Configure o arquivo .env:**
   - Edite o arquivo `.env` com as credenciais do banco de dados do servidor
   - Configure `APP_ENV=production`
   - Configure `APP_DEBUG=false`
   - Configure `APP_URL` com seu domínio

5. **Configure o banco de dados:**
   - Crie um banco de dados MySQL no cPanel
   - Anote o nome do banco, usuário e senha
   - Atualize as credenciais no `.env`

6. **Execute as migrations via SSH (se disponível):**
   ```bash
   php artisan migrate --force
   php artisan db:seed --force
   ```

7. **Configure permissões:**
   ```bash
   chmod -R 755 storage
   chmod -R 755 bootstrap/cache
   ```

8. **Configure o .htaccess:**
   - Certifique-se de que o arquivo `.htaccess` existe na pasta `public`
   - Verifique se o mod_rewrite está habilitado

### Arquivo .htaccess (public/.htaccess)

```apache
<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews -Indexes
    </IfModule>

    RewriteEngine On

    # Handle Authorization Header
    RewriteCond %{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

    # Redirect Trailing Slashes If Not A Folder...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} (.+)/$
    RewriteRule ^ %1 [L,R=301]

    # Send Requests To Front Controller...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>
```

## 🔧 Configurações Importantes

### Configuração de Email (SMTP)

Edite o `.env`:
```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.seuservidor.com
MAIL_PORT=587
MAIL_USERNAME=seu_email@dominio.com
MAIL_PASSWORD=sua_senha
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=seu_email@dominio.com
MAIL_FROM_NAME="${APP_NAME}"
```

### Configuração de Storage (AWS S3 - Opcional)

```env
AWS_ACCESS_KEY_ID=sua_chave
AWS_SECRET_ACCESS_KEY=sua_chave_secreta
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=seu_bucket
```

## 📚 Documentação Oficial

Para documentação completa, acesse: https://6ammart.app/documentation/

## 🐛 Troubleshooting

### Erro 500 após deploy
- Verifique as permissões das pastas `storage` e `bootstrap/cache`
- Verifique se o `.env` está configurado corretamente
- Verifique os logs em `storage/logs/laravel.log`

### Erro de conexão com banco de dados
- Verifique as credenciais no `.env`
- Verifique se o host está correto (geralmente `localhost` no cPanel)
- Verifique se o usuário tem permissões no banco

### Assets não carregam
- Verifique se a pasta `public` é o document root
- Execute `php artisan storage:link`
- Verifique permissões das pastas

## 📝 Notas

- **Backup:** Sempre faça backup do banco de dados antes de executar migrations
- **Segurança:** Nunca exponha o arquivo `.env` publicamente
- **Performance:** Habilite cache no production: `php artisan config:cache`, `php artisan route:cache`, `php artisan view:cache`

## 📞 Suporte

Para suporte técnico, consulte a documentação oficial ou entre em contato com o suporte do 6amMart.

---

**Versão:** 3.2  
**Framework Backend:** Laravel 10.x  
**Framework Frontend:** Flutter 3.2+
