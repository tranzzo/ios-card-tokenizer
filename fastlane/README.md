fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### submit_pod
```
fastlane submit_pod
```
Push the repo to remote and submits the Pod to the given spec repository. Do this after running update to ensure that tests have been run, versions bumped, and changes committed.
### patch
```
fastlane patch
```
This does the following: 



- Runs the unit tests

- Ensures Cocoapods compatibility

- Bumps the patch version
### minor
```
fastlane minor
```
This does the following: 



- Runs the unit tests

- Ensures Cocoapods compatibility

- Bumps the minor version
### major
```
fastlane major
```
This does the following: 



- Runs the unit tests

- Ensures Cocoapods compatibility

- Bumps the major version

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
