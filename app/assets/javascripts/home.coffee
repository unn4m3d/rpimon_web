m_handler = (id) ->
	api = new RMonAPI("/mirror/#{id}")
	return (show,cb) ->
		api.query("",{"show": show,"catch":true},cb)

a_section = (elem,name) ->
	elem.append($("<tr></tr>").append(
		$("<th></th>").text(name),
		$("<th></th>"),$("<th></th>")
	))

a_subsection = (elem, key, value) ->
	elem.append($("<tr></tr>").append(
			$("<td></td>"),
			$("<td></td>").text(key),
			$("<td></td>").html(value)
		)
	)

null_pr = (val,max) ->
	"#{val}/#{max}"



size_pr = (val,max) ->
	_size_pr = (value) ->
		suffixes = ["K","M","G","T","E"]
		i = 0
		while value > 1024.0 && i < suffixes.length-1
			value /= 1024.0
			i++

		Math.round(value*10)/10 + " " + suffixes[i] + "B"
	
	v = _size_pr val
	m = _size_pr max

	if v.slice(-2) == m.slice(-2)
		v = v.slice(0,-2)

	"#{v}/#{m}"

calc_p = (max, c) ->
	Math.ceil((c*100)/max)

perc_pr = (val,max) ->
	"#{calc_p(max,val)}%"


c_progress = (max,current,prettify = null_pr)->
	
	aria_values = (m,c) ->
		"aria-valuenow='#{c}' aria-valuemin='0' aria-valuemax='#{m}'"

	$("<div class='progress'></div>").append(
		$("<div class='progress-bar' role='progressbar' #{aria_values(max,current)} style='width:#{calc_p(max,current)}%;'></div>").html(
			"<span class='progress-text'>#{prettify(current,max)}</span>"
		)
	)

window.onload = ()->
	$(".machine-data").each ()->
		e = $(this);
		e.find(".update-btn").click( ()->
			console.log("Updating")
			e.find("table.info").find("tbody").empty()
			e.find(".status-bar").text("Loading...")
			m_handler(e.data("m-id"))("load,mem,disk,temp,who,up", (data)->
				console.log(data)
				if data.error
					if data.refused
						e.find(".status-bar").data("error","true")
						e.find(".status-bar").text(data.summary)
					else if data.statusText is "timeout"
						e.find(".status-bar").data("error","true")
						e.find(".status-bar").text("Connection refused!")
					else
						e.find(".status-bar").data("error","true")
						e.find(".status-bar").text("#{data.summary}! See console")
					
				else
					t = e.find("table.info>tbody")
					for k, v of data
						switch k
							when "disk_usage"
								a_section(t,"Disks")
								for disk in v
									unless /tmp/i.test(disk.filesystem) or /^\/dev/.test(disk.mountpoint)
										a_subsection(
											t,
											disk.mountpoint,
											c_progress(disk.size,disk.used,size_pr)
										)
							when "memory_usage"
								a_section(t,"Memory")
								for memo in v
									a_subsection(
										t,
										memo.name,
										c_progress(memo.total,memo.used,size_pr)
									)

							when "cpu_usage"
								a_section(t,"CPU")
								for cpu in v
									a_subsection(
										t,
										if cpu.core == "all" then "All" else cpu.core,
										c_progress(100,parseFloat(cpu.load),perc_pr)
									)

							when "temperature"
								a_section(t,"Temperature")
								for sensor in v
									a_subsection(
										t,
										sensor.name,
										sensor.value
									)

							when "uptime"
								a_section(t,"Uptime")
								a_subsection(
									t,
									"Uptime",
									v
								)
					e.find(".status-bar").text("")			
				
			)
		)

		e.find(".update-btn").trigger("click");
