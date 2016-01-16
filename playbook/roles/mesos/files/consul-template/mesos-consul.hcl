template {
  source = "/opt/consul/template.d/mesos-nginx.conf.ctmpl"
  destination = "/etc/nginx/sites-available/mesos-nginx.conf"
  perms = 0600
}
