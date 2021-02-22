---
layout: docs
title: "AsyncGo Documentation"
description: Learn how to use AsyncGo
---

# Markdown

AsyncGo uses [GFM markdown](https://github.github.com/gfm/) for rich content, and supports all tags listed in their documentation.
There are a few common keywords used to support discussions which are highlighted here.

{% include docs_nav.md %}

## Checklists

It's very helpful to use checklists to define the set of things you're going to discuss, and then you can mark them
off as you go. Checklists are entered as follows:

```markdown
- [ ] An unchecked checkbox
- [x] A checked checkbox
```

## Bullet Lists

You can create bulleted lists using the following format:

```markdown
- Unordered item 1
- Unordered item 2

1. Item 1
2. Item 2
```

Sub-bullets are also possible, in that case you should use two or four spaces to indicate the next level of indent. You
can also mix and match bullet types in this way.

```markdown
- Unordered item 1
- Unordered item 2
  1. Sub-item 1
  2. Sub-item 2
- Unordered item 3
  - Sub-item 1
    - Sub-sub item 1
    - Sub-sub item 2
  - Sub-item 2
```

## Links

Links can be added as follows:

```markdown
[Link description](https://www.google.com)
```

## Images

Images are added similarly:

```markdown
![foo](/url "https://www.google.com/with-my-image.png")
```

## Videos

Adding videos is done by adding images with links. Since it's not possible to embed the video directly, you show the video thumbnail instead as an image and then link to the video. With YouTube for example you would replace `VIDEO_ID` below with the actual video ID:

```markdown
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)
```
