<?php
require_once "../../config/database.php";
require_once "../../utils/response.php";

session_start();

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    sendResponse(405, ["message" => "Method not allowed. Use POST."]);
}

$data = json_decode(file_get_contents("php://input"));

if (empty($data->username) || empty($data->password)) {
    sendResponse(400, ["message" => "Please provide username and password."]);
}

$database = new Database();
$db = $database->getConnection();

try {
    $query = "SELECT id, username, password FROM users WHERE username = :username LIMIT 1";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":username", $data->username);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (password_verify($data->password, $row["password"])) {
            $_SESSION["user_id"] = $row["id"];
            $_SESSION["username"] = $row["username"];

            sendResponse(200, [
                "message" => "Login successful.",
                "user" => [
                    "id" => $row["id"],
                    "username" => $row["username"]
                ]
            ]);
        }
        else {
            sendResponse(401, ["message" => "Invalid password."]);
        }
    }
    else {
        sendResponse(401, ["message" => "User not found."]);
    }
}
catch (PDOException $e) {
    sendResponse(500, ["message" => "Database error: " . $e->getMessage()]);
}
?>