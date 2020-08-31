
RegisterTaskGenerationFunction("IOTMRedNosedSnapperTask");
void IOTMRedNosedSnapperTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("Red Nosed Snapper").familiar_is_usable()) return;
    if (my_familiar() != lookupFamiliar("Red Nosed Snapper")) return;
    if (get_property("redSnapperPhylum") != "") return;

    optional_task_entries.listAppend(ChecklistEntryMake("__familiar red-nosed snapper", "familiar.php?action=guideme&pwd=" + my_hash(), ChecklistSubentryMake("Track monsters", "+ of them and gives items", "Choose a phylum".HTMLGenerateSpanOfClass("r_element_important")), 8));
}

RegisterResourceGenerationFunction("IOTMRedNosedSnapperResource");
void IOTMRedNosedSnapperResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Red Nosed Snapper").familiar_is_usable()) return;
    if (my_familiar() != lookupFamiliar("Red Nosed Snapper") && !__misc_state["in run"]) return;

    //beast = +5 cold res (not a lot of places to go for those, esp. since it's for a quite optional effect...)
    //bug = +100% HP, 8-10 HP regen (spleen) (not really... useful enough to mention those outside of the zones having them..?)
    //constellation = Yellow ray
    //construct = +150% init (spleen)
    //demon = +5 hot res (suggested in a zone that already has one (haunted kitchen)) (there's some hellseals, though..?)
    //dude = All-day free (3x/day) banish item
    //elemental = +50% MP, 3-5 MP regen (spleen) (would recommend the snowman ninja lair, but we can't know if they chose hippy route instead; we know when they ARE there...)
    //elf = +50% candy (not encountered in-run, nor has... any... use?)
    //fish = Fishy (spleen)
    //goblin = 3-size food
    //hippy = +5 stench res
    //hobo = +100% meat (spleen) (only seen in overgrown lot, sleazy back alley, or hobopolis)
    //horror = 5x/day free kill
    //humanoid = +50% muscle stats (spleen)
    //mer-kin = +30% underwater items
    //orc = 3-size booze
    //penguin = gives meat (never useful, nor encountered in run, really)
    //pirate = +50% moxie stats (spleen)
    //plant = Full HP restore in combat
    //slime = +5 sleaze res (would be good for bridge, but there's very few slimes before that...)
    //undead = +5 spooky res
    //weird = +50% myst stats (spleen) (way too rare in-run to recommend)

    boolean going_in_Degrassi_Knoll = !knoll_available() && my_path_id() != PATH_NUCLEAR_AUTUMN && !__misc_state["desert beach available"] && __misc_state["guild open"];
    boolean making_Junk_Junk = !__misc_state["mysterious island available"] && __quest_state["Old Landfill"].in_progress;
    boolean Azazel_quest_is_in_progress = __quest_state["Azazel"].in_progress && !in_bad_moon() && $locations[The Laugh Floor, Infernal Rackets Backstage].turnsAttemptedInLocation() > 0;
    boolean nemesis_quest_at_clown_house = __quest_state["Nemesis"].mafia_internal_step == 6;
    boolean nemesis_quest_at_Fungal_Nethers = $ints[13,14,15] contains __quest_state["Nemesis"].mafia_internal_step;
    boolean cyrpt_modern_zmobies_are_appreciated = !__quest_state["Cyrpt"].state_boolean["alcove finished"] && __quest_state["Cyrpt"].state_int["alcove evilness"] > 1;
    boolean at_chasm_bridge = __quest_state["Highland Lord"].mafia_internal_step == 1;
    boolean past_chasm_bridge = __quest_state["Highland Lord"].mafia_internal_step > 1;
    boolean want_more_rusty_hedge_trimmers = __quest_state["Highland Lord"].state_boolean["can complete twin peaks quest quickly"] && __quest_state["Highland Lord"].state_int["twin peak progress"] < 15 && $item[rusty hedge trimmers].available_amount() < __quest_state["Highland Lord"].state_int["peak tests remaining"];
    boolean looking_for_mining_gear = __quest_state["Trapper"].in_progress && !__quest_state["Trapper"].state_boolean["Past mine"] && __quest_state["Trapper"].state_string["ore needed"].to_item().available_amount() < 3 && !have_outfit_components("Mining Gear") && my_path_id() != PATH_AVATAR_OF_BORIS && my_path_id() != PATH_WAY_OF_THE_SURPRISING_FIST;
    boolean they_may_be_ninjas = __quest_state["Trapper"].state_boolean["Past mine"] && ($location[lair of the ninja snowmen].turns_spent > 0 || $location[the extreme slope].turns_spent == 0);
    boolean have_some_pirating_to_do = __misc_state["mysterious island available"] && __quest_state["Pirate Quest"].state_boolean["valid"] && !__quest_state["Island War"].state_boolean["War in progress"];
    boolean have_access_to_giant_castle = $item[s.o.c.k.].available_amount() > 0 || my_path_id() == PATH_EXPLOSION;
    boolean top_floor_done = __quest_state["Castle"].mafia_internal_step > 10 && $location[the hole in the sky].locationAvailable();
    boolean going_in_the_HITS = $location[the hole in the sky].locationAvailable() && $item[richard\'s star key].available_amount() == 0 && !__quest_state["Level 13"].state_boolean["Richard's star key used"];
    boolean exploring_desert = __quest_state["Level 11"].in_progress && !__quest_state["Level 11 Desert"].state_boolean["Desert Explored"];
    boolean at_hidden_city = __quest_state["Hidden Temple Unlock"].finished && __quest_state["Level 11 Hidden City"].in_progress;
    boolean have_more_dense_lianas_to_fight = at_hidden_city && __quest_state["Level 11 Hidden City"].state_int["lianas left"] > 0;
    boolean making_wine_bomb = __quest_state["Level 11 Manor"].mafia_internal_step == 3 && get_property("spookyravenRecipeUsed") == "with_glasses";
    boolean helping_Yossarian = __quest_state["Island War"].state_boolean["War in progress"] && !__quest_state["Island War"].state_boolean["Junkyard Finished"];
    boolean fighting_filthworms = __quest_state["Island War"].state_boolean["War in progress"] && !__quest_state["Island War"].state_boolean["Orchard Finished"] && my_path_id() != PATH_2CRS;
    boolean CS_need_to_pass_hot_res_test = my_path_id() == PATH_COMMUNITY_SERVICE && !(get_property("csServicesPerformed").split_string_alternate(",").listInvert() contains "Clean Steam Tunnels");

    boolean [phylum] want_phylum_drop;
    if (true) {
        if (true) { //always up for those if available:
            want_phylum_drop[$phylum[constellation]] = true; //yellow-ray
            want_phylum_drop[$phylum[dude]] = true; //banish
            want_phylum_drop[$phylum[horror]] = true; //free kill
            want_phylum_drop[$phylum[hobo]] = true; //+100% meat
        }

        if (false) { //those just... don't have an use
            want_phylum_drop[$phylum[elf]] = true; //+50% candy drop
            want_phylum_drop[$phylum[penguin]] = true; //an envelope which gives some meat...
            want_phylum_drop[$phylum[bug]] = true; //+100% HP, ~9HP regen (not really worth it...)
        }

        if (__misc_state["in run"]) {
            if (__misc_state["need to level"])
                switch (my_primestat()) { //+50% <stat> gains
                    case $stat[muscle]:
                        want_phylum_drop[$phylum[humanoid]] = true; break;
                    case $stat[mysticality]:
                        want_phylum_drop[$phylum[weird]] = true; break;
                    case $stat[moxie]:
                        want_phylum_drop[$phylum[pirate]] = true; break;
                }

            if (!__quest_state["Level 13"].state_boolean["Init race completed"] || cyrpt_modern_zmobies_are_appreciated)
                want_phylum_drop[$phylum[construct]] = true; //+150% initiative

            if (my_path_id() != PATH_COMMUNITY_SERVICE && $item[Spookyraven billiards room key].available_amount() == 0 && get_property_int("manorDrawerCount") < 20) {
                if (numeric_modifier("hot resistance") < 7)
                    want_phylum_drop[$phylum[demon]] = true; //+5 hot res
                if (numeric_modifier("stench resistance") < 7)
                    want_phylum_drop[$phylum[hippy]] = true; //+5 stench res
            } else if (CS_need_to_pass_hot_res_test)
                want_phylum_drop[$phylum[demon]] = true; //demon again; +5 hot res

            if (past_chasm_bridge) {
                if (__quest_state["Highland Lord"].state_boolean["can complete twin peaks quest quickly"] && !__quest_state["Highland Lord"].state_boolean["Peak Stench Completed"] && numeric_modifier("stench resistance") <= 1.0) //if they have 2 or 3, they don't need a plus-FIVE
                    want_phylum_drop[$phylum[hippy]] = true; //hippy again; +5 stench res
                
                if (__quest_state["Highland Lord"].state_int["a-boo peak hauntedness"] > 2) {
                    want_phylum_drop[$phylum[beast]] = true; //+5 cold res
                    want_phylum_drop[$phylum[undead]] = true; //+5 spooky res
                }
            } else if (at_chasm_bridge)
                want_phylum_drop[$phylum[slime]] = true; //+5 sleaze res

            if (they_may_be_ninjas && !__quest_state["Trapper"].state_boolean["Groar defeated"] && numeric_modifier("cold resistance") < 3.0) //if they have 3 or 4, they don't need a plus-FIVE
                want_phylum_drop[$phylum[beast]] = true; //beast again; +5 cold res

            if (!lookupItem("Eight Days a Week Pill Keeper").have())
                want_phylum_drop[$phylum[elemental]] = true; //+50% MP, ~4MP regen

            if (__quest_state["Lair"].state_boolean["shadow will need to be defeated"])
                want_phylum_drop[$phylum[plant]] = true;
        } else if (__quest_state["Sea Monkees"].in_progress || __quest_state["Sea Temple"].in_progress || __quest_state["Sea Monkees"].state_string["skate park status"] == "war") {
            want_phylum_drop[$phylum[fish]] = true; //fishy
            want_phylum_drop[$phylum[mer-kin]] = true; //+30% underwater items (meh...)
        }

        if (in_ronin() && my_path_id() != PATH_NUCLEAR_AUTUMN) {
            if (fullness_limit() >= 3)
                want_phylum_drop[$phylum[goblin]] = true; //size 3 awesome food
            if (inebriety_limit() >= 3)
                want_phylum_drop[$phylum[orc]] = true; //size 3 awesome booze
        }
    }


    boolean [phylum] can_reach_phylum;
    if (__misc_state["in run"]) {
        if (past_chasm_bridge && want_more_rusty_hedge_trimmers)
            can_reach_phylum[$phylum[beast]] = true; //twin peak topiary animals (is that really all there is to "good" beasts locations?)

        if (exploring_desert || fighting_filthworms)
            can_reach_phylum[$phylum[bug]] = true; //desert and filthworms

        if (going_in_the_HITS)
            can_reach_phylum[$phylum[constellation]] = true;

        if (making_wine_bomb && $item[bottle of Chateau de Vinegar].available_amount() == 0)
            can_reach_phylum[$phylum[construct]] = true; //monstrous boiler and wine rack

        if (my_class() == $class[seal clubber] || __quest_state["Friars"].in_progress || Azazel_quest_is_in_progress)
            can_reach_phylum[$phylum[demon]] = true; //(some) hellseals and demons from friars and hey-deze

        if (true)
            can_reach_phylum[$phylum[dude]] = true; //they're everywhere!!!! (I'm not even gonna TRY to do anything past that.)

        if (they_may_be_ninjas && !__quest_state["Trapper"].state_boolean["Mountain climbed"])
            can_reach_phylum[$phylum[elemental]] = true; //ninja snowmen, not really worth it, though..?

        if (false)
            can_reach_phylum[$phylum[elf]] = true; //can't reach, nor want, in-run

        if (false)
            can_reach_phylum[$phylum[fish]] = true; //can't reach, nor want, in-run

        if (lookupItem("Kramco Sausage-o-Matic&trade;").available_amount() > 0 || !__quest_state["Knob Goblin King"].finished)
            can_reach_phylum[$phylum[goblin]] = true; //kramco & cobbs knob

        if (__misc_state["mysterious island available"] && __quest_state["Island War"].state_string["Side seemingly fighting for"] != "hippy")
            can_reach_phylum[$phylum[hippy]] = true;

        if (false)
            can_reach_phylum[$phylum[hobo]] = true; //no hobos in one's normal path. There's some in the wrong side of the track, but we don't recommend they go there for that.

        if (my_class() == $class[seal clubber] || nemesis_quest_at_clown_house)
            can_reach_phylum[$phylum[horror]] = true; //(some) hellseals and clowns

        if (going_in_Degrassi_Knoll || have_access_to_giant_castle && !top_floor_done || making_Junk_Junk || looking_for_mining_gear || helping_Yossarian)
            can_reach_phylum[$phylum[humanoid]] = true; //Degrassi Knoll, castle giants, old landfill, 7-foot dwarves, Junkyard gremlins

        if (false)
            can_reach_phylum[$phylum[mer-kin]] = true; //can't reach, nor want, in-run

        if (at_chasm_bridge || __misc_state["mysterious island available"] && __quest_state["Island War"].state_string["Side seemingly fighting for"] != "frat boys")
            can_reach_phylum[$phylum[orc]] = true; //smut orc logging camp and war frats

        if (false)
            can_reach_phylum[$phylum[penguin]] = true; //can't reach, nor want, in-run

        if (have_some_pirating_to_do)
            can_reach_phylum[$phylum[pirate]] = true;

        if (nemesis_quest_at_Fungal_Nethers || have_more_dense_lianas_to_fight)
            can_reach_phylum[$phylum[plant]] = true; //fungal nethers and dense lianas

        if (past_chasm_bridge && __quest_state["Highland Lord"].state_float["oil peak pressure"] > 0.0)
            can_reach_phylum[$phylum[slime]] = true; //oil peak (yes, I KNOW that the +5 sleaze res is supposed to be for the BRIDGE BUILDING, but there's just no consistent source of slimes before that; go cry me a river won't you)

        if (__quest_state["Manor Unlock"].in_progress || __quest_state["Cyrpt"].in_progress)
            can_reach_phylum[$phylum[undead]] = true; //The whole spookyraven manor, or the cyrpt

        if (false)
            can_reach_phylum[$phylum[weird]] = true; //I've got nuthin', they are too rare in-run
    }


    boolean [phylum] current_location_phylums;
    foreach index, monstr in __last_adventure_location.get_monsters()
        current_location_phylums[monstr.phylum] = true;

    phylum current_snapper_phylum = get_property("redSnapperPhylum").to_phylum();

    //The selection presented to the player. The currently tracked phylum and those present in the current locations will always be in there
    //This is meant to inform the player on the DROPS they can get, NOT on which phylum they could track to help progress (at least it's not the focus here)
    boolean [phylum] phylum_display_list;

    foreach phyl in $phylums[] {
        if (phyl == current_snapper_phylum) //obviously show the one they are tracking
            phylum_display_list[phyl] = true;
        else if (current_location_phylums contains phyl) //show those in the current location
            phylum_display_list[phyl] = true;
        else if (want_phylum_drop[phyl] && (can_reach_phylum[phyl] || !__misc_state["in run"]))
            phylum_display_list[phyl] = true;
    }


    string [int] description;

    if (get_property_int("redSnapperProgress") > 0)
        description.listAppend("Next drop in " + (11 - get_property_int("redSnapperProgress")) + " " + current_snapper_phylum + " kills.");

    string [phylum] snapper_drop = {
        $phylum[beast]:"+5 " + "cold".HTMLGenerateSpanOfClass("r_element_cold") + " res (20 turns)",
        $phylum[bug]:"+100% HP, 8-10 HP regen (1 spleen, 60 turns)",
        $phylum[constellation]:"Yellow ray item (150 turns of Ev. Looks Yellow)",
        $phylum[construct]:"+150% init (1 spleen, 30 turns)",
        $phylum[demon]:"+5 " + "hot".HTMLGenerateSpanOfClass("r_element_hot") + " res (20 turns)",
        $phylum[dude]:"All-day free (3x/day) banish item",
        $phylum[elemental]:"+50% MP, 3-5 MP regen (1 spleen, 60 turns)",
        $phylum[elf]:"+50% candy (20 turns)",
        $phylum[fish]:"Fishy (1 spleen, 30 turns)",
        $phylum[goblin]:"3-size " + "awesome".HTMLGenerateSpanOfClass("r_element_awesome") + " food",
        $phylum[hippy]:"+5 " + "stench".HTMLGenerateSpanOfClass("r_element_stench") + " res (20 turns)",
        $phylum[hobo]:"+100% meat (1 spleen, 60 turns)",
        $phylum[horror]:"5x/day free kill item",
        $phylum[humanoid]:"+50% muscle stats (1 spleen, 30 turns)",
        $phylum[mer-kin]:"+30% underwater items (20 turns)",
        $phylum[orc]:"3-size " + "awesome".HTMLGenerateSpanOfClass("r_element_awesome") + " booze",
        $phylum[penguin]:"(500 + 500 * +meat%) meat item",
        $phylum[pirate]:"+50% moxie stats (1 spleen, 30 turns)",
        $phylum[plant]:"Full HP restore combat item",
        $phylum[slime]:"+5 " + "sleaze".HTMLGenerateSpanOfClass("r_element_sleaze") + " res (20 turns)",
        $phylum[undead]:"+5 " + "spooky".HTMLGenerateSpanOfClass("r_element_spooky") + " res (20 turns)",
        $phylum[weird]:"+50% myst stats (1 spleen, 30 turns)"
    };

    foreach phyl in phylum_display_list {
        string line;
        if (current_location_phylums contains phyl)
            line += "• ";
        if (current_snapper_phylum == phyl)
            line += __html_right_arrow_character;
        line += capitaliseFirstLetter(phyl + ": ").HTMLGenerateSpanOfClass("r_bold");
        line += snapper_drop[phyl];

        description.listAppend(line);
    }

    resource_entries.listAppend(ChecklistEntryMake("__familiar red-nosed snapper", "familiar.php?action=guideme&pwd=" + my_hash(), ChecklistSubentryMake("Track monsters", "+1 item / 11 kill of tracked phylum", description)));
}
