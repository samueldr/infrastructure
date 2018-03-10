<?php

require_once __DIR__ . '/vendor/autoload.php';
use PhpAmqpLib\Connection\AMQPSocketConnection;
use PhpAmqpLib\Message\AMQPMessage;

function rabbitmq_conn($timeout = 3) {
    $host = '@domain@';
    $connection = new AMQPSocketConnection(
        $host, 5672,
        '@username@', '@password@', '@vhost@'
    );

    return $connection;
}

function gh_secret() {
    return "@github_shared_secret@";
}
