# Puppet Module for PHP composer

[![Build Status](https://travis-ci.org/Brainsware/puppet-composer.png?branch=master)](https://travis-ci.org/Brainsware/puppet-composer)

manage installation of composer as well as the installation and update of projects with composer.

This project was initially forked from [willdurand-composer](https://github.com/willdurand/puppet-composer), adding basic functionality already provided from [tPl0ch-composer](https://github.com/tPl0ch/puppet-composer). Because everyone is a unique snowflake and *we* needed one true (i.e.: our) way of handling composer.


## Documentation

Installing composer

```puppet
     include composer
```

Installing composer from a package:

```puppet
     class { 'composer':
       provider => 'package',
     }
```

Installing composer from a that installs it in a weird directory:

```puppet
     class { 'composer':
       provider   => 'package',
       target_dir => '/opt/es/bin',
     }
```

Installing a project's dependencies with composer. n.b.: This directory must already exist. We recommend tracking it with [puppetlabs-vcsrepo](http://forge.puppetlabs.com/puppetlabs/vcsrepo)

```puppet
     # track yolo-site's stable branch:
     vcsrepo { '/srv/web/yolo':
       ensure   => 'latest'
       provider => 'git',
       source   => 'git://example.com/yolo-site.git',
       revision => 'stable',
     }

     # install yolo project without dev packages:
     composer::project { 'yolo':
       ensure  => 'installed',
       target  => '/srv/web/yolo',
       dev     => false,
       require => Vcsrepo['/srv/web/yolo'],
     }
```

To keep a project up-to-date we can use the `ensure => latest`

```puppet
     # Keep yolo project up-to-date, with dev packages, ignore the lock file:
     composer::project { 'yolo':
       ensure  => 'latest',
       target  => '/srv/web/yolo',
       dev     => true,
       lock    => true,
       require => Vcsrepo['/srv/web/yolo'],
     }
```

## Patches and Testing

Contributions are highly welcomed, more so are those which contribute patches with tests. Or just more tests! We have [rspec-puppet](http://rspec-puppet.com/) and [rspec-system](https://github.com/puppetlabs/rspec-system-serverspec) tests. When [contributing patches](Github WorkFlow), please make sure that your patches pass tests:

```
  igalic@levix ~/src/bw/puppet-composer (git)-[master] % rake spec
  ....................................

  Finished in 2.29 seconds
  36 examples, 0 failures
  igalic@levix ~/src/bw/puppet-composer (git)-[master] % rake spec:system

  ...loads of output...
  2 examples, 0 failures
  igalic@levix ~/src/bw/puppet-composer (git)-[master] %
```

## Release process

The version in Modulefile should be bumped according to [semver](http://semver.org/) *during development*, i.e.: The first commit after the release should already bump the version, as master at this point differs from the latest release.

When cutting a new release, please

* make sure that all tests pass
* make sure that the documentation is up-to-date
* verify that all dependencies are correct, and up-to-date
* create a new, *signed* tag and a package, using rake

```
    igalic@levix ~/src/bw/puppet-composer (git)-[master] % rake release
    git tag -s 1.3.2 -m 't&r 1.3.2'
    ...
    git checkout 1.3.2
    Note: checking out '1.3.2'.
    ...
    HEAD is now at ff9aaae... Most awesome feature added. SHIPIT!
    puppet module build .
    Notice: Building /home/igalic/src/bw/puppet-composer for release
    Module built: /home/igalic/src/bw/puppet-composer/pkg/brainsware-composer-1.3.2.tar.gz
    igalic@levix ~/src/bw/puppet-composer (git)-[1.3.2] %
```

* push the tag,

```
    igalic@levix ~/src/bw/puppet-composer (git)-[1.3.2] % git push --tags origin
```

* and finally [upload the new package](http://forge.puppetlabs.com/brainsware/composer/upload)

License
-------

Apache Software License 2.0


Contact
-------

You can send us questions via mail [puppet@brainsware.org](puppet@brainsware.org), or reach us IRC: [igalic](https://github.com/igalic) hangs out in [#puppet](irc://freenode.org/#puppet)

Support
-------

Please log tickets and issues at our [Project's issue tracker](https://github.com/Brainsware/puppet-composer/issues)
