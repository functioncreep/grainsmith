// Multichannel panning tester ---------------------

(
SynthDef(\testpad, { arg
	out = 0,
	vol = 0.05;

	Out.ar(out, SinOsc.ar(440, 0, vol));

}).add;

MIDIFunc.noteOn({ x = Synth(\testpad) }, 18);
MIDIFunc.noteOn({ s.freeAll; }, 17);

MIDIFunc.cc({ arg val; x.set( \vol, val.linlin(0,127,0.001,0.9) ) },6,0);

MIDIFunc.noteOn({ arg val, note;
	if (note < 9,
		{x.set( \out, note )}
)});
)