document.addEventListener('DOMContentLoaded', () => {
    createBoard();
    initializeEditor();
    document.getElementById('resetBtn').addEventListener('click', resetGame);
    document.getElementById('runBtn').addEventListener('click', runUserCode);
});

function createBoard() {
    const board = document.getElementById('board');
    board.innerHTML = '';

    for (let i = 0; i < 9; i++) {
        const cell = document.createElement('div');
        cell.className = 'cell';
        cell.dataset.index = i;
        cell.addEventListener('click', handleCellClick);
        board.appendChild(cell);
    }
}

function handleCellClick(event) {
    const cell = event.target;
    const index = parseInt(cell.dataset.index);

    if (cell.classList.contains('occupied')) {
        return;
    }

    if (window.pyodide) {
        window.pyodide.runPython(`
            import sys
            sys.path.insert(0, '/web')
            import pyscript_game
            pyscript_game.handle_click(${index})
        `);
    }
}

function updateBoard(boardState) {
    const cells = document.querySelectorAll('.cell');
    boardState.forEach((cell, index) => {
        if (cell === 'X') {
            cells[index].textContent = 'X';
            cells[index].classList.add('occupied', 'x');
        } else if (cell === 'O') {
            cells[index].textContent = 'O';
            cells[index].classList.add('occupied', 'o');
        }
    });
}

function updateStatus(message) {
    const status = document.getElementById('gameStatus');
    status.textContent = message;

    if (message.includes('wins!')) {
        status.style.color = message.includes('X') ? '#667eea' : '#764ba2';
    } else if (message.includes('draw')) {
        status.style.color = '#e74c3c';
    } else {
        status.style.color = '#667eea';
    }
}

function resetGame() {
    const cells = document.querySelectorAll('.cell');
    cells.forEach(cell => {
        cell.textContent = '';
        cell.classList.remove('occupied', 'x', 'o');
    });

    if (window.pyodide) {
        window.pyodide.runPython(`
            import sys
            sys.path.insert(0, '/web')
            import pyscript_game
            pyscript_game.reset_game()
        `);
    }

    updateStatus("Player X's turn");
}

function initializeEditor() {
    const editorContainer = document.getElementById('pyscript_editor');

    const defaultCode = `# Control the Tic-Tac-Toe game
# Available functions:
# - make_move(row, col): Make a move on the board
# - reset_game(): Reset the game
# - get_board_state(): Get current board state
# - get_current_player(): Get current player

# Example: Make some moves
try:
    from pyscript_game import make_move, reset_game, get_board_state
    
    # Make a few moves
    make_move(0, 0)  # X at top-left
    make_move(1, 1)  # O at center
    make_move(0, 1)  # X at top-middle
    make_move(2, 2)  # O at bottom-right
    
    print("Moves made successfully!")
    
except Exception as e:
    print(f"Error: {e}")`;

    editorContainer.innerHTML = `
        <textarea class="py-editor" id="codeEditor" spellcheck="false">${defaultCode}</textarea>
    `;
}

function runUserCode() {
    const code = document.getElementById('codeEditor').value;

    if (window.pyodide) {
        try {
            window.pyodide.runPython(code);
            console.log('Code executed successfully');
        } catch (error) {
            console.error('Error executing code:', error);
            alert('Error executing code: ' + error.message);
        }
    } else {
        console.error('Pyodide not loaded');
        alert('Pyodide is not loaded yet. Please wait a moment and try again.');
    }
}

window.jsUpdateBoard = updateBoard;
window.jsUpdateStatus = updateStatus;