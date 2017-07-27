class tecasplunk::platform::cli(
  $splunk_user  = $tecasplunk::params::splunk_user,
  $port_deploy  = $tecasplunk::params::deploy_port,
  $port_forward = $tecasplunk::params::forward_port,
  $server       = $tecasplunk::params::server,
  )
  inherits tecasplunk::params
{
  # exec for linux family
  @exec { 'start_splunkforwarder':
    path    => "${tecasplunk::params::forwarder_dir}/bin",
    command => 'splunk start --accept-license --answer-yes ',
    user    => $splunk_user,
    tag     => 'splunk_forwarder_accept',
  }
  @exec { 'deploy_splunkforwarder':
    path    => "${tecasplunk::params::forwarder_dir}/bin",
    command => "splunk set deploy-poll ${server}:${port_deploy} -auth admin:changeme ",
    user    => $splunk_user,
    tag     => 'splunk_forwarder_deploy',
  }
  @exec { 'forward_splunkforwarder':
    path    => "${tecasplunk::params::forwarder_dir}/bin",
    command => "splunk add forward-server ${server}:${port_forward} -auth admin:changeme ",
    user    => $splunk_user,
    tag     => 'splunk_forwarder_forward',
  }
  @exec { 'restart_splunkforwarder':
    path    => "${tecasplunk::params::forwarder_dir}/bin",
    command => 'splunk restart -',
    user    => $splunk_user,
    tag     => 'splunk_forwarder_restart',
  }
}
