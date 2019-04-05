Title | Description | Status
------+-------------+--------
**Scenes** | Setup basic scenes (Home, Exercise Menu, Achievements, Settings) along with user-interaction and navigation. | √
**Buttons** | Create "bubble-buttons" which will animate inwards/outwards when the user hovers/presses/clicks on it. | √
**Modes Base** | Create a functioning abstract base which provides an interface for the user to answer questions. | √
**Standard Mode** | Implement the standard mode with the easy, medium, and hard difficulties. | √ (Now **Operations** Mode)
**Experience/Points System** | Implement an experience/points system. Each time an answer is correct, the number of experience/points increases. Experiences/points determine the user's level. | √ (Named the system **Fractureuns**, after the game.)
**Balance, Conversion, and Truth Mode** | Implement balance, conversion, and truth mode. | √
**Local Storage** | Add storage functionality. | √
**Background Animation** | Add floating animation in the background. | √
**Preliminary [Achievements](Glossary/Terms/Achievements.md)** | Begin implementing 3 to 5 achievements. | √ (`no u`, `Associate`, `Jogger`.)
**Desktop Notifications** | Implement desktop notifications which will notify on various events (e.g. on Level-Up, on Achievement-Get). | Achievement-Get: √ • Level Up: √ • Others: ???
**Preliminary Study Notes** | Add study notes for relevant to the Standard Mode. Link the study notes to relevant exercises. | Introduction: √ • Lesson One: √
**Preliminary Deployment** | Try to deploy a dmg file on macOS. | √ (Steps are noted in [Deployment Notes](Notes/Deployment.md))
**Levelling** | Implement levelling to unlock certain modes and features. (Enabled/Disabled by Opacity, add images of locks later) | Modes: √
**Redesign 1** | (1) Change the game name from "Fractureuns" to "Fractons": a more deterministic pronounciation. (2) Change how the xp-bar is displayed in ModesBase: make it horizontal for consistency. (3) Make bottom-anchored ribbon in Home scene consistent with other ribbons: navy blue, with yellow font. (4) Change achievements to have additional `isClassified` and `secretDescription` property. (5) In ModesBase, swap the GoButton and level-display positions and make the animated text fall downwards. | (1)\*: √ (2): √ (3): √ (4): √
**Images and Icons** | Add images and icons. | Home √ Others ?
**Statistics** | Implement the statistic page(s) to view past results. (See [Statistics Notes](Notes/StatisticsScene.md).) | √
**Lottery** | Add the Lottery. (Also implement levelling for this.) Unlocks at level 10. (Debug with Level 1.)  Research into V-Play/Felgo's slot machine example. <del>Also consider a minigame: asks "What is the probability of getting so and so?" (Token Mode). Rewards tokens.</del> (**March 15: Consider not having a token mode.**) | Scene Setup √ Research √ Rewards √ <del>Token Mode x</del> Complete? x
**Other [Achievements](Glossary/Terms/Achievements.md)** | (1) Prototype a layout for achievements. (2) Implement other achievements.  | Studious √ Sprinter √ Classified √ Secret √ Leveller √ Explorer √ Mastery x Seasoned x Adventurer √ Lottery √
**Daily Quests** | Add a daily quests feature. (Reward consistent at 25 fractons.) | UI/View √ Load/Update √ Increment/Progress √ Testing √ (One Day)
**Redesign 2** | (1) Redesign achievements before adding new ones. (Require `hint`, `group` fields instead of `secret`, `isSecret`, `isClassified` for easier displaying.) (2) Add an in-window notifications system (notifies level-ups, achievement-gets, quest-completions, etc.) Maybe add as part of background layer. (3) Redesign layout for quests (currently the on-pressed collides with the main buttons). Maybe a mini-banner can slide up from the bottom behind the level-frac display. Or better, a banner can slide from the left edge of the screen. <del>(4) Construct a `ModesLayer` similar to `BackgroundLayer`. Place modes as delegates?</del> (**Note: Don't bother with #4 yet -- premature optimisation.**) (5) Find a different way to earn tokens (e.g. every level-up or every combo of 10?). (6) Redesign lottery results layout (multiplier, fractons, tokens). | (1): √ (2): √ (3): √ <del>(4): x</del> (5): √ (6): √
**Scene-to-Scene Transitions** | Add transitions in-between scenes (e.g. left/right/up/down slides). | √ (1-Second Animated Behaviours on Opacity)
**Sound Effects** | Add sound effects to certain events (e.g. Levelling Up, Gaining Achievement). | Correct Answer √ Incorrect Answer √ Level Up √ Achievement √ Lottery Spinning X Lottery Win X
**Background Music** | Add serene, translucent music to the background. (Classic?) | √ (5 pieces, 3 of which are Debussy's.)
**Other Modes** | Implement other modes. Conversion (allow any fraction with d < 10 by rounding to two decimal places). Truth (fix or redo; implement other omdes). Pie (non-standard, copy from Fractureuns, draw circles/arcs [filter a pizza on top?] with variable numerator/denominator fraction). Word (parameterised questions). Fill (block highlighter). <del>Token (rewards tokens).</del> | Conversion √ ; Truth √ ; Pie x ; Word x ; Fill x ;
**Settings** | Mute Sound, Music. Delete Data. | Mute Music √ • Mute Sound √ • Delete Data √
**App Icons** | Prepare and update app icons of yellow star on light blue background. | √
**Redesign 3** | (1) Immediately tell the correct answer (e.g. by event text or by some fade out/animation?). Or have an intermediate button (like in Fractureuns). (2) Redesign notifications. Allow multiple notifications at once, but slide and fade out. Redesign statistics to store on a per-question basis. | (1) √, Integrated into the error message text field. GUI layout had to be modified. • (2) √
**Profile** | Profile the game, tying up any bottlenecks. Possible bottlenecks to check: (1) ModesBase, refactor into a single base. (1b) Reload is slow. (2) Music, too much data to load? **ToDo: Achievements should be stored in a map for quick access by key.**  | √ Rewrote achievements manager.
**Cleanup TODOs** | Check and clean TODOs, commenting/uncommenting appropriate lines, etc. | √
**Information/Help in Modes** | Implement a help/info button. | √
**Deploy and Publish** | Prepare the code for deployment. | Deploy √ Publish X
**Redesign 4** | (1) Notifications Scene (add a scene with a list of notifications recently earned in one session). Notifications fly by too quickly. | (1) X
**Tutorial** | Make a tutorial which shows first-timers how to play. Integrate quests into this as well.
**Velocity** | Define and implement the velocity feature. The speed with which the user answers a set of questions. User gains more mastery over a higher velocity.
**Mastery** | Define and implement the mastery feature. (Consider changing "Mastery" to "Skill"?)
**Integrate Advertisements** | Use Felgo/V-Play's Advert  Plugin(s).
**Other Study Notes** | Add more study notes.
**Multiple Accounts** | Add multiple accounts and allow users to switch between accounts. (May need to redesign database.)


\* Note about renaming: Fractoons sounds like this is a cartoon game. Fractons is particle or a quantatised vibration in a fractal structure. Fraktions is a metal band. Frakton is a developer service.