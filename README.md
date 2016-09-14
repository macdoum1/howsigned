# howsigned
howsigned is a ruby gem utility to see how binaries contained in an .ipa are signed
Ruby gem utility to see how binaries contained in an .ipa are signed

# Installation
```gem install howsigned```

# Usage

To print entitlements of all contained binaries in plist format keyed by application-identifier

```howsigned entitlements test.ipa```

To print all embedded provisioning profiles of contained binaries in plist format keyed by AppNameID

```howsigned profiles test.ipa```

To check codesigning on all contained binaries

```howsigned verify test.ipa```

