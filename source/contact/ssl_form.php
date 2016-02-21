<?php
header("Access-Control-Allow-Origin: https://www.canaryprint.ca");
$name = Trim(stripslashes($_POST['name']));
$email = Trim(stripslashes($_POST['email']));
$comp_name = Trim(stripslashes($_POST['comp_name']));
$domain_name = Trim(stripslashes($_POST['domain_name']));
$EmailTo = "security@canaryprint.ca";
$Subject = "Message from $name";

// prepare email body text
$Body .= "\n";
$Body .= $comp_name;

$Body .= $domain_name;
$Body .= "\n";

// send email
$success = mail($EmailTo, $Subject, $Body, "From: $name <$email>");

// redirect to success page
if ($success) {
  echo 'success';
}
else {
  http_response_code(400);
}
?>
