/*
var/list/blueprint_paths
// totally stolen from the new player panel.  YAYY

/obj/effect/proc_holder/technomancer/crafting_menu
	name = "-Crafting Menu-" //Dashes are so it's listed before all the other abilities.
	desc = "Choose what to build."
	circuit_cost = 0

/obj/effect/proc_holder/technomancer/crafting_menu/Click()
	if(!usr || !usr.mind || !usr.mind.technomancer)
		return
	var/datum/technomancer/technomancer = usr.mind.technomancer

	if(!blueprint_paths)
		blueprint_paths = init_subtypes(/obj/effect/proc_holder/technomancer)

	var/dat = create_menu(technomancer)
	usr << browse(dat, "window=designs;size=600x700")//900x480


/obj/effect/proc_holder/technomancer/crafting_menu/proc/create_menu(var/datum/technomancer/technomancer)
	var/dat
	dat +="<html><head><title>Technomancer Crafting Menu</title></head>"

	//javascript, the part that does most of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch(){


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{

						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for ( var i = 0; i < ltr.length; ++i )
						{
							try{
								var tr = ltr\[i\];
								if(tr.getAttribute("id").indexOf("data") != 0){
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								//var inner_span = li.getElementsByTagName("span")\[1\] //Should only ever contain one element.
								//document.write("<p>"+search.innerText+"<br>"+filter+"<br>"+search.innerText.indexOf(filter))
								if ( search.innerText.toLowerCase().indexOf(filter) == -1 )
								{
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,name,desc,helptext,design,ownsthis){

					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";

					body += "</td><td align='center'>";

					body += "<font size='2'><b>"+desc+"</b></font> <BR>"

					body += "<font size='2'><span class='danger'>"+helptext+"</span></font> <BR>"

					if(!ownsthis)
					{
						body += "<a href='?src=\ref[src];P="+design+"'>Build</a>"
					}
					body += "</td><td align='center'>";

					body += "</td></tr></table>";


					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(!(id.indexOf("item")==0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++){
							if(locked_tabs\[j\]==id){
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;




						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1"){
						link.setAttribute("name","2");
					}else{
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<span class='danger'>Locked</span> ";
					//link.setAttribute("onClick","attempt('"+id+"','"+link_id+"','"+notice_span_id+"');");
					//document.write("removeFromLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
					//document.write("aa - "+link.getAttribute("onClick"));
				}

				function attempt(ab){
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
					//var link = document.getElementById(link_id);
					//link.setAttribute("onClick","addToLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Technomancer Evolution Menu</b></font><br>
					Hover over a design to see more information<br>
					Current ability choices remaining: [technomancer.geneticpoints]<br>
					By rendering a lifeform to a husk, we gain enough design to alter and adapt our evolutions.<br>
					(<a href='?src=\ref[src];readapt=1'>Readapt</a>)<br>
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/i = 1
	for(var/obj/effect/proc_holder/technomancer/techno_design in blueprint_paths)

		if(techno_design.circuit_cost <= 0) //Let's skip the crap we start with. Keeps the evolution menu uncluttered.
			continue

		var/ownsthis = technomancer.has_blueprint(techno_design)

		var/color
		if(ownsthis)
			if(i%2 == 0)
				color = "#d8ebd8"
			else
				color = "#c3dec3"
		else
			if(i%2 == 0)
				color = "#f2f2f2"
			else
				color = "#e6e6e6"


		dat += {"

			<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
				<td align='center' bgcolor='[color]'>
					<span id='notice_span[i]'></span>
					<a id='link[i]'
					onmouseover='expand("item[i]","[techno_design.name]","[techno_design.desc]","[techno_design.helptext]","[techno_design]",[ownsthis])'
					>
					<b id='search[i]'>Evolve [techno_design][ownsthis ? " - Purchased" : (techno_design.req_circuit>technomancer.huskcount ? " - Requires [techno_design.req_circuit] husks" : " - Cost: [techno_design.circuit_cost]")]</b>
					</a>
					<br><span id='item[i]'></span>
				</td>
			</tr>

		"}

		i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}
	return dat


/obj/effect/proc_holder/technomancer/crafting_menu/Topic(href, href_list)
	..()
	if(!(iscarbon(usr) && usr.mind && usr.mind.technomancer))
		return

	if(href_list["P"])
		usr.mind.technomancer.purchaseDesign(usr, href_list["P"])
	var/dat = create_menu(usr.mind.technomancer)
	usr << browse(dat, "window=designs;size=600x700")
/////

/datum/technomancer/proc/purchaseDesign(var/mob/living/carbon/user, var/blueprint_name)

	var/obj/effect/proc_holder/technomancer/thedesign = null

	if(!blueprint_paths)
		blueprint_paths = init_subtypes(/obj/effect/proc_holder/technomancer)
	for(var/obj/effect/proc_holder/technomancer/techno_blueprint in blueprint_paths)
		if(techno_blueprint.name == blueprint_name)
			thedesign = techno_blueprint

	if(thedesign == null)
		user << "This is awkward. Technomancer design purchase failed, please report this bug to a coder!"
		return

	if(absorbedcount < thedesign.req_circuit)
		user << "We lack the energy to evolve this ability!"
		return

	if(has_blueprint(thedesign))
		user << "We have already evolved this ability!"
		return

	if(thedesign.circuit_cost < 0)
		user << "We cannot evolve this ability."
		return

	if(user.status_flags & FAKEDEATH)//To avoid potential exploits by buying new designs while in stasis, which clears your verblist.
		user << "We lack the energy to evolve new abilities right now."
		return

	geneticpoints -= thedesign.circuit_cost
	purchaseddesigns += thedesign
	thedesign.on_purchase(user)

*/