portage_package_keywords "=app-backup/duply-1.5.2.3"

package "app-backup/duply"

%w(
  /etc/duply
  /var/tmp/backup
  /var/cache/backup
).each do |d|
  directory d do
    owner "root"
    group "root"
    mode "0700"
  end
end

node.set[:lftp][:bookmarks][:backup] = node[:backup][:target_base_url].sub(/^ssh:/, "sftp:")

node[:backup][:configs].each do |name, params|
  directory "/etc/duply/#{name}" do
    owner "root"
    group "root"
    mode "0700"
  end

  template "/etc/duply/#{name}/conf" do
    source "duply.conf"
    owner "root"
    group "root"
    mode "0600"
    variables(params)
  end

  cron_daily "duply-bkp-#{name}" do
    command "/usr/bin/duply #{name} bkp | mailx -s 'Backup report for #{name} on #{node[:fqdn]}' #{node[:contacts][:hostmaster]}"
  end

  cron_weekly "duply-purge-#{name}" do
    command "/usr/bin/duply #{name} purge-full --force &> /dev/null"
  end
end
