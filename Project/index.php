<!--Test Oracle file for UBC CPSC304 2018 Winter Term 1
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  This file shows the very basics of how to execute PHP commands
  on Oracle.
  Specifically, it will drop a table, create a table, insert values
  update values, and then query for values

  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up
  All OCI commands are commands to the Oracle libraries
  To get the file to work, you must place it somewhere where your
  Apache server can run it, and you must rename it to have a ".php"
  extension.  You must also change the username and password on the
  OCILogon below to be your ORACLE username and password -->
<html lang="en">
<head>
    <title>CPSC 304 Project Group 11</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<h1>Subscription Service Database</h1>

<hr/>
<h2>NOTE: values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</h2>
<p>The tables available in this database includes:</p>
<p>Accesses, Artist, Developer, DeviceModel, DeviceOS, GameService, Makes, Movie, MovieCompany, MovieService, MusicService, OnlineService Plays, Provides, ReviewDetails, ReviewOverview, ServiceDataContainsCost, ServiceDataContainsProvider, ServiceDataContainsVersion, Song, Streams, SubscribesTo, SubscriptionCosts, SubscriptionProvider, UserData, Uses, VideoGame, Writes</p>
<hr/>

<h2>Insert data into Subscribes To table</h2>
<form method="POST" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
    Email: <input type="text" name="emailInsert"> <br/><br/>
    ServiceProvider: <input type="text" name="serviceProviderInsert"> <br/><br/>
    BillingFrequency: <input type="text" name="billingFrequencyInsert"> <br/><br/>
    CostPerPayment: <input type="text" name="costPerPaymentInsert"> <br/><br/>
    YearlyCost: <input type="text" name="yearlyCostInsert"> <br/><br/>
    <input type="submit" value="Insert" name="insertSubmit"></p>
</form>

<hr/>

<h2>Delete data in UserData</h2>
<p>Remove a user from the database (input their email)</p>

<form method="POST" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
    <label for="emailDelete">Email to delete: </label>
    <input type="text" id="emailDelete" name="emailDelete"> <br/><br/>
    <input type="submit" value="Delete" name="deleteSubmit"></p>
</form>

<hr/>

<h2>Update data in UserData</h2>
<p>Input their OLD EMAIL and their NEWLY UPDATED EMAIL. If you do not want to change the email, leave the SAME email
    back in. All values must be updated, you can insert old values as well</p>


<form method="POST" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
    <label for="oldEmailUpdate">Old Email: </label>
    <input type="text" id="oldEmailUpdate" name="oldEmailUpdate"> <br/><br/>
    <label for="newEmailUpdate">New Email: </label>
    <input type="text" id="newEmailUpdate" name="newEmailUpdate"> <br/><br/>
    <label for="fnameUpdate">First Name: </label>
    <input type="text" id="fnameUpdate" name="fnameUpdate"> <br/><br/>
    <label for="lnameUpdate">Last Name: </label>
    <input type="text" id="lnameUpdate" name="lnameUpdate"> <br/><br/>
    <label for="ageUpdate">Age: </label>
    <input type="text" id="ageUpdate" name="ageUpdate"> <br/><br/>
    <label for="countryUpdate">Country: </label>
    <input type="text" id="countryUpdate" name="countryUpdate"> <br/><br/>
    <label for="phoneNumberUpdate">Phone Number:</label>
    <input type="text" id="phoneNumberUpdate" name="phoneNumberUpdate"><br/><br/>
    <input type="submit" value="Update" name="updateSubmit"></p>
</form>

<hr/>

<h2>Count the number of entries in UserData</h2>
<form method="GET" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="countTupleRequest" name="countTupleRequest">
    <input type="submit" value="Count" name="countTuplesSubmit"></p>
</form>

<hr/>


<h2>Pick what table you would like to view and follow the instructions below</h2>
<p>Separate each new column should be separated by a comma. Leave no spaces between.</p>
<p>If you would like to get every column, put a * in the "columns" textbox</p>
<p>For the "where" textbox, you should use inequalities, that is, it should look something like column = 'value' or column > number</p>
<form method="GET" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="selectRequest" name="selectRequest">
    Table Name: <input type="text" id="tableSelect" name="tableSelect"> <br/><br/>
    Columns: <input type="text" id="columnSelect" name="columnSelect"> <br/><br/>
    Where: <input type="text" id="whereSelect" name="whereSelect"> <br/><br/>
    <input type="submit" value="Select" name="selectSubmit"></p>
</form>

