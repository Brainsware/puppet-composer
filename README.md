# Puppet Module for PHP composer

manage installation of composer as well as the installation and update of projects with composer.


## Documentation

Installing composer

```puppet
     include composer
```

## TODO

* I'd like to have a test case for every single thing that we have documented above.

## Release process

The version in Modulefile should be bumped according to [semver](http://semver.org/) *during development*, i.e.: The first commit after the release should already bump the version, as master at this point differs from the latest release.

When cutting a new release, please

* make sure that all tests pass
* make sure that the documentation is up-to-date
* verify that all dependencies are correct, and up-to-date
* create a new, *signed* tag and a package, using GNU make

    igalic@levix ~/src/bw/puppet-composer (git)-[master] % make release
    git tag -s 1.3.2 -m 't&r 1.3.2'
    ...
    git checkout 1.3.2
    Note: checking out '1.3.2'.
    ...
    HEAD is now at ff9aaae... bump version & explain how versioning should work
    puppet module build .
    Notice: Building /home/igalic/src/bw/puppet-composer for release
    Module built: /home/igalic/src/bw/puppet-composer/pkg/brainsware-composer-1.3.2.tar.gz
    igalic@levix ~/src/bw/puppet-composer (git)-[1.3.2] %

* push the tag,

    igalic@levix ~/src/bw/puppet-composer (git)-[1.3.2] % git push --tags origin

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
