// --- Granulator Mk II ---

(
MIDIClient.init;
MIDIIn.connectAll;

s.boot;
s.doWhenBooted({(

~chans = 2; // How many channels?
~sample = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/amberaaa_2_mono.wav");
~grains = IdentityBag.new;
~gnum = 50;



// create synth 'recipe'

SynthDef(\granFile, { arg
	trate = 50,
	buff = 0,
	playrate = 1,
	amp = 0.5,
	spray = 0.5,
	dur = 1,
	pos = 0,
	az = 0,
	width = 1;

	var outs = Array.series(~chans,0,1);
	var clk = Dust.kr(trate); // make 'Impulse' the trigger
	var pan = az + TRand.kr( width.neg, width, clk ); // random panning
	var place = (pos.lag(3) + TRand.kr(0, spray, clk));
	var grains = TGrains.ar(~chans, clk, buff, playrate, place, dur/trate, pan, amp/~gnum);

	Out.ar(outs,{ grains })
	}
).add;

// play synth

~gnum.do({~grains.add(Synth(\granFile, [\buff, ~sample]))});


// Quneo Controls ------------------------------------------------

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\pos,val.linlin(0,127,0,(~sample.numFrames/~sample.sampleRate)))})},10);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\amp,val.linexp(0,127,0.001,0.9))})},6);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\trate,val.linexp(0,127,2,600))})},0);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\dur,val.linexp(0,127,0.1,1))})},1);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\spray,val.linlin(0,127,0.01,2))})},2);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\az,val.linlin(0,127,-1.0,1.0))})},5);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\width,val.linlin(0,127,0,1))})},11);

// ---------------------------------------------------------------

)})
)
