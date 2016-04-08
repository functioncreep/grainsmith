// --- Granulator Mk I ---

// boot the server and read soundfile into buffer

MIDIClient.init;
s.boot;

(
var sample1, sample2, sample3, sample4;
sample1 = thisProcess.nowExecutingPath.dirname +/+ "sounds/readingrainbow_mono.wav";
sample2 = thisProcess.nowExecutingPath.dirname +/+ "sounds/amberaaa_2_mono.wav";
// sample3 = thisProcess.nowExecutingPath.dirname +/+ "sounds/readingrainbow_mono.wav";
// sample4 = thisProcess.nowExecutingPath.dirname +/+ "sounds/readingrainbow_mono.wav";

a = Buffer.read(s, sample1);
b = Buffer.read(s, sample2);
// c = Buffer.read(s, sample3);
// d = Buffer.read(s, sample4);
)

// create synth 'recipe'
(
SynthDef(\granFile,
	{ | trate = 600, buff, outBus, playrate = 1, amp = 0.2, spray = 0.5, dur = 0.5, pos = 0 |
    	var clk, place, pan;
		clk = Impulse.kr(trate); // make 'Impulse' the trigger
		pan = TRand.kr(-1.0,1.0,clk); // random panning
		place = (pos.lag(3) + TRand.kr(0, spray, clk));
		Out.ar([0,1],{ // stereo output bus
			TGrains.ar(2, clk, buff, playrate, place, dur, pan, amp);
			}
		)

	}
).add;
)

x = Synth(\granFile, [\buff, a]); s.scope(2); // play synth

(
// Quneo test...

~posSpec = [0,(a.numFrames/a.sampleRate),\lin].asSpec;
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
