RegisterResourceGenerationFunction("IOTMPowerfulGloveGenerateResource");
void IOTMPowerfulGloveGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupItem("Powerful Glove").have()) return;

    ChecklistSubentry getCharge() {
        int charge = get_property_int("_powerfulGloveBatteryPowerUsed");
        int chargeLeft = 100 - charge;

        // Title
        string main_title = chargeLeft + "% battery charge";

        // Subtitle
        string subtitle = "";

        // Entries
        string [int] description;
        if (chargeLeft > 0) {
            description.listAppend(HTMLGenerateSpanOfClass("Invisible Avatar (5% charge):", "r_bold") + " -10% combat.");
            description.listAppend(HTMLGenerateSpanOfClass("Triple Size (5% charge):", "r_bold") + " +200% all attributes.");
            if (chargeLeft > 5) {
                description.listAppend(HTMLGenerateSpanOfClass("Replace Enemy (10% charge):", "r_bold") + " Swap monster.");
            }
            description.listAppend(HTMLGenerateSpanOfClass("Shrink Enemy (5% charge):", "r_bold") + " Delevel.");
        }

        return ChecklistSubentryMake(main_title, subtitle, description);
    }

    ChecklistEntry entry;
    entry.image_lookup_name = "__item Powerful Glove";
    entry.url = "skillz.php";
    entry.tags.id = "Powerful glove skills resource";

    ChecklistSubentry charge = getCharge();
    if (charge.entries.count() > 0) {
        entry.subentries.listAppend(charge);
        resource_entries.listAppend(entry);
    }
}

RegisterTaskGenerationFunction("IOTMPowerfulGloveTask");
void IOTMPowerfulGloveTask(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!$item[Powerful Glove].have()) return;
    if (!__misc_state["in run"] || $item[Powerful Glove].have_equipped()) return;

    boolean is_plumber = my_path_id() == PATH_OF_THE_PLUMBER;

    if (!is_plumber) {
        if (__quest_state["Level 13"].state_boolean["digital key used"] || $item[digital key].available_amount() + $item[digital key].creatable_amount() > 0) return;
    }

    optional_task_entries.listAppend(ChecklistEntryMake("__item white pixel", "place.php?whichplace=forestvillage&action=fv_mystic", ChecklistSubentryMake("Get extra pixels" + (is_plumber ? " and coins" : ""), "", "Equip Powerful Glove"), is_plumber ? -10 : 0).ChecklistEntrySetIDTag("Powerful glove equip reminder"));
}
