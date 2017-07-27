class tecasplunk::forwarder(
$pkg_provider      = $tecasplunk::params::pkg_provider,   #done
$splunkd_port      = $tecasplunk::params::deploy_port,    #done
$splunk_user       = $tecasplunk::params::splunk_user,    #done
$package_suffix    = $tecasplunk::params::package_suffix, #done
$package_name      = $tecasplunk::params::forwarder_pkg_name,
  )
  inherits tecasplunk::params
{
  case $::kernel {
    'Linux': {
      file { '/tmp/splunkforwarder/':
        ensure => 'directory',
        recurse => true,
        purge => true,
        source => [
            'puppet:///modules/tecasplunk/universalforwarder/linux/',
        ],
      }
      notify{"Install ${package_name}":}
      notify{"Provider ${pkg_provider}":}
      notify{"Install $source/universalforwarder/linux/${forwarder_pkg_name}-${package_suffix}":}
      package { $package_name:
        ensure          => 'present',
        provider        => $pkg_provider,
        #source          => "$source/universalforwarder/linux/${forwarder_pkg_name}-${package_suffix}",
        source          => "/tmp/splunkforwarder/${forwarder_pkg_name}-${package_suffix}",
        require         => File['/tmp/splunkforwarder/'],
      }
      # xac nhan goi tin cai dat
      include tecasplunk::platform::cli
      # chay sau khi da cai dat
      realize(Exec['start_splunkforwarder'])
      realize(Exec['deploy_splunkforwarder'])
      realize(Exec['forward_splunkforwarder'])
      #realize(Exec['restart_splunkforwarder'])
    }
    default: { } # no special configuration needed
  }


  #realize Exec[tecasplunk::platform::cli::run_puppet_forwarder]
  # running cli.pp
  #notify{"Main class forwarder":}
  #notify{"install dir ${forwarder_installdir}":}
  #notify{"OS ${::osfamily} ${::architecture}":}
  #notify{"package ${tecasplunk::params::package_suffix}":}
  #notify{"Node ${tecasplunk::params::forwarder_dir}":}
  #notify{"Node ${$::kernel}":}

}
