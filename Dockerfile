# استخدم PHP 8.3 الرسمي مع FPM
FROM php:8.3-fpm

# إعداد مجلد العمل
WORKDIR /var/www

# تثبيت المتطلبات
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip

# تثبيت Composer من الصورة الرسمية
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# نسخ ملفات المشروع
COPY . .

# تثبيت الاعتماديات بدون dev
RUN composer install --no-dev --optimize-autoloader

# تعيين التصريحات
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 storage bootstrap/cache

# فتح المنفذ الافتراضي لـ PHP-FPM
EXPOSE 9000

# تشغيل الخادم
CMD ["php-fpm"]

