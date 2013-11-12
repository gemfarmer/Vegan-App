# Veganizzm App
## What would it do?

### The app would allow you to..
1. Search for vegan substitutes to non-vegan ingredients
2. Vegan Ingredient Search Engine/Translator
	* Find alternatives to vegan items
	* Add unit conversion
3. Allow users to add account.
	* Add recipes to database
	* Add vegan substitutes to database
4. Integrate user additions to recipe search engine, Vegan Ingredient Translator

## Backend

#### Technologies
1. CoffeeScript, Node.js/Express
2. Node.js/Express
3. MongoDB
4. Socket.io
5. Passport
6. APIs 
	* Yummly: https://developer.yummly.com/
		> Semantic Recipe Database
		> VeganYumYum
#### - NOT LIKELY TO MAKE THE CUT-
	* BigOven: http://api.bigoven.com/
	* Whole Foods: 
	* aetna: https://developer.carepass.com/docs/read/fooducate/fooducateapi_product
		> The Fooducate product search returns product information based on a particular product identifier.
	* LabelAPI: http://developer.foodessentials.com/
		> barcode checker for dietary preference
	* Punchfork: http://punchfork.com/
		> Now owned by Pinterest http://developers.pinterest.com/
	* Recipe Puppy API: http://www.recipepuppy.com/about/api/
		> Recipe Database
7. Hacker League Hack//Meat Silicon Valley: https://www.hackerleague.org/hackathons/hack-slash-slash-meat-silicon-valley/wikipages/51bf4c1198764b653100003e

#### Workflow 
1. Use API to get data from popular sites like allrecipes.com, foodnetwork.com, etc. for recipes as well as scrape Izzy's veganizzm.com site
2. Store data in MongoDB
3. Use Page Rank style algorithm to determine a.) importance of ingredient relative to other ingredients b.) absolute popularity of ingredient
4. Use algorithm to generate a projected composite score for any specified ingredient combination
5. Create Search engine for ingredients
6. Create list of 10 "suggested ingredients" that best fit in with the ingredients that are currently being used.

## Frontend

#### Technologies

1. CoffeeScript
2. jQuery, Chosen
3. Bootstrap
4. HTML5, CSS3

#### Workflow

1. Add visually appealing and useful search engine interface
2. Create display area for 10 "suggested items"
3. Create chart that creates a visual of the network created by a given recipe combination
4. Display overall score
5. Create user log ins and profiles that can be used to rate ingredient pairings
6. Ability to search for vegan or non-vegan ingredients
7. Provide ingredient-level or meal-level substitutes for ingredients

## To DO
##### (* -> low priority, **** -> high priority)

#### Yummly.coffee (Find)
1. ** Fix query search field so that more than 5 characters can be added before refreshing
2. ** Make yummly.coffee responsive
3. ** Finalize displayed recipe info
4. *** Store API requests in database (at least for first request)

#### Substitution.coffee (Discover)

1. *** Create hard code vegan substitutio<!-- n listing
	* http://www.vegetariantimes.com/article/ingredient-substitution-guide/
	* http://www.veganwolf.com/vegan_cooking_substitutions.htm
	* http://vegetarian.lovetoknow.com/Vegan_Ingredient_Substitution_List
	* http://www.vegkitchen.com/tips/vegan-substitutions/
2. **** Add search field and unit conversion fields -->
3. **** Add to database on submit!

#### Share.coffee (Share)
1. <!-- **** Add ability to enter secure area where you can add...
	* recipes
	* s -->ubstitutes
2. *** Store shares in database


#### Misc
1. * Find second API to pull
2. ** Add Contact
3. **** Collapse nav-bar on smaller screen sizes

