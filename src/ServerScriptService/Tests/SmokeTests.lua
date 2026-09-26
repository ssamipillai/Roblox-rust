-- Manual/Studio smoke-test checklist for the initial vertical slice.
return {
    "Player joins with Wood=0, Hunger=100, Thirst=100",
    "Generated trees carry Tree tag and TreeHealth=5",
    "Valid wall request consumes 20 Wood and creates Owner attribute",
    "Invalid/far wall request creates no instance and consumes no Wood",
    "Tree harvest outside 15 studs is rejected",
    "Tree harvest at zero health grants Wood once and respawns after 10s",
    "Gun cannot damage a non-player Humanoid",
    "Gun fire is rate-limited server-side",
    "Death creates one loot bag and zeroes dropped Wood",
    "Only another player can claim a loot bag once",
}
