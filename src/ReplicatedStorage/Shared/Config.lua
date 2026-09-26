local Config = {
    Build = { GridSize = 4, WallSize = Vector3.new(10, 1, 10), MaxBuildHeight = 12, CostWood = 20 },
    Resources = { TreeHealth = 5, WoodPerTree = 10, HarvestRange = 15, RespawnSeconds = 10 },
    Survival = { Start = 100, HungerDecay = 1, ThirstDecay = 2, TickSeconds = 10, Damage = 5, DamageTickSeconds = 2 },
    Combat = { RifleDamage = 25, RifleRange = 500, FireCooldown = 0.15 },
    Loot = { ClaimRange = 12 },
    Map = { Size = 500, Trees = 50, Rocks = 30, MinSpacing = 10 },
    Data = { StoreName = "RobloxRust_PlayerData_v1", SchemaVersion = 1, Retries = 3 },
}
return Config
