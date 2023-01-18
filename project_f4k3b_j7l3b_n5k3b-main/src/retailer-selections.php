<header>
    <?php echo file_get_contents("html/header.html"); ?>
</header>
<body>
<div>
    <?php echo file_get_contents("html/retailer-list.html"); ?>
</div>
</body>

<?php

function debugAlertMessage($message) {
    global $show_debug_alert_messages;

    if ($show_debug_alert_messages) {
        echo "<script type='text/javascript'>alert('" . $message . "');</script>";
    }
}

$success = True; //keep track of errors so it redirects the page only if there are no errors
$db_conn = NULL; // edit the login credentials in connectToDB()
$show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())


function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
    //echo "<br>running ".$cmdstr."<br>";
    global $db_conn, $success;

    $statement = OCIParse($db_conn, $cmdstr);
    //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

    if (!$statement) {
        echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
        $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
        echo htmlentities($e['message']);
        $success = False;
    }

    $r = OCIExecute($statement, OCI_DEFAULT);
    if (!$r) {
        echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
        $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
        echo htmlentities($e['message']);
        $success = False;
    }

    return $statement;
}

function executeBoundSQL($cmdstr, $list) {
    /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
In this case you don't need to create the statement several times. Bound variables cause a statement to only be
parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
See the sample code below for how this function is used */

    global $db_conn, $success;
    $statement = OCIParse($db_conn, $cmdstr);

    if (!$statement) {
        echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
        $e = OCI_Error($db_conn);
        echo htmlentities($e['message']);
        $success = False;
    }

    foreach ($list as $tuple) {
        foreach ($tuple as $bind => $val) {
            //echo $val;
            //echo "<br>".$bind."<br>";
            OCIBindByName($statement, $bind, $val);
            unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
        }

        $r = OCIExecute($statement, OCI_DEFAULT);
        if (!$r) {
            echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
            $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
            echo htmlentities($e['message']);
            echo "<br>";
            $success = False;
        }
    }
}

function connectToDB() {
    global $db_conn;

    // Your username is ora_(CWL_ID) and the password is a(student number). For example,
    // ora_platypus is the username and a12345678 is the password.
    $db_conn = OCILogon("ora_********", "a********", "dbhost.students.cs.ubc.ca:1522/stu");

    if ($db_conn) {
        debugAlertMessage("Connected to Database");
        return true;
    } else {
        debugAlertMessage("Cannot connect to Database");
        $e = OCI_Error(); // For OCILogon errors pass no handle
        echo htmlentities($e['message']);
        return false;
    }
}

function disconnectFromDB() {
    global $db_conn;

    debugAlertMessage("Disconnect from Database");
    OCILogoff($db_conn);
}

function handlePhysicalRequest() {
    if (isset($_POST['Selection']) && $_POST['Selection'] == 'GameID') {
        handlePhysicalIDRequest();
    } else if (isset($_POST['Selection']) && $_POST['Selection'] == 'Price') {
        handlePhysicalPriceRequest();
    } else if (isset($_POST['Selection']) && $_POST['Selection'] == 'G_Title') {
        handlePhysicalTitleRequest();
    }
}

function handleOnlineRequest() {
    if (isset($_POST['Selection']) && $_POST['Selection'] == 'GameID') {
        handleOnlineIDRequest();
    } else if (isset($_POST['Selection']) && $_POST['Selection'] == 'Price') {
        handleOnlinePriceRequest();
    } else if (isset($_POST['Selection']) && $_POST['Selection'] == 'G_Title') {
        handleOnlineTitleRequest();
    }
}

