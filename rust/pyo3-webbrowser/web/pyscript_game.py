"""
Tic-Tac-Toe Game Logic for PyScript
Controls the game board and interacts with JavaScript UI
"""

import micropip
await micropip.install("./tictactoe-0.1.0-cp313-abi3-emscripten_4_0_9_wasm32.whl")

from pyscript import document, window

# import micropython
# micropython.mem_info()

from tictactoe import Board

board = Board()
print(board.get_current_player())

# Global game state
board = [[None for _ in range(3)] for _ in range(3)]
current_player = 'X'
game_over = False


def reset_game():
    """Reset the game to initial state"""
    global board, current_player, game_over
    board = [[None for _ in range(3)] for _ in range(3)]
    current_player = 'X'
    game_over = False
    window.jsUpdateStatus("Player X's turn")
    update_ui()


def get_board_state():
    """Get current board state as a flat list"""
    flat_board = []
    for row in board:
        for cell in row:
            if cell is None:
                flat_board.append(None)
            else:
                flat_board.append(str(cell))
    return flat_board


def get_current_player():
    """Get current player"""
    return current_player


def make_move(row, col):
    """Make a move at the specified position"""
    global current_player, game_over

    if game_over:
        window.jsUpdateStatus("Game is over! Click Reset to play again.")
        return False

    if not is_valid_move(row, col):
        window.jsUpdateStatus(f"Invalid move! Cell ({row}, {col}) is already occupied.")
        return False

    board[row][col] = current_player

    if check_winner(current_player):
        game_over = True
        window.jsUpdateStatus(f"Player {current_player} wins!")
        update_ui()
        return True

    if is_board_full():
        game_over = True
        window.jsUpdateStatus("Game is a draw!")
        update_ui()
        return True

    current_player = 'O' if current_player == 'X' else 'X'
    window.jsUpdateStatus(f"Player {current_player}'s turn")
    update_ui()
    return True


def handle_click(index):
    """Handle click on board cell from JavaScript"""
    if game_over:
        return

    row = index // 3
    col = index % 3

    make_move(row, col)


def is_valid_move(row, col):
    """Check if the move is valid"""
    return 0 <= row < 3 and 0 <= col < 3 and board[row][col] is None


def is_board_full():
    """Check if the board is full"""
    return all(cell is not None for row in board for cell in row)


def check_winner(player):
    """Check if the specified player has won"""
    # Check rows
    for row in board:
        if all(cell == player for cell in row):
            return True

    # Check columns
    for col in range(3):
        if all(board[row][col] == player for row in range(3)):
            return True

    # Check diagonals
    if all(board[i][i] == player for i in range(3)):
        return True

    if all(board[i][2 - i] == player for i in range(3)):
        return True

    return False


def update_ui():
    """Update the JavaScript UI"""
    board_state = get_board_state()
    window.jsUpdateBoard(board_state)


# Initialize the game when module loads
print("Tic-Tac-Toe game initialized!")
print("Available functions:")
print("  - make_move(row, col): Make a move")
print("  - reset_game(): Reset the game")
print("  - get_board_state(): Get current board state")
print("  - get_current_player(): Get current player")
print("  - handle_click(index): Handle cell click (internal)")