<?php

// Include required classes.
require 'classes/connect.php';
require 'classes/smsified.class.php';
require 'classes/inbound.class.php';

// Credentials for DB access
define('DB_HOST', '');
define('DB_USER', '');
define('DB_PASSWORD', '');
define('DB_NAME', 'derbycityfood');
define('SQL_QUERY_TEMPLATE', 'SELECT Est_Name, str_to_date(Date_Insp, \'%c/%e/%Y\') AS I_Date, Score, Grade FROM inspections WHERE Est_Name LIKE \'%{NAME}%\' ORDER BY I_Date DESC LIMIT 1');

// Credentials for SMSified.
define('SMS_USER', '');
define('SMS_PASSWORD', '');
define('SMS_SENDER_NUMBER', '');

try {

	// Get the JSON payload sumbitted from SMSified.
	$json = file_get_contents("php://input");

	// Create a new instance of the custom object.
	$sms = new InboundMessage($json);

	// Get the message sent with the inbound message.
	$message = $sms->getMessage();

	// Get the number message was sent from.
	$number = $sms->getSenderAddress();

	// Look up latest review for establishment.
	$conn = new DBConnect(DB_HOST, DB_USER, DB_PASSWORD);
	$conn->selectDB(DB_NAME);
	$query = str_replace("{NAME}", $conn->escapeInput($message), SQL_QUERY_TEMPLATE);
	$result = $conn->runQuery($query);

	// Construct response to send back to user.

	if($conn->getNumRowsAffected() == 0) {
		$response = "No establishments found";
	}
	else {
		$review = mysql_fetch_assoc($result);
		$response = 'Name: ' . $review["Est_Name"] . ' ';
		$response .= 'Insp. Date: ' . $review["I_Date"] . ' ';
		$response .= 'Score: ' . $review["Score"] . ' ';
		$response .= 'Grade: ' . $review["Grade"];
	}

	// Create a new instance of the SMSified object.
	$sms = new SMSified(SMS_USER, SMS_PASSWORD);
	$sms->sendMessage(SMS_SENDER_NUMBER, $number, $response);
	
}

catch (Exception $ex) {
	openlog("DERBYCITYFOOD", LOG_ODELAY, LOG_USER);
	syslog(LOG_ERR, "There was a problem.");
	closelog();
}

?>
