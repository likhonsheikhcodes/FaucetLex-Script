<?php
// db.php                                                 RECOMPENSA USD 0.0000274
$servername = "";
$username = "";
$password = "";
$dbname = "";

// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión UTILIZAR PHP 8.0
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

function getDB() {
    global $conn;
    return $conn;
}
?>
