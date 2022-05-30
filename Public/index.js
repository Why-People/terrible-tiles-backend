const playerX = document.getElementById("player-x");
const playerY = document.getElementById("player-y");
const dropped = document.getElementById("dropped");
const items = document.getElementById("items")
const countTimer = document.getElementById("count-timer");
const score = document.getElementById("score");

let secondsPassed = 0;
let isGameOver = false;

const ws = new WebSocket("ws://localhost:8080/game/connect");

ws.onmessage = async (e) => {
    const data = JSON.parse(await e.data.text());
    console.log(data);
    
    if (data.playerPosition != undefined) {
        playerX.innerHTML = `x: ${data.playerPosition.x}`;
        playerY.innerHTML = `y: ${data.playerPosition.y}`;
        dropped.innerHTML = filterMapJoinTiles(data.filledTiles, (tile) => tile.type === "VOID");
        items.innerHTML = filterMapJoinTiles(data.filledTiles, (tile) => tile.type !== "VOID");
    }
    
    if (data.playerScore != undefined) {
        isGameOver = true
    }
}

const filterMapJoinTiles = (tiles, condition) => {
    return tiles.filter(tile => condition(tile))
        .map(tile => `(${tile.position.x}, ${tile.position.y}, ${tile.type})`)
        .join(" ")
}

document.onkeydown = (e) => {
    switch (event.key) {
        case "ArrowLeft":
            sendData({ inputCommand: "MOVE_LEFT" });
            break;
        case "ArrowRight":
            sendData({ inputCommand: "MOVE_RIGHT" });
            break;
        case "ArrowUp":
            sendData({ inputCommand: "MOVE_UP" });
            break;
        case "ArrowDown":
            sendData({ inputCommand: "MOVE_DOWN" });
            break;
    }
}

const sendData = (obj) => {
    ws.send(JSON.stringify(obj));
}

setInterval(() => {
    if (isGameOver) return;
    countTimer.innerHTML = `${secondsPassed}`;
    secondsPassed++;
}, 1000);