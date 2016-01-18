template {
  source = "/opt/consul/template.d/mesos-nginx.conf.ctmpl"
  destination = "/etc/nginx/sites-available/mesos-nginx.conf"
  command = "ln -s /etc/nginx/sites-available/mesos-nginx.conf /etc/nginx/sites-enabled/mesos-nginx.conf; service nginx reload"
  perms = 0600
}