<hr/>

<h2>Select the table and what columns you would like to see </h2>
<p>Separate each new column should be separated by a comma. Leave no spaces between.</p>
<p>If you would like to get every column, put a * in the "columns" textbox</p>
<form method="GET" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="projectRequest" name="projectRequest">
    Table Name: <input type="text" id="tableProject" name="tableProject"> <br/><br/>
    Columns: <input type="text" id="columnProject" name="columnProject"> <br/><br/>
    <input type="submit" value="Project" name="projectSubmit"></p>
</form>


<hr/>

<h2>Join data in UserData and SubscriptionCosts </h2>
<p>Find people who use certain brands to access subscription services</p>
<form method="GET" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="joinRequest" name="joinRequest">
    Brand: <input type="text" id="brand" name="brand"> <br/><br/>
    <input type="submit" value="Join and find" name="joinSubmit"></p>
</form>

<hr/>


<h2>Find the average monthly revenue of companies by each year</h2>
<form method="GET" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="groupByRequest" name="groupByRequest">
    <input type="submit" value="Get Data" name="groupBySubmit"></p>
</form>

<hr/>


<h2>Find all emails that are subscribed to more than 2 subscriptions</h2>
<form method="GET" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="havingRequest" name="havingRequest">
    <input type="submit" value="Get data" name="havingSubmit"></p>
</form>

<hr/>

<h2>Find all subscriptions with a higher than average monthly revenue </h2>
<form method="GET" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="nestedGroupRequest" name="nestedGroupRequest">
    <input type="submit" value="Get Data" name="nestedGroupSubmit"></p>
</form>

<hr/>

<h2>Get all online services that have been used by all device platforms (Mobile and PC)</h2>
<form method="GET" action="index.php"> <!--refresh page when submitted-->
    <input type="hidden" id="divisionRequest" name="divisionRequest">
    <input type="submit" value="Get division data" name="divisionSubmit"></p>
</form>

<hr/>

<?php
//this tells the system that it's no longer just parsing html; it's now parsing PHP

$success = True; //keep track of errors so it redirects the page only if there are no errors
$db_conn = NULL; // edit the login credentials in connectToDB()
$show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

function debugAlertMessage($message)
{
    global $show_debug_alert_messages;

    if ($show_debug_alert_messages) {
        echo "<script type='text/javascript'>alert('" . $message . "');</script>";
    }
}

