# UIImageDefaults
Simple Swift extension for locally saving and loading images with ease.

## Installation - TODO
Using pods

## Usage

### Import the package to use with an image
```Swift

import UIImageDefaults

// Let's say we have an image that we have downloaded from somewhere:
var image = downloadImage()
```
### User Defaults
```Swift
// If we would like to use this image in our app all the time without having to download it every time,
// we can save it to the UserDefaults.
let userDefaults = UserDefaults()

// We can save (and override) the image to user defaults:
userDefaults.set(value: image, forKey: "myImage")

// and then restore it from user defaults:
image = userDefaults.uiimage(forKey: "myImage")

// Then delete it from the cache, so that we aren't taking up too much room:
userDefaults.removeImage(forKey: "myImage")

// Or remove all images in our cache:
userDefaults.removeImages()

```
### UIImage
```Swift
// Instead of interfacing through the UserDefaults, we can also interface directly with the UIImage class:
image.saveImage(forKey: "myImage")            // Saving
image = UIImage.getImage(forKey: "myImage")   // Loading
image = UIImage(forKey: "myImage")            // Initialising
UIImage.removeImage(forKey: "myImage")        // Removing
UIImage.removeImages()                        // Removing all

```
### UIImageView
```Swift
// Furthermore, we can also cleanly interact with the UIImageView class to load and store images without hassle.
// We can easily load into a UIImageView from a URL.
let url = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"
let imageView = UIImageView(frame: view.bounds)

// loadCachedImage(withUrl, checkForUpdates) will load from the cache if it is available, and then if
// checkForUpdates is true it will update the image view will the latest content from the URL. If the
// image is not in the cache, it will default to loading from the URL. Each time the image is loaded
// from the URL, it will be saved to the cached with the (modified( URL as the key.
imageView.loadCachedImage(withUrl: url, checkForUpdates: true)

// loadCachedImage(withKey, checkForUpdates, withLoader) operates with the same logic except the user
// is able to provide their own UIImage loading logic. The caching will operate the same, so long as
// the user calls the completion handler correctly on failure and success, providing either the image
// on success or a nil value on failure.
imageView.loadCachedImage(withKey: "google", checkForUpdates: true) { (done: @escaping (UIImage?) -> Void) in
    URLSession.shared.dataTask(with: URL(string: url)!) {
        (data: Data?, resposnse: URLResponse?, error: Error?) -> Void in
        guard let data = data, error == nil else {
            // Call the completion handler when you've failed
            done(nil)
            return
        }
        DispatchQueue.main.async {
            // And call the completion handler when you've succeded
            done(UIImage(data: data))
        }
    }.resume()
}

// Now this looks a little confusing and you won't want your code looking that everywhere, but that's
// ok because there is a solution. If you are loading your images in the same way we can easily wrap
// that into a function to make your loadCachedImage(...) code short and simple.
// Using the same, load from url example, we can create a function, customImageLoader:
func customImageLoader(url: String) -> ((@escaping (UIImage?) ->()) -> Void) {
    return { (done: @escaping (UIImage?) -> Void) in
        URLSession.shared.dataTask(with: URL(string: url)!) {
            (data: Data?, resposnse: URLResponse?, error: Error?) -> Void in
            guard let data = data, error == nil else {
                // Call the completion handler when you've failed
                done(nil)
                return
            }
            DispatchQueue.main.async {
                // And call the completion handler when you've succeded
                done(UIImage(data: data))
            }
        }.resume()
    }
}

// Then we can easily resuse this code everywhere:
imageView.loadCachedImage(withKey: "google", checkForUpdates: true, withLoader: customImageLoader(url: url))
let url2 = "https://avatars0.githubusercontent.com/u/9919?s=280&v=4"
imageView2.loadCachedImage(withKey: "github", checkForUpdates: true, withLoader: customImageLoader(url: url2))
```

## License
Available under the [MIT License](https://github.com/mattDavo/Lingo/blob/master/LICENSE)
