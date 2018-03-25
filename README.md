# currency-rates
This project has been made using **Xcode 9.2** and **Swift 4**.

The purpose of this project is a simple demonstration of having a live feed of currency pairs that is updated every 10 seconds. If the new price is greater than the previous price, the price is displayed in green, otherwise in red.

The project contains a **ViewController** in which there is a table view that displays the currency pair and its latest price. 

The **NetworkManager** class is responsible for making the API call and returning the response received from the server to the ViewController.

The **Rates** model conforms to `Codable` which was introduced in Swift 4 to enable easy parsing of **JSON** data.

The **RepeatingTimer** class has been used from https://github.com/danielgalasko that uses `DispatchSourceTimer` to create a repeating event.

Pull-to-refresh has also been implemented on the table view. This fires the API and the latest data is shown.
