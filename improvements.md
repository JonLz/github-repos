# General Improvements

### Design & Layout
* Modularize layout by feature vs. having a sprawling namespace in a single Layout file
* Move towards stateful components  (e.g. login buttons with their own loading state/spinners)
* Inline error views (e.g. render the error on screen instead of in an alert)

### Errors
* Add more descriptive errors throughout the app

### Login states
* Handle the cases when an authentication token is expired (user changes their credentials via web)
* Handle personal access tokens (this might already work, I didn't test it)
* Use the oauth flow to avoid having to ask for credentials at all

### Networking
* Use a protocol instead of a concrete class to enable testability (replace BaseTransport usages with an injected Networking protocol)
* Add a caching layer to avoid duplicate requests
* Add a few additional networking layers to handle typical error states

### Storage
* Use the keychain instead of NSUserDefaults to store sensitive information

### View architecture
* While promise behavior is not exposed directly to the view controller we still generally don't want to be executing promises directly in the view controller. Below are some options we can discuss.
* Move to a more testable architecture depending on the direction of the codebase
	* MVVM if we have simple interactions and want to test protocol boundaries with mocks
	* VIPER if individual modules are complex with a lot of interactions that need unit testing
* Invest in a lightweight bindings system to move away from delegates
	* RxSwift if the team is comfortable with it, or wait for Combine
	* Delegates are fine they just require more code in general

# Specific Improvements

### Login
* Add validations and responsive button states (disabled, enabled) based on user input (empty username/pass, invalid email, etc.)

### Repositories
* Add paging support if a user has a lot of repositories (I tested this with a user with only a few repos)

### Repository details
* Support retrying on errors or reloading the whole page
* Size the detail statistic components across all states instead of dynamically
* Present a chart as soon as data is finished loading or load the chart inline with the rest of the components since it's not obvious you can tap on a component right now
* Crawl all of the issues and pull request data rather than just the first page of results (github paginates results to 100 per page max)
* Invest in a more modular architecture for this screen depending on the direction it takes. While it's the largest file by LOC and has some complexity the code is still pretty straightforward so I left it as is.

### StatisticSeriesData
* Definitely want some unit tests as the business logic is very specific and deals with date parsing. It's also a core component that powers views that have high user visibility
