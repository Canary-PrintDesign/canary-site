<?php

// This file does NOTHING until moved to http://static-files.canaryprint.ca/canaryprint.ca/contact-forms/

header("Access-Control-Allow-Origin: https://www.canaryprint.ca");
$email = Trim(stripslashes($_POST['email']));
$EmailTo = "info@canaryprint.ca";
$Subject = "PROMO REQUEST";

// prepare email body text
$Body .= "\n";
$Body .= "1,000 business cards for $49 promo"
$Body .= "\n";

// send email
$success = mail($EmailTo, $Subject, $Body, "From: Promo Page <$email>");

// redirect to success page
if ($success) {
  echo 'success';
}
else {
  http_response_code(400);
}
?>
