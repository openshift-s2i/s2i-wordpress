<?php
require_once("/opt/app-root/src/wp-config.php");
$servername = getenv(strtoupper(getenv("DATABASE_SERVICE_NAME"))."_SERVICE_HOST");
$username = getenv("WORDPRESS_DB_USER");
$password = getenv("WORDPRESS_DB_PASSWORD");
$k8s_probe = getenv("K8S_PROBE");

foreach (getallheaders() as $name => $value) {
    error_log("Header: $name: $value");
    if ($name == "X-K8S-PROBE") {
        $k8sHeader = $value;
    }
}

// Check for magic header
if ($k8sHeader != $k8s_probe) {
    error_log("Unauthorized health check, got: $k8sHeader expected: $k8s_probe");
    header("HTTP/1.1 403 Forbidden");
    die("Unauthorized health check");
}
@$link = mysql_connect(DB_HOST, DB_USER, DB_PASSWORD);
if ( ! $link ) {
    header("HTTP/1.1 503 Service Unavailable");
    error_log(sprintf("Could not connect to the MySQL server: %s", mysql_error()));
    die( sprintf( "Could not connect to the MySQL server: %s\n", mysql_error() ) );
}
echo "OK";
?>
