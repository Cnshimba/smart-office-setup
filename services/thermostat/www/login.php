<?php
$db = new PDO('sqlite:' . __DIR__ . '/../db/users.sqlite');
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = $_POST['user'];
    $pass = $_POST['pass'];
    $sql = "SELECT * FROM users WHERE username = '$user' AND password = '$pass'"; // vulnerable
    $res = $db->query($sql);
    if ($res && $res->fetch()) echo "Welcome technician"; else echo "Invalid";
}
?>
<form method="post">
  <input name="user" placeholder="username">
  <input name="pass" placeholder="password">
  <button>Login</button>
</form>
