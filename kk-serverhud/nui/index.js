(function () {

  const hudRoot = document.getElementById("hudRoot");

  const elPlayersOnline = document.getElementById("playersOnline");
  const elPlayersMax = document.getElementById("playersMax");
  const elPlayerId = document.getElementById("playerId");

  const elTime = document.getElementById("hudTime");

  function pad(n) {
    return String(n).padStart(2, "0");
  }

  function updateClock() {
    const d = new Date();
    elTime.textContent = `${pad(d.getHours())}:${pad(d.getMinutes())}`;
  }

  function setVisible(state) {
    if (state) hudRoot.classList.add("is-visible");
    else hudRoot.classList.remove("is-visible");
  }

  updateClock();
  setInterval(updateClock, 1000);
  setVisible(false);

  window.addEventListener("message", (event) => {
    const data = event.data || {};

    if (data.type === "hud:setVisible") {
      setVisible(!!data.state);
      return;
    }

    if (data.type === "hud:update") {

      if (typeof data.playersOnline === "number")
        elPlayersOnline.textContent = data.playersOnline;

      if (typeof data.playersMax === "number")
        elPlayersMax.textContent = data.playersMax;

      if (typeof data.playerId === "number")
        elPlayerId.textContent = data.playerId;

    }
  });

})();