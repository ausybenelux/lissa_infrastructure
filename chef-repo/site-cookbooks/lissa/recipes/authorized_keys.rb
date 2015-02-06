file '/home/' + node['web_user'] + '/.ssh/authorized_keys' do
  owner     #{web_user}
  group     #{web_user}
  mode      '0600'
  content   node['lissa'].authorized_keys.join("\n")
end
