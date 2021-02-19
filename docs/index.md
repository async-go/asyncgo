---
layout: docs
title: "AsyncGo Documentation"
description: Learn how to use AsyncGo
---

# AsyncGo Basics

Welcome to AsyncGo! AsyncGo helps your team communicate flexibly and without
the interruptions caused by meetings and chat. This documentation site is broken
out into a few areas. This page contains the basics and context you need to get
up and running.

{% include docs_nav.md %}

## What are the basics?

AsyncGo is a discussion tool meant to replace chat and meetings. Each team gets a topic
board that has all the important discussions that are happening for that team.
Anyone can create a [topic](/topics) at any time, and we encourage you to set
a [due date](#timeboxing) on every item since the topic list is sorted by what's
coming due. It's also important to write a good description, and pre-format
the outcome so that everyone knows the information needed coming into the
discussion, and what exactly the expected outcome is. You might also want to
define expected actions to occur during the discussion (you can place these
in the description), or actions to occur after the decision is done (you can
place these in the space for the outcome.) Checklists using markdown are a good
way to list these.

Within a topic everyone can collaborate on an outcome together by using
comments and votes to iterate towards the result you're looking for.

Once done, someone should ensure that the outcome is updated with the final
results, and then close the topic. It's archived forever so you can always
reference it.

These are the fundamentals, but please read on for more tips and tricks on
how to get the most out of AsyncGo.

![Overview Image](/assets/images/basicfunctions.png){:.img-fluid.border.border-secondary}

## Async Working

The first step to getting the most out of AsyncGo is to familiarize yourself with async working.

Async is a way of working, useful for remote, colocated, or hybrid companies, where collaboration is done via a digital workspace
rather than in synchronous meetings/discussions. This gives the flexibility for any team member to choose
their own workday based on when they like to focus or have other commitments.

Here are some good places to learn more about async work:

- [What is Async? Understanding How to Collaborate Remotely and Solve Zoom Fatigue](https://www.hrexchangenetwork.com/employee-engagement/columns/what-is-async-understanding-how-to-collaborate-remotely-and-solve-zoom-fatigue)
- [GitLab's Async Work Handbook](https://about.gitlab.com/company/culture/all-remote/asynchronous/)

---

## Key Concepts

AsyncGo was designed for asynchronous work, which means the app will not hound you for updates.
You won't find phone notifications, loud indicators in the app, constant email reminders, or anything
like that. Instead, the application is designed to be interacted with on your own schedule, with
gentle reminders on a slower cadence.

This can be initially hard to adjust to if you're used to interrupt-driven, realtime work, but once
you're used to it, it's quite easy. There are just a few key concepts to understand:

### Timeboxing

We recommend setting a due date on nearly every item. Setting a due date helps your team members
know when they need to reply by. Most users work down the topic list from the ones coming due most soon
to the furthest out, in order to make sure they have a chance to contribute to the topics they are
interested in.

This lets everyone manage their own time to decide what they want to focus on at any given point,
while having the confidence that they won't miss out.

Note that due dates are at the end of the chosen day. If you want something to be due at end of day
Monday, then you should choose Monday as the date. If, instead, you want it to be due at midnight on
Sunday, you should choose Sunday instead.

### Clear Communication

Because you aren't meeting as a team and kicking things off with a general Q&A session, at least
via the app, it's important to write a very clear description that sets the table for the problem
at hand. Include links to relevant documentation, sources, and issues, and in general try to not
assume any context from the reader. This will also help you later when the topic is reviewed to see
how a decision was made.

You can also apply some initial structure to the outcome, indicating the format of what you're
looking for in the end. That can also help focus the team and ensure they understand what you
are asking for.

If you are the kind of person who likes to lay things out with spoken words, you can always record audio
or video and [embed it](#video) into the description, outcome, or a comment. Note that embedded videos
are not auto-transcribed, so are not searchable.

### Slower-Paced Notifications

The primary way to be notified about what's going on in AsyncGo is via digest notifications. These
are meant to be reviewed a couple of times per day, at your convenience, and highlight what's new since
your last visit, as well as any items that are coming due soon.

In this way you aren't constantly being interrupted to respond to the latest reply in a conversation
thread, like you might be in a regular chat application. Also, since your collaborators aren't expecting
immediate replies, it helps everyone be in the right mindset.

This may feel like you're slowing down overall, but it just isn't the case. By working on several
topics simultaneously, rather than serially as you would in meetings, you actually get more done.
While it's true that any individual item may take slightly longer, the overall productivity is
much higher. In any case, if something is urgent and needed right away, it's always possible to
reach out to the person directly.. but this should be saved for real urgent situations, because
whenever you do this you're impacting the team's async flow.

## Monitoring throughput and productivity

A common question from managers working with remote teams for the first time is how to know if
your team members are really working, or how to tell if they are taking the opportunity of being away from the
office to avoid work.

The reality is that most people increase rather than decrease the amount of
work done when moving to remote, since the lines between personal and work life can become blurred.
As a manager you'll be better off spending your time helping your team establish these
boundaries in order to avoid burn out and ensure everyone is well rested and at their best.

That said, of course occasionally you will have performance issues with someone. Although it
may be tempting in this case to want to track the hours they are spending logged in and active,
that's at best only a secondary, poor version of what you should actually be measuring: the
outcomes they deliver. This is complex enough that it requires engagement between the manager
and employee who needs help, and isn't something that a metric here would help. If you're
interested in this topic you can read our [blog post on how to think about productivity for remote teams](https://asyncgo.com/blog/leadership/2020/02/05/measuring-remote-productivity.html)

Because of this, we don't plan to have metrics in AsyncGo about individual performance. Instead,
we will add metrics that speak to overall team activity and collaboration. You can expect to see these in an
upcoming release, in the meantime we'd love your feedback on what you're looking for.

---

## Practical Usage

AsyncGo is designed to make it easy to get up and running with your team. It doesn't require getting
rid of any of the other tools you use, though you may decide to do so later, and it doesn't require
changing any of the behaviors of anyone outside your team.

Within your team, there are three main applications that adopting AsyncGo will change your usage of.

### Reducing usage of video conferencing (Zoom, Teams, etc.) and meetings

The first and most fundamental - don't schedule that meeting that you're considering having, especially
if the meeting is within your own team. Instead, open up a new topic and place the meeting agenda there.

If you're including someone from outside of your team, then you have a decision to make. If you think
the person is up for participating then you can always invite them to your team. From that point on
they will be able to participate as a normal user.

With all your free time that you've freed up from meetings, consider scheduling a coffee chat or two
with someone that you'd like to have a more free-form, human conversation with. It's a much better
use of your time than work meetings where everyone is staring at documents or quietly working on
something else in the background.

### Replacing ongoing discussion agendas (Google Docs, Notion, etc.)

With AsyncGo, you also don't need a register of topics that are in discussion. A lot of companies use a
Google Doc for this, with a long list of topics that they keep coming back to and/or archive off for
later reference. Instead, use the topic list in AsyncGo itself to keep track of all the various things
you're discussing.

One of the most powerful features of AsyncGo is how the complete list of discussion topics is right there
for anyone to see, and they can choose to participate at any time if they have something to contribute.

### Reducing usage of chat (Slack, IRC, etc.)

Chat is an insidious one. It almost feels async, but anyone who has felt overwhelmed at the pace of
threads happening in chat will attest to the fact that it's more realtime than they'd let you believe.
To get the most out of AsyncGo, whenever there's a deeper topic that you want to give time for people
to reflect on and participate at their convenience, don't start a Slack discussion. Instead create a
new topic in AsyncGo and link to it from your channel.

Realtime chat is great for the things it's good at, which is quick clarifying questions and short
interactions, so try to save it for that. Avoid it for deeper thought.

### How to tell you've got it right

You shouldn't worry about this too much, the benefit will be felt by everyone once you make the change.
That said, some good practical measurements are:

- How much time is spent in meetings per week
- Uninterrupted focus blocks and duration per day
- Reduced messages in chat

If these measures aren't improving, it's time to look at where the interruptions are coming from.
If they are coming from other teams, you could consider including the high-contact ones into
AsyncGo as well, then work together on creating focus time together. In most companies there
are just a few sources of interruptions that, when dealt with, reduce the total interruptions
dramatically.
