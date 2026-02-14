<?php
require_once "../../config/database.php";
require_once "../../utils/response.php";

if ($_SERVER["REQUEST_METHOD"] !== "GET") {
    sendResponse(405, ["message" => "Method not allowed. Use GET."]);
}

$database = new Database();
$db = $database->getConnection();

try {
    $query = "SELECT 
                p.id, 
                p.refNo, 
                p.seller_ID,
                p.title, 
                p.price, 
                p.image_1, 
                p.image_2,
                p.created_at,
                p.location,
                pct.category_name,
                pit.items_name,
                u.business_name
              FROM products p
              LEFT JOIN product_category_types pct ON p.productCategoryID = pct.id
              LEFT JOIN product_items_types pit ON p.productItemID = pit.id
              LEFT JOIN users u ON p.seller_ID = u.id
              ORDER BY p.created_at DESC";

    $stmt = $db->prepare($query);
    $stmt->execute();

    $products = [];
    if ($stmt->rowCount() > 0) {
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);
            $product_item = [
                "id" => $id,
                "refNo" => $refNo,
                "sellerID" => $seller_ID,
                "sellerName" => $business_name,
                "title" => $title,
                "price" => (float)$price,
                "image_1" => $image_1,
                "image_2" => $image_2,
                "categoryName" => $category_name,
                "itemName" => $items_name,
                "created_at" => $created_at,
                "sellerLocation" => $location
            ];
            array_push($products, $product_item);
        }
        sendResponse(200, ["products" => $products]);
    }
    else {
        sendResponse(200, ["products" => [], "message" => "No products found."]);
    }
}
catch (PDOException $e) {
    sendResponse(500, ["message" => "Database error: " . $e->getMessage()]);
}
?>