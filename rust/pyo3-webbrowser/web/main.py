import micropip
await micropip.install("./tictactoe-0.1.0-cp313-abi3-emscripten_4_0_9_wasm32.whl")

from pyscript import web, when

import tictactoe

class TicTacToe:
    def __init__(self):
        # self.board = web.page["table#board"][0]
        # self.status = web.page["h2#status"][0]
        # Use web.page instead of page
        self.status = web.page["status"]
        self.output = web.page["terminal"]

        # Initialize DOM cells
        self.cells = []
        for i in (0, 1, 2):
            row = []
            for j in (0, 1, 2):
                cell = web.page[f"cell{i}{j}"]
                row.append(cell)
            self.cells.append(row)
        
        # Use Rust for game logic
        self.game = tictactoe.Board()
        self.new_game()

    def set_status(self, text):
        self.status.textContent = text

    def set_cell(self, i, j, value):
        cell = self.cells[i][j]
        cell.textContent = value
        # Clear all classes
        for cls in ["x", "o", "win"]:
            cell.classes.discard(cls)
        if value in ("x", "o"):
            cell.classes.add(value)

    def get_cell(self, i, j):
        py_cell = self.game.get_cell(i, j)
        if py_cell is None:
            return ""
        elif str(py_cell) == str(tictactoe.Cell.X):
            return "x"
        elif str(py_cell) == str(tictactoe.Cell.O):
            return "o"
        else:
            return ""

    def new_game(self, event=None):
        print('=================')
        print('NEW GAME STARTING')
        print()
        
        self.game.reset()
        
        for i in (0, 1, 2):
            for j in (0, 1, 2):
                self.set_cell(i, j, "")
        
        player = self.game.get_current_player()
        if str(player) == str(tictactoe.Player.X):
            self.set_status("x playing...")
        else:
            self.set_status("o playing...")

    def next_turn(self):
        game_state = self.game.check_game_state()
        
        if game_state == tictactoe.PyGameState.Draw:
            self.set_status("It's a tie!")
            return
        elif game_state == tictactoe.PyGameState.Won:
            winner = self.game.check_winner()
            if str(winner) == str(tictactoe.Player.X):
                self.set_status("x wins")
            elif str(winner) == str(tictactoe.Player.O):
                self.set_status("o wins")
            if winning_cells := self.game.get_winning_cells():
                for i, j in winning_cells:
                    self.cells[i][j].classes.add("win")
            return
        
        player = self.game.get_current_player()
        if str(player) == str(tictactoe.Player.X):
            self.set_status("x playing...")
        else:
            self.set_status("o playing...")

    def click(self, event):
        i = int(event.target.getAttribute('data-x'))
        j = int(event.target.getAttribute('data-y'))
        print(f'Cell {i}, {j} clicked: ', end='')
        
        if self.game.is_game_over():
            print('game ended, nothing to do')
            return
        
        if self.game.is_valid_move(i, j):
            print('cell empty, setting it')
            player_text = self.get_current_player_to_text()
            self.game.make_move(i, j)
            self.set_cell(i, j, player_text)
            self.next_turn()
        else:
            print(f'cell already full, cannot set it')

    def get_current_player_to_text(self):
        current_player = self.game.get_current_player()
        if str(current_player) == str(tictactoe.Player.X):
            return "x"
        return "o"

    # def clear_terminal(self):
    #     self.console.terminal.clear()
    
    def toggle_terminal(self, event):
        if self.output:
            self.output.hidden = not self.output.hidden

GAME = TicTacToe()

@when("click", "#resetBtn")
def new_game(event):
    GAME.new_game(event)

# @when("click", "#btn-toggle-terminal")
# def toggle_terminal(event):
#     GAME.toggle_terminal(event)

@when("click", ".cell")
def user_click(event):
    GAME.click(event)