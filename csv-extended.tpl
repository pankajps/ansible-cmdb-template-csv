<%

import sys
import csv


cols = [
  {"title": "UUID",             "id": "uuid",             "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_product_uuid', '')},
  {"title": "Epoch",            "id": "epoch",            "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_date_time', {}).get('epoch', '')},
  {"title": "Name",             "id": "name",             "visible": True, "field": lambda h: h.get('name', '')},
  {"title": "OS",               "id": "os",               "visible": True, "field": lambda h: h['ansible_facts'].get('ansible_distribution', '') + ' ' + h['ansible_facts'].get('ansible_distribution_version', '')},
  {"title": "Architecture",     "id": "architecture",     "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_architecture', '')},
  {"title": "Kernel",           "id": "kernel",           "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_kernel', '')},
  {"title": "Supplier",         "id": "supplier",         "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_system_vendor', '')},
  {"title": "IPv4 default",     "id": "ipv4_default",     "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_default_ipv4', {}).get('address', '')},
  {"title": "IPv6 default",     "id": "ipv6_default",     "visible": True, "field": lambda h: host['ansible_facts'].get('ansible_default_ipv6', {}).get('address', '')},
  {"title": "Mem",              "id": "mem",              "visible": True, "field": lambda h: '%0.0f' % (int(host['ansible_facts'].get('ansible_memtotal_mb', 0)) / 1000.0)},
  {"title": "MemFree",          "id": "memfree",          "visible": True, "field": lambda h: '%0.0f' % (int(host['ansible_facts'].get('ansible_memfree_mb', 0)) / 1000.0)},
  {"title": "MemUsed",          "id": "memused",          "visible": True, "field": lambda h: '%0.0f' % (int(host['ansible_facts'].get('ansible_memory_mb', {}).get('real', {}).get('used',0)) / 1000.0)},
  {"title": "CPUs",             "id": "cpus",             "visible": True, "field": lambda h: str(host['ansible_facts'].get('ansible_processor_count', 0))},
  {"title": "Disk avail",       "id": "disk_avail",       "visible": True, "field": lambda h: ', '.join(['{0:0.1f}'.format(i['size_available']/1048576000) for i in host['ansible_facts'].get('ansible_mounts', []) if 'size_available' in i and i['size_available'] > 1])},
]

# Enable columns specified with '--columns'
if columns is not None:
  for col in cols:
    if col["id"] in columns:
      col["visible"] = True
    else:
      col["visible"] = False

def get_cols():
  return [col for col in cols if col['visible'] is True]

fieldnames = []
for col in get_cols():
  fieldnames.append(col['title'])

writer = csv.writer(sys.stdout, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
writer.writerow(fieldnames)
for hostname, host in hosts.items():
  if 'ansible_facts' not in host:
    sys.stderr.write('{0}: No info collected'.format(hostname))
  else:
    out_cols = []
    for col in get_cols():
      out_cols.append(col['field'](host))
    writer.writerow(out_cols)
%>
