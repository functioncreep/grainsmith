// --- Granulator Mk I ---

// boot the server and read soundfile into buffer

s.boot;

s.quit;

b = Buffer.read(s, "/home/clacktron/SuperCollider/grainysmith/readingrainbow_mono.wav");
c = Buffer.read(s, "/home/clacktron/SuperCollider/grainysmith/amberaaa_2_mono.wav");

// create synth 'recipe'
(
SynthDef(\granFile,
	{ arg  trate = 500, buff = b, outBus, playrate = 1, vol = 0.2, spray = 0.5, dur = 0.5;
		Out.ar([0,1],{ // stereo output bus
			var clk, pos, pan;
    		clk = Impulse.kr(trate); // make 'Dust' the trigger
			pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, spray, clk); // adjust position + random "spray"
			pan = TRand.kr(-1.0,1.0,clk); // random panning
			TGrains.ar(2, clk, buff, playrate, pos, dur, pan, vol);
			}
		)

	}
).add;


)

MIDIClient.init;

(
x = Synth(\granFile, [\buff, b]); s.scope(2); // play synth

// MIDI

MIDIFunc.cc({arg val;x.set(\vol,(val/127))},1);

MIDIFunc.cc({arg val;x.set(\playrate,(val/127)*2)},2);

MIDIFunc.cc({arg val;x.set(\spray,(val/127)*0.90+0.1)},3);

MIDIFunc.cc({arg val;x.set(\dur,(val/127)*0.49+0.01)},4);

MIDIFunc.cc({arg val;x.set(\trate,(val/127)*495+5)},5);
)

