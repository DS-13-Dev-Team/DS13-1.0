// ss13-specific metrics
/datum/metric_family/ss13_master_runlevel
	name = "ss13_master_runlevel"
	metric_type = PROMETHEUS_METRIC_GAUGE
	help = "Current MC runlevel"

/datum/metric_family/ss13_master_runlevel/collect()
	if(Master)
		return list(list(null, Master.current_runlevel))
	return list()
