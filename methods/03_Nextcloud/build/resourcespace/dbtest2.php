<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$hosts = ['db', '192.168.112.7', 'localhost'];
$user = 'your_db_user';      // Replace with your database user
$pass = 'your_db_password';  // Replace with your database password
$db   = 'your_db_name';      // Replace with your database name

echo "PHP Version: " . PHP_VERSION . "\n";
echo "Testing multiple host configurations:\n\n";

foreach ($hosts as $host) {
    echo "Testing connection to: $host\n";
    $conn = @mysqli_connect($host, $user, $pass, $db);
    
    if (!$conn) {
        echo "  Failed: " . mysqli_connect_error() . "\n";
    } else {
        echo "  Success!\n";
        $result = mysqli_query($conn, "SELECT DATABASE(), USER(), @@hostname");
        $row = mysqli_fetch_row($result);
        echo "  Connected DB: " . $row[0] . "\n";
        echo "  Connected as: " . $row[1] . "\n";
        echo "  Server host: " . $row[2] . "\n";
        mysqli_close($conn);
    }
    echo "\n";
} 