function handlePhysicalIDRequest() {
    if (connectToDB()) {
        global $db_conn;

        $max_price = $_POST['maxPrice'];

        $result = executePlainSQL(
        "SELECT g.GameID
        FROM Stocks s, Game g, Retailer r, Physical_R x
        WHERE s.RetailerID = r.RetailerID AND s.GameID = g.GameID AND r.RetailerID = x.RetailerID AND s.Quantity > 0 AND g.Price < $max_price");
        echo "<table>";       
        echo "<tr><th>GameID</th></tr>";
        printResult($result);
    }
    disconnectFromDB();
}

function handlePhysicalPriceRequest() {
    if (connectToDB()) {
        global $db_conn;

        $max_price = $_POST['maxPrice'];

        $result = executePlainSQL(
        "SELECT g.Price
        FROM Stocks s, Game g, Retailer r, Physical_R x
        WHERE s.RetailerID = r.RetailerID AND s.GameID = g.GameID AND r.RetailerID = x.RetailerID AND s.Quantity > 0 AND g.Price < $max_price");
        echo "<table>";
        echo "<tr><th>Price</th></tr>";
        printResult($result);
    }
    disconnectFromDB();
}

function handlePhysicalTitleRequest() {
    if (connectToDB()) {
        global $db_conn;

        $max_price = $_POST['maxPrice'];

        $result = executePlainSQL(
        "SELECT g.G_Title
        FROM Stocks s, Game g, Retailer r, Physical_R x
        WHERE s.RetailerID = r.RetailerID AND s.GameID = g.GameID AND r.RetailerID = x.RetailerID AND s.Quantity > 0 AND g.Price < $max_price");
        echo "<table>";
        echo "<tr><th>Game Title</th></tr>";
        printResult($result);
    }
    disconnectFromDB();
}

function handleOnlineIDRequest() {
    if (connectToDB()) {
        global $db_conn;

        $max_price = $_POST['maxPrice'];

        $result = executePlainSQL(
        "SELECT g.GameID
        FROM Stocks s, Game g, Retailer r, Online_R x
        WHERE s.RetailerID = r.RetailerID AND s.GameID = g.GameID AND r.RetailerID = x.RetailerID AND s.Quantity > 0 AND g.Price < $max_price");
        echo "<table>";
        echo "<tr><th>GameID</th></tr>";
        printResult($result);
    }
    disconnectFromDB();
}

function handleOnlinePriceRequest() {
    if (connectToDB()) {
        global $db_conn;

        $max_price = $_POST['maxPrice'];

        $result = executePlainSQL(
        "SELECT g.Price
        FROM Stocks s, Game g, Retailer r, Online_R x
        WHERE s.RetailerID = r.RetailerID AND s.GameID = g.GameID AND r.RetailerID = x.RetailerID AND s.Quantity > 0 AND g.Price < $max_price");
        echo "<table>";
        echo "<tr><th>Price</th></tr>";
        printResult($result);
    }
    disconnectFromDB();
}

function handleOnlineTitleRequest() {
    if (connectToDB()) {
        global $db_conn;

        $max_price = $_POST['maxPrice'];

        $result = executePlainSQL(
        "SELECT g.G_Title
        FROM Stocks s, Game g, Retailer r, Physical_R x
        WHERE s.RetailerID = r.RetailerID AND s.GameID = g.GameID AND r.RetailerID = x.RetailerID AND s.Quantity > 0 AND g.Price < $max_price");
        echo "<table>";
        echo "<tr><th>Game Title</th></tr>";
        printResult($result);
    }
    disconnectFromDB();
}

function printResult($result) { //prints results from a select statement

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        //echo "<tr><td>" . $row["Username"] . "</td><td>" . $row["C_Name"] . "</td></tr>" . $row["Phone#"] . "</td></tr>"; //or just use "echo $row[0]"
        echo "<tr><td>" . $row[0] ;
    }

    echo "</table>";
}

if (isset($_POST['Retailer']) && $_POST['Retailer'] == 'Physical_R') {
    handlePhysicalRequest();
} else if (isset($_POST['Retailer']) && $_POST['Retailer'] = 'Online_R') {
    handleOnlineRequest();
}

?>

<h2>Select different conditions</h2>
<p>If you wish to select different conditions, click here</p>

<form method="POST" action="retailers.php">
    <input type="hidden" id="deleteTablesRequest" name="deleteTablesRequest">
    <input type="submit" value="back" name="button"></p>
</form>
