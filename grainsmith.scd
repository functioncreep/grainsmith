// --- Granulator Mk I ---

// boot the server and read soundfile into buffer

MIDIClient.init;
s.boot;

(
~chans = 2; // How many channels?
~sample1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/readingrainbow_mono.wav");
~sample2 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/amberaaa_2_mono.wav");

// create synth 'recipe'

SynthDef(\granFile,
	{ arg
		trate = 600,
		buff = (~sample1),
		playrate = 1,
		amp = 0.2,
		spray = 0.5,
		dur = 0.5,
		pos = 0;

		var outs = Array.series(~chans,0,1);
		var clk = Impulse.kr(trate); // make 'Impulse' the trigger
		var pan = TRand.kr(-1.0,1.0,clk); // random panning
		var place = (pos.lag(3) + TRand.kr(0, spray, clk));
		var grains = TGrains.ar(~chans, clk, buff, playrate, place, dur, pan, amp);

		Out.ar(outs,{ grains })
	}
).add;

// play synth

x = Synth(\granFile); s.scope(~chans);
)

(
// Quneo test...

~posSpec = [0,(~sample1.numFrames/~sample1.sampleRate),\lin].asSpec;
~ampSpec = [0.01, 0.6, \exp ].asSpec;
~rateSpec = [2,600,\exp].asSpec;
~spraySpec = [0.01, 2,\lin].asSpec;

MIDIFunc.cc({arg val;x.set(\pos,~posSpec.map(val/127));},10);

MIDIFunc.cc({arg val;x.set(\amp,~ampSpec.map(val/127))},6);

MIDIFunc.cc({arg val;x.set(\trate,~rateSpec.map(val/127))},0);

MIDIFunc.cc({arg val;x.set(\spray,~spraySpec.map(val/127))},11);
)

/* ...rotary test. not working.

(
var newval = 0, lastval = 0;

MIDIFunc.cc({ arg val;
	lastval = newval;
	newval = val;
	if (newval > lastval,
		{"forward".postln;
			~bufPos = ~bufPos + 1;
			x.set(\pos, ~bufPos)}
	);
	if (newval < lastval,
		{"backwards".postln}
	);

}, 5, 0, 8388608 )
)

*/
