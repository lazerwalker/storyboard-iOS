# Storyboard-iOS

This is an iOS wrapper for the [Storyboard](https://github.com/lazerwalker/storyboard.git) multilinear storytelling engine. Just like Storyboard itself, this is considered alpha software. It isn't yet reasonably expected that anyone who isn't me will be able to use this.


## Setup and Usage

This contains an Xcode project which itself contains two targets:

* A framework (`Storyboard`) that wraps the Storyboard runtime engine in a native Swift API
* An example project (`Storyboard-Example`) that shows how to wire up a Storyboard `.story` file with a few native Swift inputs and outputs

Currently, the version of the JS Storyboard engine is hardcoded to pull from a different location on my hard drive and isn't actually included in this repo. In order for this to actually work, you'll need to follow the setup instructions for the [Storyboard](https://github.com/lazerwalker/storyboard.git) repo, build Storyboard, and manually copy the generated `bundle.js` file into this project (as part of the `Storyboard` target).

Eventually, this'll be available on both CocoaPods and Carthage, with a prebaked copy of `bundle.js`, but it's not quite mature enough for that yet.


## Future plans

When this is a bit more mature, I plan to offer a standalone library that wraps Storyboard in a  native iOS interface. It's likely I may also offer a set of standard input/output widgets, taken from projects such as this one (e.g. text-to-speech output using Apple's APIs). Stay tuned!

## License

This project is licensed under the MIT License. See the LICENSE file in this repository for more information.