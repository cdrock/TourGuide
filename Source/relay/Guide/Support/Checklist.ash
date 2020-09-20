import "relay/Guide/Support/HTML.ash"
import "relay/Guide/Support/KOLImage.ash"
import "relay/Guide/Support/List.ash"
import "relay/Guide/Support/Page.ash"
import "relay/Guide/Support/Library.ash"
import "relay/Guide/Settings.ash"


record ChecklistSubentry
{
	string header;
	string [int] modifiers;
	string [int] entries;
};


ChecklistSubentry ChecklistSubentryMake(string header, string [int] modifiers, string [int] entries)
{
	boolean all_subentries_are_empty = true;
	foreach key in entries
	{
		if (entries[key] != "")
			all_subentries_are_empty = false;
	}
	ChecklistSubentry result;
	result.header = header;
	result.modifiers = modifiers;
	if (!all_subentries_are_empty)
		result.entries = entries;
	return result;
}

ChecklistSubentry ChecklistSubentryMake(string header, string modifiers, string [int] entries)
{
	if (modifiers == "")
		return ChecklistSubentryMake(header, listMakeBlankString(), entries);
	else
		return ChecklistSubentryMake(header, listMake(modifiers), entries);
}


ChecklistSubentry ChecklistSubentryMake(string header, string [int] entries)
{
	return ChecklistSubentryMake(header, listMakeBlankString(), entries);
}

ChecklistSubentry ChecklistSubentryMake(string header, string [int] modifiers, string e1)
{
	return ChecklistSubentryMake(header, modifiers, listMake(e1));
}

ChecklistSubentry ChecklistSubentryMake(string header, string [int] modifiers, string e1, string e2)
{
	return ChecklistSubentryMake(header, modifiers, listMake(e1, e2));
}


ChecklistSubentry ChecklistSubentryMake(string header, string modifiers, string e1)
{
	if (modifiers == "")
		return ChecklistSubentryMake(header, listMakeBlankString(), listMake(e1));
	else
		return ChecklistSubentryMake(header, listMake(modifiers), listMake(e1));
}

ChecklistSubentry ChecklistSubentryMake(string header)
{
	return ChecklistSubentryMake(header, "", "");
}

void listAppend(ChecklistSubentry [int] list, ChecklistSubentry entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listPrepend(ChecklistSubentry [int] list, ChecklistSubentry entry)
{
	int position = 0;
	while (list contains position)
		position -= 1;
	list[position] = entry;
}

ChecklistSubentry [int] listMake(ChecklistSubentry e1)
{
	ChecklistSubentry [int] result;
	result.listAppend(e1);
	return result;
}


int CHECKLIST_DEFAULT_IMPORTANCE = 0;
record ChecklistEntry
{
	string image_lookup_name;
	string url;
    string [string] container_div_attributes;
	ChecklistSubentry [int] subentries;
	boolean should_indent_after_first_subentry;
    
    boolean should_highlight;
	
	int importance_level; //Entries will be resorted by importance level before output, ascending order. Default importance is 0. Convention is to vary it from [-11, 11] for reasons that are clear and well supported in the narrative.
    boolean only_show_as_extra_important_pop_up; //only valid if -11 importance or lower - only shows up as a pop-up, meant to inform the user they can scroll up to see something else (semi-rares)
    ChecklistSubentry [int] subentries_on_mouse_over; //replaces subentries
    
    string combination_tag; //Entries with identical combination tags will be combined into one, with the "first" taking precedence.
    string identification_tag; //For the "minimize" feature to keep track of the entries. Uses combination_tag instead if present. Uses the first entry's header if empty.
};


ChecklistEntry ChecklistEntryMake(string image_lookup_name, string url, ChecklistSubentry [int] subentries, int importance, boolean should_highlight)
{
	ChecklistEntry result;
	result.image_lookup_name = image_lookup_name;
	result.url = url;
	result.subentries = subentries;
	result.importance_level = importance;
    result.should_highlight = should_highlight;
	return result;
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, int importance)
{
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, importance, false);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, int importance, boolean [location] highlight_if_last_adventured)
{
    boolean should_highlight = false;
    
    if (highlight_if_last_adventured contains __last_adventure_location)
        should_highlight = true;
    return ChecklistEntryMake(image_lookup_name, target_location, subentries, importance, should_highlight);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries)
{
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, CHECKLIST_DEFAULT_IMPORTANCE);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry [int] subentries, boolean [location] highlight_if_last_adventured)
{
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, CHECKLIST_DEFAULT_IMPORTANCE, highlight_if_last_adventured);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, int importance)
{
	ChecklistSubentry [int] subentries;
	subentries[subentries.count()] = subentry;
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, importance);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, int importance, boolean [location] highlight_if_last_adventured)
{
	ChecklistSubentry [int] subentries;
	subentries[subentries.count()] = subentry;
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, importance, highlight_if_last_adventured);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry)
{
	return ChecklistEntryMake(image_lookup_name, target_location, subentry, CHECKLIST_DEFAULT_IMPORTANCE);
}

