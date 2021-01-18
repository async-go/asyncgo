---
layout: default
title: 'AsyncGo Documentation'
description: Learn how to use AsyncGo
---

## Introduction

Welcome to AsyncGo, a meeting replacement tool that helps you:

- Replace meetings with a collaborative discussion workspace
- Manage ongoing topics with your team in a shared agenda that everyone can contribute to

Table of Contents

* TOC
{:toc}

---

## Async Working

The first step to getting the most out of AsyncGo is to familiarize yourself with async working.

Async is a way of working, useful for remote, colocated, or hybrid companies, where collaboration is done via a digital workspace
rather than in syncronous meetings/discussions. This gives the flexibility for any team member to choose
their own workday based on when they like to focus or have other commitments.

#### Resources

Here are some good places to learn more about async work:

- [What is Async? Understanding How to Collaborate Remotely and Solve Zoom Fatigue](https://www.hrexchangenetwork.com/employee-engagement/columns/what-is-async-understanding-how-to-collaborate-remotely-and-solve-zoom-fatigue)
- [GitLab's Async Work Handbook](https://about.gitlab.com/company/culture/all-remote/asynchronous/)

---

## Topics

AsyncGo is oriented around temporary **topics** that are created, typically from a pre-existing meeting or issue, that can
represent any discussion topic that needs to be had. A topic is meant to exist for a short period of time during which
everyone contributes their thoughts.

At the end the discussion is resolved and the final outcomes and/or decisions are recorded.

#### The Topic List

When you log in you'll see a list of open topics. From here you can click on any of the available topics
to participate.

#### Creating Topics

From the topic list click on "New Topic" to create a topic. You will be prompted to enter a description and a title.
Topic descriptions set the table for the conversation to be had and are very important. You can use [markdown](markdown.html)
to enter richer content than plain text; we recommend including a checklist of key points to discuss, which can be marked
off as you go, and potentially an embedded video recording to help set the context.

#### Collaborating on Topics

Once the topic is set up you can share it with everyone who you want to participate. Everyone can collaborate async as
you go, discussing the topic at hand until you reach your outcome.

#### Resolving Topics

Now that your topic is complete you can mark it as resolved. This will freeze further edits.

---

## Teams

Teams in AsyncGo represent one group of users who collaborate with each other. Teams are
billed as one unit, based on the total number of members.

#### Managing Teams

From the Teams page you are able to add and remove users. A few important notes:

- Users must be individually invited from the Teams page
- There are no limitations on domain name as to who can be invited to the team
- An individual user, as defined by one email address, may only be a member of one team

---

## Markdown

AsyncGo uses [GFM markdown](https://github.github.com/gfm/) for rich content, and supports all tags listed in their documentation.
There are a few common keywords used to support discussions which are highlighted here.

#### Checklists

It's very helpful to use checklists to define the set of things you're going to discuss, and then you can mark them
off as you go. Checklists are entered as follows:

```
- [ ] An unchecked checkbox
- [x] A checked checkbox
```

#### Links

Links can be added as follows:

```
[Link description](https://www.google.com)
```

#### Images

Images are added similarly:

```
![foo](/url "https://www.google.com/with-my-image.png")
```

#### Videos

Adding videos is done by adding images with links. Since it's not possible to embed the video directly, you show the video thumbnail instead as an image and then link to the video. With YouTube for example you would replace `VIDEO_ID` below with the actual video ID:

```
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)
```
