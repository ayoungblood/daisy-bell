// daisy-basic.js
// Play Daisy Bell using Web Audio signal chain and scheduling

window.onload = function() {
    daisy();
};
function daisy() {
    var DAISY_P = [
        74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
        69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
        71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
        62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67];
    var DAISY_T = [
        3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
        3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
        1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
        1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5];
    QUARTER = 0.180;
    A440    = 440;
    // set up audio context and simple signal chain
    window.AudioContext = window.AudioContext||window.webkitAudioContext;
    var ctx = new AudioContext();
    var osc = ctx.createOscillator();
    var gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    gain.gain.value = 0;
    osc.start(0);
    // schedule all note events at once
    eventTime = ctx.currentTime + 0.5;
    for (var i=0; i<DAISY_P.length; ++i) {
        var f = Math.pow(2,(DAISY_P[i]-69)/12)*A440;
        osc.frequency.setValueAtTime(f,eventTime);
        gain.gain.setValueAtTime(0.05,eventTime);
        gain.gain.exponentialRampToValueAtTime(1,eventTime+0.002); // smooth out attacks
        gain.gain.exponentialRampToValueAtTime(0.05,eventTime+DAISY_T[i]*QUARTER);
        eventTime += DAISY_T[i]*QUARTER;
    }
    gain.gain.exponentialRampToValueAtTime(0.00001,eventTime+QUARTER);
}
