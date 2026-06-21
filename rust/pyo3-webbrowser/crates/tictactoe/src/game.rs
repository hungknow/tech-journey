#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Player {
    X,
    O,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Cell {
    Empty,
    X,
    O,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum GameState {
    Playing,
    Won(Player),
    Draw,
}

pub struct Board {
    grid: [[Cell; 3]; 3],
    current_player: Player,
}

impl Board {
    pub fn new() -> Self {
        Board {
            grid: [[Cell::Empty; 3]; 3],
            current_player: Player::X,
        }
    }

    pub fn make_move(&mut self, row: usize, col: usize) -> Result<(), String> {
        if !self.is_valid_move(row, col) {
            return Err(format!("Invalid move at ({}, {})", row, col));
        }

        let marker = match self.current_player {
            Player::X => Cell::X,
            Player::O => Cell::O,
        };

        self.grid[row][col] = marker;

        self.current_player = match self.current_player {
            Player::X => Player::O,
            Player::O => Player::X,
        };

        Ok(())
    }

    pub fn is_valid_move(&self, row: usize, col: usize) -> bool {
        row < 3 && col < 3 && self.grid[row][col] == Cell::Empty
    }

    pub fn check_game_state(&self) -> GameState {
        if let Some(winner) = self.check_winner() {
            return GameState::Won(winner);
        }

        if self.is_full() {
            return GameState::Draw;
        }

        GameState::Playing
    }

    pub fn is_full(&self) -> bool {
        for row in &self.grid {
            for &cell in row {
                if cell == Cell::Empty {
                    return false;
                }
            }
        }
        true
    }

    pub fn get_cell(&self, row: usize, col: usize) -> Option<Cell> {
        if row < 3 && col < 3 {
            Some(self.grid[row][col])
        } else {
            None
        }
    }

    pub fn reset(&mut self) {
        self.grid = [[Cell::Empty; 3]; 3];
        self.current_player = Player::X;
    }

    pub fn get_current_player(&self) -> Player {
        self.current_player
    }

    pub fn check_winner(&self) -> Option<Player> {
        let lines = [
            self.grid[0],
            self.grid[1],
            self.grid[2],
            [self.grid[0][0], self.grid[1][0], self.grid[2][0]],
            [self.grid[0][1], self.grid[1][1], self.grid[2][1]],
            [self.grid[0][2], self.grid[1][2], self.grid[2][2]],
            [self.grid[0][0], self.grid[1][1], self.grid[2][2]],
            [self.grid[0][2], self.grid[1][1], self.grid[2][0]],
        ];

        for line in lines {
            if line[0] != Cell::Empty && line[0] == line[1] && line[1] == line[2] {
                return match line[0] {
                    Cell::X => Some(Player::X),
                    Cell::O => Some(Player::O),
                    Cell::Empty => None,
                };
            }
        }

        None
    }

    pub fn is_game_over(&self) -> bool {
        matches!(self.check_game_state(), GameState::Won(_) | GameState::Draw)
    }

    pub fn get_winning_cells(&self) -> Option<[(usize, usize); 3]> {
        let winning_combos = [
            // Rows
            [(0,0), (0,1), (0,2)],
            [(1,0), (1,1), (1,2)],
            [(2,0), (2,1), (2,2)],
            // Columns
            [(0,0), (1,0), (2,0)],
            [(0,1), (1,1), (2,1)],
            [(0,2), (1,2), (2,2)],
            // Diagonals
            [(0,0), (1,1), (2,2)],
            [(0,2), (1,1), (2,0)],
        ];
        
        for combo in &winning_combos {
            let values: Vec<Cell> = combo.iter()
                .map(|&(r, c)| self.grid[r][c])
                .collect();
            
            if values[0] != Cell::Empty && values[0] == values[1] && values[1] == values[2] {
                return Some(*combo);
            }
        }
        None
    }

    pub fn make_move_check_game(&mut self, row: usize, col: usize) -> Result<GameState, String> {
        if !self.is_valid_move(row, col) {
            return Err(format!("Invalid move at ({}, {})", row, col));
        }
        
        let marker = match self.current_player {
            Player::X => Cell::X,
            Player::O => Cell::O,
        };
        
        self.grid[row][col] = marker;
        
        let game_state = self.check_game_state();
        
        // Only switch player if game is still playing
        if matches!(game_state, GameState::Playing) {
            self.current_player = match self.current_player {
                Player::X => Player::O,
                Player::O => Player::X,
            };
        }
        
        Ok(game_state)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_board_initialization() {
        let board = Board::new();
        assert!(board.get_cell(0, 0).is_some());
        assert_eq!(board.get_cell(0, 0), Some(Cell::Empty));
        assert_eq!(board.get_current_player(), Player::X);
    }

    #[test]
    fn test_valid_move() {
        let mut board = Board::new();
        assert!(board.is_valid_move(0, 0));
        board.make_move(0, 0).unwrap();
        assert!(!board.is_valid_move(0, 0));
        assert!(board.is_valid_move(1, 1));
    }

    #[test]
    fn test_invalid_move() {
        let mut board = Board::new();
        board.make_move(0, 0).unwrap();
        let result = board.make_move(0, 0);
        assert!(result.is_err());
    }

    #[test]
    fn test_win_horizontal() {
        let mut board = Board::new();
        board.make_move(0, 0).unwrap();
        board.make_move(1, 0).unwrap();
        board.make_move(0, 1).unwrap();
        board.make_move(1, 1).unwrap();
        board.make_move(0, 2).unwrap();

        assert_eq!(board.check_game_state(), GameState::Won(Player::X));
    }

    #[test]
    fn test_win_vertical() {
        let mut board = Board::new();
        board.make_move(0, 0).unwrap();
        board.make_move(0, 1).unwrap();
        board.make_move(1, 0).unwrap();
        board.make_move(0, 2).unwrap();
        board.make_move(2, 0).unwrap();

        assert_eq!(board.check_game_state(), GameState::Won(Player::X));
    }

    #[test]
    fn test_win_diagonal() {
        let mut board = Board::new();
        board.make_move(0, 0).unwrap();
        board.make_move(0, 1).unwrap();
        board.make_move(1, 1).unwrap();
        board.make_move(0, 2).unwrap();
        board.make_move(2, 2).unwrap();

        assert_eq!(board.check_game_state(), GameState::Won(Player::X));
    }

    #[test]
    fn test_win_anti_diagonal() {
        let mut board = Board::new();
        board.make_move(0, 2).unwrap();
        board.make_move(0, 0).unwrap();
        board.make_move(1, 1).unwrap();
        board.make_move(0, 1).unwrap();
        board.make_move(2, 0).unwrap();

        assert_eq!(board.check_game_state(), GameState::Won(Player::X));
    }

    #[test]
    fn test_draw() {
        let mut board = Board::new();
        let moves = [
            (0, 0), (0, 1), (0, 2),
            (1, 1), (1, 0), (1, 2),
            (2, 1), (2, 0), (2, 2),
        ];

        for (row, col) in moves {
            board.make_move(row, col).unwrap();
        }

        assert_eq!(board.check_game_state(), GameState::Draw);
    }

    #[test]
    fn test_reset() {
        let mut board = Board::new();
        board.make_move(0, 0).unwrap();
        board.make_move(1, 1).unwrap();

        board.reset();

        assert_eq!(board.get_cell(0, 0), Some(Cell::Empty));
        assert_eq!(board.get_cell(1, 1), Some(Cell::Empty));
        assert_eq!(board.get_current_player(), Player::X);
    }

    #[test]
    fn test_player_alternation() {
        let mut board = Board::new();
        assert_eq!(board.get_current_player(), Player::X);

        board.make_move(0, 0).unwrap();
        assert_eq!(board.get_current_player(), Player::O);

        board.make_move(0, 1).unwrap();
        assert_eq!(board.get_current_player(), Player::X);
    }
}