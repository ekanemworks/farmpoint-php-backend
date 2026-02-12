<?php
require_once "../../config/database.php";
require_once "../../utils/response.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    sendResponse(405, ["message" => "Method not allowed. Use POST."]);
}

$data = json_decode(file_get_contents("php://input"));

if (empty($data->username) || empty($data->email) || empty($data->password)) {
    sendResponse(400, ["message" => "Please provide username, email, and password."]);
}

$database = new Database();
$db = $database->getConnection();

try {
    // Check if user already exists
    $query = "SELECT id FROM users WHERE username = :username OR email = :email LIMIT 1";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":username", $data->username);
    $stmt->bindParam(":email", $data->email);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        sendResponse(409, ["message" => "Username or email already exists."]);
    }

    // Insert user
    $query = "INSERT INTO users (username, email, password) VALUES (:username, :email, :password)";
    $stmt = $db->prepare($query);

    $hashed_password = password_hash($data->password, PASSWORD_DEFAULT);

    $stmt->bindParam(":username", $data->username);
    $stmt->bindParam(":email", $data->email);
    $stmt->bindParam(":password", $hashed_password);

    if ($stmt->execute()) {
        sendResponse(201, ["message" => "User created successfully."]);
    }
    else {
        sendResponse(500, ["message" => "Failed to create user."]);
    }
}
catch (PDOException $e) {
    sendResponse(500, ["message" => "Database error: " . $e->getMessage()]);
}
?>
