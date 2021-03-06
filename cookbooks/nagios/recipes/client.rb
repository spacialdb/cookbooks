unless node[:skip][:nagios_client]
  tag("nagios-client")

  include_recipe "password"

  package "net-analyzer/nagios-nrpe"

  directory "/etc/nagios" do
    owner "nagios"
    group "nagios"
    mode "0750"
  end

  directory "/etc/nagios/nrpe.d" do
    owner "root"
    group "root"
    mode "0755"
  end

  service "nrpe" do
    action [:enable, :start]
  end

  allowed = search(:node, "tags:nagios-master").map do |n| n['ipaddress'] end

  mysql_nagios_password = get_password("mysql/nagios")

  nagios_conf "nrpe" do
    subdir false
    mode "0640"
    variables :allowed => allowed, :mysql_nagios_password => mysql_nagios_password
  end

  # third-party plugins
  portage_package_keywords "=dev-perl/Nagios-Plugin-0.34"
  portage_package_keywords "=dev-perl/Math-Calc-Units-1.07"
  portage_package_keywords "=net-analyzer/nagios-check_pidfile-1"

  file "/usr/lib/nagios/plugins/check_pidfile" do
    action :delete
    not_if do File.exists?("/var/db/pkg/net-analyzer/nagios-check_pidfile-1") end
  end

  package "net-analyzer/nagios-check_pidfile"
end
