[master]
%{ for i in range(length(names)) ~}
%{ if length(regexall("master", split("-", names[i])[1])) > 0 ~}
${names[i]} ansible_host=${addrs[i]}
%{ endif ~}
%{ endfor ~}

[worker]
%{ for i in range(length(names)) ~}
%{ if length(regexall("worker", split("-", names[i])[1])) > 0 ~}
${names[i]} ansible_host=${addrs[i]}
%{ endif ~}
%{ endfor ~}

[all]
%{ for i in range(length(names)) ~}
${names[i]} ansible_host=${addrs[i]}
%{ endfor ~}
