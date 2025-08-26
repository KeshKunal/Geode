# Geode 🧘 - A Mindful Productivity App

Hey there! Welcome to the official repo for Geode, a little productivity app with a big idea. Thanks for stopping by to check out the code.

**✨ Live Demo:** [**https://geode-app.netlify.app/**](https://geode-app.netlify.app/)

---

## What's the Big Idea? 🤔

Most productivity apps try to force you into being focused. They use aggressive reminders, streak-counters, and guilt-trips to keep you "on track." Geode is different.

The goal here isn't to force focus, but to help you build it naturally. It's about creating a calm, digital space where you can see your progress grow over time, without the pressure. Think of it less like a drill sergeant and more like a quiet garden you get to tend.

---

## Features Walkthrough

Here's a quick tour of what Geode is all about.

### 🏡 Tab 1: The Dashboard
This is your daily command center. It's designed to show you only what you need to worry about *today*, cutting out the noise from the rest of the week.
* **Today's Snapshot:** See your tasks broken down into "To Do," "In Progress," and "Completed."
* **Priority Progress:** A simple bar that shows how you're doing on your most important tasks.
* **Task Horizon:** A special view to see all your upcoming tasks sorted by their deadline, so you can plan ahead without stress.

### 🧘 Tab 2: The Focus Hub
This is where the magic happens. It’s a clean, simple space to start a focus session.
* **The Bamboo Timer:** A beautiful circular timer is the main event. As you work, a stalk of bamboo grows in the background, giving you a calm, visual sense of progress.
* **Frictionless Start:** Just set your time (defaults to 25 mins) and hit "Begin Focus." That's it.

### 🌳 Tab 3: The Grove
This is your reward. For every focus session you complete, a new bamboo stalk is added to your personal grove.
* **Your Digital Sanctuary:** Watch your grove get more lush and dense over time. It's a visual representation of all the hard work you've put in.
* **No Penalties, Ever:** Miss a day? No problem. Your plants won't die. There are no stressful "streaks" to maintain. This space is purely for positive reinforcement.

### 🚦 Tab 4: App Rules & The Intentionality Gate (Under Development)
This section is still under development. The goal is to help you teach Geode how to help you best.
* **App Categorization:** Quickly sort your phone's apps into Productive (🌱), Neutral (➖), or Distracting (🚫). During a focus session, all distracting apps are blocked.
* **The Intentionality Gate:** This is our secret weapon against mindless scrolling. If you try to open a distracting app, Geode makes you pause for 5 seconds, giving you a brief moment to ask yourself, "Do I really want to do this?" It's a simple, non-intrusive way to build better habits.

---

## Tech Stack 🛠️

This project was built with a focus on simplicity, performance, and cross-platform compatibility.

* **Framework:** **Flutter** (for building beautiful apps on mobile, web, and desktop from one codebase).
* **State Management:** **Provider** (for a simple and clean way to manage the app's data).
* **Local Database:** **Hive** (a super-fast, native Dart database for saving your tasks right on your device, ensuring your data is always available).
* **Audio:** **audioplayers** (for playing the completion sound).
* **Cool UI Packages:**
    * `percent_indicator` for the beautiful circular timers.
    * `fl_chart` for the productivity graphs.

The project's code is organized as follows:

* `models`: Defines the data models for tasks and grove sessions.
* `providers`: Manages the app's state and data.
* `screens`: Contains the UI for each screen in the app.
* `services`: Provides utility services like app blocking and data persistence.

---

## How to Get Started

Want to run this on your own machine? It's easy!

1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/KeshKunal/geode.git](https://github.com/KeshKunal/geode.git)
    ```

2.  **Get the packages:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

And that's it! Feel free to poke around, make changes, and learn from the code.

## Got Ideas or Found a Bug? 🐛💡
This is a work in progress, and I'm always open to suggestions on how to make Geode even better. If you've got a cool idea or spot something wonky, feel free to open an issue here on GitHub. Let's make this a chill and useful tool together!

Thanks for checking out Geode! Happy task managing! 😊

