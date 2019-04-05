###### Last Updated: Saturday, March 16, 2019

# Quests

## Brief

### Definitions
**`Active` [Quest(s)]**: refers to the quests currently being used as part of the daily number. If the player successfully completes an active quest, the player receives an amount of fractons as a reward.
**`Update` [Quest(s)]**: refers to modifying the internal state of **active** quests. This includes changing the values of `progress` or `isCollected`.
**`Purge` [Quest(s)]**: refers to changing the active  quests such that new quests replace old quests. Each quest has an initial `progress = 0` and `isCollected = false`.
**`Last Purge Time` (LPT)**: refers to the time active quests were last purged.

### Storage

The following quest-related items will be stored in the QML storage:

* A dictionary with quest keys and their corresponding quest object.
* A dictionary of currently active quests.
* The time quests were last purged. (**LPT**)

In some ways, quests are similar to achievements. Each quest object has the following format:

	{
		text: string,
		progress: int,
		maxProgress: int,
		isCollected: bool
	}


### Logistics

Quests are availble to the player starting from level 5 and are refreshed everyday at midnight.

When the game first starts, the will be no available quests, but these can be readily made available through `qml/game/singles/Quests.qml : Component.onCompleted`.

*Note: Consider hardcoding quests into `defaultkeys.json`. Consider using beginner/tutorial quests.*

On application startup, the following algorithm should be executed:

1. Retrieve LPT from storage.
2. Check whether the LPT exceeds the most recent midnight time (i.e. at time 00:00:00).
3. If it does, purge the quests and update the LPT. Store the results into storage.

A timer should be used to keep track if a stored time surpassed midnight and purge the quests.

When the time surpasses the midnight minute, the quests should be purged.






