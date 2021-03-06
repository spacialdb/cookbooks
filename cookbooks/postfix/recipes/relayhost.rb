include_recipe "postfix"

mynetworks = search(:node, "ipaddress:[* TO *]").map do |n| n[:ipaddress] end
mynetworks += node[:postfix][:mynetworks]

file "/etc/postfix/mynetworks" do
  content "#{mynetworks.sort.join("\n")}\n"
  owner "root"
  group "root"
  mode "0644"
end

postconf "allowed relay clients" do
  set :mynetworks => "127.0.0.1/32 /etc/postfix/mynetworks"
end
