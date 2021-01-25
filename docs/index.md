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

Here are some good places to learn more about async work:

- [What is Async? Understanding How to Collaborate Remotely and Solve Zoom Fatigue](https://www.hrexchangenetwork.com/employee-engagement/columns/what-is-async-understanding-how-to-collaborate-remotely-and-solve-zoom-fatigue)
- [GitLab's Async Work Handbook](https://about.gitlab.com/company/culture/all-remote/asynchronous/)

---

## Getting the most out of AsyncGo

AsyncGo was designed for asynchronous work, which means we intentionally do not hound you for updates.
You won't find phone notifications, loud indicators in the app, constant email reminders, or anything
like that. Instead, the application is designed to be interacted with on your own schedule.

This can be initiall hard to adjust to if you're used to interrupt-driven, realtime work, but once
you're used to it it's quite easy. There are just a few key concepts to understand:

### Timeboxing

We recommend setting a due date on nearly every item. Setting a due date helps your team members
know when they need to reply by. Most users work down the topic list from the ones coming due most soon
to the furthest out, in order to make sure they have a chance to contribute to the topics they are
interested in.

This lets everyone manage their own time to decide what they want to focus on at any given point,
while having the confidence that they won't miss out.

### Clear Communication

Because you aren't meeting as a team and kicking things off with a general Q&A session, at least
via the app, it's important to write a very clear description that sets the table for the problem
at hand. Include links to relevant documentation, sources, and issues, and in general try to not
assume any context from the reader. This will also help you later when the topic is reviewed to see
how a decision was made.

You can also apply some initial structure to the outcome, indicating the format of what you're
looking for in the end. That can also help focus the team and ensure they understand what you
are asking for.

If you are the kind of person who likes to lay things out with words, you can always record audio
or video and [embed it](#video) into the description, outcome, or a comment. Note that embedded videos
are not auto-transcribed, so are not searchable.

### Notifications

The primary way to be notified about what's going on in AsyncGo is via digest notifications. These
are meant to be reviewed a couple times per day, at your convenience, and highlight what's new since
your last visit, as well as any items that are coming due soon.

In this way you aren't constantly being interrupted to respond to the latest reply in a conversation
thread, like you might be in a regular chat application. Also, since your collaborators aren't expecting
immediate replies, it helps everyone be in the right mindset.

If something is urgent and needed right away, it's best to reach out to the person directly.

---

## Topics

AsyncGo is oriented around temporary **topics** that are created, typically from a pre-existing meeting or issue, that can
represent any discussion topic that needs to be had. A topic is meant to exist for a short period of time during which
everyone contributes their thoughts.

At the end the discussion is resolved and the final outcomes and/or decisions are recorded.

### The Topic List

When you log in you'll see a list of open topics. From here you can click on any of the available topics
to participate.

### Creating Topics

From the topic list click on "New Topic" to create a topic. You will be prompted to enter a description and a title.
Topic descriptions set the table for the conversation to be had and are very important. You can use [markdown](markdown.html)
to enter richer content than plain text; we recommend including a checklist of key points to discuss, which can be marked
off as you go, and potentially an embedded video recording to help set the context.

### Collaborating on Topics

Once the topic is set up you can share it with everyone who you want to participate. Everyone can collaborate async as
you go, discussing the topic at hand until you reach your outcome.

### Resolving Topics

Now that your topic is complete you can mark it as resolved. This will freeze further edits.

---

## Teams

Teams in AsyncGo represent one group of users who collaborate with each other. Teams are
billed as one unit, based on the total number of members.

### Managing Teams

From the Teams page you are able to add and remove users. A few important notes:

- Users must be individually invited from the Teams page
- There are no limitations on domain name as to who can be invited to the team
- An individual user, as defined by one email address, may only be a member of one team

---

## Markdown

AsyncGo uses [GFM markdown](https://github.github.com/gfm/) for rich content, and supports all tags listed in their documentation.
There are a few common keywords used to support discussions which are highlighted here.

### Checklists

It's very helpful to use checklists to define the set of things you're going to discuss, and then you can mark them
off as you go. Checklists are entered as follows:

```
- [ ] An unchecked checkbox
- [x] A checked checkbox
```

### Links

Links can be added as follows:

```
[Link description](https://www.google.com)
```

### Images

Images are added similarly:

```
![foo](/url "https://www.google.com/with-my-image.png")
```

### Videos

Adding videos is done by adding images with links. Since it's not possible to embed the video directly, you show the video thumbnail instead as an image and then link to the video. With YouTube for example you would replace `VIDEO_ID` below with the actual video ID:

```
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)
```
