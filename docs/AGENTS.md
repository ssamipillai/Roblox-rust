# Multi-Agent Development Contract

| Agent | Role | Required output |
|---|---|---|
| Forge | Builder | Implementation + focused tests |
| Sentinel | Security reviewer | Remote validation, exploit paths, authority review |
| Atlas | Integration reviewer | Rojo hierarchy, dependencies, Studio wiring |
| Vanguard | QA | Acceptance tests, regression findings |

## Sequence
1. Forge implements one bounded feature.
2. Sentinel reviews trust boundaries and server validation.
3. Atlas checks hierarchy/API contracts.
4. Vanguard runs tests and reports failures.
5. Forge fixes findings.
6. Merge only after all gates pass.

Agents must not silently change another phase's contract.
