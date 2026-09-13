# CHANGELOG

## 2.0.0

* **Breaking:** Convert from a Flutter plugin to a pure Dart package (remove the `flutter` SDK dependency); the package can now be used in any Dart project, not just Flutter
* Fix a bug where `Formula1Data` closed its shared `Dio` client after the first API call, causing every subsequent call on the same instance to silently fail and return `null`/an empty list
* Correct the package description, which incorrectly referred to graphing/charting features that don't exist
* Add an `example/` directory with a runnable usage sample
* Add `topics` and `issue_tracker` to `pubspec.yaml`
* Switch from `flutter_lints` to `lints` and update dev dependencies to their latest versions
* Remove an unused duplicate `PitStop` model file
* Fix incorrect field/method names in the README usage sample (`Circuit.circuitName`, `getLaps`, `PitStop.driver.driverId`)

## 1.2.1

* Fix getRace method to handle datetime fields correctly

## 1.2.0

* Fix datetime handling by combining separate date and time fields into a single datetime field
* Fix various datetime related bugs and inconsistencies

## 1.1.0

* Rename Formula1Api class to Formula1Data

## 1.0.0

* Add sprint race related methods (getSprint, getDriverSprint, getConstructorSprint, getSprintByRound)
* Add qualifying related method (getQualifying)
* Add race detail methods (getPitStops, getLapTimes, getStatus)

## 0.2.0

* Create getDriverStanding method.
* Create getConstructorsStanding method.

## 0.1.8

* Fixed export files.

## 0.1.7

* Create getCircuit method.

## 0.1.6

* Delete widget folder.

## 0.1.5

* Fixed export files.

## 0.1.4

* Update refactoring.
* Create getSchedule method.

## 0.1.3

* Update example.
* Create ResultTable widget.

## 0.1.2

* Linked GitHub.
* Linked Homepage.
* Add comments.

## 0.1.1

* Update LICENSE.

## 0.1.0

* Initial release.
