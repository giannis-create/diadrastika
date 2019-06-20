(
d = Dictionary.new;
d.add(\t -> PathName("/Users/giannistsiaras/Desktop/Diadrastika Systimata Hxou/Toms/").entries.collect({arg sf;
	Buffer.read(s, sf.fullPath);
});
);
d.add(\s -> PathName("/Users/giannistsiaras/Desktop/Diadrastika Systimata Hxou/Shakers/").entries.collect({arg sf;
	Buffer.read(s, sf.fullPath);
});
);
d.add(\p -> PathName("/Users/giannistsiaras/Desktop/Diadrastika Systimata Hxou/Percs/").entries.collect({arg sf;
	Buffer.read(s, sf.fullPath);
});
);
)



(
SynthDef.new(\bufplay, {
	arg buf=0, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;

SynthDef.new(\sine, {
	arg freq=440, atk=0.0005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]),doneAction:2);
	sig = Pan2.ar(sig, MouseX.kr(-1, 1, 0, 0.2), MouseY.kr(0, 1, 0, 0.2));
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)



(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Pseq(
			[
				Prand(d[\t], 1),
				Prand(d[\t]++d[\s]++d[\p], inf),
				Prand(d[\s], 1),
				Prand(d[\t]++d[\s]++d[\p], inf),
			], inf
		),
		\rate, Pexprand(0.2, 4.1, inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf),
	);
).stop;
)

(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pseq([1/4], inf),
		\stretch, 1.875,
		\midinote, Pseq([33], inf),
		\harmonic, Pexprand(1, 80, inf).round,
		\atk, Pwhite(0.01, 0.8, inf),
		\rel, Pwhite(0.2, 1.0, inf),
		\rate, Pexprand(0.1, 3.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.5,
	)
).stop;
)