RegisterLowKeyGenerationFunction("PathLowKeyGenerateKeys");
void PathLowKeyGenerateKeys(ChecklistEntry [int] low_key_entries) {

    if (my_path_id() != PATH_LOW_KEY_SUMMER) return;
    if (__quest_state["Lair"].state_boolean["past keys"]) return;

    foreach index, key in LKS_keys {
        if (key.was_used || key.it.available_amount() > 0) continue;	

        string url;
        boolean [location] relevant_location = {key.zone:true}; //only format accepted by ChecklistEntryMake

        // Entries
        string [int] description;

        // Set unlock messages or delay messages
        if (!key.zone.locationAvailable()) {
            description.listAppend("Unlock " + key.zone + " by " + key.condition_for_unlock);
            url = key.pre_unlock_url;
        } else {
            int delayLeft = 11 - key.zone.turns_spent;
            if (delayLeft > 0)
                description.listAppend("Delay for  " + pluralise(delayLeft, "turn", "turns") + " in " + key.zone + " to find key.");
            else
                description.listAppend("Find key on next turn in " + key.zone);

            url = key.zone.getClickableURLForLocation();
        }

        low_key_entries.listAppend(ChecklistEntryMake("__item " + key.it.name, url, ChecklistSubentryMake(key.it.name.capitaliseFirstLetter(), key.enchantment, description), relevant_location));
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
	