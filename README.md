# Storyboard-iOS

This is the reference client for the [Storyboard](https://github.com/lazerwalker/storyboard.git) multilinear storytelling engine. Just like Storyboard itself, this is considered pre-alpha software and is not documented at all.


## Setup and Usage

This is not yet really intended for use by anyone other than myself. That being said:

* This currently expects to exist as a submodule to Storyboard itself. Set this up by cloning Storyboard and running `git submodule init --update`
* Specifically, it expects two things: a compiled `../dist.js` file, and a `../examples` folder containing projects. Any projects that exist there (with a `.json` file and optionally a folder of media assets with the same name as the JSON file) will show up if you hit the Search icon in-app.

Knock yourself out.