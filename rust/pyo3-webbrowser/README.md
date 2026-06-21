# Purpose

- Create a Tic-Tac-Toe game implemented in Rust
- Create the Rust bindings in Python by leverage `PyO3`
- Compiled to WebAssembly
- Executed in a browser using `Pyscript` with a live code editor interface.

# Creation flow

- Create Rust library by Cargo
- Implement the Tic-Tac-Toe game in Rust
- In "python" folder, create the PyO3 binding corresponding the Rust implementation.
- Configure `build.rs` to compile PyO3 by `marturin` targeting `wasm32-unknown-emscripten`
- Create the web app to load `Pyscript` and Python compiled library
- Using `PyEditor` plugin of `PyScript` to write the Python script to execute the `PyO3` library

# Maturin Usage

Activate Python env that have `maturin` tool available
```
python3 -m venv .venv
source .venv/bin/activate
pip install -U pip maturin
pip freeze
```

In order to build and test PyO3 version of `tictactoe`:
```bash
cd crates/tictactoe
maturin develop
python
```

**Important**: Always use `maturin` commands, not `cargo build`, because:
- Maturin handles Python linking correctly
- `cargo build` will fail with Python library linking errors
- Maturin creates the Python wheel and installs it in the venv

# File tree

```
pyo3-webbrowser/
├── crates/
│   └── tictactoe/
│       ├── Cargo.toml
│       ├── pyproject.toml
│       ├── build.rs
│       ├── src/
│       │   ├── lib.rs
│       │   ├── game.rs
│       │   └── python/
│       │       ├── mod.rs  <-- Module root with #[pymodule]
│       │       └── bindings.rs  <-- PyO3 bindings
│       └── .venv/
├── web/
│   ├── index.html
│   ├── styles.css
│   ├── app.js
│   └── pyscript_game.py
├── target/
│   ├── debug/  <-- Development builds
│   └── wasm32-unknown-emscripten/
│       └── release/
│           └── tictactoe.wasm
├── Makefile (optional)
└── README.md
```

# PyO3 naming convention

- For the Rust struct called Board, when writing the PyO3, we prepend "Py" so it's called "PyBoard", but in the PyO3 macro, we need to rename it to "Board" to match the Rust struct

## Implementation Plan

### Phase 1: Project Setup (Rust Library)

**Initialize with maturin**
```bash
maturin new crates/tictactoe --name tictactoe -b pyo3
cd crates/tictactoe
```

You have the file tree
```
tictactoe/
├── Cargo.toml
├── pyproject.toml  # required for maturin configuration
└── src
    ├── lib.rs  # default for library crates
```

### Phase 2: Tic-Tac-Toe Game Implementation (Rust)

**Create src/game.rs**
- Implement `Player` enum (X, O)
- Implement `Cell` enum (Empty, X, O)
- Implement `GameState` enum (Playing, Won(Player), Draw)
- Implement `Board` struct (3x3 grid)
- Game state management:
  - Cell states: Empty, X, O
  - Game status: Playing, Won (X/O), Draw
- Core methods:
  - `new()` - Initialize empty board
  - `make_move(row, col, player)` - Place marker
  - `is_valid_move(row, col)` - Check if move is legal
  - `check_game_state(&self)` - Determine game state (Playing, Won, Draw)
  - `is_full()` - Check for draw
  - `get_cell(row, col)` - Get cell state
  - `reset()` - Reset board
- Win detection logic:
  - Check rows, columns, diagonals

**Update src/lib.rs**
- Import the `game` module for game logic
- Import the `python` module for PyO3 bindings
- Export game types for internal use
```rust
mod game;
mod python;

pub use game::{Board, Cell, GameState, Player};
```

### Phase 3: Python Bindings (PyO3)

**Create src/python/ directory structure**
```
src/python/
├── mod.rs  <-- Module root that exports pymodule and bindings
└── bindings.rs  <-- Rust file with PyO3 bindings
```

**Update src/lib.rs**
```rust
mod game;
mod python;

pub use game::{Board, Cell, GameState, Player};
```

**Create src/python/mod.rs**
```rust
use pyo3::prelude::*;

mod bindings;

pub use bindings::{PyPlayer, PyCell, PyGameState, PyBoard};

#[pymodule]
fn tictactoe(_py: Python, m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_class::<PyPlayer>()?;
    m.add_class::<PyCell>()?;
    m.add_class::<PyGameState>()?;
    m.add_class::<PyBoard>()?;
    Ok(())
}
```

**Create src/python/bindings.rs (Rust file)**
- Import PyO3 macros and game module
- Create wrapper structs with `#[pyclass]` that wrap existing Rust types:
  - `PyPlayer` wraps `Player` enum (exposed as "Player" via `#[pyclass(name = "Player")]`)
  - `PyCell` wraps `Cell` enum (exposed as "Cell" via `#[pyclass(name = "Cell")]`)
  - `PyGameState` wraps `GameState` enum (exposed as "GameState" via `#[pyclass]`)
    - **Note**: PyO3 0.27 doesn't support complex enums with both unit and tuple variants
    - Use unit variants only: `Playing`, `Won`, `Draw`
  - `PyBoard` wraps `Board` struct (exposed as "Board" via `#[pyclass(name = "Board")]`)
