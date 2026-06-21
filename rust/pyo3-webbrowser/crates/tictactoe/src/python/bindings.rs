use pyo3::prelude::*;
use crate::game::{Board, Cell, GameState, Player};

#[pyclass(name = "Player")]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PyPlayer {
    X,
    O,
}

impl From<Player> for PyPlayer {
    fn from(player: Player) -> Self {
        match player {
            Player::X => PyPlayer::X,
            Player::O => PyPlayer::O,
        }
    }
}

impl From<PyPlayer> for Player {
    fn from(player: PyPlayer) -> Self {
        match player {
            PyPlayer::X => Player::X,
            PyPlayer::O => Player::O,
        }
    }
}

#[pyclass(name = "Cell")]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PyCell {
    Empty,
    X,
    O,
}

impl From<Cell> for PyCell {
    fn from(cell: Cell) -> Self {
        match cell {
            Cell::Empty => PyCell::Empty,
            Cell::X => PyCell::X,
            Cell::O => PyCell::O,
        }
    }
}

impl From<PyCell> for Cell {
    fn from(cell: PyCell) -> Self {
        match cell {
            PyCell::Empty => Cell::Empty,
            PyCell::X => Cell::X,
            PyCell::O => Cell::O,
        }
    }
}

#[pyclass]
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PyGameState {
    Playing,
    Won,
    Draw,
}

impl From<GameState> for PyGameState {
    fn from(state: GameState) -> Self {
        match state {
            GameState::Playing => PyGameState::Playing,
            GameState::Won(_) => PyGameState::Won,
            GameState::Draw => PyGameState::Draw,
        }
    }
}

impl From<PyGameState> for GameState {
    fn from(state: PyGameState) -> Self {
        match state {
            PyGameState::Playing => GameState::Playing,
            PyGameState::Won => GameState::Won(Player::X),
            PyGameState::Draw => GameState::Draw,
        }
    }
}

#[pyclass(name = "Board")]
pub struct PyBoard {
    board: Board,
}

#[pymethods]
impl PyBoard {
    #[new]
    fn new() -> Self {
        PyBoard {
            board: Board::new(),
        }
    }

    fn make_move(&mut self, row: usize, col: usize) -> PyResult<()> {
        self.board
            .make_move(row, col)
            .map_err(|e| PyErr::new::<pyo3::exceptions::PyValueError, _>(e))
    }

    fn is_valid_move(&self, row: usize, col: usize) -> bool {
        self.board.is_valid_move(row, col)
    }

    fn check_game_state(&self) -> PyGameState {
        self.board.check_game_state().into()
    }

    fn is_full(&self) -> bool {
        self.board.is_full()
    }

    fn get_cell(&self, row: usize, col: usize) -> Option<PyCell> {
        self.board.get_cell(row, col).map(|cell| cell.into())
    }

    fn reset(&mut self) {
        self.board.reset();
    }

    fn get_current_player(&self) -> PyPlayer {
        self.board.get_current_player().into()
    }

    fn get_winning_cells(&self) -> Option<Vec<(usize, usize)>> {
        self.board.get_winning_cells()
            .map(|combo| combo.to_vec())
    }

    fn is_game_over(&self) -> bool {
        self.board.is_game_over()
    }

    fn make_move_check(&mut self, row: usize, col: usize) -> PyResult<PyGameState> {
        self.board.make_move_check_game(row, col)
            .map(|state| state.into())
            .map_err(|e| PyErr::new::<pyo3::exceptions::PyValueError, _>(e))
    }

    fn check_winner(&self) -> Option<PyPlayer> {
        self.board.check_winner().map(|player| player.into())
    }
}