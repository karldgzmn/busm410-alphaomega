-- Create a US-region workspace for CP2 analysis tables; see sql/README.md.
CREATE SCHEMA IF NOT EXISTS `stately-mote-509700-r8.busm410_cp2`
OPTIONS (
  location = 'US',
  description = 'BUSM 410 CP2 analysis tables and model'
);
