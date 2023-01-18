<header>
    <?php echo file_get_contents("html/header.html"); ?>
</header>
<body>
<div>
    <?php echo file_get_contents("html/retailer-list.html"); ?>
</div>
</body>

<form method ="POST" action="retailer-selections.php">
<label for="RetailerType">Search Physical or Online </label>
<select name="Retailer" id="Retailer">
    <option value="Physical_R" name = "Physical_R">Physical</option>
    <option value="Online_R" name = "Online_R">Online</option>
</select>  
<br><br>

<label for="Attribute">Search by Game ID, Game Titles, or Price</label>
<select name="Selection" id="Selection">
    <option value="GameID" name = "GameID">Game ID</option>
    <option value="Price" name ="Price">Price</option>
    <option value="G_Title" name ="G_Title">Game Titles</option>
</select>
<br><br>
    
<label for="MaxPrice">What is the max price you want to see</label>
<input type="text" value="100" name="maxPrice">
<br><br>

    <input type="submit" value="Submit">
</form>

