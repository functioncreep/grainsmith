// --- Granulator Mk II ---
<<<<<<< HEAD
=======

>>>>>>> quneo-support

(
MIDIClient.init;
MIDIIn.connectAll;
<<<<<<< HEAD
=======
~quneo = MIDIOut(0);
~quneo.connect(17);

MIDIClient.destinations.do{ |it,i| [i,it].postln; }
>>>>>>> quneo-support

s.boot;
s.doWhenBooted({(

~chans = 2; // How many channels?
~sample = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/amberaaa_2_mono.wav");
~grains = IdentityBag.new;
~gnum = 50;


<<<<<<< HEAD

// create synth 'recipe'

=======
(
~chans = 2; // How many channels?
~sample1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/dialogue.wav");
~sample2 = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "sounds/celloloop_mono.wav");
~grainsynth1 = IdentityBag.new;
~grainsynth2 = IdentityBag.new;
~gnum = 50;
)

// create synth 'recipe'

(
>>>>>>> quneo-support
SynthDef(\granFile, { arg
	trate = 50,
	buff = 0,
	playrate = 1,
<<<<<<< HEAD
	amp = 0.5,
=======
	amp = 0.7,
>>>>>>> quneo-support
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

<<<<<<< HEAD
~gnum.do({~grains.add(Synth(\granFile, [\buff, ~sample]))});


// Quneo Controls ------------------------------------------------

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\trate,val.linexp(0,127,0.5,600))})},0);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\dur,val.linexp(0,127,0.1,1))})},1);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\spray,val.linexp(0,127,0.01,2))})},2);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\playrate,val.linlin(0,127,0.25,1.25))})},3);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\az,val.linlin(0,127,-1.0,1.0))})},5);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\amp,val.linexp(0,127,0.001,0.9))})},6);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\pos,val.linlin(0,127,0,(~sample.numFrames/~sample.sampleRate)))})},10);

MIDIFunc.cc({arg val;
	~grains.do({ |i|
		i.set(\width,val.linlin(0,127,0,1))})},11);

// ---------------------------------------------------------------

)})
)
=======
(
~gnum.do({
	~grainsynth1.add(
		Synth(\granFile, [
			\buff, ~sample1,
			\amp, 0.0,
			\trate, 100,
			\az, 0.0,
			\spray, 0.1,
			\dur, 1.0,
			\width, 1.0,
		])
	)
});
~gnum.do({
	~grainsynth2.add(
		Synth(\granFile, [
			\buff, ~sample2,
			\amp, 0,
			\trate, 100,
			\az, 1,
			\spray, 0.1,
			\dur, 1.0,
			\width, 0.0,
			\pos, 4
		])
	)
});
)

// Quneo Controls ------------------------------------------------

(
var currsynth = ~grainsynth2;
var currbuff = ~sample2;

MIDIFunc.noteOn({ |val,note|
	switch(note,
		12, {
			"SAMPLE 1".postln;
			currsynth = ~grainsynth1;
			currbuff = ~sample1;
			~quneo.noteOn(0,24,60);
			[26].do({ arg item; ~quneo.noteOff(0,item)});
		},
		13, {
			"SAMPLE 2".postln;
			currsynth = ~grainsynth2;
			currbuff = ~sample2;
			~quneo.noteOn(0,26,60);
			[24].do({ arg item; ~quneo.noteOff(0,item)});
		}
	);
});

MIDIFunc.cc({arg val;
	currsynth.do({ |i|
		i.set(\pos,val.linlin(0,127,0,(currbuff.numFrames/currbuff.sampleRate)))})},10);

MIDIFunc.cc({arg val;
	currsynth.do({ |i|
		i.set(\amp,val.linexp(0,127,0.001,1.0))})},6);

MIDIFunc.cc({arg val;
	currsynth.do({ |i|
		i.set(\trate,val.linexp(0,127,2,600))})},0);

MIDIFunc.cc({arg val;
	currsynth.do({ |i|
		i.set(\dur,val.linexp(0,127,0.1,1))})},1);

MIDIFunc.cc({arg val;
	currsynth.do({ |i|
		i.set(\spray,val.linexp(0,127,0.01,2))})},2);

MIDIFunc.cc({arg val;
	currsynth.do({ |i|
		i.set(\width,val.linlin(0,127,0.001,1.0))})},3);

MIDIFunc.cc({arg val;
	currsynth.do({ |i|
		i.set(\az,val.linlin(0,127,-1.0,1.0))})},5);

MIDIFunc.noteOn({
	~gnum.do({
		~grainsynth1.add(
			Synth(\granFile, [
				\buff, ~sample1,
				\amp, 0.0,
				\trate, 100,
				\az, 0.0,
				\spray, 0.1,
				\dur, 1.0,
				\width, 1.0,
				\pos, 1.5
			])
		)
	});
	~gnum.do({
		~grainsynth2.add(
			Synth(\granFile, [
				\buff, ~sample2,
				\amp, 0,
				\trate, 100,
				\az, 1,
				\spray, 0.1,
				\dur, 1.0,
				\width, 0.0,
				\pos, 4
			])
		)
	});
},18);

MIDIFunc.noteOn({s.freeAll},17);

)

// ---------------------------------------------------------------

~quneo.noteOn(0,24,64);
for(0,32,{|i|~quneo.noteOff(0,i)});

~quneo.noteOn(0,4,60);

	MIDIFunc.trace;
>>>>>>> quneo-support
