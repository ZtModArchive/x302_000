include "scenario/scripts/needs.lua";
include "scenario/scripts/awards.lua";


SPECIAL_GATE_BINDER = "frontgate_end";

function xaward(group, index)


	-- we set true because there was a previous milestone amount
	-- that must be subtracted in calculating green bar length
	-- (e.g. 100 guests before we get to 1000 guests -- if 101 guests, only .1%
	--  of second bar gets filled)
	awards_update_bar(group.group_xml, index, howMuchCash(), 1000000)
	if (howMuchCash() >= 1000000) then
		awards_set_received_graphics(group, index, true);
		
		-- Give them out the special gate
		setglobalvar("specialgate", SPECIAL_GATE_BINDER);
		
		-- Get the gate to change right away
		local mgr = queryObject("ZTStatus");
		if (mgr) then
			mgr:ZT_PROCESS_FAME_UPDATE();
		else
			BFLOG(SYSTRACE, "error getting ZTStatus in ZooTycoonAward");
		end
		
		showawardpanel();
		return true;
	end
end

awards_group={
	-- incremental awards set: player gets first set, then second, then third...
	-- flag_name: flag in comps to set when condition becomes true
	-- icon_name: refers to names to in XML file named by group_xml below
	-- locid: refers to "before" and "after" loc ids found in lang\1033\awards.XML
	-- args: arg[1] = donation amount to check for, arg[2] = type of award (ed. or ent.)
	{flag_name="zootycoonaward", icon_name="ZooTycoon_award", locid="ZooTycoon", args={} },
	test_func=xaward,
	-- the XML file that defines graphic for this awards group
	group_xml="awards/ZooTycoon.xml",
	process_whole_group=true,
	is_challenge_only=true
}

-- this function stays the same in every awards LUA script
function initaward(comp)
	create_award_group_graphics(awards_group)
end

-- this function stays the same in every awards LUA script
function processaward(comp)
	process_award_group(comp, awards_group)
end

-- this function gets called when the awards group is completely won
function postawardgroupcomplete()
	--do animal crating or whatever
end
