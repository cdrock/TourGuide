RegisterLowKeyGenerationFunction("PathLowKeyGenerateKeys");
void PathLowKeyGenerateKeys(ChecklistEntry [int] low_key_entries) {

    if (my_path_id() != PATH_LOW_KEY_SUMMER) return;
    if (!__misc_state["in run"] || __quest_state["Lair"].state_boolean["past keys"]) return;

    record Key {
        string name;
        location zone;
        string zone_url;
        string enchantment;
        string condition_for_unlock;
        string pre_unlock_url;
    };

    void listAppend(Key [int] list, Key entry) {
        int position = list.count();
        while (list contains position)
            position += 1;
        list[position] = entry;
    }

    Key [int] keys;
    keys.listAppend(new Key("Actual skeleton key", $location[The Skeleton Store], "place.php?whichplace=town_market", "+100 Damage Absorption, +10 Damage Reduction", "accepting the meathsmith\'s quest", "shop.php?whichshop=meatsmith"));
    keys.listAppend(new Key("Anchovy can key", $location[The Haunted Pantry], "place.php?whichplace=manor1", "+100% Food Drops"));
    keys.listAppend(new Key("Aqu&iacute;", $location[South of the Border], "place.php?whichplace=desertbeach", "+3 Hot Res, +15 Hot Damage, +30 Hot Spell Damage", "getting access to the desert beach"));
    keys.listAppend(new Key("Batting cage key", $location[The Bat Hole Entrance], "place.php?whichplace=bathole", "+3 Stench Res, +15 Stench Damage, +30 Stench Spell Damage", "starting the boss bat quest"));
    keys.listAppend(new Key("Black rose key", $location[The Haunted Conservatory], "place.php?whichplace=manor1", "+5 Familiar Weight, +2 Familiar Exp"));
    keys.listAppend(new Key("Cactus key", $location[The Arid, Extra-Dry Desert], "place.php?whichplace=desertbeach", "Regen HP, Max HP +20", "reading the diary in the McGuffin quest"));
    keys.listAppend(new Key("Clown car key", $location[The \"Fun\" House], "place.php?whichplace=plains", "+10 Prismatic Damage, +10 ML", "doing the nemesis quest"));
    keys.listAppend(new Key("Deep-fried key", $location[Madness Bakery], "place.php?whichplace=town_right", "+3 Sleaze Res, +15 Sleaze Damage, +30 Sleaze Spell Damage", "accepting the Armorer and Leggerer\'s quest", "shop.php?whichshop=armory"));
    keys.listAppend(new Key("Demonic key", $location[Pandamonium Slums], "pandamonium.php", "+20% Myst Gains, Myst +5, -1 MP Skills", "finishing the Friars quest"));
    keys.listAppend(new Key("Discarded bike lock key", $location[The Overgrown Lot], "place.php?whichplace=town_wrong", "Max MP + 10, Regen MP", "accepting Doc Galaktik\'s quest", "shop.php?whichshop=doc"));
    keys.listAppend(new Key("F'c'le sh'c'le k'y", $location[The F\'c\'le], "place.php?whichplace=cove", "+20 ML", "doing the pirate\'s quest"));
    keys.listAppend(new Key("Ice key", $location[The Icy Peak], "place.php?whichplace=mclargehuge", "+3 Cold Res, +15 Cold Damage, +30 Cold Spell Damage", "doing the trapper quest"));
    keys.listAppend(new Key("Kekekey", $location[The Valley of Rof L\'m Fao], "place.php?whichplace=mountains", "+50% Meat", "finishing the chasm quest"));
    keys.listAppend(new Key("Key sausage", $location[Cobb\'s Knob Kitchens], "cobbsknob.php", "-10% Combat", "doing the Cobb\'s Knob quest"));
    keys.listAppend(new Key("Knob labinet key", $location[Cobb\'s Knob Laboratory], "cobbsknob.php?action=tolabs", "+20% Muscle Gains, Muscle +5, -1 MP Skills", "finding the Cobb's Knob lab key during the Cobb\'s Knob quest"));
    keys.listAppend(new Key("Knob shaft skate key", $location[The Knob Shaft], "cobbsknob.php?action=tolabs", "Regen HP/MP, +3 Adventures", "finding the Cobb's Knob lab key during the Cobb\'s Knob quest"));
    keys.listAppend(new Key("Knob treasury key", $location[Cobb\'s Knob Treasury], "cobbsknob.php", "+50% Meat, +20% Pickpocket", "doing the Cobb\'s Knob quest"));
    keys.listAppend(new Key("Music Box Key", $location[The Haunted Nursery], "place.php?whichplace=manor3", "+10% Combat", "doing the Spookyraven quest"));
    keys.listAppend(new Key("Peg key", $location[The Obligatory Pirate\'s Cove], "island.php", "+5 Stats", "doing the pirate\'s quest"));
    keys.listAppend(new Key("Rabbit\'s foot key", $location[The Dire Warren], "tutorial.php", "All Attributes +10"));
    keys.listAppend(new Key("Scrap metal key", $location[The Old Landfill], "place.php?whichplace=woods", "+20% Moxie Gains, Moxie +5, -1MP Skills", "starting the Old Landfill quest"));
    keys.listAppend(new Key("Treasure chest key", $location[Belowdecks], "place.php?whichplace=cove", "+30% Item, +30% Meat", "doing the pirate\'s quest"));
    keys.listAppend(new Key("Weremoose key", $location[Cobb\'s Knob Menagerie, Level 2], "cobbsknob.php?action=tomenagerie", "+3 Spooky Res, +15 Spooky Damage, +30 Spooky Spell Damage", "finding the  Cobb\'s Knob Menagerie key in the Cobb\'s Knob lab" + ($item[Cobb's Knob Menagerie key].available_amount() == 0 ? ", accessed by doing the Cobb\'s Knob quest" : "")));

    foreach index, key in keys {
        if (__quest_state["Lair"].state_boolean[key.name + " used"] || lookupItem(key.name).available_amount() > 0) return;	

        ChecklistEntry entry;
        entry.image_lookup_name = "__item " + key.name;

        // Title
        string title = key.name;

        // Subtitle
        string subtitle = key.enchantment;

        // Entries
        string [int] description;
        int turnsSpent = key.zone.turns_spent;
        int delayLeft = 11 - turnsSpent;

        // Set unlock messages or delay messages
        if (!key.zone.locationAvailable()) {
            description.listAppend("Unlock " + key.zone + " by " + key.condition_for_unlock);
            entry.url = key.pre_unlock_url;
        } else {
            if (turnsSpent < 11)
                description.listAppend("Delay for  " + pluralise(delayLeft, "turn", "turns") + " in " + key.zone + " to find key.");
            else
                description.listAppend("Find key on next turn in " + key.zone);

            entry.url = key.zone_url;
        }

        entry.subentries.listAppend(ChecklistSubentryMake(title, subtitle, description));

        low_key_entries.listAppend(entry);
    }
}

RegisterLowKeyGenerationFunction("PathLowKeyGenerateStandardKeys");
void PathLowKeyGenerateStandardKeys(ChecklistEntry [int] low_key_entries) {
    if (!__quest_state["Level 13"].state_boolean["past keys"]) {		

        // Skeleton Key
		if ($item[skeleton key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["skeleton key used"]) {
			string line = "loose teeth";
			if ($item[loose teeth].available_amount() == 0)
				line += " (need)";
			else
				line += " (have)";
			line += " + skeleton bone";
			if ($item[skeleton bone].available_amount() == 0)
				line += " (need)";
			else
				line += " (have)";
			low_key_entries.listAppend(ChecklistEntryMake("__item skeleton key", $location[the defiled nook].getClickableURLForLocation(), ChecklistSubentryMake("Skeleton key", "", line)));
		}
		
        // Digital key
		if ($item[digital key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["digital key used"]) {
			string [int] options;
            if ($item[digital key].creatable_amount() > 0) {
                options.listAppend("Have enough pixels, make it.");
            }
            else
            {
                options.listAppend("Fear man's level (jar)");
                if (__misc_state["fax equivalent accessible"] && in_hardcore()) //not suggesting this in SC
                    options.listAppend("Fax/copy a ghost");
                options.listAppend("8-bit realm (olfact blooper, slow)");
                if (my_path_id() == PATH_ONE_CRAZY_RANDOM_SUMMER)
                    options.listAppend("Wait for pixellated monsters");
                
                int total_white_pixels = $item[white pixel].available_amount() + $item[white pixel].creatable_amount();
                if (total_white_pixels > 0)
                    options.listAppend(total_white_pixels + "/30 white pixels found.");
            }
			low_key_entries.listAppend(ChecklistEntryMake("__item digital key", "", ChecklistSubentryMake("Digital key", "", options)));
		}

        // Star key
        QHitsGenerateMissingItems(low_key_entries);

        // Sneaky Pete key
		string from_daily_dungeon_string = "From daily dungeon";
		if ($item[fat loot token].available_amount() > 0)
			from_daily_dungeon_string += "|" + pluralise($item[fat loot token]) + " available";
		if ($item[sneaky pete\'s key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["Sneaky Pete\'s key used"])
		{
			string [int] options;
			options.listAppend(from_daily_dungeon_string);
			if (__misc_state_int["pulls available"] > 0 && __misc_state["can eat just about anything"])
				options.listAppend("From key lime pie");
			low_key_entries.listAppend(ChecklistEntryMake("__item Sneaky Pete\'s key", "da.php", ChecklistSubentryMake("Sneaky Pete\'s key", "", options)));
		}

        // Jarlsberg Key
		if ($item[jarlsberg\'s key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["Jarlsberg\'s key used"])
		{
			string [int] options;
			options.listAppend(from_daily_dungeon_string);
			if (__misc_state_int["pulls available"] > 0 && __misc_state["can eat just about anything"])
				options.listAppend("From key lime pie");
			low_key_entries.listAppend(ChecklistEntryMake("__item jarlsberg's key", "da.php", ChecklistSubentryMake("Jarlsberg's key", "", options)));
		}

        // Boris Key
		if ($item[Boris\'s key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["Boris\'s key used"])
		{
			string [int] options;
			options.listAppend(from_daily_dungeon_string);
			if (__misc_state_int["pulls available"] > 0 && __misc_state["can eat just about anything"])
				options.listAppend("From key lime pie");
			low_key_entries.listAppend(ChecklistEntryMake("__item Boris's key", "da.php", ChecklistSubentryMake("Boris's key", "", options)));
		}
	}
}
	