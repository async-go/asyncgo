---
layout: default
title: 'AsyncGo Documentation: Markdown'
description: Learn how to use markdown to make rich descriptions in topics
---

AsyncGo uses [GFM markdown](https://github.github.com/gfm/) for rich content, and supports all tags listed in their documentation.
There are a few common keywords used to support discussions which are highlighted here.

## Checklists

It's very helpful to use checklists to define the set of things you're going to discuss, and then you can mark them
off as you go. Checklists are entered as follows:

```
- [ ] An unchecked checkbox
- [x] A checked checkbox
```

## Links

Links can be added as follows:

```
[Link description](https://www.google.com)
```

## Images

Images are added similarly:

```
![foo](/url "https://www.google.com/with-my-image.png")
```

## Videos

Adding videos is done by adding images with links. Since it's not possible to embed the video directly, you show the video thumbnail instead as an image and then link to the video. With YouTube for example you would replace `VIDEO_ID` below with the actual video ID:

```
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)
```