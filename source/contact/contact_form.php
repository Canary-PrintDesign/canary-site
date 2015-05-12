<?php

$name = Trim(stripslashes($_POST['name']));
$email = Trim(stripslashes($_POST['email']));
$message = Trim(stripslashes($_POST['message']));
$EmailTo = "info@canaryprint.ca";
$Subject = "Message from $name";

// prepare email body text
$Body .= "\n";
$Body .= $message;
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
