# Storyboard-iOS

This is the reference client for the [Storyboard](https://github.com/lazerwalker/storyboard.git) multilinear storytelling engine. Just like Storyboard itself, this is considered pre-alpha software and is not documented at all.


## Setup and Usage

This is not yet really intended for use by anyone other than myself. That being said:

* This expects a compiled version of storyboard. Until that exists on npm, you'll have to provide that itself. Compile it (see the README in the proper readme) and bring in `bundle.js`.
* Right now, it's hardcoded to read a single `elevator.story` file included.

Knock yourself out.


## Future plans

When this is a bit more mature, I plan to offer a standalone library that wraps Storyboard in a  native iOS interface. It's likely I may also offer a set of standard input/output widgets, taken from projects such as this one (e.g. text-to-speech output using Apple's APIs). Stay tuned!

## License

This project is licensed under the MIT License. See the LICENSE file in this repository for more information.