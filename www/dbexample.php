<html>


<?php 
$user = "reader";
$pass = "testtest";

$dbh = new PDO('mysql:host=localhost;dbname=testdb', $user, $pass);
$sth = $dbh->query('SELECT * FROM test');

$rows = $sth->fetchAll();

echo('<table style="border: solid 1px black;"><tr><th>name</th><th>prename</th></tr>');
foreach($rows as $row) {
    echo("<tr class='row'><td>$row[0]  </td><td> $row[1] </td> </tr>");

}
echo "</table>";

?>
</html>