function executePlainSQL($cmdstr)
{ //takes a plain (no bound variables) SQL command and executes it
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

function executeBoundSQL($cmdstr, $list)
{
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

function printResult($result)
{ //prints results from a select statement
    echo "<br>Retrieved data from table UserTable:<br>";
    echo "<table>";
    echo "<tr><th>ID</th><th>Name</th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        echo "<tr><td>" . $row["ID"] . "</td><td>" . $row["NAME"] . "</td></tr>"; //or just use "echo $row[0]"
    }

    echo "</table>";
}

function connectToDB()
{
    global $db_conn;

    // Your username is ora_(CWL_ID) and the password is a(student number). For example,
    // ora_platypus is the username and a12345678 is the password.
    $db_conn = OCILogon("ora_clu56", "a37798238", "dbhost.students.cs.ubc.ca:1522/stu");

    if ($db_conn) {
        debugAlertMessage("Database is Connected");
        return true;
    } else {
        debugAlertMessage("Cannot connect to Database");
        $e = OCI_Error(); // For OCILogon errors pass no handle
        echo htmlentities($e['message']);
        return false;
    }
}

function disconnectFromDB()
{
    global $db_conn;

    debugAlertMessage("Disconnect from Database");
    OCILogoff($db_conn);
}

function handleUpdateRequest()
{
    global $db_conn;

    $tuple = array(
        ":old_email" => $_POST['oldEmailUpdate'],
        ":new_email" => $_POST['newEmailUpdate'],
        ":new_fname" => $_POST['fnameUpdate'],
        ":new_lname" => $_POST['lnameUpdate'],
        ":new_age" => $_POST['ageUpdate'],
        ":new_country" => $_POST['countryUpdate'],
        ":new_phoneNumber" => $_POST['phoneNumberUpdate']
    );

    $alltuples = array(
        $tuple
    );

    executeBoundSQL("UPDATE UserData SET Email=:new_email, FirstName=:new_fname, LastName=:new_lname, Age=:new_age, Country=:new_country, PhoneNumber=:new_phoneNumber WHERE Email=:old_email", $alltuples);

    echo "<h2>UserData table after update:</h2>";
    printResultGeneral(executePlainSQL("SELECT Email, FirstName, LastName, Age, Country, PhoneNumber FROM UserData"));

    OCICommit($db_conn);
}

function handleDeleteRequest()
{
    global $db_conn;
    $tuple = array(
        ":email" => $_POST['emailDelete']
    );

    $alltuples = array(
        $tuple
    );
    executeBoundSQL("
				DELETE
				FROM UserData
				WHERE Email = :email
			", $alltuples);
    OCICommit($db_conn);
    echo "<h2>UserData table after delete:</h2>";
    printResultGeneral(executePlainSQL("SELECT * FROM UserData"));
    echo "<h2>Potentially affected tables:</h2>";
    printResultGeneral(executePlainSQL("SELECT * FROM SubscribesTo"));
    printResultGeneral(executePlainSQL("SELECT * FROM Uses"));
    printResultGeneral(executePlainSQL("SELECT * FROM ReviewOverview NATURAL JOIN ReviewDetails"));
}

function handleInsertRequest()
{
    global $db_conn;

    //Getting the values from user and insert data into the table
    $tuple = array(
        ":email" => $_POST['emailInsert'],
        ":serviceProvider" => $_POST['serviceProviderInsert'],
        ":billingFrequency" => $_POST['billingFrequencyInsert'],
        ":costPerPayment" => $_POST['costPerPaymentInsert'],
        ":yearlyCost" => $_POST['yearlyCostInsert'],
    );

    $alltuples = array(
        $tuple
    );

    executeBoundSQL("INSERT INTO SubscribesTo (Email, ServiceProvider, BillingFrequency, CostPerPayment, YearlyCost)
                    VALUES (:email, :serviceProvider, :billingFrequency, :costPerPayment, :yearlyCost)", $alltuples);

    echo "UserData table after insertion:";
    printResultGeneral(executePlainSQL("SELECT * FROM SubscribesTo"));
    // you need the wrap the old name and new name values with single quotations
    OCICommit($db_conn);
}

function handleCountRequest()
{
    global $db_conn;

    $result = executePlainSQL("SELECT Count(*) FROM UserData");

    if (($row = oci_fetch_row($result)) != false) {
        echo "<br> The number of tuples in UserData: " . $row[0] . "<br>";
    }
}

function handleProjectRequest()
{
    global $db_conn;
    $table = $_GET['tableProject'];
    $columns = $_GET['columnProject'];

    $result = executePlainSQL("SELECT $columns FROM $table");

    if ($result) {
        printResultGeneral($result);
    } else {
        echo "Invalid, no result";
    }
}

function handleSelectionRequest()
{
    global $db_conn;
    $table = $_GET['tableSelect'];
    $columns = $_GET['columnSelect'];
    $where = $_GET['whereSelect'];

    $result = executePlainSQL("SELECT $columns FROM $table WHERE $where");

    if ($result) {
        printResultGeneral($result);
    } else {
        echo "Invalid, no result";
    }
}

function handleJoinRequest()
{
    global $db_conn;
    $brand = $_GET['brand'];
    $result = executePlainSQL("SELECT * FROM Uses U, DeviceOS DOS, DeviceModel DM WHERE DOS.OperatingSystem = DM.OperatingSystem AND U.ModelNumber = DM.ModelNumber AND U.ModelNumber = DM.ModelNumber AND U.Brand = '" . $brand . "'");

    echo "<h3>Unfiltered table:</h3>";
    printResultGeneral(executePlainSQL("SELECT * FROM Uses U, DeviceOS DOS, DeviceModel DM WHERE DOS.OperatingSystem = DM.OperatingSystem AND U.ModelNumber = DM.ModelNumber AND U.ModelNumber = DM.ModelNumber"));

    echo "<h3>Table with only items from brand: $brand</h3>";
    printResultGeneral($result);
}

function printResultGroupBy($result)
{ //prints results from a select statement
    echo "<h2>Average Monthly Revenue by Year</h2>";
    echo "<table>";
    echo "<tr><th>Service Provider</th><th>Year</th><th>Avg Revenue</th></tr>";

    while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
        echo "<tr><td>" . $row[0] . "</td><td>" . $row[1] . "</td><td>" . $row[2] . "</td></tr>";
    }

    echo "</table>";
}

function handleGroupByRequest()
{
    global $db_conn;
    $result = executePlainSQL("SELECT ServiceProvider, Year, AVG(MonthlyRevenue)
                                        FROM ServiceDataContainsProvider
                                        GROUP BY ServiceProvider, Year");

    if (!$result) {
        echo "Error executing the query.";
        return;
    }

    printResultGeneral($result);
}

// Taken from:
// https://stackoverflow.com/questions/11378982/how-can-i-get-columns-name-from-select-query-in-php
// https://www.php.net/manual/en/function.oci-parse.php
function printResultGeneral($result)
{
    echo "<table>";

    // Print the table headers dynamically
    $headerPrinted = false;
    while ($row = OCI_Fetch_Array($result, OCI_ASSOC+OCI_RETURN_NULLS)) {
        if (!$headerPrinted) {
            echo "<tr>";
            foreach ($row as $column => $value) {
                echo "<th>" . $column . "</th>";
            }
            echo "</tr>";
            $headerPrinted = true;
        }

        // Print the row data
        echo "<tr>";
        foreach ($row as $column => $value) {
            echo "<td>" . ($value !== null ? $value : "") . "</td>";
        }
        echo "</tr>";
    }

    echo "</table>";
}

function handleDivisionRequest()
{
    global $db_conn;
    $result = executePlainSQL("SELECT * FROM OnlineService O 
                                        WHERE NOT EXISTS 
                                            ((SELECT Platform FROM DeviceOS DOS NATURAL JOIN DeviceModel DM) 
                                            MINUS (SELECT DOS2.Platform 
                                                   FROM Accesses A, DeviceOS DOS2, DeviceModel DM2 
                                                   WHERE DM2.ModelNumber = A.ModelNumber 
                                                     AND DM2.Brand = A.Brand 
                                                     AND O.ServiceProvider = A.ServiceProvider))");
    printResultGeneral($result);
}

function handleNestedGroupRequest()
{
    global $db_conn;
    $result = executePlainSQL("SELECT ServiceProvider, AVG(MonthlyRevenue)
                                        FROM ServiceDataContainsProvider
                                        GROUP BY ServiceProvider
                                        HAVING AVG(MonthlyRevenue) > (SELECT AVG(MonthlyRevenue) FROM ServiceDataContainsProvider)");
    printResultGeneral($result);

}

function handleHavingRequest()
{
    global $db_conn;
    $result = executePlainSQL("SELECT u.Email, COUNT(*)
                                        FROM UserData u, SubscribesTo s
                                        WHERE u.Email = s.Email
                                        GROUP BY u.Email
                                        HAVING COUNT(*) > 2");
    printResultGeneral($result);
}


// HANDLE ALL POST ROUTES
// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
function handlePOSTRequest()
{
    if (connectToDB()) {
        if (array_key_exists('deleteQueryRequest', $_POST)) {
            handleDeleteRequest();
        } else if (array_key_exists('updateQueryRequest', $_POST)) {
            handleUpdateRequest();
        } else if (array_key_exists('insertQueryRequest', $_POST)) {
            handleInsertRequest();
        }

        disconnectFromDB();
    }
}


// HANDLE ALL GET ROUTES
// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
function handleGETRequest()
{
    if (connectToDB()) {
        if (array_key_exists('countTuplesSubmit', $_GET)) {
            handleCountRequest();
        } else if (array_key_exists('groupBySubmit', $_GET)) {
            handleGroupByRequest();
        } else if (array_key_exists('joinSubmit', $_GET)) {
            handleJoinRequest();
        } else if (array_key_exists('havingSubmit', $_GET)) {
            handleHavingRequest();
        } else if (array_key_exists('nestedGroupSubmit', $_GET)) {
            handleNestedGroupRequest();
        } else if (array_key_exists('divisionSubmit', $_GET)) {
            handleDivisionRequest();
        } else if (array_key_exists('selectSubmit', $_GET)) {
            handleSelectionRequest();
        } else if (array_key_exists('projectSubmit', $_GET)) {
            handleProjectRequest();
        }

        disconnectFromDB();
    }
}

if (isset($_POST['updateSubmit']) || isset($_POST['insertSubmit']) || isset($_POST['deleteSubmit'])) {
    handlePOSTRequest();
} else if (isset($_GET['countTupleRequest']) || isset($_GET['groupByRequest']) || isset($_GET['joinRequest']) || isset($_GET['havingRequest']) || isset($_GET['nestedGroupRequest']) || isset($_GET['divisionRequest']) || isset($_GET['selectRequest']) || isset($_GET['projectRequest'])) {
    handleGETRequest();
}
?>
</html>


