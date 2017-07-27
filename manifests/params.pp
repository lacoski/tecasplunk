class tecasplunk::params(
  $deploy_port          = '8089',
  $forward_port         = '9997',
  $admin                = 'admin',
  $passwd               = 'changeme',
  $version              = '6.6.2',
  $build                = '4b804538c686',
  $source               = 'puppet:///modules/tecasplunk',
  $forwarder_installdir = undef,
  $splunk_user          = 'root',
  $server               = '10.0.0.160',
  )
{
  #$forwarder_dir - forwarder_dir
  if $::osfamily == 'Windows' {
    $forwarder_dir = pick($forwarder_installdir, 'C:/Program Files/SplunkUniversalForwarder')

  } else {
    $forwarder_dir = pick($forwarder_installdir, '/opt/splunkforwarder')

  }
  notify{"value ${forwarder_installdir}":}
  #$pkg_provider -> cli.pp
  case $::osfamily {
    'RedHat':  { $pkg_provider = 'rpm'  }
    'Debian':  { $pkg_provider = 'dpkg' }
    'Solaris': { $pkg_provider = 'sun'  }
    default:   { $pkg_provider = undef  } # Don't define a $pkg_provider
  }
  case "${::osfamily} ${::architecture}" {
    'RedHat x86_64': {
      $package_suffix       = "${version}-${build}-linux-2.6-x86_64.rpm" #cli.pp
      $forwarder_pkg_name   = 'splunkforwarder' #cli.pp
      $server_pkg_name      = 'splunk'          #cli.pp
    }
    default: { fail("unsupported osfamily/arch ${::osfamily}/${::architecture}") }
  }
}
