# EmojiAsciiArt.spoon
Spoon for creating sick-ass ASCII Art with emojis.


## What this Spoon does

This is a [Spoon](https://www.hammerspoon.org/Spoons/) (or plugin) for Hammerspoon that converts a string of text into ASCII art using a series of emojis as the foreground & background.

If you aren't familiar with  [Hammerspoon](https://www.hammerspoon.org/) yet, it is a powerful programmable automation tool for macOS.

Using this Spoon in concert with Hammerspoon, you can do things like:
- Input text & 2 emojis to create ASCII art that can be sent on Slack or other messaging tools
- That's it & I'm sure it's enough.

## How to install this Spoon

1. Make sure that you have Hammerspoon installed

   If it's not installed already, then use the [Getting Started with Hammerspoon](https://www.hammerspoon.org/go/) guide to learn how to install and use Hammerspoon.

2. Install the EmojiAsciiArt Spoon

   The easiest way to do this is to download the [ZIP version of this Spoon](https://github.com/luke-brooks/EmojiAsciiArt.spoon/archive/main.zip), unzip it, remove the `-main` from the folder name, then double click the `EmojiAsciiArt.spoon` folder. Hammerspoon will install it for you.

> If you plan on modifying the Spoon and sending a pull request to this repo, then you should clone this repo into your `~/.hammerspoon/Spoons`

## How to use this Spoon

Open your Hammerspoon configuration file and edit it to make use of this Spoon. Below is a sample configuration that does the following:

- Starts the EmojiAsciiArt Spoon
- Assigns the `F1` button to gather text & emoji payload then pastes the output ASCII art

``` lua
hs.loadSpoon('EmojiAsciiArt')

hs.hotkey.bind('', 'f1', function()
    emojiAsciiArt:convertToAsciiArt()
end)
```

## EmojiAsciiArt Spoon API

``` lua
spoon.EmojiAsciiArt:convertToAsciiArt()
spoon.EmojiAsciiArt:debug() -- enables hs.printf() logging in hs console
```

## Future Enhancements

- Add support for multi-word messages (whitespace characters disrupt emojification)
- Better string input format validation
- Add support for a `?` that isn't ugly as sin
- Add support for `:` if I ever feel like, it'll be a PITA I'm sure
- README documentation about what the output actually looks like & stuff

## Credit Where It's Due

This unoriginal Spoon idea was lovingly copied from [Nick Ellsworth's](https://nickmakes.website/) [Slack Emoji Converter](https://nickmakes.website/slack-emoji-converter/) AngularJS tool. Your brilliant idea has brought countless laughs to myself, friends, coworkers, and colleagues.
