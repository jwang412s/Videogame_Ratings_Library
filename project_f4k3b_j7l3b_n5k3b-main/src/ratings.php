<header>
    <?php echo file_get_contents("html/header.html"); ?>
</header>
<div>
    <?php echo file_get_contents("html/ratings-home.html"); ?>
</div>


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
        echo "<br> Database is connected <br>";
        return true;
    } else {
        echo "<br> Database could not connect <br>";
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

function handlePrintRequest() {
    if (connectToDB()) {
        global $db_conn;

        $result = executePlainSQL(
        "SELECT g.G_Title, r.Stars, r.R_Title
        FROM Game g, Rating r
        WHERE g.GameID = r.GameID");
    
        printResult($result); 
    }

    disconnectFromDB();
}

function printResult($result) { //prints results from a select statement
    echo "<br>Retrieved data from table Customer:<br>";
    echo "<table>";
    echo "<tr><th>Game</th><th>Stars</th><th>Rating Title</th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        //echo "<tr><td>" . $row["Username"] . "</td><td>" . $row["C_Name"] . "</td></tr>" . $row["Phone#"] . "</td></tr>"; //or just use "echo $row[0]"
        echo "<tr><td>" . $row[0]  . "</td><td>" . $row[1] . "</td><td>" .  $row[2] . "</td><td>";
    }

    echo "</table>";
}

function printResultAboveYours($result) { //prints results from a select statement
    echo "<br>Retrieved data from table Customer:<br>";
    echo "<table>";
    echo "<tr><th>Game</th><th>Price</th></th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        //echo "<tr><td>" . $row["Username"] . "</td><td>" . $row["C_Name"] . "</td></tr>" . $row["Phone#"] . "</td></tr>"; //or just use "echo $row[0]"
        echo "<tr><td>" . $row[0]  . "</td><td>" . $row[1] . "</td><td>" .  $row[2] . "</td><td>";
    }

    echo "</table>";
}




//Nested Aggregation with group by query//////////////////////////////////////////////////////////////////////////////////////////
function handleRatingCalcRequest() {
    global $db_conn;

    //Getting the values from user and insert data into the table
    /*
    $tuple = array (
        ":bind1" => $_GET['ratingNum'],
    );

    $alltuples = array (
        $tuple
    ); */

    //$input0 = $_POST['ratingNum'];
    //echo "<br>$input0</br>";

    $result = executePlainSQL(
        "SELECT COUNT(g.G_Title), g.Price
        FROM Game g, Rating r
        WHERE g.GameID = r.GameID AND r.Stars >  ALL (SELECT AVG (r2.Stars)
        FROM Rating r2
        )
        GROUP BY  g.Price");
    
        printResultAboveYours($result); 
}

Function handleGETRequest() {
    if (connectToDB()) {
        if (array_key_exists('calcRateSubmit', $_GET)) {
            handleRatingCalcRequest();
        } else if (array_key_exists('findAllSubmit', $_GET)) {
            handlePrintRequest();
        }

        disconnectFromDB();
    }
}







function printResultOwn($result) { //prints results from a select statement
    echo "<br>Retrieved data from table Customer:<br>";
    echo "<table>";
    echo "<tr><th>Game</th><th>Stars</th><th>Rating Title</th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        
        echo "<tr><td>" . $row[0]  . "</td><td>" . $row[1] . "</td><td>" .  $row[2] . "</td><td>";
    }

    echo "</table>";
}


//JOIN QUERY//////////////////////////////////////////////////////////////////////////////////////////////////////////////
function handleSoloRequest() {
    global $db_conn;
/*
    //Getting the values from user and insert data into the table
    $tuple = array (
        ":bind2" => $_POST['insName']
    );

    $alltuples = array (
        $tuple
    );*/
    $new_name = $_POST['insName'];

    $result = executePlainSQL("SELECT g.G_Title, r.Stars, r.R_Title
    FROM Game g, Rating r
    WHERE g.GameID = r.GameID AND r.Username = '$new_name'");
    //OCICommit($db_conn);
    printResultOwn($result);
}





function printResultView($result, $new_View) { //prints results from a select statement
    echo "<br>Retrieved data from table Customer:<br>";
    echo "<table>";
   /* echo "<tr><th>Game</th><th>Stars</th><th>Rating Title</th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        if ($new_View == '3') {
            echo "<tr><td>" . $row[0]  . "</td><td>" . $row[1] . "</td><td>" .  $row[2] . "</td><td>";
        } else if ($new_View == '2') {
            echo "<tr><td>" . $row[0]  . "</td><td>" . $row[1] . "</td><td>";
        } else if ($new_View == '1'){
            echo "<tr><td>" . $row[0]  . "</td><td>";
        }
        
    }

*/

    if ($new_View == 2) {
        echo "<tr><th>Game</th><th>Stars</th></tr>";
        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "<tr><td>" . $row[0]  . "</td><td>" . $row[1] . "</td><td>";
        }
    } else if ($new_View == 1) {
        echo "<tr><th>Game</th></tr>";
        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "<tr><td>" . $row[0]  . "</td><td>";
        }
    } else {
        echo "<tr><th>Game</th><th>Stars</th><th>Rating Title</th></tr>";
        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "<tr><td>" . $row[0]  . "</td><td>" . $row[1] . "</td><td>" .  $row[2] . "</td><td>";
        }
    }
        
    echo "</table>";
}


//PROJECTION QUERY//////////////////////////////////////////////////////////////////////////////////////////////////////////////
function handleViewRequest() {
    global $db_conn;
/*
    //Getting the values from user and insert data into the table
    $tuple = array (
        ":bind2" => $_POST['insName']
    );

    $alltuples = array (
        $tuple
    );*/
    $new_View = $_POST['insNum'];

    $result = executePlainSQL("SELECT g.G_Title, r.Stars, r.R_Title
    FROM Game g, Rating r
    WHERE g.GameID = r.GameID");
    //OCICommit($db_conn);
    printResultView($result, $new_View);
}




function handlePOSTRequest() {
    if (connectToDB()) {
        if (array_key_exists('soloQueryRequest', $_POST)) {
            handleSoloRequest();
        } if (array_key_exists('findViewRequest', $_POST)) {
            handleViewRequest();
        } 

        disconnectFromDB();
    }
}




if (isset($_POST['soloSubmit']) || isset($_POST['findViewSubmit'])) {
    handlePOSTRequest();
}

if (isset($_GET['calcRateSubmit']) || isset($_GET['findAllSubmit'])) {
    echo "<br>lol</br>";
    handleGETRequest();
    
} 




?>


