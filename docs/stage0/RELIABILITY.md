# Reliability measures

| Measure | Design | Test |
|---|---|---|
| Atomic save | Write `.forge.tmp` in same directory, flush + fsync file, verify by reopening and checking member sha256, keep previous as `.forge.bak`, `os.replace`, fsync directory | Kill writer mid-write (fault injection); original must open and verify |
| Autosave / recovery | Timer + after N commands, writes `<project>.autosave` journal (history only, small) in the data path; on startup, offer recover/discard, never auto-overwrite | Simulated crash then recover; history equal |
| Undo/redo | Command pattern, bounded by memory not count; undo restores via inverse command or history replay | Property test: random command sequences, undo all == initial state |
| Versioned schema | `schema_version` in manifest; ordered migrations; files from newer versions open read-only with a warning | Migration fixtures per version, golden files |
| Integrity | sha256 per member, manifest hash; verification on open; corrupt member reported by name, history kept even if cache is bad | Corrupt a byte, expect named error + partial recovery |
| Failed operations | Applied on a copy in a worker; on failure last valid state kept, error carries kernel message, representation and alternatives | Inject failing boolean; state unchanged |
| Crash diagnostics | `faulthandler`, rotating log in data path, crash report with versions/hardware/last commands (no network upload) | Forced crash writes report |
| Resource limits | Per-job timeout, memory ceiling, worker count; warn before heavy jobs | Job exceeding limit is terminated and reported |
| Determinism | Rebuild from history must reproduce geometry within tolerance; volume/bbox hashes stored | Round-trip tests |
