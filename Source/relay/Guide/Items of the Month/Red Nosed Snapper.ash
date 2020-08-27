
RegisterTaskGenerationFunction("IOTMRedNosedSnapperTask");
void IOTMRedNosedSnapperTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupFamiliar("Red Nosed Snapper").familiar_is_usable()) return;
    if (my_familiar() != lookupFamiliar("Red Nosed Snapper")) return;
    if (get_property("redSnapperPhylum") != "") return;

    optional_task_entries.listAppend(ChecklistEntryMake("__familiar red-nosed snapper", "familiar.php?action=guideme&pwd", ChecklistSubentryMake("Track monsters", "", "Choose a phylum".HTMLGenerateSpanOfClass("r_element_important")), 8));
}

RegisterResourceGenerationFunction("IOTMRedNosedSnapperResource");
void IOTMRedNosedSnapperResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupFamiliar("Red Nosed Snapper").familiar_is_usable()) return;
    if (my_familiar() != lookupFamiliar("Red Nosed Snapper")) return;
    if (get_property("redSnapperPhylum") == "") return;

    //int redSnapperProgress = get_property_int("redSnapperProgress");

    string [int] description;
    description.listAppend("Dudes:".HTMLGenerateSpanOfClass("r_bold") + " Free banish item");
    description.listAppend("Goblins:".HTMLGenerateSpanOfClass("r_bold") + " 3-size " + "awesome".HTMLGenerateSpanOfClass("r_element_awesome") + " food");
    description.listAppend("Orcs:".HTMLGenerateSpanOfClass("r_bold") + " 3-size " + "awesome".HTMLGenerateSpanOfClass("r_element_awesome") + " booze");
    description.listAppend("Undead:".HTMLGenerateSpanOfClass("r_bold") + " +5 " + "spooky".HTMLGenerateSpanOfClass("r_element_spooky") + " res potion");
    description.listAppend("Constellations:".HTMLGenerateSpanOfClass("r_bold") + " Yellow ray");

    resource_entries.listAppend(ChecklistEntryMake("__familiar red-nosed snapper", "familiar.php?action=guideme&pwd", ChecklistSubentryMake("Track monsters", "", description)));
}
