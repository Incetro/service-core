![](service-core.png)

<H1 align="center">service-core</H1>

<p align="center">
<a href="https://cocoapods.org/pods/service-core"><img alt="Version" src="https://img.shields.io/cocoapods/v/service-core.svg?style=flat"></a> 
<a href="https://github.com/Incetro/service-core/blob/master/LICENSE"><img alt="Liscence" src="https://img.shields.io/cocoapods/l/service-core.svg?style=flat"></a> 
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a> 
<a href="https://developer.apple.com/swift"><img alt="Swift4.2" src="https://img.shields.io/badge/language-Swift5.3-orange.svg"/></a>
</p>

## Description

This library is a wrapper over the service layer in the VIPER architecture.
 
- [Usage](#Usage)
- [Example](#Example)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Authors](#license)

## Usage <a name="Usage"></a>

To use a *service-core*, all you will need to import 'ServiceCore' module into your swift file:

```swift
import ServiceCore
```

## Example

##### Protocol of a service:

```swift
import ServiceCore

// MARK: - SomeSevice

protocol SomeSevice {

    /// Obtain target entity
    func obtain() -> ServiceCall<YourTargetPlainObject>
}
```

##### Implementation of the service using the `http-transport` framework:

```swift
// MARK: - SomeServiceImplementation

final class SomeServiceImplementation: WebService {

    // MARK: - Initializers

    /// Default initializer
    /// - Parameter:
    ///   - transport: HTTPTransport instance
    init(transport: HTTPTransport) {
        super.init(baseURL: URL(string: "https://yourBaseURL.com/"), transport: transport)
    }
}

// MARK: - SomeSevice

extension SomeSeviceImplementation: SomeSevice {

    func obtain() -> ServiceCall<YourTargetPlainObject> {
        createCall { () -> Result<YourTargetPlainObject, Error> in
            let request = HTTPRequest(
                httpMethod: .get,
                endpoint: "/entity",
                base: self.baseRequest
            )
            let result = self.transport.send(request: request)
            switch result {
            case .success(let response):
                let json = try response.getJSONDictionary() ?? [:]
                let entity = try Mapper<YourTargetPlainObject>().map(JSON: json)
                return .success(entity)
            case .failure(let error):
                log.error(error)
                return .failure(error)
            }
        }
    }
}
```
Learn more about [http-transport](https://github.com/Incetro/http-transport)

## Requirements
- iOS 12.0+
- Xcode 9.0
- Swift 5.3

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Installation <a name="installation"></a>

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To install it using [CocoaPods](https://cocoapods.org), simply add the following line to your Podfile:

```ruby
use_frameworks!

target "<Your Target Name>" do
pod "service-core", :git => "https://github.com/Incetro/service-core", :tag => "[0.0.1]"
end
```
Then, run the following command:

```bash
$ pod install
```
### Manually

If you prefer not to use any dependency managers, you can integrate *service-core* into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add *service-core* as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/incetro/service-core.git
  ```

- Open the new `service-core` folder, and drag the `ServiceCore.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `ServiceCore.xcodeproj ` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `ServiceCore.xcodeproj ` folders each with two different versions of the `ServiceCore.framework` nested inside a `Products` folder.

- Select the `ServiceCore.framework`.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `Nio` will be listed as either `ServiceCore iOS`.

- And that's it!

  > The `ServiceCore.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.
  


## Authors <a name="authors"></a>

TraxxasWyls: savinov.dsta@gmail.com, incetro: incetro@ya.ru


## License <a name="license"></a>

*Validator* is available under the MIT license. See the LICENSE file for more info.