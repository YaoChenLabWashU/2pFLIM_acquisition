CREATE TABLE Cell (
	cell_id SERIAL PRIMARY KEY,
	cellType text,
	breakinTime text,
	comment text,
	expt_id integer,
	cellName text,
	scanImageVersion float4,
	userInitials text
);

CREATE TABLE Acquisition (
	acq_id SERIAL PRIMARY KEY,
	cell_id integer REFERENCES cell,
	acq_num integer,
	epoch integer,
	triggerTime text,
	cycleName text,
	cyclePosition integer,
	repeatsDone integer,
	comment text
);

CREATE TABLE Waves (
	name text,
	data float8[],
	xoffset float8,
	xscale float8,	
	wave_id SERIAL PRIMARY KEY
);

CREATE TABLE PhysAcq (
	physacq_id SERIAL PRIMARY KEY,
	cell_id integer NOT NULL REFERENCES Cell,
	acq_id integer NOT NULL REFERENCES Acquisition,
	channel integer,
	currentClamp int,
	inputgain int,
	samplerate int,
	pulsePatternNum int,
	wave_id integer REFERENCES Waves
);

CREATE TABLE ImagingAcq (
	imagingacq_id SERIAL PRIMARY KEY,
	acq_id integer REFERENCES Acquisition,
	zoom integer,
	rotation real,
	motorX real,
	motorY real,
	motorZ real,
	zStepSize real,
	piezoZ real,
	trackFlag boolean,
	numFrames integer,
	numberOfZSlices integer,
	linescan int,
	pmtOffsetChannel1 real,
	pmtOffsetChannel2 real,
	pmtOffsetChannel3 real,
	pmtOffsetChannel4 real,
	tiff_lo_oid Oid
);
