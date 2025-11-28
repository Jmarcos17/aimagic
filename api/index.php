<?php

/**
 * Ponto de entrada para Vercel Serverless Functions
 * 
 * Este arquivo redireciona todas as requisições para o Laravel
 */

// Definir variáveis de ambiente se necessário
if (!defined('LARAVEL_START')) {
    define('LARAVEL_START', microtime(true));
}

// Carregar o autoloader do Composer
require __DIR__ . '/../vendor/autoload.php';

// Carregar a aplicação Laravel
$app = require_once __DIR__ . '/../bootstrap/app.php';

// Criar o kernel HTTP
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

// Criar a requisição
$request = Illuminate\Http\Request::capture();

// Processar a requisição
$response = $kernel->handle($request);

// Enviar a resposta
$response->send();

// Finalizar
$kernel->terminate($request, $response);

