# Implementation Plan

## Architecture
| Layer | Responsibility |
|---|---|
| Client | Input, preview, UI, local effects |
| Remote boundary | Explicit requests only |
| Server services | Validation, state mutation, persistence |
| Shared modules | Constants, schemas, pure utilities |
| Workspace | Runtime instances only |

## Phase gates
| Phase | Deliverable | Exit gate |
|---|---|---|
| 1 | Grid building + DataStore | Placement, ownership and reload pass |
| 2 | Trees, wood, crafting | Server-authoritative resource flow passes |
| 3 | Hunger/thirst + loot | Death/drop/claim flow passes |
| 4 | Inventory/crafting UI | UI reflects replicated state and cannot bypass server checks |
| 5 | Resource generator | No-overlap spawning and deterministic validation pass |
| 6 | Rifle | Server validates target, range and fire cadence |

## Immediate implementation order
1. Establish Rojo hierarchy and remote contracts.
2. Implement player state and building service.
3. Add persistence with retries and schema versioning.
4. Add resource harvesting and inventory state.
5. Add survival and loot.
6. Add UI, procedural world and rifle.
