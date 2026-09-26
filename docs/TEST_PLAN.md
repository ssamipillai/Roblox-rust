# Test Plan

## Security invariants
- Client cannot award itself Wood.
- Client cannot place a wall without sufficient Wood.
- Client cannot place a wall outside the allowed build envelope.
- Client cannot damage arbitrary Humanoids outside server-approved weapon rules.
- Client cannot loot the same bag twice.
- Player-owned walls are the only walls loaded for that player.

## Phase acceptance
### P1
- Join creates state.
- Valid grid placement succeeds.
- Invalid placement is rejected.
- Leave/rejoin restores owned walls.
- DataStore failures do not crash the server.

### P2
- Hatchet request within range damages a tree.
- Out-of-range request is rejected.
- Tree depletion grants exactly 10 Wood once.
- Respawn restores health after 10 seconds.
- Wall costs exactly 20 Wood.

### P3
- Hunger/Thirst decay at configured intervals.
- Zero status damages the character.
- Death creates one loot bag.
- First valid claimant receives the stored Wood.

### P4-P6
See phase-specific test suites as services are added.
