
### Setup

#### Xcode

Built with [Xcode 10.2.1](https://download.developer.apple.com/Developer_Tools/Xcode_10.2.1/Xcode_10.2.1.xip)

Future Xcode versions should be compatible but there are known issues with 9.x versions.

#### Installation

This project uses cocoapods to manage dependencies. Dependency source files are committed directly to the project so you should not need to manually install them. If you do, follow the below steps:

1. `bundle install`
2. `bundle exec pod install`

#### Running the project

`open github-repos.xcworkspace` and run the project in your chosen simulator (recommended: any iPhone simulator on iOS 11.x or 12.x - iOS 13 has not been tested yet)

Since we do not implement code signing you will not be able to run this app on a device.

### Github APIs

This project uses the [Github V3 API](https://developer.github.com/v3/) and the following endpoints:
* [Current authenticated user](https://developer.github.com/v3/users/#get-the-authenticated-user)
* [Issues](https://developer.github.com/v3/issues/#list-issues-for-a-repository)
* [Pull requests](https://developer.github.com/v3/pulls/#list-pull-requests)

Authentication with Github is provided via basic authentication which allows logging in with a username (or email) and password.

### Features

* Log in as Github user and persist a user session
* Log out of a user session
* See a list of the logged in user's public repositories
* See a yearly overview of any of the public repositories following statistics:
	* Open issues
	* Closed issues
	* Open pull requests
	* Closed pull requests
* See a graphical representation of data bucketed by week for the previous year by clicking on any of the above statistic components

### Screenshots

![Login](/screenshots/Login.png "Login")

![Repositories](/screenshots/Repositories.png "Repositories")

![Repository Detail](/screenshots/RepositoryDetail.png "Repository Detail")

### Improvements

See the [Improvements](improvements.md) file
