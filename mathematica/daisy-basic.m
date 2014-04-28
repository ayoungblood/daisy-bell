(* ::Package:: *)

(* daisy-basic.m *)
(* Play Daisy Bell, using a sine wave with an exponential envelope *)
daisyP = {74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
          69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
          71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
          62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67};
daisyT = { 3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
           3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
           1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
           1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5};
quarterNote = 0.180;(*Length of quarter note, in seconds*)

daisyT*=quarterNote;
(* simpleTone, where f is frequency in hertz, and d is duration in seconds *)
simpleTone[f_,d_] := (EmitSound[Sound[Play[Sin[f 2 Pi t]*Exp[-(3/d)*t], {t, 0, d}]]];Pause[d])
(* midi2f, where n is a MIDI note. Returns a frequency in hertz *)
midi2f[n_]:=Return[2^((n-69)/12)*440];
(* loop through and play notes *)
Do[simpleTone[midi2f[daisyP[[i]]],daisyT[[i]]],{i,1,Length[daisyP]}];

