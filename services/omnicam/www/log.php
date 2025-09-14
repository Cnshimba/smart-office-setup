<?php
$file = __DIR__ . '/../flags/visitors.txt';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['name'])) {
    file_put_contents($file, date('c') . '|' . $_POST['name'] . PHP_EOL, FILE_APPEND);
}
$lines = file_exists($file) ? file($file, FILE_IGNORE_NEW_LINES) : [];
?>
<form method="post">
  <input name="name" placeholder="Your name"><button>Submit</button>
</form>
<ul>
<?php foreach($lines as $l) {
    list($t,$n) = explode('|',$l,2);
    echo "<li>$t - $n</li>"; // intentionally unsanitized -> stored XSS
} ?>
</ul>