ChecklistEntry ChecklistEntryMake(string image_lookup_name, string target_location, ChecklistSubentry subentry, boolean [location] highlight_if_last_adventured)
{
	ChecklistSubentry [int] subentries;
	subentries[subentries.count()] = subentry;
	return ChecklistEntryMake(image_lookup_name, target_location, subentries, CHECKLIST_DEFAULT_IMPORTANCE, highlight_if_last_adventured);
}

//Secondary level of making checklist entries; setting properties and returning them.
ChecklistEntry ChecklistEntryTagEntry(ChecklistEntry e, string tag)
{
    e.combination_tag = tag;
    return e;
}

ChecklistEntry ChecklistEntryIDEntry(ChecklistEntry e, string tag)
{
    e.identification_tag = tag;
    return e;
}


void listAppend(ChecklistEntry [int] list, ChecklistEntry entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listAppendList(ChecklistEntry [int] list, ChecklistEntry [int] entries)
{
	foreach key in entries
		list.listAppend(entries[key]);
}

void listClear(ChecklistEntry [int] list)
{
	foreach i in list
	{
		remove list[i];
	}
}


record Checklist
{
	string title;
	ChecklistEntry [int] entries;
    
    boolean disable_generating_id; //disable generating checklist anchor and title-based div identifier
};


Checklist ChecklistMake(string title, ChecklistEntry [int] entries)
{
	Checklist cl;
	cl.title = title;
	cl.entries = entries;
	return cl;
}

Checklist ChecklistMake()
{
	Checklist cl;
	return cl;
}

void listAppend(Checklist [int] list, Checklist entry)
{
	int position = list.count();
	while (list contains position)
		position += 1;
	list[position] = entry;
}

void listRemoveKeys(Checklist [int] list, int [int] keys_to_remove)
{
	foreach i in keys_to_remove
	{
		int key = keys_to_remove[i];
		if (!(list contains key))
			continue;
		remove list[key];
	}
}


string ChecklistGenerateModifierSpan(string [int] modifiers)
{
    if (modifiers.count() == 0)
        return "";
	return HTMLGenerateSpanOfClass(modifiers.listJoinComponents(", "), "r_cl_modifier");
}

string ChecklistGenerateModifierSpan(string modifier) //no longer span, but I'm sure as hell not gonna change every instance of it :V
{
	return HTMLGenerateDivOfClass(modifier, "r_cl_modifier");
}


void ChecklistInit()
{
	PageAddCSSClass("a", "r_cl_internal_anchor", "");
    PageAddCSSClass("", "r_cl_modifier_inline", "font-size:0.85em; color:" + __setting_modifier_colour + ";");
    PageAddCSSClass("", "r_cl_modifier", "font-size:0.85em; color:" + __setting_modifier_colour + "; display:block;");
	
	PageAddCSSClass("", "r_cl_header", "text-align:center; font-size:1.15em; font-weight:bold;");
	PageAddCSSClass("", "r_cl_subheader", "font-size:1.07em; font-weight:bold;");
    PageAddCSSClass("div", "r_cl_entry_first_subheader", "display:flex;flex-direction:row;justify-content:space-between;align-items:flex-start;width:100%;");
    PageAddCSSClass("div", "r_cl_entry_container", "display:flex;flex-direction:row;align-items:flex-start;padding-top:5px;padding-bottom:5px;");
    
    string gradient = "background: #ffffff;background: -moz-linear-gradient(left, #ffffff 50%, #F0F0F0 75%, #F0F0F0 100%);background: -webkit-gradient(linear, left top, right top, color-stop(50%,#ffffff), color-stop(75%,#F0F0F0), color-stop(100%,#F0F0F0));background: -webkit-linear-gradient(left, #ffffff 50%,#F0F0F0 75%,#F0F0F0 100%);background: -o-linear-gradient(left, #ffffff 50%,#F0F0F0 75%,#F0F0F0 100%);background: -ms-linear-gradient(left, #ffffff 50%,#F0F0F0 75%,#F0F0F0 100%);background: linear-gradient(to right, #ffffff 50%,#F0F0F0 75%,#F0F0F0 100%);filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#F0F0F0',GradientType=1 );"; //help
    PageAddCSSClass("", "container_highlighted", gradient + "margin-right:-" + __setting_indention_width + ";padding-right:" + __setting_indention_width + ";"); //counter the checklist_container's padding, so that the gradient won't stop mid-way
    
    PageAddCSSClass("div", "r_cl_entry_image", "width:" + __setting_image_width_large + "px;flex:none;");
    PageAddCSSClass("div", "r_cl_entry_content_container", "flex-grow:1;display:flex;flex-direction:column;text-align:left;align-items:flex-start;");
    
    PageAddCSSClass("hr", "r_cl_hr", "padding:0px;margin:0px;width:auto;"); // could replace by manually adding a border-top to any r_cl_entry_container other than the top one?
    PageAddCSSClass("hr", "r_cl_hr_extended", "padding:0px;margin:0px;width:auto; margin-right: -" + __setting_indention_width + ";");
    PageAddCSSClass("div", "r_cl_collapsed","display:none;");
    PageAddCSSClass("button", "r_cl_minimize_button", "background-color:antiquewhite;padding:0px;font-size:11px;height:18px;width:18px;position:relative;z-index:2;color:#7F7F7F;cursor:pointer;");
    PageAddCSSClass("button", "r_cl_minimize_button:hover", "background-color:black;");
	
    
    PageAddCSSClass("", "r_cl_image_container_large", "display:block;");
    PageAddCSSClass("", "r_cl_image_container_medium", "display:none;");
    PageAddCSSClass("", "r_cl_image_container_small", "display:none;");
    
	PageAddCSSClass("div", "r_cl_checklist_container", "margin:0px; padding-left:" + __setting_indention_width + "; padding-right:" + __setting_indention_width + "; border:1px; border-style: solid; border-color:" + __setting_line_colour + ";border-left:0px; border-right:0px;background-color:#FFFFFF; padding-top:5px;");
    
    //media queries:
    if (true)
    {
        PageAddCSSClass("div", "r_cl_checklist_container", "padding-left:" + (__setting_indention_width_in_em / 2.0) + "em; padding-right:" + (__setting_indention_width_in_em / 2.0) + "em;", 0, __setting_media_query_medium_size);
        PageAddCSSClass("div", "r_cl_entry_container", "padding-top:4px;padding-bottom:4px;", 0, __setting_media_query_medium_size);
        PageAddCSSClass("div", "r_cl_entry_image", "width:" + __setting_image_width_medium + "px;", 0, __setting_media_query_medium_size);
        PageAddCSSClass("hr", "r_cl_hr_extended", "margin-right: -" + (__setting_indention_width_in_em / 2.0) + "em;", 0, __setting_media_query_medium_size);
        PageAddCSSClass("", "container_highlighted", "margin-right:-" + (__setting_indention_width_in_em / 2.0) + "em;padding-right:" + (__setting_indention_width_in_em / 2.0) + "em;", 0, __setting_media_query_medium_size);
        
        
        PageAddCSSClass("div", "r_cl_checklist_container", "padding-left:5px; padding-right:0px;", 0, __setting_media_query_small_size);
        PageAddCSSClass("hr", "r_cl_hr_extended", "margin-right:0px;", 0, __setting_media_query_small_size);
        PageAddCSSClass("", "container_highlighted", "margin-right:0px;padding-right:0px;", 0, __setting_media_query_small_size);
        PageAddCSSClass("div", "r_cl_entry_container", "padding-top:3px;padding-bottom:3px;", 0, __setting_media_query_small_size);
        PageAddCSSClass("div", "r_cl_entry_image", "width:" + __setting_image_width_small + "px;", 0, __setting_media_query_small_size);
        
        
        PageAddCSSClass("div", "r_cl_checklist_container", "padding-left:3px; padding-right:0px;", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("hr", "r_cl_hr_extended", "margin-right:0px;", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("", "container_highlighted", "margin-right:0px;padding-right:0px;", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("div", "r_cl_entry_container", "padding-top:3px;padding-bottom:3px;", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("div", "r_cl_entry_image", "width:0px;", 0, __setting_media_query_tiny_size);
        
        
        
        PageAddCSSClass("", "r_cl_image_container_large", "display:none", 0, __setting_media_query_medium_size);
        PageAddCSSClass("", "r_cl_image_container_medium", "display:block;", 0, __setting_media_query_medium_size);
        PageAddCSSClass("", "r_cl_image_container_small", "display:none;", 0, __setting_media_query_medium_size);
        
        PageAddCSSClass("", "r_cl_image_container_large", "display:none", 0, __setting_media_query_small_size);
        PageAddCSSClass("", "r_cl_image_container_medium", "display:none;", 0, __setting_media_query_small_size);
        PageAddCSSClass("", "r_cl_image_container_small", "display:block;", 0, __setting_media_query_small_size);
        
        PageAddCSSClass("", "r_cl_image_container_large", "display:none", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("", "r_cl_image_container_medium", "display:none;", 0, __setting_media_query_tiny_size);
        PageAddCSSClass("", "r_cl_image_container_small", "display:none;", 0, __setting_media_query_tiny_size);
        
        
        PageAddCSSClass("", "r_indention", "margin-left:" + (__setting_indention_width_in_em / 2.0) + "em;", 0, __setting_media_query_small_size);
        PageAddCSSClass("", "r_indention", "margin-left:" + (__setting_indention_width_in_em / 2.0) + "em;", 0, __setting_media_query_tiny_size);
    }
}

//Creates if not found:
Checklist lookupChecklist(Checklist [int] checklists, string title)
{
	foreach key in checklists
	{
		Checklist cl = checklists[key];
		if (cl.title == title)
			return cl;
	}
	//Not found, create one.
	Checklist cl = ChecklistMake();
	cl.title = title;
	checklists.listAppend(cl);
	return cl;
}

void ChecklistFormatSubentry(ChecklistSubentry subentry) {
    foreach i in subentry.entries {
        string [int] line_split = split_string_alternate(subentry.entries[i], "\\|");
        foreach l in line_split {
            if (stringHasPrefix(line_split[l], "*")) {
                // Indent
                line_split[l] = HTMLGenerateIndentedText(substring(line_split[l], 1));
            }
        }

        // Recombine
        buffer building_line;
        boolean first = true;
        boolean last_was_indention = false;
        foreach key in line_split {
            string line = line_split[key];
            if (!contains_text(line, "class=\"r_indention\"") && !first && !last_was_indention) {
                building_line.append("<br>");
            }
            last_was_indention = contains_text(line, "class=\"r_indention\"");
            building_line.append(line);
            first = false;
        }
        subentry.entries[i] = to_string(building_line);
    }
}

buffer ChecklistGenerateEntryHTML(ChecklistEntry entry, ChecklistSubentry [int] subentries, string [string] anchor_attributes) {
    Vec2i max_image_dimensions_large = Vec2iMake(__setting_image_width_large, 75);
    Vec2i max_image_dimensions_medium = Vec2iMake(__setting_image_width_medium, 50);
    Vec2i max_image_dimensions_small = Vec2iMake(__setting_image_width_small, 50);

    buffer result;
    buffer image_container;
    //string entry_id = entry.subentries[0].header + entry.importance_level.to_string();
    //string entry_id = create_matcher("[^0-9a-zA-Z]", entry_id_raw).replace_all(""); //remove characters that break the .js
    
    image_container.append(KOLImageGenerateImageHTML(entry.image_lookup_name, true, max_image_dimensions_large, "r_cl_image_container_large"));
    image_container.append(KOLImageGenerateImageHTML(entry.image_lookup_name, true, max_image_dimensions_medium, "r_cl_image_container_medium"));
    image_container.append(KOLImageGenerateImageHTML(entry.image_lookup_name, true, max_image_dimensions_small, "r_cl_image_container_small"));
    
    if (anchor_attributes.count() > 0 && !__setting_entire_area_clickable)
        image_container = HTMLGenerateTagWrap("a", image_container, anchor_attributes);
    
    result.append(HTMLGenerateTagWrap("div", image_container, mapMake("class", "r_cl_entry_image")));
    
    buffer entry_content;
    
    string entry_id;
    if (entry.combination_tag != "") //not supposed to happen, but still can
        entry_id = entry.combination_tag;
    else if (entry.identification_tag != "")
        entry_id = entry.identification_tag;
    else
        entry_id = entry.subentries[0].header;
    entry_id = create_matcher("[ \\-.]", entry_id).replace_all("_");
    
    boolean first = true;
    boolean indented_after_first_subentry = false;
    boolean entry_is_just_a_title = true;
    foreach j, subentry in subentries {
        if (subentry.header == "")
            continue;
        string subheader = HTMLGenerateSpanOfClass(subentry.header, "r_cl_subheader");
        
        if (first)
        {
            buffer first_subheader;
            if (anchor_attributes.count() > 0 && !__setting_entire_area_clickable)
                subheader = HTMLGenerateTagWrap("a", subheader, anchor_attributes);
            first_subheader.append(subheader);
            
            //minimize button
            boolean entry_has_content_to_minimize = false;
            int indented_entries;
            foreach j, subentry in subentries {
                if (subentry.header == "")
                    continue;
                
                if (entry.should_indent_after_first_subentry)
                    indented_entries++;
                if (subentry.entries.count() > 0 || indented_entries >= 2) {
                    entry_has_content_to_minimize = true;
                    break;
                }
            }

            if (entry_has_content_to_minimize) {
                first_subheader.append(HTMLGenerateTagWrap("button", "&#9660;", string [string] {"class":"r_cl_minimize_button","alt":"Minimize","title":"Minimize","id":"toggle_" + entry_id,"onclick":"alterSubentryMinimization(event)"}));
            }

            entry_content.append(HTMLGenerateTagWrap("div", first_subheader, string [string] {"class":"r_cl_entry_first_subheader"}));
        }
        else if (entry.should_indent_after_first_subentry && !indented_after_first_subentry)
        {
            entry_content.append(HTMLGenerateTagPrefix("div", mapMake("class", "r_indention " + entry_id)));
            indented_after_first_subentry = true;
        }
        
        if (anchor_attributes.count() > 0 && !__setting_entire_area_clickable) {
            if (subentry.modifiers.count() + subentry.entries.count() > 0 && entry_is_just_a_title) {
                entry_is_just_a_title = false;
                entry_content.append(HTMLGenerateTagPrefix("a", anchor_attributes));
            }
        }
        
        if (!first)
            entry_content.append(HTMLGenerateDivOfClass(subentry.header, "r_cl_subheader"));
        
        if (subentry.modifiers.count() > 0)
            entry_content.append(subentry.modifiers.listJoinComponents(", ").HTMLGenerateDivOfClass("r_indention r_cl_modifier"));

        if (subentry.entries.count() > 0)
        {
            buffer subentry_text;
            for intra_k from 0 to subentry.entries.count() - 1
            { 
                if (intra_k > 0)
                    subentry_text.append("<hr>");
                string line = subentry.entries[listKeyForIndex(subentry.entries, intra_k)];
                
                subentry_text.append(line);
            }
            entry_content.append(HTMLGenerateTagWrap("div", subentry_text, mapMake("class", "r_indention" + (indented_after_first_subentry ? "" : " " + entry_id) )));
        }
        
        first = false;
    }
    if (indented_after_first_subentry)
        entry_content.append("</div>");
    if (anchor_attributes.count() > 0 && !__setting_entire_area_clickable && !entry_is_just_a_title)
        entry_content.append("</a>");
    result.append(HTMLGenerateTagWrap("div", entry_content, mapMake("class", "r_cl_entry_content_container")));
    return result;
}

/**
Generates HTML for a checklist and appends it to the DOM
@param cl The checklist being appended to the DOM
@param output_borders Whether or not to add borders
*/
buffer ChecklistGenerate(Checklist cl, boolean output_borders) {
	ChecklistEntry [int] entries = cl.entries;
	
	//Combine entries with identical combination tags:
	ChecklistEntry [string] combination_tag_entries;
	foreach key, entry in entries {
		if (entry.combination_tag == "") continue;
        if (entry.only_show_as_extra_important_pop_up) continue; //do not support this feature with this
        if (entry.subentries_on_mouse_over.count() > 0) continue;
        if (entry.container_div_attributes.count() > 0) continue;
        
        if (!(combination_tag_entries contains entry.combination_tag)) {
        	entry.importance_level -= 1; //combined entries gain a hack; a level above everything else
            entry.identification_tag = entry.combination_tag;
        	combination_tag_entries[entry.combination_tag] = entry;
            continue;
        }

        ChecklistEntry master_entry = combination_tag_entries[entry.combination_tag];
        
        if (entry.should_highlight) {
        	master_entry.should_highlight = true;
        }

        if (master_entry.url == "" && entry.url != "") {
        	master_entry.url = entry.url;
        }

        master_entry.importance_level = min(master_entry.importance_level, entry.importance_level - 1);
        
        foreach key, subentry in entry.subentries { 
        	master_entry.subentries.listAppend(subentry);
        }

        remove entries[key];
	}
	
	//Sort by importance:
	sort entries by value.importance_level;
	
    //Format subentries:
    foreach index in entries {
        ChecklistEntry entry = entries[index];
        foreach subentryIndex in entry.subentries {
            ChecklistFormatSubentry(entry.subentries[subentryIndex]);
        }
        foreach subentryIndex in entry.subentries_on_mouse_over {
            ChecklistFormatSubentry(entry.subentries_on_mouse_over[subentryIndex]);
        }
    }

	boolean skip_first_entry = false;
	string special_subheader = "";
	if (entries.count() > 0) {
		if (entries[0].image_lookup_name == "special subheader") {
			if (entries[0].subentries.count() > 0) {
				special_subheader = entries[0].subentries[0].header;
				skip_first_entry = true;
			}
		}
	}
	
	buffer result;
    string [string] main_container_map;
    main_container_map["class"] = "r_cl_checklist_container";
    if (!cl.disable_generating_id)
        main_container_map["id"] = HTMLConvertStringToAnchorID(cl.title + " checklist container");
    if (output_borders)
        main_container_map["style"] = "margin-top:12px;margin-bottom:24px;"; //spacing
    else
        main_container_map["style"] = "border:0px;";
    result.append(HTMLGenerateTagPrefix("div", main_container_map));
	
	
    string anchor = cl.title;
    if (!cl.disable_generating_id)
        anchor = HTMLGenerateTagWrap("a", "", mapMake("id", HTMLConvertStringToAnchorID(cl.title), "class", "r_cl_internal_anchor")) + cl.title;
    
	result.append(HTMLGenerateDivOfClass(anchor, "r_cl_header"));
	
	if (special_subheader != "")
		result.append(ChecklistGenerateModifierSpan(special_subheader));
	
	int starting_intra_i = 1;
	if (skip_first_entry)
		starting_intra_i++;
	int intra_i = 0;
	int entries_output = 0;
    boolean last_was_highlighted = false;
    int current_mouse_over_id = 1;
    foreach i, entry in entries
	{
        if (++intra_i < starting_intra_i)
			continue;
        entries_output++;
		if (intra_i > starting_intra_i)
		{
            //add a division (hr) between the entries
            boolean next_is_highlighted = false;
            if (entry.should_highlight)
                next_is_highlighted = true;
            string class_name = "r_cl_hr";
            if (last_was_highlighted || next_is_highlighted)
                class_name = "r_cl_hr_extended";
			result.append(HTMLGenerateTagPrefix("hr", mapMake("class", class_name)));
		}
        string [string] anchor_attributes;
		if (entry.url != "")
            anchor_attributes = {"target":"mainpane", "href":entry.url, "class":"r_a_undecorated"};
        
        buffer entry_content;
        string container_class = "r_cl_entry_container";
        if (entry.should_highlight)
            container_class += " container_highlighted";
        last_was_highlighted = entry.should_highlight;
        
        buffer generated_subentry_html = ChecklistGenerateEntryHTML(entry, entry.subentries, anchor_attributes);
        if (entry.subentries_on_mouse_over.count() > 0)
        {
            buffer generated_mouseover_subentry_html = ChecklistGenerateEntryHTML(entry, entry.subentries_on_mouse_over, anchor_attributes);
            
            //Can't properly escape, so generate two no-show divs and replace them as needed:
            //We could just have a div that shows up when we mouse over...
            //This is currently very buggy.
            entry.container_div_attributes["onmouseenter"] = "event.currentTarget.innerHTML = document.getElementById('r_temp_o" + current_mouse_over_id + "').innerHTML";
            entry.container_div_attributes["onmouseleave"] = "event.currentTarget.innerHTML = document.getElementById('r_temp_l" + current_mouse_over_id + "').innerHTML";
            
            entry_content.append(HTMLGenerateTagPrefix("div", mapMake("id", "r_temp_o" + current_mouse_over_id, "style", "display:none")));
            entry_content.append(generated_mouseover_subentry_html);
            entry_content.append(HTMLGenerateTagSuffix("div"));
            entry_content.append(HTMLGenerateTagPrefix("div", mapMake("id", "r_temp_l" + current_mouse_over_id, "style", "display:none")));
            entry_content.append(generated_subentry_html);
            entry_content.append(HTMLGenerateTagSuffix("div"));
            
            current_mouse_over_id += 1;
        }
        
        if (entry.container_div_attributes contains "class")
        {
            if (!entry.container_div_attributes["class"].contains_text(container_class)) //can happen with entries being pinned in the importance bar, passing here twice
                entry.container_div_attributes["class"] += " " + container_class;
        }
        else
            entry.container_div_attributes["class"] = container_class;
        entry_content.append(HTMLGenerateTagWrap("div", generated_subentry_html, entry.container_div_attributes));

		
		if (anchor_attributes.count() > 0 && __setting_entire_area_clickable)
            entry_content = HTMLGenerateTagWrap("a", entry_content, anchor_attributes);
		
        result.append(entry_content);
	}
	result.append("</div>");
	
	return result;
}

/**
Attaches checklist to DOM.
@param checklist The checklist being appended.
*/
buffer ChecklistGenerate(Checklist checklist) {
    return ChecklistGenerate(checklist, true);
}


Record ChecklistCollection
{
    Checklist [string] checklists;
};

//NOTE: WILL DESTRUCTIVELY EDIT CHECKLISTS GIVEN TO IT
//mostly because there's no easy way to copy an object in ASH
//without manually writing a copy function and insuring it is synched
Checklist [int] ChecklistCollectionMergeWithLinearList(ChecklistCollection collection, Checklist [int] other_checklists)
{
    Checklist [int] result;
    
    boolean [string] seen_titles;
    foreach key, checklist in other_checklists
    {
        seen_titles[checklist.title] = true;
        result.listAppend(checklist);
    }
    foreach key, checklist in collection.checklists
    {
        if (seen_titles contains checklist.title)
        {
            foreach key, checklist2 in result
            {
                if (checklist2.title == checklist.title)
                {
                    checklist2.entries.listAppendList(checklist.entries);
                    break;
                }
            }
        }
        else
        {
            result.listAppend(checklist);
        }
    }
    
    return result;
}

Checklist lookup(ChecklistCollection collection, string name)
{
    if (collection.checklists contains name)
        return collection.checklists[name];
    
    Checklist c = ChecklistMake();
    c.title = name;
    collection.checklists[c.title] = c;
    return c;
}