- Implement `From<OriginalType>` and `From<PyWrapperType>` traits for conversions between Rust types and PyO3 wrappers:
  - For enums: simple match-based conversion
  - For `PyBoard`: holds a `Board` instance internally
- For `PyBoard`, add `#[pymethods]` implementations that delegate to the wrapped Board:
  - `#[new]` - constructor that creates `Board::new()`
  - `make_move()` - calls `board.make_move()` and handles Result errors
  - `is_valid_move()` - calls `board.is_valid_move()`
  - `check_game_state()` - calls `board.check_game_state()` and converts to PyGameState
  - `is_full()` - calls `board.is_full()`
  - `get_cell()` - calls `board.get_cell()` and converts to PyCell
  - `reset()` - calls `board.reset()`
  - `get_current_player()` - calls `board.get_current_player()` and converts to PyPlayer
- For enum wrappers (`PyPlayer`, `PyCell`):
  - Expose variants directly via `#[pyclass]` - PyO3 automatically makes them available in Python
  - Use `From`/`Into` traits for conversion to/from original Rust types
  - No explicit `#[pymethods]` needed since enums are value types
- Error handling: convert `Result<(), String>` to Python exceptions using `PyErr::new::<pyo3::exceptions::PyValueError, _>()`

**Key concepts**:
- Maturin finds the `#[pymodule]` function in the library root (`lib.rs` or modules it imports)
- The module structure: `src/lib.rs` → `mod python;` → `src/python/mod.rs` → `#[pymodule] fn tictactoe`
- PyO3 wrappers are thin layers around existing Rust types
- Struct wrappers like `PyBoard` hold an instance of the wrapped Rust type
- Enum wrappers use direct conversion via `From`/`Into` traits
- `#[pyclass(name = "...")]` renames the type in Python to match the original Rust name (e.g., PyBoard → Board)
- Wrapper methods delegate calls to the underlying Rust implementation
- Enums don't need explicit `#[pymethods]` - PyO3 exposes variants automatically

### Phase 4: Build Configuration

**Create build.rs**
```rust
fn main() {
    println!("cargo:rerun-if-changed=build.rs");
}
```

**Configure Cargo.toml for maturin**
- Ensure cdylib crate type for WASM compatibility
- Maturin will handle the Python binding build process

**Create maturin.toml** (optional, for advanced configuration)
- Target: wasm32-unknown-emscripten
- Python version compatibility

### Phase 5: Web Application Setup

**Create web/ directory structure**
```
web/
├── index.html
├── styles.css
└── app.js
```

**Create web/index.html**
- HTML5 boilerplate
- Load PyScript from CDN
- Configure PyScript runtime
- Create container for PyEditor
- Add game display area
- Load compiled WASM module

**Create web/styles.css**
- Styling for game board
- PyEditor container styling
- Game status display
- Responsive design

**Create web/app.js**
- PyScript initialization
- PyEditor configuration
- Game UI updates
- Event handling

### Phase 6: PyScript Integration

**Create web/pyscript_game.py**
- Import PyBoard from pyo3_webbrowser
- Create game instance
- Implement game loop
- Update UI based on game state
- Handle user input from PyEditor

**Update web/index.html to include PyEditor**
- Configure PyEditor plugin
- Set up live code execution
- Bind to game logic

**Test PyEditor functionality**
- Verify code execution
- Check game state updates
- Ensure proper error handling

### Phase 7: Build and Deployment

**Primary build command (maturin)**
```bash
# Build Rust to WASM (use maturin directly)
maturin build --release --target wasm32-unknown-emscripten

# For development (faster builds)
maturin develop --target wasm32-unknown-emscripten
```

**Why not trigger from build.rs?**
- build.rs runs during cargo build
- maturin invokes cargo build
- This creates a circular dependency
- Solution: Use maturin as the primary build tool instead

**Create build wrapper script**
```bash
#!/bin/bash
# scripts/build.sh
set -e

# Add WASM target if not present
rustup target add wasm32-unknown-emscripten

# Build with maturin
maturin build --release --target wasm32-unknown-emscripten

# Copy WASM to web directory
cp target/wasm32-unknown-emscripten/release/*.wasm web/
```

**Makefile**
```makefile
.PHONY: build dev clean

build:
	maturin build --release --target wasm32-unknown-emscripten
	cp target/wasm32-unknown-emscripten/release/*.wasm web/

dev:
	maturin develop --target wasm32-unknown-emscripten

clean:
	cargo clean
	rm -f web/*.wasm
```

**Create README.md updates**
- Build instructions
- Usage examples
- Dependencies

### Phase 8: Testing and Verification

**Unit Tests (Rust)**
- Test Board initialization
- Test move validation
- Test win detection
- Test draw detection
- Test edge cases

**Integration Tests**
- Test PyO3 bindings
- Test Python API
- Test WASM compilation

**Manual Testing**
- Test web interface
- Verify game playability
- Check PyEditor interactivity
