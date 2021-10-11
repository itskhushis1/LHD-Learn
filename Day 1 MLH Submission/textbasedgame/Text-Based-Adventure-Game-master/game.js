//---------------------------------------------------------------------------------------------------Player----------------------------------------------------------------------------------------------------------------
var playerLife = true;
var i = 0;
var name;

var player = new Object();
player.hp = 100;
player.damage = 10;
player.name = "Greg";
//----------------------------------------------------------------------------------------------------Locations------------------------------------------------------------------------------------------------------------
var currentRoom = "north corridor";
var locations = ["north corridor", "south corridor", "outside the building", "shed", "forest", "castle", "throne room"];

//------------------------------------------------------------------------------------------------------Items---------------------------------------------------------------------------------------------------------------
var matches = true;
var matches1 = "matches";
var sword = false;
var sword1 = "sword";
var lantern = false;
var lantern1 = "lantern";
var potion = false;
var potion1 = "potion";
var bow = false;
var bow1 = "bow";
var helm = false;
var helm1 = "helm";
var shield = false;
var shield1 = "shield"
var letter = false;
var letter1 = "letter";
var inventory = [matches1];

var index;

function clearCell() {
    $("#command_line").val("");
}

function writeName() {
   //Get input
    var input = document.getElementById('command_line');
    
//----------------------------------------------------------------------------------------------------Help command------------------------------------------------------------------------------------------------------------
    if (input.value === "help")
        {
            $("#message_help").clone().insertBefore("#placeholder").fadeIn(1000);
        }
    
//----------------------------------------------------------------------------------------------------Change Location---------------------------------------------------------------------------------------------------------
    //From north corridor
    if (input.value === "go south" && currentRoom === "north corridor")
        {
            i = i + 1;
            currentRoom = locations[i];
            $("<p>Traveling south... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            clearCell();
        }
    else if ((input.value === "go east" || input.value === "go north" || input.value === "go west") && currentRoom === "north corridor")
        {
            $("<p>You cannot go that way.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
           
        }
    
    //From south corridor
    if (input.value === "go south" && currentRoom === "south corridor")
        {
            i = i + 1;
            currentRoom = locations[i];
            $("<p>Traveling south... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            clearCell();
        }
    
    else if ((input.value === "go east" || input.value === "go west" )&& currentRoom === "south corridor")
        {
            $("<p>You cannot go that way.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            
        }
    
    else if (input.value === "go north" && currentRoom === "south corridor")
        {
            i = i -1;
            currentRoom = locations[i];
             $("<p>Traveling north... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
   
    //From outside the building
    if (input.value === "go west" && currentRoom === "outside the building")
        {
            i = i + 1;
            currentRoom = locations[i];
            $("<p>Traveling west... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            clearCell();
        }
    else if ((input.value === "go south" || input.value === "go east") && currentRoom === "outside the building")
        {
            $("<p>You cannot go that way.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            
        }
    
    else if (input.value === "go north" && currentRoom === "outside the building")
        {
            i = i -1;
            currentRoom = locations[i];
             $("<p>Traveling north... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
     //From the shed
   if (currentRoom === "shed" && input.value === "go north")
        {
            i = i + 1;
            currentRoom = locations[i];
            $("<p>Traveling north... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
           clearCell();
        }
    else if ((input.value === "go south" || input.value === "go west") && currentRoom === "shed")
        {
            $("<p>You cannot go that way.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            
        }
    else if (input.value === "go east" && currentRoom === "shed")
        {
            i = i -1;
            currentRoom = locations[i];
             $("<p>Traveling east... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    //From the forest
   if (currentRoom === "forest" && input.value === "go east")
        {
            i = i + 1
            currentRoom = locations[i];
            $("<p>Traveling east... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
           clearCell();
        }
    else if ((input.value === "go west" || input.value === "go north") && currentRoom === "forest")
        {
            $("<p>You cannot go that way.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    else if (input.value === "go south" && currentRoom === "forest")
        {
            i = i -1;
            currentRoom = locations[i];
             $("<p>Traveling north... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    //From the castle
    if (currentRoom === "castle" && input.value === "go north")
        {
            i = i + 1;
            currentRoom = locations[i];
            $("<p>Traveling north... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            clearCell();
        }
    
    else if (currentRoom === "castle" && (input.value === "go east" || input.value === "go south"))
        {
            $("<p>You cannot go that way.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
        
    else if (currentRoom === "castle" && input.value === "go west")
        {
            i = i -1;
            currentRoom = locations[i];
             $("<p>Traveling west... Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
        
    //To go backwards
    if (input.value === "go back")
        {
            i = i - 1;
            currentRoom = locations[i];
            $("<p>Your location is: " + currentRoom + "." + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
//----------------------------------------------------------------------------------------------------Look Around------------------------------------------------------------------------------------------------------------
    //Info for north corridor
    if (input.value === "look around" && currentRoom === "north corridor")
    {
        $("<p>You awake in a hallway, the building around looks abandoned and in disarray. There is no sign of anyone, and it looks like this place hasn't been inhabited in ages.</p>").hide().insertBefore("#placeholder").fadeIn(2000);
        $("<p>As you scan around the room you notice a there is a sword lying on the wall.</p>").hide().insertBefore("#placeholder").fadeIn(7000);
    }
    
    //Info for south corridor
     if (input.value === "look around" && currentRoom === "south corridor")
    {
        $("<p>The air feels damp. This room seems to be colder than the last, it sends a shiver down your spine.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        $("<p>As you walk further down the hall you see a door at the end. A breeze blows through the door that sends a chill down to your bones.</p>").hide().insertBefore("#placeholder").fadeIn(5000);
        $("<p>You see a lantern beside some rubble on the ground.</p>").hide().insertBefore("#placeholder").fadeIn(10000);
    }
    
    //Info for outside the building
     if (input.value === "look around" && currentRoom === "outside the building" && lantern === true && matches ===true  )
    {
        $("<p>You open the door to the outside. It is pitch black out here and the cold is even worse than the building, you light the lantern with your matches and it illuminates the area.</p>").hide().insertBefore("#placeholder").fadeIn(4000);
        $("<p>You feel slightly warmer, but you need to find something else if you want to make it through the night.</p>").hide().insertBefore("#placeholder").fadeIn(9000);
        $("<p>You find yourself in clearing, surrounded by a forest, with small shed on the edge of the forest.</p>").hide().insertBefore("#placeholder").fadeIn(14000);
    }
    
    //Optional for outside the building with no lantern
    else if (input.value === "look around" && currentRoom === "outside the building" && lantern === false)
        {
            $("<p>You can't see anything, it is too dark outside.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    //Info for shed
    if (input.value === "look around" && currentRoom === "shed" && lantern === true && sword === true )
        {
            $("<p>You slowly creep into the shed, with you lantern in one hand your sword in the other. </p>").hide().insertBefore("#placeholder").fadeIn(1000);
            $("<p>As you enter the shed you see something move in the corner. You go to investigate further... </p>").hide().insertBefore("#placeholder").fadeIn(7000);
            $("<p>A large shadowy figure on all four legs leaps towards you! You slash at it with your sword and take off what appears to be its ear. </p>").hide().insertBefore("#placeholder").fadeIn(14000);
            $("<p>The beast jumps to the side and sprints at you, knocking you over as he escapes the shed and into the forest. You lantern now appears to be broken. </p>").hide().insertBefore("#placeholder").fadeIn(20000);
            $("<p>You take 33 damage.</p>").hide().insertBefore("#placeholder").fadeIn(25000);
            player.hp -= 33;
            $("<p>You are slightly wounded, luckily you find a potion underneath a nearby corpse. The body is fresh, couldn't have been dead more than a few days.</p>").hide().insertBefore("#placeholder").fadeIn(30000);
            $("<p>You picked up a potion.</p>").hide().insertBefore("#placeholder").fadeIn(40000);
            potion = true;
            inventory.push(potion1);
            player.hp += 25;
            
        }
    
    //Optional for shed with no sword
    else if (input.value === "look around" && currentRoom === "shed" && lantern === true && sword === false)
        {
            $("<p>You slowly creep into the shed, with you lantern in one hand and your other hand braced against the wall. </p>").hide().insertBefore("#placeholder").fadeIn(1000);
            $("<p>As you enter the shed you see something move in the corner. You go to investigate further... </p>").hide().insertBefore("#placeholder").fadeIn(7000);
            $("<p>A large shadowy figure on all four legs leaps towards you! You slash at it with your lantern but it's not enough to ward it off! </p>").hide().insertBefore("#placeholder").fadeIn(14000);
            $("<p>The beast latches its jaws around your neck and rips out your throat. It begins to feed on you as you slowly die an agonizing death...</p>").hide().insertBefore("#placeholder").fadeIn(20000);
            playerLife = false;
        }
    
    //Info for forest
    if (input.value === "look around" && currentRoom === "forest")
    {
        $("<p>You stumble your way into the forest since you have no light. Luckily your eyes have adjusted to night and the gentle glow of the moon is enough to find your way.</p>").hide().insertBefore("#placeholder").fadeIn(4000);
        $("<p>You tread carefully, you do not know if or when the beast will return. You come across a trail and decide to follow it.</p>").hide().insertBefore("#placeholder").fadeIn(9000);
        $("<p>As you walk down the trail you find another corpse, this one is even more fresh than the last. Been dead less than a day this one. Beside him lay a bow.</p>").hide().insertBefore("#placeholder").fadeIn(14000);
    }
    //Info for castle
    if (input.value === "look around" && currentRoom === "castle")
    {
        $("<p>The trail spits you out of the forest and right in front of a castle. The gate is down and it appears the doors to the castle are cracked open. You decide to venture on inside.</p>").hide().insertBefore("#placeholder").fadeIn(4000);
        $("<p>The entrance is very dark and damp, however, there is lit torch off in the distance.</p>").hide().insertBefore("#placeholder").fadeIn(9000);
        $("<p>In the right corner of the room is mannequin with helm on its head.</p>").hide().insertBefore("#placeholder").fadeIn(14000);
    }
    //Info for throne room
    if (input.value === "look around" && currentRoom === "throne room")
    {
        $("<p>You walk through large double doors that lead to the a huge hall. Against the back wall sits a dias and a stone throne surrounded in ivy.</p>").hide().insertBefore("#placeholder").fadeIn(4000);
        $("<p>There are torches lit in every corner of the room. The air is still and smells slightly of meat. A roaring fire is going in the hearth. </p>").hide().insertBefore("#placeholder").fadeIn(9000);
        $("<p>Beneath the throne sits a shield embroidered in gold. There is a letter tucked away in the back of the shield.</p>").hide().insertBefore("#placeholder").fadeIn(14000);
        $("<p>You picked up a letter.</p>").hide().insertBefore("#placeholder").fadeIn(20000);
        letter = true;
        inventory.push(letter1);
    }
//----------------------------------------------------------------------------------------------------Item Pickup------------------------------------------------------------------------------------------------------------
    //For north corridor
    if (input.value === "take sword" && sword !== true && currentRoom === "north corridor")
        {
            $("<p>You picked up a sword.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            sword = true;
            inventory.push(sword1);
            player.damage += 10;
        }
     else if (input.value === "take sword" && currentRoom !== "north corridor")
        {
            $("<p>You cannot do that right now.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    else if (input.value === "take sword" && currentRoom === "north corridor" && sword === true)
        {
            $("<p>You have already picked up the sword.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    //For south corridor
    if (input.value === "take lantern" && lantern !== true && currentRoom === "south corridor")
        {
            $("<p>You picked up a lantern.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            lantern = true;
            inventory.push(lantern1);
        }
    else if (input.value === "take lantern" && currentRoom !== "south corridor")
        {
            $("<p>You cannot do that right now.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
     else if (input.value === "take lantern" && currentRoom === "south corridor" && lantern === true)
        {
            $("<p>You have already picked up the lantern.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    //For shed
    else if (input.value === "take potion" && currentRoom !== "shed")
        {
           $("<p>You cannot do that right now.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
     else if (input.value === "take potion" && currentRoom === "shed" && potion === true)
        {
            $("<p>You have already picked up the potion.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    //For forest
     if (input.value === "take bow" && currentRoom === "forest")
        {
            $("<p>You picked up a bow.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            bow = true;
            inventory.push(bow1);
        }
    
    else if (input.value === "take bow" && currentRoom !== "forest")
        {
           $("<p>You cannot do that right now.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
     else if (input.value === "take bow" && currentRoom === "forest" && potion === true)
        {
            $("<p>You have already picked up the potion.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    //For castle
    if (input.value === "take helm" && currentRoom === "castle")
        {
            $("<p>You picked up a helm.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            helm = true;
            inventory.push(helm1);
            player.hp += 7;
        }
    
    else if (input.value === "take helm" && currentRoom !== "castle")
        {
           $("<p>You cannot do that right now.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
     else if (input.value === "take helm" && currentRoom === "castle" && helm === true)
        {
            $("<p>You have already picked up the potion.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    //For throne room
    if (input.value === "take shield" && currentRoom === "throne room")
        {
            $("<p>You picked up a shield.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            helm = true;
            inventory.push(shield1);
            player.hp += 10;
        }
    
    else if (input.value === "take shield" && currentRoom !== "throne room")
        {
           $("<p>You cannot do that right now.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
     else if (input.value === "take shield" && currentRoom === "throne room" && shield === true)
        {
            $("<p>You have already picked up the potion.</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
//------------------------------------------------------------------------------------------------Show-----------------------------------------------------------------------------------------------------------------------
    //Show inventory
    if(input.value === "inventory")
        {
            $("<p>Here is your inventory: " + inventory + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    //Show location
    if(input.value === "location")
        {
            $("<p>Your location is: " + currentRoom + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
        }
    
    //Drop item
    if (input.value === "drop")
        {
            $("<p>What item do you want to drop?</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            $("#command_line").val("");
            index = inventory.indexOf(input);
            inventory.splice(index,1);
            if (inventory.indexOf("sword") === -1)
                {
                    player.damage = 10;
                }
        }
    
    if (playerLife === false)
        {
            $("<p>Game over. </p>").hide().insertBefore("#placeholder").fadeIn(40000);
            $("<p>Press enter in the box to restart. </p>").hide().insertBefore("#placeholder").fadeIn(41000);
        }
    
    if (inventory.indexOf("letter") !== -1)
        {
            $("<p>Congradulations! You have reached the end of the game!</p>").hide().insertBefore("#placeholder").fadeIn(40000);
            $("<p>Press enter in the box to restart. </p>").hide().insertBefore("#placeholder").fadeIn(41000);
        }
//------------------------------------------------------------------------------------------------Show stats-----------------------------------------------------------------------------------------------------------------
    
    if (input.value === "show stats")
        {
            $("<p>Your name is: " + player.name + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            $("<p>Your hp is: " + player.hp + "</p>").hide().insertBefore("#placeholder").fadeIn(4000);
            $("<p>Your damage is: " + player.damage + "</p>").hide().insertBefore("#placeholder").fadeIn(7000);
        }
    
    //Doesn't work
    if (input.value === "set name")
        {   
            $("#command_line").val("");
            $("<p>Enter your name: </p>").hide().insertBefore("#placeholder").fadeIn(1000);
            //$("#command_line").val("");
            if (input.value !== "")
                {
            player.name = document.getElementById('command_line');
            //name = input;
            $("<p>Your entered: " + player.name + "</p>").hide().insertBefore("#placeholder").fadeIn(1000);
            //player.name += name.value;
                }
        }
    
    //Clear the input box
   $("#command_line").val(""); 
    
}

