
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
    if (my_familiar() != lookupFamiliar("Red Nosed Snapper")) return;
    if (get_property("redSnapperPhylum") == "") return;

    //int redSnapperProgress = get_property_int("redSnapperProgress");
    string [phylum] snapperDrop = {
        $phylum[beast]:"+5 " + "cold".HTMLGenerateSpanOfClass("r_element_cold") + " res (20 turns)",
        $phylum[bug]:"+100% HP, 8-10 HP regen (1 spleen, 60 turns)",
        $phylum[constellation]:"Yellow ray item (150 turns of ELY)",
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

    string snapperLine(phylum phyl) {
        return capitaliseFirstLetter(phyl + ": ").HTMLGenerateSpanOfClass("r_bold") + snapperDrop[phyl];
    }

    string [int] description;
    description.listAppend($phylum[dude].snapperLine());
    description.listAppend($phylum[goblin].snapperLine());
    description.listAppend($phylum[orc].snapperLine());
    description.listAppend($phylum[undead].snapperLine());
    description.listAppend($phylum[constellation].snapperLine());

    resource_entries.listAppend(ChecklistEntryMake("__familiar red-nosed snapper", "familiar.php?action=guideme&pwd=" + my_hash(), ChecklistSubentryMake("Track monsters", "+1 item / 11 kill of tracked phylum", description)));
}
