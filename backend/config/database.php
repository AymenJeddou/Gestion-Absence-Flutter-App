<?php
// === CORS Headers (needed for Flutter to communicate with the API) ===
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// === Database connection ===
$host = "localhost";
$db_name = "gest_absence";
$username = "root";
$password = "";

$conn = new mysqli($host, $username, $password, $db_name);

if ($conn->connect_error) {
    echo json_encode(["success" => 0, "message" => "Erreur de connexion à la base de données"]);
    exit();
}

$conn->set_charset("utf8mb4");
?>