In order to run the code:
1. Enter Parser.pm and change the FILE_PATH constant to '<your_path>\Softvision\DataFiles'
    ex. C:\Strawberry\perl\lib\Softvision\DataFiles
2. Enter Downloader.pm and change the LOCAL_SAVE_PATH constant to '<your_path>\Softvision\Images'
3. run Runner.pm
    ex. perl C:\Strawberry\perl\lib\Softvision\Project\Runner.pm
------------------------------------------------------------------------------------------------
My thought process:
Since permits are quite familiar to me, i took a look at the .csv file provided and tried to find some key items to help me out.
I noticed we have FoodItems, Schedule and Address aswel as map coordonates for the food trucks, so i thought i can use them to create a nice table with those.
But since i didnt have a database ready to work with, i came up with 'Food pirates' idea.
My first idea was to ask the user, what he wants to eat, match the input with the FoodItems column from our csv, extract the address and use google maps to grab 
    the images related to this address. I wanted to use Image::Magick to then add a foodtruck.png on top of the recently downloaded images 
    and question the user if this is the truck he was looking for, then show him the schedule along with more data about when the 'robbery' can begin.

I started by creating three modules. 
    - A runner which should run all the code
    - A parser, where i will parse all the data and do modifications to it where needed
    - A Downloader which should access and download images from google maps, then store them in a folder.

After the Runner and the Parser were done, i took some time trying to figure out how to access the main image from Google Maps after a quick search by address.
I found a google api which does exactly this, but it wasnt free unfortunately.
I ended up using chrome developer tools and postman to simulate a manual search to find the link and the payload necesary to pull up images.
I needed some cleaning and organizing functions, so i created a Utils module, where i stored some utilitary functions.
It took me some time, but once this was done, I wanted to use Image::Magick to concatenate a truck image on top of the downloaded images.
    Sadly i quickly figured out that Image::Magick was not a core module of Perl library, so i had to drop the idea.
    To compensate this with my remaining time, i made a short dialog, questioning the user what food he would like to have,
        find all addresses by iterating over the permits matching the FoodItems column with the user input and grabbing it along with the schedule.
Next up i used the addresses to question the user if it is close to him, and if it is, i use the Downloader to fetch the images from google maps, store them in ..\Images
    and print the truck's schedule. If the user is brave enough, now he can start planning his robbery :).
------------------------------------------------------------------------------------------------
If i had more time and resources:
Make a config.txt file to store all local constants like: FILE_PATH and LOCAL_SAVE_PATH so it would've been easier to configure the program.
Store relevant permit's data in a centralized structure(database) so the program shoudnt parse the .csv all the time, improving the overall speed of the program.
Use Image::Magick to overlap a truck image on top of the street images from google maps, asking the user if this truck is suitable for his robbery.
Ask for an address and find a way to show the closest address from the .csv.
Test my code better. Handle input exceptions, browser calls errors, organize code better.
------------------------------------------------------------------------------------------------
Time spent:
20 minutes brainstormin
15 minutes fixing path problems
40 minutes goolging, researching, finding ways to access google maps photos.
90 minutes writing code
15 minutes testing
20 minutes documenting 



