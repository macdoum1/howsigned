# howsigned
howsigned is a ruby gem utility to see how binaries contained in an .ipa are signed

The contained binary extensions used with the commands are defined [here](https://github.etsycorp.com/mmacdougall/howsigned/blob/master/lib/contained_binaries_definition.rb) 

https://rubygems.org/gems/howsigned

# Installation
```gem install howsigned```

# Usage

To print entitlements of all contained binaries in plist format keyed by application-identifier

```howsigned entitlements test.ipa```

To print all embedded provisioning profiles of contained binaries in plist format keyed by AppNameID

```howsigned profiles test.ipa```

To print expiration dates of all provisioning profiles in plist format keyed by AppNameID

```howsigned profiles --expiration test.ipa```

To check codesigning on all contained binaries

```howsigned verify test.ipa```

To compare entitlements and profiles between two .ipa files

```howsigned compare testA.ipa testB.ipa```

